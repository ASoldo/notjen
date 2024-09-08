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
  {
    name = "Build",
    jobs = {
      {
        name = "Compile",
        run = function()
          print("Compiling...")
          return 0
        end,
      },
    },
  },
  {
    name = "Test",
    jobs = {
      {
        name = "Unit Tests",
        run = function()
          print("Running tests...")
          return 0
        end,
      },
    },
  },
  {
    name = "Deploy",
    jobs = {
      {
        name = "Deploy to Production",
        run = function()
          print("Deploying...")
          return 0
        end,
      },
    },
  },
})
