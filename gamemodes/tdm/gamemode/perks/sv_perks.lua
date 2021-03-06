--//Contains all perk-related tables, functions, and net messages
GM.DefaultIconDuration = 1
GM.Perks = {}
perks = GM.Perks

GM.PerkLevelsOverride = {
    --[[
        packrat         0   Utility
        crescendo       5   Combat
        hunter          10  Movement
        entrench        15  Combat
        rebound         20  Health
        frostbite       25  Combat
        headpopper      30  Sniper
        bleedout        35  Health
        martyrdom       40  Combat
        doublejump      45  Movement
        regeneration    50  Health
        thornmail       55  Combat
        vulture         60  Sniper/combat
        excited         65  Movement
        pyromancer      70  Combat
        leech           75  Health
        lifeline        80  Movement
        expertise       85  Combat
        deadlyweapon    90  Sniper
        vampir          95  Health
    ]]
    bleedout = 35,
    crescendo = 5,
    entrench = 15,
    deadlyweapon = 90,
    doublejump = 45,
    excited = 65,
    expertise = 85,
    frostbite = 25,
    headpopper = 30,
    hunter = 10,
    leech = 75,
    lifeline = 80,
    martyrdom = 40,
    packrat = 0,
    pyromancer = 70,
    rebound = 20,
    regeneration = 50,
    thornmail = 55,
    vampir = 95,
    vulture = 60
}

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
    print("[CTDM] Registering new perk: " .. name)
	table.insert( GM.Perks, { name, value, GM.PerkLevelsOverride[ value ] or lvl, hint } )
	table.sort( GM.Perks, function( a, b ) return a[ 3 ] < b[ 3 ] end )
end

function CheckPerk( ply )
    if ply and ply:IsValid() and ply:IsPlayer() then
        if GAMEMODE.PerkTracking[ id( ply:SteamID() ) ] then
            return GAMEMODE.PerkTracking[ id( ply:SteamID() ) ].ActivePerk 
        elseif GAMEMODE.PlayerLoadouts[ ply ] then
            return GAMEMODE.PlayerLoadouts[ ply ].perk
        else
            return "none"
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

for k, v in pairs( file.Find( "tdm/gamemode/perks/perks/*.lua", "LUA" ) ) do
    include( "/perks/" .. v )
end
hook.Call( "PostPerkLoading", GM, GM.Perks )