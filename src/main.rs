use clap::Parser;
use mlua::{Error, Lua};
use std::fs::read_to_string;

/// Command-line arguments parser
#[derive(Parser)]
#[command(
    name = "NotJen - Lua Pipeline Runner",
    version = "1.0",
    about = "Run Lua pipeline scripts with custom plugins"
)]
struct Args {
    /// Path to the Lua pipeline file
    #[arg(short, long)]
    file: String,

    /// Path to the Lua plugin file (directory)
    #[arg(short, long)]
    plugin_dir: Option<String>, // Optional plugin directory argument
}

/// Load Lua configuration from a file and execute the pipeline with optional plugins
fn load_lua_pipeline(file_path: &str, plugin_dir: Option<&str>) -> Result<(), Error> {
    let lua = Lua::new();

    if let Some(plugin_dir) = plugin_dir {
        let globals = lua.globals();
        let package: mlua::Table = globals.get("package")?;

        // Update package.path
        let current_path: String = package.get("path")?;
        package.set(
            "path",
            format!(
                "{}/?.lua;/usr/share/lua/5.4/?.lua;{}",
                plugin_dir, current_path
            ),
        )?;

        // Update package.cpath
        let current_cpath: String = package.get("cpath")?;

        package.set(
            "cpath",
            format!(
                "{}/?.so;/usr/lib/lua/5.4/?.so;{}",
                plugin_dir, current_cpath
            ),
        )?;
    }

    let lua_script = read_to_string(file_path).expect("Unable to read Lua file");

    lua.load(&lua_script).exec()?;

    Ok(())
}

#[tokio::main]
async fn main() -> std::io::Result<()> {
    // Parse command-line arguments using Clap
    let args = Args::parse();

    // Load the Lua configuration and optional plugin directory
    if let Err(e) = load_lua_pipeline(&args.file, args.plugin_dir.as_deref()) {
        eprintln!("Pipeline execution failed: {:?}", e);
        std::process::exit(1);
    }

    println!("Pipeline executed successfully from file: {}", args.file);
    Ok(())
}
