-- selene: allow(global_usage)
describe = describe
it = it

-- Add plugins directory to package path
package.path = package.path .. ";./lua/plugins/?.lua"
require("busted.runner")()

local git_plugin = require("git_plugin")

describe("Git Plugin", function()
  -- Test case for a valid command
  it("should run a valid command without error", function()
    local command = "echo 'Hello World'"
    local status, output = pcall(function()
      return git_plugin.run_command(command)
    end)

    -- Assert that the command ran successfully
    assert(status, "The valid command should have succeeded.")
    print("Command ran with output:", output)
  end)
end)
