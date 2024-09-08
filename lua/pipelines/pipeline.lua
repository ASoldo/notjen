-- Require the plugin;
local plugin = require("plugin")

function pipeline(stages)
  for _, stage in pairs(stages) do
    -- Call the plugin's before_stage hook if available
    if plugin and plugin.before_stage then
      plugin.before_stage(stage.name)
    end

    print("Stage: " .. stage.name)
    for _, job in pairs(stage.jobs) do
      print("Scheduling job: " .. job.name)

      -- Use the plugin job if provided, otherwise run the default job
      local result
      if plugin and plugin.job then
        result = plugin.job()
      else
        result = job.run()
      end

      if result ~= 0 then
        error("Job failed: " .. job.name)
      end
    end

    -- Call the plugin's after_stage hook if available
    if plugin and plugin.after_stage then
      plugin.after_stage(stage.name)
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
