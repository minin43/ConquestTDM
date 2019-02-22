net.Receive("KillstreakNotification", function()
    local plyName = net.ReadString()
    local soundName = net.ReadString()
    local num = net.ReadInt(16)
    
    chat.AddText(color_white, plyName .. " is on a " .. tostring(num) .. " kill streak!")
end)