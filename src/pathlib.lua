local pathlib = {}

function pathlib.isabs(path)
  return path:find("^/") == 1
end

function pathlib.basename(path)
	return path:match("([^/]+)/*$") or path
end

function pathlib.dirname(path)
	local i = path:find("/+[^/]*/*$")
	return i and (i == 1 and path or path:sub(1, i - 1)) or "."
end

function pathlib.splitext(path)
	local base, ext = path:match("^(.*[^/]+)(%.[^./]+)$")
	return base or path, ext or ""
end

function pathlib.join(path, ...)
	assert(type(path) == "string")
	path = path == "" and {} or {path}
  for _, p in ipairs({...}) do
    if pathlib.isabs(p) then
      path = {p}
    elseif p ~= "" and (#path == 0 or p ~= ".") then
      table.insert(path, p)
    end
  end
  return table.concat(path, "/")
end

return pathlib
