use clap::Parser;
use mlua::{Error, Lua};
use std::fs::read_to_string;
use tokio::task;

/// Command-line arguments parser
#[derive(Parser)]
#[command(
    name = "Lua Pipeline Runner",
    version = "1.0",
    about = "Run Lua pipeline scripts"
)]
struct Args {
    /// Path to the Lua pipeline file
    #[arg(short, long)]
    file: String,
}

// A simple async job function
async fn run_job(name: &str, job_num: usize) {
    println!("Running job: {} with number: {}", name, job_num);
}

// Load Lua configuration from a file and execute the pipeline
fn load_lua_pipeline(file_path: &str) -> Result<(), Error> {
    // Read the Lua script from the file
    let lua_script = read_to_string(file_path).expect("Unable to read Lua file");

    let lua = Lua::new();
    lua.load(&lua_script).exec()?; // Execute the Lua script

    Ok(())
}

#[tokio::main]
async fn main() -> std::io::Result<()> {
    // Parse command-line arguments using Clap
    let args = Args::parse();

    // Load the Lua configuration from the provided file path
    if let Err(e) = load_lua_pipeline(&args.file) {
        eprintln!("Pipeline execution failed: {:?}", e);
        std::process::exit(1);
    }

    // Schedule an example job after loading the Lua pipeline
    let job_num = 42; // Example job number
    task::spawn(run_job("Compile", job_num)).await?;

    println!("Pipeline executed successfully from file: {}", args.file);
    Ok(())
}
