-- Require the plugin and the new Git plugin
local plugin = require("plugin")
local git_plugin = require("git_plugin")
local pnpm_plugin = require("pnpm_plugin")

-- Pipeline function
function pipeline(stages)
  -- Print the current working directory
  local handle = io.popen("pwd")
  local current_dir = handle:read("*a"):gsub("\n", "")
  handle:close()
  print("Current working directory: " .. current_dir)

  for _, stage in pairs(stages) do
    -- Call the plugin's before_stage hook if available
    if plugin and plugin.before_stage then
      plugin.before_stage(stage.name)
    end

    print("Stage: " .. stage.name)
    for _, job in pairs(stage.jobs) do
      print("Scheduling job: " .. job.name)

      -- Directly execute the job (bypassing plugin.job)
      local result = job.run()

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
    name = "Clone Repository",
    jobs = {
      {
        name = "Clone nuxt3-sanity repository",
        run = function()
          -- Use the Git plugin to clone the repo
          local repo_url = "https://github.com/ASoldo/nuxt3-sanity"
          local destination = "/home/rootster/Documents/rust_dojo/notjen/temp/"
          git_plugin.clone(repo_url, destination)
          return 0
        end,
      },
    },
  },
  {
    name = "Install Dependencies",
    jobs = {
      {
        name = "Run pnpm install",
        run = function()
          -- Use the pnpm install in the correct folder
          local destination = "/home/rootster/Documents/rust_dojo/notjen/temp"
          pnpm_plugin.run_pnpm_install(destination)
          return 0
        end,
      },
    },
  },
})
