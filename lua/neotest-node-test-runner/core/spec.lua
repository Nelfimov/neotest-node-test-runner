local Utils = require("adapters.core.utils")
local lib = require("neotest.lib")

local Spec = {}

---Create execution command
---@param args any
---@return table
function Spec.build_spec(args)
	local file_path = args.tree:data().path
	local command
	local env = {}

	local rootPath = lib.files.match_root_pattern(".git")(args[1])
	local has_yarn_lock = rootPath and lib.files.exists(rootPath .. "/yarn.lock")

	if has_yarn_lock then
		if Utils.is_yarn_atls() then
			command = {
				"yarn",
				"test",
				"--test-reporter=tap",
				file_path,
			}
		elseif Utils.is_yarn_raijin() then
			io.popen("source " .. rootPath .. "/.env && export NODE_OPTIONS")
			env.NODE_OPTIONS = "-r "
				.. rootPath
				.. "/.pnp.cjs --loader "
				.. rootPath
				.. "/.pnp.loader.mjs --experimental-vm-modules --max-old-space-size=8192 --no-warnings=ExperimentalWarning"

			command = {
				"yarn",
				"test",
				"--test-reporter=tap",
				file_path,
			}
		else
			command = {
				"yarn",
				"node",
				"--experimental-strip-types",
				"--experimental-transform-types",
				"--test",
				"--no-warnings=ExperimentalWarning",
				"--test-reporter=tap",
				file_path,
			}
		end
	else
		command = {
			"node",
			"--experimental-strip-types",
			"--experimental-transform-types",
			"--test",
			"--no-warnings=ExperimentalWarning",
			"--test-reporter=tap",
			file_path,
		}
	end

	return {
		command = command,
		env = env,
		context = args.tree:data(),
		cwd = vim.fn.getcwd(),
	}
end

return Spec
