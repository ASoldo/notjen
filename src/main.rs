use clap::Parser;
use mlua::{Error, Lua};
use std::fs::read_to_string;
// use tokio::task;

/// Command-line arguments parser
#[derive(Parser)]
#[command(
    name = "Lua Pipeline Runner",
    version = "1.0",
    about = "Run Lua pipeline scripts with plugins"
)]
struct Args {
    /// Path to the Lua pipeline file
    #[arg(short, long)]
    file: String,

    /// Path to the Lua plugin file (directory)
    #[arg(short, long)]
    plugin_dir: Option<String>, // Optional plugin directory argument
}

// A simple async job function
// async fn run_job(name: &str, job_num: usize) {
//     println!("Running job: {} with number: {}", name, job_num);
// }

// Load Lua configuration from a file and execute the pipeline with optional plugins
fn load_lua_pipeline(file_path: &str, plugin_dir: Option<&str>) -> Result<(), Error> {
    let lua = Lua::new();

    // Set the Lua package.path to include the plugin directory
    if let Some(plugin_dir) = plugin_dir {
        let globals = lua.globals();
        let package: mlua::Table = globals.get("package")?;
        let current_path: String = package.get("path")?;
        // Add the plugin directory to the package.path
        package.set("path", format!("{}/?.lua;{}", plugin_dir, current_path))?;
    }

    // Load the Lua script from the pipeline file
    let lua_script = read_to_string(file_path).expect("Unable to read Lua file");

    // Load and execute the pipeline Lua script
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

    // Schedule an example job after loading the Lua pipeline
    // let job_num = 42; // Example job number
    // task::spawn(run_job("Compile", job_num)).await?;

    println!("Pipeline executed successfully from file: {}", args.file);
    Ok(())
}
