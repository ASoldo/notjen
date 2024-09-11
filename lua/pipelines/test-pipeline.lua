-- Adjust package paths to include your plugin directory
-- package.path = package.path .. ";../plugins/?.lua"
-- package.cpath = package.cpath .. ";../plugins/?.so"

-- Require the plugins
local hook_plugin = require("hook_plugin")
local print_me_plugin = require("print_me_plugin")
local state_plugin = require("state_plugin")
local pwd_plugin = require("pwd_plugin")
local stages_plugin = require("stages_plugin")
local env_plugin = require("env_plugin")

-- Pipeline function
-- pass the stages as table
--- @param stages table<{name: string,jobs: table<{name: string, run: function}>}>
--
-- @usage
-- ```lua
-- local stages = {
--    { name = "Build", jobs = { {name = "Compile", run = function() end} } }
-- }
-- ```
local function pipeline(stages)
	pwd_plugin.pwd()
	stages_plugin.execute_stages(stages, hook_plugin, print_me_plugin)
	env_plugin.get_env("USER")
end

-- Define the pipeline stages and jobs
pipeline({
	{
		name = "Test 1",
		jobs = {
			{
				name = "Test Run",
				run = function()
					-- print("Current package.path: " .. package.path)
					-- print("Current package.cpath: " .. package.cpath)

					hook_plugin.before(function()
						print("Before ls")
						state_plugin.set("test", "Andrija")
					end)
					os.execute("ls")
					hook_plugin.after(function()
						print("after ls")
						print(state_plugin.get("test"))
					end)

					return 0
				end,
			},
		},
	},
	{
		name = "Test 2",
		jobs = {
			{
				name = "Test Run",
				run = function()
					hook_plugin.before(function()
						print("Before ls")
					end)
					state_plugin.set("test", "Mario")
					os.execute("ls")
					hook_plugin.after(function()
						print("after ls")
						print(state_plugin.get("test"))
					end)

					return 0
				end,
			},
		},
	},
})
