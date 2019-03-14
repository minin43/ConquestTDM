GM.AttachmentList = { }

function SaveCurrentAttachments()
    for _, weaponEnt in pairs( LocalPlayer():GetWeapons() ) do
        if weaponEnt.Base == "cw_base" and weaponEnt.Attachments then
            GAMEMODE.AttachmentList[ weaponEnt:GetClass() ] = { }
            for typeIdentifier, tab in pairs( weaponEnt.Attachments ) do
                if tab.last and tab.last > 0 then
                    GAMEMODE.AttachmentList[ weaponEnt:GetClass() ][ typeIdentifier ] = tab.last
                end
            end
        end
    end
end

net.Receive( "StartAttTrack", function()
    if timer.Exists( "AttTracking" ) then
        timer.Remove( "AttTracking" )
    end

    timer.Create( "AttTracking", 10, 0, function()
        if !LocalPlayer():Alive() then
            timer.Remove( "AttTracking" )
        else
            SaveCurrentAttachments()
        end
    end )
end )

net.Receive( "GetCurrentAttachments", function()
    SaveCurrentAttachments()
    
    net.Start( "GetCurrentAttachmentsCallback" )
        net.WriteTable( GAMEMODE.AttachmentList )
    net.SendToServer()
end )

--[[
    Above format
    GAMEMODE.AttachmentList = {
        ["cw_ar15"] = { "+reload" = 1, 1 = 3, 2 = 1 } // The second number corresponds to the order the attachment is in in its attachment list
    }
]]