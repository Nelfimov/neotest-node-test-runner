local lib = require("neotest.lib")

local Discoverer = {}

---Find test functions via TreeSitter
---@param path string
---@return neotest.Tree
function Discoverer.discover_positions(path)
	local query = [[
    ; -- Namespaces --
    ; Matches: `describe('context')`
    ((call_expression
      function: (identifier) @func_name (#eq? @func_name "describe")
      arguments: (arguments (string (string_fragment) @namespace.name) (arrow_function))
    )) @namespace.definition
    ; Matches: `describe.only('context')`
    ((call_expression
      function: (member_expression
        object: (identifier) @func_name (#any-of? @func_name "describe")
      )
      arguments: (arguments (string (string_fragment) @namespace.name) (arrow_function))
    )) @namespace.definition
    ; Matches: `describe.each(['data'])('context')`
    ((call_expression
      function: (call_expression
        function: (member_expression
          object: (identifier) @func_name (#any-of? @func_name "describe")
        )
      )
      arguments: (arguments (string (string_fragment) @namespace.name) (arrow_function))
    )) @namespace.definition

    ; -- Tests --
    ; Matches: `test('test') / it('test')`
    ((call_expression
      function: (identifier) @func_name (#any-of? @func_name "it" "test")
      arguments: (arguments (string (string_fragment) @test.name) (arrow_function))
    )) @test.definition
    ; Matches: `test.only('test') / it.only('test')`
    ((call_expression
      function: (member_expression
        object: (identifier) @func_name (#any-of? @func_name "test" "it")
      )
      arguments: (arguments (string (string_fragment) @test.name) (arrow_function))
    )) @test.definition
    ; Matches: `test.each(['data'])('test') / it.each(['data'])('test')`
    ((call_expression
      function: (call_expression
        function: (member_expression
          object: (identifier) @func_name (#any-of? @func_name "it" "test")
        )
      )
      arguments: (arguments (string (string_fragment) @test.name) (arrow_function))
    )) @test.definition
  ]]
	query = query .. string.gsub(query, "arrow_function", "function_expression")
	return lib.treesitter.parse_positions(path, query, { nested_tests = true })
end

--- Check if file is a test file
--- @param file_path string
--- @return boolean
function Discoverer.is_test_file(file_path)
	if file_path == nil then
		return false
	end

	local is_test_file = false

	if string.match(file_path, "__tests__") then
		is_test_file = true
	end

	for _, x in ipairs({ "spec", "test" }) do
		for _, ext in ipairs({ "js", "jsx", "coffee", "ts", "tsx" }) do
			if string.match(file_path, "%." .. x .. "%." .. ext .. "$") then
				is_test_file = true
				goto matched_pattern
			end
		end
	end
	::matched_pattern::
	return is_test_file
end

---Get the project root dir
---@param dir string
---@return string | nil
function Discoverer.root(dir)
	return lib.files.match_root_pattern("package.json", ".git")(dir)
end

---Filter out dirs
---@param name string
---@param _relpath any
---@param _root any
---@return boolean
function Discoverer.filter_dir(name, _relpath, _root)
	return name ~= "node_modules"
end

return Discoverer
