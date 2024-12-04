local Spec = {}

---Create execution command
---@param args any
---@return table
function Spec.build_spec(args)
	local file_path = args.tree:data().path
	local command = {
		"node",
		"--experimental-strip-types",
		"--experimental-transform-types",
		"--test",
		"--no-warnings=ExperimentalWarning",
		"--test-reporter=tap",
		file_path,
	}
	return {
		command = command,
		context = args.tree:data(),
		cwd = vim.fn.getcwd(),
	}
end

return Spec
