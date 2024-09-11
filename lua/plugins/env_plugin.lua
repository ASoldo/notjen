local M = {}

---@param var_name string The name of the environment variable to retrieve.
-- Function to get and print the environment variable by name
function M.get_env(var_name)
	local value = os.getenv(var_name) -- Get the environment variable's value
	if value then
		print("The value of $" .. var_name .. " is: " .. value)
		return value
	else
		print("Environment variable $" .. var_name .. " is not set.")
	end
end

return M
