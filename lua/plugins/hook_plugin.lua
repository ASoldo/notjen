local M = {}

-- Custom job provided by the plugin (unchanged)
M.job = function()
  print("Plugin job running...")
  return 0 -- return success
end

-- Hook to be run before a stage starts, accepting a function to execute
M.before = function(func)
  print("Before - hook running...")
  if func and type(func) == "function" then
    func() -- Execute the passed function
  else
    print("No function passed to before")
  end
  return 0 -- Indicate success (optional)
end

-- Hook to be run after a stage completes, accepting a function to execute
M.after = function(func)
  print("After - hook running...")
  if func and type(func) == "function" then
    func() -- Execute the passed function
  else
    print("No function passed to after")
  end
  return 0 -- Indicate success (optional)
end

return M -- Return the module
