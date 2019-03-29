--If you have died to a player 3 times without killing them, they become your vendetta, and you see them through all walls

GM.VendettaPlayers = { }

net.Receive( "UpdateVendetta", function()
    local ply = net.ReadString() --Comes in as: id( ply:SteamID() )
    local toAdd = net.ReadBool()
    if ply == id( LocalPlayer():SteamID() ) then return end

    if toAdd then
        for k, v in pairs( player.GetAll() ) do
            if ply == id( v:SteamID() ) then
                GAMEMODE.VendettaPlayers[ ply ] = v
            end
        end
    else
        for k, v in pairs( GAMEMODE.VendettaPlayers ) do
            if ply == k then
                GAMEMODE.VendettaPlayers[ k ] = nil
            end
        end
    end
end )

hook.Add( "PreDrawHalos", "VendettaHalos", function()
    --if !LocalPlayer():Alive() then return end
    if LocalPlayer():Team() == 0 then return end

    halo.Add( GAMEMODE.VendettaPlayers, Color( 255, 255, 255 ), 1, 1, 1, true, true )
end )