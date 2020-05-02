--//Contains all perk-related tables, functions, and net messages
GM.DefaultIconDuration = 1
GM.Perks = {}
perks = GM.Perks

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

function RegisterPerk( name, value, lvl, hint )
	table.insert( GM.Perks, { name, value, lvl, hint } )
	table.sort( GM.Perks, function( a, b ) return a[ 3 ] < b[ 3 ] end )
end

function CheckPerk( ply )
	if ply:IsPlayer() and GAMEMODE.PlayerLoadouts[ ply ] ~= nil then
		if ply.perk and GAMEMODE.PlayerLoadouts[ ply ].perk then
			return GAMEMODE.PlayerLoadouts[ ply ].perk
		end
	end
end

function GetPerkTable( perkid )
    for k, v in pairs( GAMEMODE.Perks ) do
        if v[ 2 ] == perkid then
            return v
        end
    end
    return false
end