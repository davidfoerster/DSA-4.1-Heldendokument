local locale = {all = assert(os.setlocale(""))}
for category, name in locale.all:gmatch("([%w_]+)=([^;]*)") do
	locale[category:sub(4):lower()] = name
end

local format = {locale = locale}


function format.group_thousands(value, sep, group_length)
	local svalue = tostring(math.abs(value))
	if sep == nil then
		sep = format.thousands_separator
	end
  if group_length == nil then
    group_length = 3
  end
  if sep ~= "" and group_length < #svalue then
	  local thousands = {}
	  local i = #svalue % group_length
	  if i ~= 0 then
	    table.insert(thousands, svalue:sub(1, i))
	  end
	  for i = i + 1, #svalue, group_length do
	    table.insert(thousands, svalue:sub(i, i + group_length))
	  end
	  svalue = table.concat(thousands, sep)
	 end
	 if value < 0 then
	 	svalue = "−" .. svalue
	 end
	 return svalue
end


function format.decimal(value, fmt)
	-- LuaTeX doesn't use the numeric category from the environment (unless forced).
	-- Therefore, use the messages category temporarily.
	assert(os.setlocale(locale.messages, "numeric"))
	if fmt then
		value = string.format(fmt, value)
	else
		value = tostring(value)
	end
	assert(os.setlocale(locale.numeric, "numeric"))
	return value
end


local decimal_to_thousands_separator_mapping = {
	["."] = ",",
	[","] = ".",
}
format.thousands_separator =
	decimal_to_thousands_separator_mapping[format.decimal(0.5):match("%p")]


return format
