-- Rounds to the nearest integer. Halfway cases are arounded _away_ from zero.
function math.round(x)
  local integral, fractional = math.modf(x)
  if fractional >= 0.5 then
    return integral + 1
  elseif fractional <= -0.5 then
    return integral - 1
  end
  return integral
end


-- Find item `x` in a sequential table and returns its index or `nil` if such an
-- item doesn't occur.
--
-- If `key` is specified and a function, it is called for each list item until
-- its return value equals `x`. Returns the index of the matching item as well
-- as the matching item itself.
--
-- If `key` is specified and *not* a funtion, looks up the entry `key` in each
-- list item until it matches `x`.
function table:find(x, key)
  if key == nil then
    for i, v in ipairs(self) do
      if v == x then
        return i
      end
    end
  elseif type(key) == "function" then
    for i, v in ipairs(self) do
      if key(v) == x then
        return i, v
      end
    end
  else
    for i, v in ipairs(self) do
      if v[key] == x then
        return i, v
      end
    end
  end
  return nil
end
