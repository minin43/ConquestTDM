net.Receive( "GetCurrentAttachments", function()
    if !LocalPlayer():Alive() then return end

    local AttachmentList = { }
    for _, weaponEnt in pairs( LocalPlayer():GetWeapons() ) do
        if weaponEnt.Base == "cw_base" and weaponEnt.Attachments then
            AttachmentList[ weaponEnt:GetClass() ] = { }
            for typeIdentifier, tab in pairs( weaponEnt.Attachments ) do
                if tab.last and tab.last > 0 then
                    AttachmentList[ weaponEnt:GetClass() ][ typeIdentifier ] = tab.last
                end
            end
        end
    end

    net.Start( "GetCurrentAttachmentsCallback" )
        net.WriteTable( AttachmentList )
    net.SendToServer()
end )

--[[
    Above format
    AttachmentList = {
        ["cw_ar15"] = { "+reload" = 1, 1 = 3, 2 = 1 } // The second number corresponds to the order the attachment is in in its attachment list
    }
]]