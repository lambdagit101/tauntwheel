local enabledTauntWheel = false
local selectedTaunt = 0

local availableTaunts = {"dance", "wave", "laugh", "cheer", "muscle", "robot", "zombie", "becon", "agree", "disagree", "salute", "forward", "pers", "group", "halt", "bow"}

local tauntWheelAlpha = 0
local tauntWheel = tauntWheel or {}
tauntWheel.mInputEnabler = vgui.Create("Panel")
tauntWheel.mInputEnabler:SetSize(ScrW(), ScrH())
tauntWheel.mInputEnabler.Paint = nil

function PointOnCircle(ang, radius, offX, offY)
    ang = math.rad(ang)
    local x = math.cos(ang) * radius + offX
    local y = math.sin(ang) * radius + offY

    return x, y
end

hook.Add("InitPostEntity", "tauntwheel-initialize", function()
    local numSquares = #availableTaunts
    local interval = 360 / numSquares
    local centerX, centerY = ScrW() / 2 - 24, ScrH() / 2 - 24
    local radius = 216
    local increment = 0

    for degrees = 1, 360, interval do
        increment = increment + 1
        local tempincrement = increment
        local x, y = PointOnCircle(degrees, radius, centerX, centerY)
        local tauntBooton = vgui.Create("DButton", tauntWheel.mInputEnabler)
        tauntBooton:SetPos(x, y)
        tauntBooton:SetSize(48, 48)
        tauntBooton:SetText(string.upper(string.sub(availableTaunts[tempincrement], 1, 1)) .. string.sub(availableTaunts[tempincrement], 2, #availableTaunts[tempincrement]))
        tauntBooton:SetTextColor(color_white)

        tauntBooton.Paint = function(self, w, h)
            if self:IsHovered() then
                draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, tauntWheelAlpha - 100))
            else
                draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, tauntWheelAlpha - 155))
            end
        end

        tauntBooton.Think = function(self)
            if self:IsHovered() then
                selectedTaunt = tempincrement
            end
        end
    end

    tauntWheel.mInputEnabler:Hide()

    hook.Add("HUDPaint", "gmod-mw-tauntwheel", function()
        tauntWheelAlpha = Lerp(FrameTime() * 10, tauntWheelAlpha, enabledTauntWheel and 255 or 0)
        draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, tauntWheelAlpha - 200))
        draw.RoundedBox(480, ScrW() / 2 - 240, ScrH() / 2 - 240, 480, 480, Color(0, 0, 0, tauntWheelAlpha - 155))
    end)

    concommand.Add("+mw_tauntwheel", function(ply, cmd, args)
        enabledTauntWheel = true
        tauntWheel.mInputEnabler:Show()
        tauntWheel.mInputEnabler:MakePopup()
        tauntWheel.mInputEnabler:SetKeyboardInputEnabled(false)
    end)

    concommand.Add("-mw_tauntwheel", function(ply, cmd, args)
        enabledTauntWheel = false
        tauntWheel.mInputEnabler:Hide()
        RunConsoleCommand("act", availableTaunts[selectedTaunt])
    end)
end)
