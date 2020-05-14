GM.SaidTheMagicWords = {}

util.AddNetworkString( "SaidMagicPhrase" )

hook.Add( "PlayerSay", "SaidTheMagicPhrase", function( ply, msg, teamOnly )
    local stringCheck = string.lower( msg )
    if GAMEMODE.EquippedTitles[ id( ply:SteamID() ) ] then
        local len = string.len( "[" .. GAMEMODE.EquippedTitles[ id( ply:SteamID() ) ] .. "]" )
        stringCheck = string.Right( string.lower( msg ), len )
    end
    if string.StartWith( stringCheck, "!inputsenabled" ) and !GAMEMODE.SaidTheMagicWords[ ply ] then
        GAMEMODE.SaidTheMagicWords[ ply ] = true
        net.Send( "SaidMagicPhrase" )
        net.Send( ply )
        return "Read the help menu, you twat!"
    end
end )