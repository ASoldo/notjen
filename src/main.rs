use actix_web::{web, App, HttpServer, Responder};
use mlua::{Error, Lua};
use tokio::task;

// A simple async job function
async fn run_job(name: &str, job_num: usize) {
    println!("Running job: {} with number: {}", name, job_num);
}

// Load Lua configuration and execute the pipeline
fn load_lua_pipeline() -> Result<(), Error> {
    let lua = Lua::new();

    lua.load(
        r#"
        function pipeline(stages)
            for _, stage in pairs(stages) do
                print("Stage: " .. stage.name)
                for _, job in pairs(stage.jobs) do
                    print("Scheduling job: " .. job.name)
                    local result = job.run()
                    if result ~= 0 then
                        error("Job failed: " .. job.name)
                    end
                end
            end
        end

        -- Define the pipeline stages and jobs
        pipeline({
            { name = "Build", jobs = {
                { name = "Compile", run = function() print("Compiling..."); return 0 end }
            }},
            { name = "Test", jobs = {
                { name = "Unit Tests", run = function() print("Running tests..."); return 0 end }
            }},
            { name = "Deploy", jobs = {
                { name = "Deploy to Production", run = function() print("Deploying..."); return 0 end }
            }},
        })
        "#,
    )
    .exec()?;

    Ok(())
}

// Actix-web handler for job execution
async fn run_pipeline_handler() -> impl Responder {
    // Load the Lua configuration and schedule the jobs
    if let Err(e) = load_lua_pipeline() {
        return format!("Pipeline execution failed: {:?}", e);
    }

    // Schedule actual jobs from the Lua pipeline dynamically
    let job_num = 42; // Example job number; can be replaced with a real job id
    task::spawn(run_job("Compile", job_num)); // Spawning the job asynchronously

    format!("Pipeline scheduled successfully!")
}

#[tokio::main]
async fn main() -> std::io::Result<()> {
    // Start the Actix-web server and expose an endpoint for running jobs
    HttpServer::new(|| App::new().route("/run-pipeline", web::get().to(run_pipeline_handler)))
        .bind(("127.0.0.1", 8080))?
        .run()
        .await
}
