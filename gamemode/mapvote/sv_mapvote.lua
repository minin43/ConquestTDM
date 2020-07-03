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
        print( "[CTDM WARNING:MAP]" .. game.GetMap() .. " is NOT set up to auto-download on player join" )
    end
else
	print( "[CTDM WARNING:MAP] Map is NOT registered to work with the mapvote, this may be due to lack of spawn/flag placements" )
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
    elseif winningMap == "random" then --This got messy
        local suggestedplayercount = { Tiny = {min = 0, max = 6}, Small = {min = 4, max = 10}, Midsize = {min = 6, max = 12}, Large = {min = 8, max = 16}, Massive = {min = 10, max = 20} }
        local tab, map
        local plycount = #player.GetAll()
        for i = 1, 4 do --"try" to find a suitable chance, but continue to leave it up to chance whether one is found
            tab, map = table.Random( GAMEMODE.MapTable )
            if plycount > suggestedplayercount[ tab.size ].min and plycount < suggestedplayercount[ tab.size ].max then
                winningMap = map
            end
        end
        if winningMap == "random" then --If the first 3 attempts didn't find one close, just go with the final, 4th random
            winningMap = map
        end
        sendtoclient = "random"
    end

    if doEvent then
        file.Write( "tdm/newevent.txt", doEvent )
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
            hook.Run( "StartMapvote", true )
        end
    end )
end

hook.Add( "StartMapvote", "RunMapvote", function( winningTeam, preventRepeat )
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

    --//Event logic, 1 in 20 chance to run an event
    if math.random( 20 ) == 1 then
        doEvent = GAMEMODE.EventTable.Single[ math.random( #GAMEMODE.EventTable.Single ) ].id
    end
    
    for counter = 1, 6 do
        if table.Count( GAMEMODE.MapTable ) != 0 then
            local mapTable, mapName = table.Random( GAMEMODE.MapTable )
            if doEvent then mapTable.tags[ #mapTable.tags + 1 ] = "event" end

            GAMEMODE.VoteOptions[ counter ] = { name = mapName, info = mapTable }
            GAMEMODE.MapTable[ mapName ] = nil
        end
    end
    GAMEMODE.VoteOptions[ 7 ] = { name = "repeat", info = { custom = true, img = lastmapimg, disable = preventRepeat or false } }
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

--RTV hook hash been moved to chat/sv_chat_commands.lua