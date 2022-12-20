local monitors = {peripheral.find("monitor")}

function DefineMonitors()
    for i in monitors do
        i.setBackgroundColor(colors.gray)
        i.clear()
        i.setCursorPos(1, 1)
        i.write("Define as Status Display")
    end
end