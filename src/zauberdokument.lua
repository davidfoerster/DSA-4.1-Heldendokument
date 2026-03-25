require("stdext")
local data = require("data")
local common = require("common")

local zauberdokument = {}

function zauberdokument.asp_regeneration()
  tex.sprint([[\rule{0pt}{1em}]])
  if data:cur("KL") ~= "" and data:cur("IN") ~= "" then
    local val = data.Vorteile.Magisch.AstraleRegeneration or 0
    if data.Nachteile.Magisch.AstralerBlock then
      val = val - 1
    end
    local mr = data.SF.Magisch.MeisterlicheRegeneration
    if mr ~= nil then
      tex.sprint(-2, val + 3 + math.round(data:cur(mr) / 3))
    else
      common.schaden.render(
        {dice=1, die=6, num=val + #data.SF.Magisch:getlist("Regeneration")})
    end
  end
end

return zauberdokument
