local M = {}
local jobs_report = {}

function M.add_job_report(stage_name, job_name, status, time_taken, cpu_time)
	table.insert(jobs_report, {
		stage = stage_name,
		job = job_name,
		status = status,
		time_taken = time_taken,
		cpu_time = cpu_time,
	})
end

-- Ensure this function is returning a valid table
function M.get_reports()
	return jobs_report or {}
end

return M
