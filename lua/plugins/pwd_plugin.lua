local M = {}

--- Print the current working directory
function M.pwd()
	-- Print the current working directory
	local handle = io.popen("pwd")
	-- Check if handle is not nil before attempting to read
	if handle then
		local current_dir = handle:read("*a")

		-- Check if current_dir is not nil before gsub
		if current_dir then
			current_dir = current_dir:gsub("\n", "")
		else
			print("Error: Failed to read the current directory.")
		end

		handle:close() -- Close the handle safely
		print("Current working directory: " .. current_dir)
	else
		print("Error: Failed to open pipe for command.")
	end
end

return M
