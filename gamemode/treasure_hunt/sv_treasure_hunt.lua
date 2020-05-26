GM.SaidTheMagicWords = {}

util.AddNetworkString( "SaidMagicPhrase" )

hook.Add( "PlayerSay", "SaidTheMagicPhrase", function( ply, msg, teamOnly )
    local stringCheck = string.lower( msg )
    --[[print(stringCheck, GAMEMODE.EquippedTitles[ id( ply:SteamID() ) ])
    if GAMEMODE.EquippedTitles[ id( ply:SteamID() ) ] then
        local len = string.len( "[" .. GAMEMODE.EquippedTitles[ id( ply:SteamID() ) ] .. "]" )
        stringCheck = string.Right( string.lower( msg ), len )
    end
    print(stringCheck)]]
    if string.StartWith( stringCheck, "!inputsenabled" ) and !GAMEMODE.SaidTheMagicWords[ ply ] then
        GAMEMODE.SaidTheMagicWords[ ply ] = true
        net.Start( "SaidMagicPhrase" )
        net.Send( ply )
        return "Read the help menu, you twat!"
    end
end )