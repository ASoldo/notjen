local M = {}

-- Run pnpm install
function M.run_pnpm_install(destination)
  print("Running pnpm install in " .. destination)
  M.run_command("cd " .. destination .. " && pnpm install")
  return 0 -- Ensure success
end

-- Helper function to run shell commands
function M.run_command(command)
  print("Running command: " .. command)      -- Print the command being executed
  local handle = io.popen(command .. " 2>&1") -- Capture both stdout and stderr
  local result = handle:read("*a")
  handle:close()
  print("Command output: " .. result) -- Print the result (stdout + stderr)

  if string.find(result, "fatal") or string.find(result, "error") then
    error("Command failed: " .. command .. " with output: " .. result)
  end
end

return M
