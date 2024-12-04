local async = require("neotest.async")

local Result = {}

---Process result file
---@param spec neotest.RunSpec
---@param result_output neotest.StrategyResult
---@param _ neotest.Tree
---@return neotest.Result
function Result.results(spec, result_output, _)
	if not type(result_output) == "table" or not result_output.output then
		vim.notify("Unknown result_output structure: " .. vim.inspect(result_output), vim.log.levels.ERROR)
		return {}
	end

	local file_content = async.fn.readfile(result_output.output)

	if not file_content or #file_content == 0 then
		vim.notify("Test output is empty", vim.log.levels.ERROR)
		return {}
	end

	local results = {}
	local context_stack = {}
	local last_test_key = nil

	local errors = {}
	local is_error = false
	local error = {}

	for _, line in ipairs(file_content) do
		if is_error == false then
			if line:match("# Subtest:") then
				local padding, subtest_name = line:match("^(%s*)# Subtest: (.+)$")
				local padding_length = padding and #padding or 0
				local test_level = padding_length / 4 + 1

				if subtest_name then
					context_stack[test_level] = subtest_name
				end

				if last_test_key and results[last_test_key] and #errors > 0 then
					results[last_test_key].errors = errors
					errors = {}
				end

				if #context_stack > test_level then
					context_stack[#context_stack] = nil
				end
			elseif line:match("ok %d+") then
				local test_indent, test_status, test_name = line:match("^(%s*)(%w*%s*ok) %d+ %- (.+)$")

				if test_status and test_name then
					local status = test_status == "ok" and "passed" or "failed"
					local test_result_level = #test_indent / 4 + 1

					local full_context = table.concat(context_stack, "::", 1, test_result_level)
					local test_key = spec.context.id .. "::" .. full_context
					results[test_key] = {
						status = status,
						short = test_name .. ": " .. test_status,
						output = result_output.output,
					}
					last_test_key = test_key
				end
			elseif line:match("error: |-") then
				is_error = true
			end
		end

		if is_error == true then
			if line:match("TestContext") and is_error then
				local line_number = line:match("TestContext.*:(%d+):%d+%)")
				error.line = line_number
			elseif line:match("code: ") or line:match("%.%.%.") then
				is_error = false
				table.insert(errors, error)
				error = {}
			elseif not line:match("error: |-") then
				local initial_message = ""
				if error.message then
					initial_message = error.message
				end
				local new_message = line:match("^%s+(.+)")
				error.message = initial_message .. "\n" .. new_message
			end
		end
	end

	return results
end

return Result
