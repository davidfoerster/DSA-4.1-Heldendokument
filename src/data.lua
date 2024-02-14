local ext = ".tex"
local n = #arg
for i, name in ipairs(arg) do
  if string.sub(name, -#ext, -1):lower() == ext then
    n = i + 1
    break
  end
end

if n < #arg then
  tex.error("zu viele Argumente: '" .. table.concat(arg, "' '", n + 1) .. "'")
end

local filename = arg[n]
local values = assert(loadfile("values.lua", "t")(filename))
values.filename = filename

return values
