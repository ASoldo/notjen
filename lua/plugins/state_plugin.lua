local M = {}

-- Table to store key-value pairs
local state = {}

--- Function to set a variable in the store
--- @param key string The name of the variable to set
--- @param value any The value to set for the variable
function M.set(key, value)
  state[key] = value
  print("Set variable '" .. key .. "' to '" .. tostring(value) .. "'")
end

--- Function to get a variable from the store
--- @param key string The name of the variable to get
--- @return any The value of the variable, or nil if not found
function M.get(key)
  local value = state[key]
  if value ~= nil then
    print("Retrieved variable '" .. key .. "' with value '" .. tostring(value) .. "'")
    return value
  else
    print("Variable '" .. key .. "' not found")
    return nil
  end
end

return M
