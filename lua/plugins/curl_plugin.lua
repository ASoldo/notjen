local M = {}

-- Function to run a curl command with optional pipe commands
function M.run_curl_with_pipe(url, ...)
	-- Build the base curl command
	local curl_command = "curl -s '" .. url .. "'"

	-- Handle any additional pipe commands
	local args = { ... }
	if #args > 0 then
		for _, pipe_command in ipairs(args) do
			curl_command = curl_command .. " | " .. pipe_command
		end
	end

	-- Execute the full command
	print("Executing command: " .. curl_command)
	local handle = io.popen(curl_command)
	local result = handle:read("*a")
	handle:close()

	-- Return the result from the command
	return result
end

return M
