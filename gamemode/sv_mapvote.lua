util.AddNetworkString( "BeginMapvote" )
util.AddNetworkString( "MapvoteFinished" )
util.AddNetworkString( "PlayerVotedUpdate" )
util.AddNetworkString( "UpdateCountdown" )
util.AddNetworkString( "PlayerSelectedMap" )

GM.Votes = { } --The table that records the total tallies as well as all individual votes
GM.VoteOptions = { } --The table we send to clients, contains the 6 map options
GM.MapvoteTime = 20
GM.MapTable = { --Controls both the map autodownload and the mapvote information
    --[ "" ] = { id = , size = "", img = "" }
    [ "gm_lasertag" ] = { id = 473594402, size = "Tiny", img = "vgui/maps/lasertag.png" },
    [ "gm_floatingworlds_3" ] = { id = 122421739, size = "Enormous", img = "vgui/maps/floatingworlds.png" },
    [ "gm_forestforts" ] = { id = 253493702, size = "Large", img = "vgui/maps/forestforts.png" },
    [ "ttt_lazertag" ] = { id = 206405740, size = "Large", img = "vgui/maps/lazertag2.png" }, --Fix flags
    [ "ttt_gunkanjima_v2" ] = { id = 229000479, size = "Small", img = "vgui/maps/gunkanjima.png" },
    [ "ttt_forest_final" ] = { id = 147635981, size = "Small", img = "vgui/maps/forestfinal.png" },
    [ "ttt_riverside_b3" ] = { id = 312731430, size = "Midsize", img = "vgui/maps/riverside.png" },
    [ "de_asia" ] = { id = 872474392, size = "Midsize", img = "vgui/maps/asia.png" },
    [ "de_star" ] = { id = 296000772, size = "Large", img = "vgui/maps/star.png" }, --Fix flags & spawn
    [ "dm_canals" ] = { id = 108953008, size = "Large", img = "vgui/maps/canals.png" }, --Fix spawn
    [ "gm_toysoldiers" ] = { id = 313827200, size = "Enormous", img = "vgui/maps/toysoldier.png" },
    [ "sh_lockdown" ] = { id = 261713202, size = "Large", img = "vgui/maps/lockdown.png" },
    [ "sh_lockdown_v2" ] = { id = 423308835, size = "Large", img = "vgui/maps/lockdown2.png" },
    [ "sh_smalltown_c" ] = { id = 865967849, size = "Midsize", img = "vgui/maps/smalltown.png" },
    [ "ttt_mw2_terminal" ] = { id = 176887855, size = "Midsize", img = "vgui/maps/terminal.png" } --Fix flags
    --[[[ "cs_assault" ] = { size = "Midsize", img = "vgui/maps/assault.png" }, --Removed while player count remains low
    [ "cs_italy" ] = { size = "Midsize", img = "vgui/maps/italy.png" },
    [ "cs_compound" ] = { size = "Small", img = "vgui/maps/compound.png" },
    [ "de_cbble" ] = { size = "Midsize", img = "vgui/maps/cbbl.png" },
    [ "de_dust" ] = { size = "Midsize", img = "vgui/maps/dust.png" },
    [ "de_dust2" ] = { size = "Midsize", img = "vgui/maps/dust2.png" },
    [ "cs_office" ] = { size = "Small", img = "vgui/maps/office.png" }]]
}

print( "Checking the validity for current map: " .. game.GetMap() .. "..." )
if GM.MapTable[ game.GetMap() ] then
    print( "    Map is registered to work with the gamemode" )
    if GM.MapTable[ game.GetMap() ].id then
	    print( "    Map is set up to auto-download on player join, addon ID: " .. GM.MapTable[ game.GetMap() ].id )
        resource.AddWorkshop( tostring( GM.MapTable[ game.GetMap() ].id ) )
    else
        local prefix = string.sub( game.GetMap(), 1, 2 )
        print("DEBUG PREFIX: ", prefix )
        if prefix == "de" or prefix == "cs" or prefix == "dm" then
            print( "    Map is counter-strike or HL2:DM map, separate download not necessary" )
        end
        print( "    " .. game.GetMap() .. " is NOT set up to auto-download on player join" )
    end
else
	print( "    Map IS NOT registered to work with the mapvote, this may be due to lack of spawn/flag placements" )
end
print( "End map checking" )

for k, v in pairs( GM.MapTable ) do
    if flags[ k ] then --found in sv_flags
        v.flags = true
    else
        v.flags = false
    end
end

function EndMapvote()
    local winningMap, winningTotal = "", 0
    for k, v in pairs( GAMEMODE.Votes ) do
        if isnumber( v ) then --Since we record the individual votes as strings in this table, don't run them through this loop
            if v > winningTotal then --If new count is higher than old
                winningMap = k
                winningTotal = v
            elseif v == winningTotal then --If new count is same as old
                if math.random( 2 ) == 1 then --50/50 chance we'll take the new map
                    winningMap = k
                    winningTotal = v
                end
            end
        end
    end

    if winningMap == "" then --If no votes then re-do last map, I guess
        winningMap = file.Read( "tdm/lastmap.txt", "DATA" )
    end

    net.Start( "MapvoteFinished" )
        net.WriteString( winningMap )
    net.Broadcast()

    timer.Simple( 5, function()
        RunConsoleCommand( "changelevel", winningMap )
    end )
end

hook.Add( "StartMapvote", "RunMapvote", function( winner, loser )
    file.Write( "tdm/lastmap.txt", game.GetMap() )

    local lastmap = ""
    if file.Exists( "tdm/lastmap.txt", "DATA" ) then
        lastmap = file.Read( "tdm/lastmap.txt", "DATA" )
        GAMEMODE.MapTable[ lastmap ] = nil
        print( "Lastmap detected", lastmap, GAMEMODE.MapTable[ lastmap ] )
    end
    
    local key
    for counter = 1, 6 do
        if table.Count( GAMEMODE.MapTable ) != 0 then
            local mapTable, mapName = table.Random( GAMEMODE.MapTable )
            GAMEMODE.VoteOptions[ mapName ] = mapTable
            print(" Selecting map randomly: ", mapName )
            GAMEMODE.MapTable[ mapName ] = nil
        end
    end
    
    for k, v in pairs( GAMEMODE.VoteOptions ) do
        GAMEMODE.Votes[ k ] = 0
    end

    print( "Start Net Message BeginMapVote..." )
    net.Start( "BeginMapvote" )
        net.WriteTable( GAMEMODE.VoteOptions ) --The 6 maps we want to be sending to all clients
    net.Broadcast()

    timer.Create( "MapvoteCountdown", 1, GAMEMODE.MapvoteTime, function()
        net.Start( "UpdateCountdown" )
            net.WriteInt( timer.RepsLeft( "MapvoteCountdown" ), 6 )
        net.Broadcast()
    end )
    timer.Simple( GAMEMODE.MapvoteTime, function()
        EndMapvote()
    end )
end )

net.Receive( "PlayerSelectedMap", function( len, ply )
    local playerVote = net.ReadString() --map name they voted for

    if GAMEMODE.Votes[ id( ply:SteamID() ) ] then
        GAMEMODE.Votes[ GAMEMODE.Votes[ id( ply:SteamID() ) ] ] = GAMEMODE.Votes[ GAMEMODE.Votes[ id( ply:SteamID() ) ] ] - 1
    end
    GAMEMODE.Votes[ id( ply:SteamID() ) ] = playerVote
    GAMEMODE.Votes[ playerVote ] = GAMEMODE.Votes[ playerVote ] or 0
    GAMEMODE.Votes[ playerVote ] = GAMEMODE.Votes[ playerVote ] + 1

    net.Start( "PlayerVotedUpdate" )
        net.WriteString( id( ply:SteamID() ) )
        net.WriteString( playerVote )
    net.Broadcast()
end )