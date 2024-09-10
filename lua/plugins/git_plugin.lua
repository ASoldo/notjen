local M = {}

-- Helper function to run shell commands
function M.run_command(command)
	print("Running command: " .. command) -- Print the command being executed
	local handle = io.popen(command .. " 2>&1") -- Capture both stdout and stderr
	local result = handle:read("*a")
	handle:close()
	print("Command output: " .. result) -- Print the result (stdout + stderr)

	if string.find(result, "fatal") or string.find(result, "error") then
		error("Command failed: " .. command .. " with output: " .. result)
	end
end

-- Clone a Git repository
function M.clone(repo_url, destination)
	print("Cloning repository " .. repo_url .. " into " .. destination)
	M.run_command("mkdir -p " .. destination) -- Create destination directory if needed
	M.run_command("git clone " .. repo_url .. " " .. destination)
	return 0 -- Ensure success
end

return M
