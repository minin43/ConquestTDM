util.AddNetworkString( "BeginMapvote" )
util.AddNetworkString( "MapvoteFinished" )
util.AddNetworkString( "PlayerVotedUpdate" )
util.AddNetworkString( "UpdateCountdown" )
util.AddNetworkString( "PlayerSelectedMap" )

GM.Votes = { } --The table that records the total tallies as well as all individual votes
GM.VoteOptions = { } --The table we send to clients, contains the 6 map options
GM.MapvoteTime = 30
GM.RTVCooldown = 120
GM.RTVTime = 60

--//Map table has been moved to shared.lua

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
        v.tags[ #v.tags + 1 ] = "flags" 
    --[[else
        v.flags = false]]
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

    local sendtoclient
    if winningMap == "" or winningMap == "repeat" or winningMap == "legend" then
        sendtoclient = "repeat"
        winningMap = file.Read( "tdm/lastmap.txt", "DATA" )
    elseif winningMap == "random" then
        local tab, map = table.Random( GAMEMODE.MapTable )
        winningMap = map
        sendtoclient = "random"
    end

    net.Start( "MapvoteFinished" )
        net.WriteString( sendtoclient or winningMap )
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

    local lastmap, lastmapimg = "", ""
    if file.Exists( "tdm/lastmap.txt", "DATA" ) then
        lastmap = file.Read( "tdm/lastmap.txt", "DATA" )
        if GAMEMODE.MapTable[ lastmap ] then
            lastmapimg = GAMEMODE.MapTable[ lastmap ].img
        end
        GAMEMODE.MapTable[ lastmap ] = nil
    end
    
    for counter = 1, 6 do
        if table.Count( GAMEMODE.MapTable ) != 0 then
            local mapTable, mapName = table.Random( GAMEMODE.MapTable )
            GAMEMODE.VoteOptions[ counter ] = { name = mapName, info = mapTable }
            GAMEMODE.MapTable[ mapName ] = nil
        end
    end
    GAMEMODE.VoteOptions[ 7 ] = { name = "repeat", info = { custom = true, img = lastmapimg } }
    GAMEMODE.VoteOptions[ 8 ] = { name = "random", info = { custom = true } }
    GAMEMODE.VoteOptions[ 9 ] = { name = "legend", info = { custom = true } }
    
    for k, v in pairs( GAMEMODE.VoteOptions ) do
        GAMEMODE.Votes[ v.name ] = 0
    end

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
    if GAMEMODE.EquippedTitles[ id( ply:SteamID() ) ] then
        local len = string.len( "[" .. GAMEMODE.EquippedTitles .. "]" )
        stringCheck = string.Right( string.lower( msg ), len )
    end
    if string.StartWith( stringCheck, "rtv" ) or string.StartWith( stringCheck, "/rtv" ) or string.StartWith( stringCheck, "!rtv" ) then
        if not timer.Exists( "RTVCooldownTimer" ) then --If the RTV isn't on cooldown (because it didn't pass)
            if not timer.Exists( "RTVTimer" ) then --If an RTV hasn't been started yet
                if GAMEMODE.GameTime - GetGlobalInt( "RoundTime" ) < 60 then 
                    GlobalChatPrintColor( "[RTV] Too early into the round before a Rock The Vote can be started!" )
                    return
                end
                GAMEMODE.NecessaryRTVVotes = math.Round( #player.GetAll() / 2 ) or 1
                GAMEMODE.RTVVotes = { [ id( ply:SteamID() ) ] = true }
                GAMEMODE.TotalRTVVotes = 1

                timer.Create( "RTVTimer", GAMEMODE.RTVTime, 1, function()
                    GlobalChatPrintColor( "[RTV] Not enough votes placed to Rock The Vote" )
                    timer.Create( "RTVCooldownTimer", GAMEMODE.RTVCooldown, 1, function() end )
                    GAMEMODE.TotalRTVVotes = 0
                end )

                GlobalChatPrintColor( "[RTV] Rock The Vote has been called, total votes necessary: " .. GAMEMODE.NecessaryRTVVotes )
                GlobalChatPrintColor( "[RTV] Type \"rtv\" in chat to cast your vote" )
                timer.Simple( 0.25, function()
                    GlobalChatPrintColor( "[RTV] Time to cast your vote: " .. GAMEMODE.RTVTime .. " seconds" )
                end )
                timer.Simple( 0.5, function()
                    GlobalChatPrintColor( "[RTV] " .. ply:Nick() .. " has voted, " .. GAMEMODE.NecessaryRTVVotes - GAMEMODE.TotalRTVVotes .. " more vote(s) necessary" )
                end )
            else
                if !GAMEMODE.RTVVotes[ id( ply:SteamID() ) ] then
                    GAMEMODE.RTVVotes[ id( ply:SteamID() ) ] = true
                    GAMEMODE.TotalRTVVotes = GAMEMODE.TotalRTVVotes + 1
                    
                    GlobalChatPrintColor( "[RTV] " .. ply:Nick() .. " has voted, " .. GAMEMODE.NecessaryRTVVotes - GAMEMODE.TotalRTVVotes .. " more vote(s) necessary" )

                    if GAMEMODE.TotalRTVVotes >= GAMEMODE.NecessaryRTVVotes then
                        GlobalChatPrintColor( "[RTV] Enough votes have been cast, rocking the vote..." )
                        timer.Simple( 3, function()
                            hook.Run( "StartMapvote" )
                        end )
                        timer.Remove( "RTVTimer" )
                        timer.Create( "RTVCooldownTimer", GAMEMODE.RTVCooldown, 1, function() end ) --Just so we don't get a second RTV called while in mapvote
                    end
                end
            end
        else
            GlobalChatPrintColor( "[RTV] RockTheVote is on cooldown for " .. math.Round( timer.TimeLeft( "RTVCooldownTimer" ) ) .. " more second(s)" )
        end
        return ""
    end
end )