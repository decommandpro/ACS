local unDefMonitors = {peripheral.find("monitor")}
local monitorTypes = {"Ship Status", "Indicators", "LevelTrim", "RotTrim"}
local definedMonitors = {}

function DefineMonitors()
    for i, t in pairs(monitorTypes) do
        for j, m in pairs(unDefMonitors) do
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

    m.setTextColor(colors.lightGray)
    m.setBackgroundColor(colors.black)
    m.setCursorPos(1, 3)
    m.write("Stress: ")

    m.setCursorPos(15, 3)
    for i=1, 10 do
        if i <= StressUsage/StressCap*10 then
            m.setTextColor(colors.lime)
        else
            m.setTextColor(colors.red)
        end
        m.write(string.char(187))
    end

    m.setTextColor(colors.gray)
    m.setCursorPos(26, 3)
    m.write("("..StressUsage.."/"..StressCap..")")
end



function UpdateIndicatorsDisplay()
    local m = definedMonitors["Indicators"]
    local lights = {
        LandingGear = true,
    }
    local warnings = {
        OverStressed = true,
        Stall = true,
        Falling = true,
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



function UpdateDisplays()
    for i, t in pairs(monitorTypes) do
        local m = definedMonitors[t]
        m.setBackgroundColor(colors.black)
        m.clear()
        m.setTextColor(colors.black)
        m.setBackgroundColor(colors.lightGray)
        m.setCursorPos(1, 1)
        m.clearLine()
        m.write(t)
    end
    UpdateShipStatusDisplay()
    UpdateIndicatorsDisplay()
end







DefineMonitors()

while sleep(0.1) or true do
    UpdateDisplays()
end


--for i, m in pairs(definedMonitors) do
--    m.write(i)
--end