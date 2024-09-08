-- Plugin for adding custom job and hooks to the pipeline

local M = {}

-- Custom job provided by the plugin
M.job = function()
  print("Plugin job running...")
  return 0 -- return success
end

-- Hook to be run before a stage starts
M.before_stage = function(stage_name)
  print("Before stage hook: " .. stage_name)
end

-- Hook to be run after a stage completes
M.after_stage = function(stage_name)
  print("After stage hook: " .. stage_name)
end

return M -- Return the module
