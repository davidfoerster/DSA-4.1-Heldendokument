function string:lstrip()
  return self:gsub("^%s+", "", 1)
end

function string:rstrip()
  return self:gsub("%s+$", "", 1)
end

function string:strip()
  return self:lstrip():rstrip()
end

function table:find(x, key)
  if key then
    for i, v in ipairs(self) do
      if v[key] == x then
        return i, v
      end
    end
  else
    for i, v in ipairs(self) do
      if v == x then
        return i, v
      end
    end
  end
  return nil
end

-- Rounds to the nearest integer. Halfway cases are arounded _away_ from zero.
function math.round(x)
  local integral, fractional = math.modf(x)
  if fractional >= 0.5 then
    return integral + 1
  else if fractional <= -0.5 then
    return integral - 1
  end
  return integral
end
