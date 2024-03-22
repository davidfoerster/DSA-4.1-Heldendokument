local pathlib = {}

function pathlib.splitext(path)
	local base, ext = path:match("^(.*[^/]+)(%.[^./]+)$")
	return base or path, ext or ""
end

return pathlib
