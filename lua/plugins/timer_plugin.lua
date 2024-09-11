local M = {}

--- @param job_name string
--- @param job_func function
--- @return integer, number
-- Function to track time spent on jobs
function M.time_job(job_name, job_func)
	local start_time = os.clock()
	local result = job_func() -- Run the job function
	local end_time = os.clock()

	local time_spent = end_time - start_time
	print(string.format("Job '%s' completed in %.2f seconds", job_name, time_spent))

	return result, time_spent
end

return M
