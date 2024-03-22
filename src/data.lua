local pathlib = require("pathlib")

local n = nil
for i, name in ipairs(arg) do
  local _, ext = pathlib.splitext(name)
  if ext:lower() == ".tex" then
    n = i + 1
    break
  end
end

if not n then
  tex.error(string.format(
    "Keine .tex-Datei in der Argumentenliste: {%s}", table.concat(arg, ", ")))
elseif n < #arg then
  tex.error(string.format(
    "Zu viele Argumente: '%s'", table.concat(arg, "' '", n + 1)))
end

return assert(loadfile("values.lua", "t"))(arg[n])
