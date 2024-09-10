-- loop_plugin.lua
local M = {}

function M.execute_stages(stages, hook_plugin, print_me_plugin)
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

      -- Directly execute the job
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

return M
