util.AddNetworkString( "BeginMapvote" )
util.AddNetworkString( "MapvoteFinished" )
util.AddNetworkString( "PlayerVotedUpdate" )
util.AddNetworkString( "UpdateCountdown" )
util.AddNetworkString( "PlayerSelectedMap" )
--[[util.AddNetworkString( "StartRTV" )
util.AddNetworkString( "ReceivedRTVVote" )
util.AddNetworkString( "UpdateRTVVotes" )]]

GM.Votes = { } --The table that records the total tallies as well as all individual votes
GM.VoteOptions = { } --The table we send to clients, contains the 6 map options
GM.MapvoteTime = 20
GM.RTVCooldown = 120
GM.RTVTime = 40
GM.MapTable = { --Controls both the map autodownload and the mapvote information
    [ "gm_lasertag" ] = { id = 473594402, size = "Tiny", img = "vgui/maps/lasertag.png" },
    [ "gm_floatingworlds_3" ] = { id = 122421739, size = "Enormous", img = "vgui/maps/floatingworlds.png" },
    [ "gm_forestforts" ] = { id = 253493702, size = "Large", img = "vgui/maps/forestforts.png" },
    [ "ttt_lazertag" ] = { id = 206405740, size = "Large", img = "vgui/maps/lazertag2.png" },
    [ "ttt_gunkanjima_v2" ] = { id = 229000479, size = "Small", img = "vgui/maps/gunkanjima.png" },
    [ "ttt_forest_final" ] = { id = 147635981, size = "Small", img = "vgui/maps/forestfinal.png" },
    [ "ttt_riverside_b3" ] = { id = 312731430, size = "Small", img = "vgui/maps/riverside.png" },
    [ "de_asia" ] = { id = 872474392, size = "Midsize", img = "vgui/maps/asia.png" },
    [ "de_star" ] = { id = 296000772, size = "Large", img = "vgui/maps/star.png" },
    --[ "dm_canals" ] = { id = 108953008, size = "Large", img = "vgui/maps/canals.png" }, --Fix spawns
    [ "gm_toysoldiers" ] = { id = 313827200, size = "Enormous", img = "vgui/maps/toysoldier.png" },
    [ "sh_lockdown" ] = { id = 261713202, size = "Large", img = "vgui/maps/lockdown.png" },
    [ "sh_lockdown_v2" ] = { id = 423308835, size = "Large", img = "vgui/maps/lockdown2.png" },
    [ "sh_smalltown_c" ] = { id = 865967849, size = "Midsize", img = "vgui/maps/smalltown.png" },
    [ "ttt_mw2_terminal" ] = { id = 176887855, size = "Midsize", img = "vgui/maps/terminal.png" },
    --[[[ "cs_assault" ] = { size = "Midsize", img = "vgui/maps/assault.png" }, --Removed while player count remains low
    [ "cs_italy" ] = { size = "Midsize", img = "vgui/maps/italy.png" },
    [ "cs_compound" ] = { size = "Small", img = "vgui/maps/compound.png" },
    [ "de_cbble" ] = { size = "Midsize", img = "vgui/maps/cbbl.png" },
    [ "de_dust" ] = { size = "Midsize", img = "vgui/maps/dust.png" },
    [ "de_dust2" ] = { size = "Midsize", img = "vgui/maps/dust2.png" },
    [ "cs_office" ] = { size = "Small", img = "vgui/maps/office.png" },]]
    [ "dm_aftermath" ] = { id = 975289333, size = "Large", img = "vgui/maps/aftermath.png" },
    [ "dm_basebunker" ] = { id = 812797510, size = "Small", img = "vgui/maps/bunker.png" },
    [ "dm_laststop" ] = { id = 513311726, size = "Midsize", img = "vgui/maps/laststop.png" },
    [ "dm_powerstation" ] = { id = 446026985, size = "Midsize", img = "vgui/maps/powerstation.png" },
    [ "dm_plaza17" ] = { id = 1689260918, size = "Large", img = "vgui/maps/plaza17.png" },
    [ "de_corse" ] = { id = 1689260682, size = "Midsize", img = "vgui/maps/corse.png" },
    [ "de_joint" ] = { id = 1689260841, size = "Large", img = "vgui/maps/joint.png" },
    [ "dm_9rooms_b16" ] = { id = 1642035717, size = "Small", img = "vgui/maps/9rooms.png" },
    [ "dm_avalon" ] = { id = 1669465120, size = "Midsize", img = "vgui/maps/avalon.png" },
    [ "dm_bounce" ] = { id = 1645391828, size = "Small", img = "vgui/maps/bounce.png" },
    [ "dm_resident" ] = { id = 1623087187, size = "Midsize", img = "vgui/maps/resident.png" },
    [ "ttt_mw2_highrise" ] = { id = 290247692, size = "Large", img = "vgui/maps/highrise.png" },
    [ "ttt_mw2_scrapyard" ] = { id = 294363438, size = "Large", img = "vgui/maps/scrapyard.png" }
    --[ "gm_blackbrook_asylum" ] = { id = 903842886, size = "Small", img = "vgui/maps/blackbrook.png" } --Seems to be crashing the server
    --[ "" ] = { id = 0, size = "", img = "vgui/maps/.png" },
}

local CSSMaps = { 
	[ "cs_assault" ] = true,
	[ "cs_compound" ] = true,
	[ "cs_havana" ] = true,
	[ "cs_italy" ] = true,
	[ "cs_militia" ] = true,
	[ "cs_office" ] = true,
	[ "de_aztec" ] = true,
	[ "de_cbble" ] = true,
	[ "de_chateau" ] = true,
	[ "de_dust" ] = true,
	[ "de_dust2" ] = true,
	[ "de_inferno" ] = true,
	[ "de_nuke" ] = true,
	[ "de_piranesi" ] = true,
	[ "de_port" ] = true,
	[ "de_prodigy" ] = true,
	[ "de_tides" ] = true,
	[ "de_train" ] = true
}

if GM.MapTable[ game.GetMap() ] then
    if GM.MapTable[ game.GetMap() ].id and not CSSMaps[ game.GetMap() ] then
        resource.AddWorkshop( tostring( GM.MapTable[ game.GetMap() ].id ) )
    else
        print( "[WARNING:MAP]" .. game.GetMap() .. " is NOT set up to auto-download on player join" )
    end
else
	print( "[WARNING:MAP] Map is NOT registered to work with the mapvote, this may be due to lack of spawn/flag placements" )
end

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

function StartRTV( starter )
    GAMEMODE.NecessaryRTVVotes = math.Round( #player.GetAll() / 2 )
    GAMEMODE.TotalRTVVotes = 1

    timer.Create( "RTVTimer", 1, GAMEMODE.RTVTime, function()
        if GAMEMODE.TotalRTVVotes >= GAMEMODE.NecessaryRTVVotes then
            hook.Run( "StartMapvote" )
        end
    end )
end

hook.Add( "StartMapvote", "RunMapvote", function( winner )
    if timer.Exists( "MapvoteCountdown" ) then return end

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
    if not GAMEMODE.Votes[ playerVote ] then return end

    if GAMEMODE.Votes[ id( ply:SteamID() ) ] then
        GAMEMODE.Votes[ GAMEMODE.Votes[ id( ply:SteamID() ) ] ] = GAMEMODE.Votes[ GAMEMODE.Votes[ id( ply:SteamID() ) ] ] - 1
    end
    GAMEMODE.Votes[ id( ply:SteamID() ) ] = playerVote
    GAMEMODE.Votes[ playerVote ] = GAMEMODE.Votes[ playerVote ] + 1

    net.Start( "PlayerVotedUpdate" )
        net.WriteString( id( ply:SteamID() ) )
        net.WriteString( playerVote )
    net.Broadcast()
end )

--//RockTheVote shit
hook.Add( "PlayerSay", "DontRockTheVoteBaby", function( ply, msg, teamOnly )
    if #player.GetAll() == 1 then return end
    local stringCheck = string.lower( msg )
    if string.StartWith( stringCheck, "rtv" ) or string.StartWith( stringCheck, "!rtv" ) then
        if not timer.Exists( "RTVCooldownTimer" ) then --If the RTV isn't on cooldown (because it didn't pass)
            if not timer.Exists( "RTVTimer" ) then --If an RTV hasn't been started yet
                GAMEMODE.NecessaryRTVVotes = math.Round( #player.GetAll() / 2 ) or 1
                GAMEMODE.RTVVotes = { [ id( ply:SteamID() ) ] = true }
                GAMEMODE.TotalRTVVotes = 1

                timer.Create( "RTVTimer", GAMEMODE.RTVTime, 1, function()
                    for k, v in pairs( player.GetAll() ) do
                        v:ChatPrint( "Not enough votes placed to Rock The Vote" )
                    end
                    timer.Create( "RTVCooldownTimer", GAMEMODE.RTVCooldown, 1, function() end )
                    GAMEMODE.TotalRTVVotes = 0
                end )

                for k, v in pairs( player.GetAll() ) do
                    v:ChatPrint( "Rock The Vote has been called, total votes necessary: " .. GAMEMODE.NecessaryRTVVotes )
                    v:ChatPrint( "Time to cast your vote: " .. GAMEMODE.RTVTime .. " seconds" )
                    v:ChatPrint( ply:Nick() .. " has voted, " .. GAMEMODE.NecessaryRTVVotes - GAMEMODE.TotalRTVVotes .. " more vote(s) necessary" )
                end
            else
                if !GAMEMODE.RTVVotes[ id( ply:SteamID() ) ] then
                    GAMEMODE.RTVVotes[ id( ply:SteamID() ) ] = true
                    GAMEMODE.TotalRTVVotes = GAMEMODE.TotalRTVVotes + 1
                    
                    for k, v in pairs( player.GetAll() ) do
                        v:ChatPrint( ply:Nick() .. " has voted, " .. GAMEMODE.NecessaryRTVVotes - GAMEMODE.TotalRTVVotes .. " more vote(s) necessary" )
                    end

                    if GAMEMODE.TotalRTVVotes >= GAMEMODE.NecessaryRTVVotes then
                        for k, v in pairs( player.GetAll() ) do
                            v:ChatPrint( "Enough votes have been cast, rocking the vote..." )
                        end
                        timer.Simple( 3, function()
                            hook.Run( "StartMapvote" )
                        end )
                        timer.Remove( "RTVTimer" )
                        timer.Create( "RTVCooldownTimer", GAMEMODE.RTVCooldown, 1, function() end ) --Just so we don't get a second RTV called while in mapvote
                    end
                end
            end
        else
            ply:ChatPrint( "RockTheVote is on cooldown for " .. math.Round( timer.TimeLeft( "RTVCooldownTimer" ) ) .. " more second(s)" )
        end
        return ""
    end
end )