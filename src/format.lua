local format = {}

function format.group_thousands(value, sep, group_length)
	value = tostring(value)
  if group_length == nil then
    group_length = 3
  end
  local thousands = {}
  local i = #value % group_length
  if i ~= 0 then
    table.insert(thousands, value:sub(1, i))
  end
  for i = i + 1, #value, group_length do
    table.insert(thousands, value:sub(i, i + group_length))
  end
  return table.concat(thousands, sep or ".")
end

return format
