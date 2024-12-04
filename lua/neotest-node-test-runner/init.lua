local Discoverer = require("neotest-node-test-runner.core.neotest-discoverer")
local Spec = require("neotest-node-test-runner.core.neotest-spec")
local Result = require("neotest-node-test-runner.core.neotest-result")

---@class neotest.Adapter
local NodeTestAdapter = {}

NodeTestAdapter.name = "neotest-node-runner"

---Find project root dir
---@param dir string
---@return string | nil
function NodeTestAdapter.root(dir)
	return Discoverer.root(dir)
end

---Check if file is a test file
---@param file_path string
---@return boolean
function NodeTestAdapter.is_test_file(file_path)
	return Discoverer.is_test_file(file_path)
end

---Discover tests and suites within file
---@param path string
---@return neotest.Tree
function NodeTestAdapter.discover_positions(path)
	return Discoverer.discover_positions(path)
end

---Create execution command
function NodeTestAdapter.build_spec(args)
	return Spec.build_spec(args)
end

---Process results file
---@param spec neotest.RunSpec
---@param result_output neotest.StrategyResult
---@param _ neotest.Tree
---@return neotest.Result
function NodeTestAdapter.results(spec, result_output, _)
	return Result.results(spec, result_output, _)
end

---Filter out directories
---@param name string
---@param _relpath any
---@param _root any
---@return boolean
function NodeTestAdapter.filter_dir(name, _relpath, _root)
	return Discoverer.filter_dir(name, _relpath, _root)
end

return NodeTestAdapter
