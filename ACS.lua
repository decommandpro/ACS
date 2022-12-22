local red = 0xAA0000
local lime = 0x00FF00


local unDefMonitors = {peripheral.find("monitor")}
local monitorTypes = {"Ship Status", "Indicators", "LevelTrim", "RotTrim", "Thrust", "FlightInfo"}
local definedMonitors = {}

function DefineMonitors()
    for i, t in pairs(monitorTypes) do
        for j, m in pairs(unDefMonitors) do
            m.setPaletteColor(colors.red, red)
            m.setPaletteColor(colors.lime, lime)

            m.setBackgroundColor(colors.gray)
            m.setTextColor(colors.white)
            m.setTextScale(0.5)
            m.clear()
            m.setCursorPos(1, 1)
            m.write("Define for:")
            m.setCursorPos(1, 2)
            m.write(t)
        end
        local _, side = os.pullEvent("monitor_touch")
        definedMonitors[t] = peripheral.wrap(side)
        definedMonitors[t].setBackgroundColor(colors.black)
        definedMonitors[t].clear()

        for j, m in pairs(unDefMonitors) do
            if peripheral.getName(m) == peripheral.getName(definedMonitors[t]) then
                table.remove(unDefMonitors, j)
            end
        end
    end
    for i, m in pairs(unDefMonitors) do
        m.setBackgroundColor(colors.black)
        m.clear()
    end
end



function UpdateShipStatusDisplay()
    local m = definedMonitors["Ship Status"]

    local StressCap = 100000
    local StressUsage = 80000

    local bars = {
        Stress = {Value = StressUsage/StressCap*10, Extra = "("..StressUsage.."/"..StressCap..")", Inverted = true},
        Fuel = {Value = 3, Extra = "(".."30".."/".."100"..")", Inverted = false},
    }

    

    --[[for i=1, 10 do
        if i <= StressUsage/StressCap*10 then
            m.setTextColor(colors.red)
        else
            m.setTextColor(colors.lime)
        end
        m.write(string.char(171))
    end]]--

    

    m.setCursorPos(1, 3)
    for i, b in pairs(bars) do
        m.setTextColor(colors.lightGray)
        m.setBackgroundColor(colors.black)
        local _, y = m.getCursorPos()
        m.setCursorPos(1, y)
        m.write(i..": ")
        m.setCursorPos(15, y)
        for j=1, 10 do
            if b.Inverted then
                if j <= b.Value then
                    m.setTextColor(colors.red)
                else
                    m.setTextColor(colors.lime)
                end
            else
                if j >= b.Value then
                    m.setTextColor(colors.red)
                else
                    m.setTextColor(colors.lime)
                end
            end
            m.write(string.char(187))
        end

        m.setTextColor(colors.gray)
        m.setCursorPos(26, y)
        m.write(b.Extra)
        m.setCursorPos(1, y+1)
    end
end



function UpdateIndicatorsDisplay()
    local m = definedMonitors["Indicators"]
    local lights = {
        LandingGear = true,
        Thrusters = false,
    }
    local warnings = {
        OverStressed = true,
        Stall = true,
        Falling = true,
        Damage = true,
    }

    m.setTextColor(colors.lightGray)
    m.setBackgroundColor(colors.black)
    m.setCursorPos(2, 3)
    for i, v in pairs(lights) do
        if v then
            m.blit(" ", "5", "5")
        else
            m.blit(" ", "e", "e")
        end
        m.write(" "..i)

        local _, y = m.getCursorPos()
        m.setCursorPos(2, y+1)
    end

    m.setTextColor(colors.red)
    m.setBackgroundColor(colors.black)
    m.setCursorPos(30, 3)
    for i, v in pairs(warnings) do
        if v then
            m.write(i)

            local _, y = m.getCursorPos()
            m.setCursorPos(30, y+1)
        end
    end
end


function DrawTrimCross(m)
    m.setCursorPos(2, 6)
    for i=1, 13 do
        m.blit("-", "7", "f")
    end
    for i=1, 9 do
        m.setCursorPos(8, i+1)
        m.blit("|", "7", "f")
    end
    m.setCursorPos(8, 6)
    m.blit(string.char(127), "7", "f")
end


function DrawTrimOutlines(m)
    m.setCursorPos(1, 2)
    for i=1, 9 do
        m.setCursorPos(1, i+1)
        m.blit(string.char(127), "f", "8")

        m.setCursorPos(15, i+1)
        m.blit(string.char(127), "f", "7")
    end
end



function UpdateLTrimDisplay()
    local m = definedMonitors["LevelTrim"]

    DrawTrimCross(m)
    DrawTrimOutlines(m)


end



function UpdateRTrimDisplay()
    local m = definedMonitors["RotTrim"]

    DrawTrimCross(m)
    DrawTrimOutlines(m)

    
end



function UpdateThrustDisplay()
    local m = definedMonitors["Thrust"]

    DrawTrimCross(m)
    DrawTrimOutlines(m)

    
end



function UpdateDisplays()
    for i, m in pairs(definedMonitors) do
        m.setBackgroundColor(colors.black)
        m.clear()
        m.setTextColor(colors.black)
        m.setBackgroundColor(colors.lightGray)
        m.setCursorPos(1, 1)
        m.clearLine()
        m.write(i)
    end
    UpdateShipStatusDisplay()
    UpdateIndicatorsDisplay()
    UpdateLTrimDisplay()
    UpdateRTrimDisplay()
    UpdateThrustDisplay()
end







DefineMonitors()

while sleep(0.1) or true do
    UpdateDisplays()
end


--for i, m in pairs(definedMonitors) do
--    m.write(i)
--end