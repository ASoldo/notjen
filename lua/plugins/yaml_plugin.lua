--- YAML Plugin
-- This plugin provides utilities for creating and parsing YAML content in-memory.
-- It uses the `lyaml` Lua library for YAML operations.
--
-- @module yaml_plugin

local M = {}
local lyaml = require("lyaml")

--- Creates a YAML string from a Lua table.
--- This function takes a Lua table and converts it into a YAML-formatted string.
--
--- @param data_table table The Lua table to be converted into YAML.
--- @return string The resulting YAML string.
function M.create_yaml(data_table)
	local yaml_data = lyaml.dump({ data_table })
	print("YAML Created:\n", yaml_data)
	return yaml_data
end

--- Parses a YAML string and retrieves a value by key.
--- This function parses the YAML content and returns the value associated with a specific key.
--
--- @param yaml_content string The YAML string to parse.
--- @param key string The key to retrieve the value for.
function M.parse_yaml(yaml_content, key)
	local parsed_data = lyaml.load(yaml_content)

	-- Assuming the YAML content is a map/table
	if parsed_data and parsed_data[key] then
		print(string.format("Value for '%s': %s", key, parsed_data[key]))
		return parsed_data[key]
	else
		print(string.format("Key '%s' not found", key))
		return nil
	end
end

return M
