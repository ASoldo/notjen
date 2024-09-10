-- Require the plugins
local hook_plugin = require("hook_plugin")
local print_me_plugin = require("print_me_plugin")
local state_plugin = require("state_plugin")

-- Pipeline function
-- pass the stages as table
--- @param stages table<{name: string,jobs: table<{name: string, run: function}>}>
--
-- @usage
-- ```lua
-- local stages = {
--    { name = "Build", jobs = { {name = "Compile", run = function() end} } }
-- }
-- ```
function pipeline(stages)
  -- Print the current working directory
  local handle = io.popen("pwd")
  local current_dir = handle:read("*a"):gsub("\n", "")
  handle:close()
  print("Current working directory: " .. current_dir)

  for _, stage in pairs(stages) do
    -- Call the plugin's before_stage hook if available
    if hook_plugin and hook_plugin.before then
      hook_plugin.before(function()
        print("This is function")
        print(" --- This is also")
      end)
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
    if hook_plugin and hook_plugin.after then
      hook_plugin.after(function()
        print_me_plugin.print_me("Andrijano hook after")
      end)
    end
  end
end

-- Define the pipeline stages and jobs
pipeline({
  {
    name = "Test 1",
    jobs = {
      {
        name = "Test Run",
        run = function()
          hook_plugin.before(function()
            print("Before ls")
            state_plugin.set("test", "Andrija")
          end)
          os.execute("ls")
          hook_plugin.after(function()
            print("after ls")
            print(state_plugin.get("test"))
          end)

          return 0
        end,
      },
    },
  },
  {
    name = "Test 2",
    jobs = {
      {
        name = "Test Run",
        run = function()
          hook_plugin.before(function()
            print("Before ls")
          end)
          state_plugin.set("test", "Mario")
          os.execute("ls")
          hook_plugin.after(function()
            print("after ls")
            print(state_plugin.get("test"))
          end)

          return 0
        end,
      },
    },
  },
})
