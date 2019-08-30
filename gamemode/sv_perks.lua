--//This file is to be used for handling sending clients relevant crosshair icons when perks 'n such effect the game
GM.DefaultIconDuration = 1

util.AddNetworkString( "QueueUpIcon" )

function GM:QueueIcon( player, perk, duration )
    local ply = player
    local str = perk or "none"
    local dur = duration or self.DefaultIconDuration

    if not IsValid( ply ) then return end

    net.Start( "QueueUpIcon" )
        net.WriteString( str )
        net.WriteFloat( dur ) --2^16 is probably overkill, but it's better safe than sorry
    net.Send( ply )
end