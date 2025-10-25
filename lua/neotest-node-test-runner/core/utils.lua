local Utils = {}

function Utils.get_yarn_version()
	local handle = io.popen("yarn -v")
	if handle then
		local output = handle:read("*l")
		handle:close()
		return output
	end
end

function Utils.is_yarn_atls()
	local version = Utils.get_yarn_version()
	return version and version:match("atls")
end

function Utils.is_yarn_raijin()
	local version = Utils.get_yarn_version()
	local handle = io.popen("git remote get-url origin")
	if handle then
		local output = handle:read("*l")
		handle:close()
		return version == nil and output:match("raijin")
	end
	return false
end

return Utils
