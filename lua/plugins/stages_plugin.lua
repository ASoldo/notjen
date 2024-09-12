local report_plugin = require("report_plugin")
local hook_plugin = require("hook_plugin")
local print_me_plugin = require("print_me_plugin")

-- loop_plugin.lua
local M = {}

--- Executes the stages and jobs in the pipeline.
--- @param stages table
function M.execute_stages(stages)
	for _, stage in pairs(stages) do
		-- Call the plugin's before_stage hook if available
		hook_plugin.before(function()
			print("This is a before hook function")
		end)

		print("Stage: " .. stage.name)
		for _, job in pairs(stage.jobs) do
			print("Scheduling job: " .. job.name)
			local start_cpu_time = os.clock()
			local start_time = os.time()
			-- Directly execute the job
			local result = job.run()
			local end_cpu_time = os.clock()
			local end_time = os.time()

			report_plugin.add_job_report(
				stage.name,
				job.name,
				result,
				end_time - start_time,
				end_cpu_time - start_cpu_time
			)
			if result ~= 0 then
				error("Job failed: " .. job.name)
			end
		end

		-- Call the plugin's after_stage hook if available
		hook_plugin.after(function()
			print_me_plugin.print_me("After hook call")
			local stage_reports = report_plugin.get_reports()
			for i = 1, #stage_reports, 1 do
				print(string.rep("-", 20))
				print("Job index: ", i)
				print("Stage: ", stage_reports[i].stage)
				print("Job: ", stage_reports[i].job)
				print("Status: ", stage_reports[i].status)
				print("Duration: ", stage_reports[i].time_taken)
				print("CPU Time: ", stage_reports[i].cpu_time)
			end
			local total_duration = 0
			local total_cpu_duration = 0
			for j = 1, #stage_reports, 1 do
				total_duration = total_duration + stage_reports[j].time_taken
				total_cpu_duration = total_cpu_duration + stage_reports[j].cpu_time
			end
			print(string.rep("-", 20))
			print("Total duration: ", total_duration)
			print("Total CPU duration: ", total_cpu_duration)
			print(string.rep("-", 20))
		end)
	end
end

return M
