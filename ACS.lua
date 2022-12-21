local monitors = {peripheral.find("monitor")}
local monitorTypes = {"Status", "LevelTrim", "RotTrim"}
local definedMonitors = {}

function DefineMonitors()
    for i, t in pairs(monitorTypes) do
        for j, m in pairs(monitors) do
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
        for j, m in pairs(monitors) do
            if m == definedMonitors[t] then
                table.remove(monitors, j)
                print("remove")
            end
        end
    end
end

DefineMonitors()
for i, m in pairs(definedMonitors) do
    m.write(i)
end