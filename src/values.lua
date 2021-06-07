local i = 1
while i <= #arg do
  local name = arg[i]
  i = i + 1

  if name == "heldendokument.tex" then
    break
  end
end

if i > #arg then
  tex.error("missing argument for hero data!")
end

local function sum_and_round(items, pos)
  local cur = nil
  for i,v in ipairs(items) do
    if #v >= pos then
      local num = tonumber(v[pos])
      if num == nil then
        return ""
      elseif cur == nil then
        cur = num
      else
        cur = cur + num
      end
    end
  end
  return cur == nil and "" or tonumber(string.format("%.0f", cur + 0.0001)) -- round up at 0.5
end

local values = require(arg[i])

local getter_map = {
  calc = {
    LE = function() return {"KO", "KO", "KK", div=2} end,
    AU = function() return {"MU", "KO", "GE", div=2} end,
    AE = function()
      if data.vorteile.magisch then
        if data.sf.magisch.gefaess_der_sterne then
          return {"MU", "IN", "CH", "CH", div=2}
        else
          return {"MU", "IN", "CH", div=2}
        end
      else
        return {"MU", "IN", "CH", div=2, disabled=true}
      end
    end,
    MR = function() return {"MU", "KL", "KO", div=5} end,
    KE = function() return {"KE", hide_formula = true} end,
    INI = function() return {"MU", "MU", "IN", "GE", div=5, add_sf=true} end,
    AT = function() return {"MU", "GE", "KK", div=5} end,
    PA = function() return {"IN", "GE", "KK", div=5} end,
    FK = function() return {"IN", "FF", "KK", div=5} end,
  },
}

function getter_map:reg(kind, ...)
  for i,v in ipairs({...}) do
    self[v] = kind
  end
end

function getter_map:formula(name)
  local vals = self.calc[name]()
  if vals.hide_formula then
    return ""
  end
  local res = "("
  for i,v in ipairs(vals) do
    if i ~= 1 then
      res = res .. "+"
    end
    res = res .. v
  end
  return res .. ")/" .. vals.div
end

getter_map:reg("basic", "MU", "KL", "IN", "CH", "FF", "GE", "KO", "KK", "GS")
getter_map:reg("calculated", "LE", "AU", "AE", "MR", "KE", "INI", "AT", "PA", "FK")
getter_map:reg("rs", "RS")
getter_map:reg("be", "BE")
getter_map:reg("be_voll", "BE_voll")

function getter_map.sparse(val, div)
  div = div or 1
  if val == 0 then
    return ""
  end
  return tonumber(string.format("%.0f", val/div + 0.0001)) -- round up at 0.5
end

values.sparse = getter_map.sparse

setmetatable(getter_map.calc, {
  __call = function(self, data, name)
    local vals = self[name]()
    if vals.disabled then
      return ""
    end
    local div = vals.div and vals.div or 1
    local val = 0
    for i,v in ipairs(vals) do
      local x = 0
      if v == "KE" then
        x = data.eig.KE[1]
      else
        x = data.eig[v][3]
      end
      if x == 0 then
        return ""
      end
      val = val + x
    end
    val = val / div
    if val == 0 then
      return ""
    end
    local others = data.eig[name]
    if others and #others >= 1 then
      -- Modifikator
      val = val + others[1]
      if #others >= 2 then
        -- Zugekauft
        val = val + others[2]
        if #others >= 3 then
          -- Permanent
          val = val - others[3]
        end
      end
    end
    if vals.add_sf then
      if data.sf.kampfreflexe then
        val = val + 4
      end
      if data.sf.kampfgespuer then
        val = val + 2
      end
    end
    return getter_map.sparse(val)
  end
})

function values:cur(name, div)
  div = div or 1
  local kind = getter_map[name]
  if kind == "basic" then
    return getter_map.sparse(self.eig[name][3], div)
  elseif kind == "calculated" then
    return getter_map.calc(self, name)
  elseif kind == "rs" then
    return sum_and_round(self.ruestung, 2)
  elseif kind == "be" or kind == "be_voll" then
    local val = sum_and_round(self.ruestung, 3)
    if val == "" then
      return val
    end
    if kind == "be" then
      if self.sf.ruestungsgewoehnung[3] then
        val = val - 2
      elseif self.sf.ruestungsgewoehnung[1] then
        val = val - 1
      end
      if val < 0 then
        val = 0
      end
    end
    return val
  else
    tex.error("queried unknown value: " .. name)
  end
end

function values:formula(name)
  local kind = getter_map[name]
  if kind ~= "calculated" then
    tex.error("requested formula of something not calculated: " .. name)
  end
  return getter_map:formula(name)
end

return values