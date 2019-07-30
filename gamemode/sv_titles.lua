util.AddNetworkString( "EquipTitle" )
util.AddNetworkString( "EquipTitleCallback" )

GM.EquippedTitles = {}
GM.CheckedTitles = {}

if not file.Exists( "tdm/users/titles", "DATA" ) then
	file.CreateDir( "tdm/users/titles" )
end

if not file.Exists( "tdm/users/titles/equippedtitles.txt", "DATA" ) then
    file.Write( "tdm/users/titles/equippedtitles.txt", util.TableToJSON( { } ) )
else
    local fil = util.JSONToTable( file.Read( "tdm/users/titles/equippedtitles.txt", "DATA" ) )
	for k, v in pairs( fil ) do
        GM.EquippedTitles[ k ] = v
    end
end

--//Sets up the PData for new players and new titles
hook.Add( "PlayerInitialSpawn", "SetupTitles", function( ply )
    if not file.Exists( "tdm/users/titles/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) then
        file.Write( "tdm/users/titles/" .. id( ply:SteamID() ) .. ".txt", util.TableToJSON( { ply:Name(), {} } ) )
    else
		local contents = util.JSONToTable( file.Read( "tdm/users/titles/" .. id( ply:SteamID() ) .. ".txt" ) )
		if ply:Name() ~= contents[ 1 ] then
			file.Write( "tdm/users/titles/" .. id( ply:SteamID() ) .. ".txt", util.TableToJSON( { ply:Name(), contents[ 2 ] } ) )
		end
    end

    --//May not work this early into the connection
    for k, v in pairs( GAMEMODE.TitleMasterTable ) do
        ply:SetPData( v.id .. "count", ply:GetPData( v.id .. "count" ) or 0 )
    end
end )

--//Since total kills, deaths, flag captures, and time played have is all information which has been saved since before this title implementation, we could very easily
--//run into players who are already over some of the title's requirements - this checks ownership and saves previous ownership checks, so checking amount overages isn't constantly
--//reading new files every kill, flag capture, and minute
function GM:CheckTitleOwnership( ply, titleid )
    self.CheckedTitles[ id( ply:SteamID() ) ] = self.CheckedTitles[ id( ply:SteamID() ) ] or {}
    if self.CheckedTitles[ id( ply:SteamID() ) ][ titleid ] != nil then
        return self.CheckedTitles[ id( ply:SteamID() ) ][ titleid ]
    end

    local fil = util.JSONToTable( file.Read( "tdm/users/titles/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) )
	local ttab = fil[ 2 ]

    for k, v in pairs( ttab ) do
        if v == titleid then
            self.CheckedTitles[ id( ply:SteamID() ) ][ titleid ] = true
            return true
        end
    end
    self.CheckedTitles[ id( ply:SteamID() ) ][ titleid ] = false
    return false
end

--//Doesn't do any checking, but can't be called from net messages, so w/e
function GM:GivePlayerTitle( ply, titleid )
    local fil = util.JSONToTable( file.Read( "tdm/users/titles/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) )
	local ttab = fil[ 2 ]
	table.insert( ttab, titleid )
	local new = util.TableToJSON( { fil[ 1 ], ttab } )
	file.Write( "tdm/users/titles/" .. id( ply:SteamID() ) .. ".txt", new )

    self.CheckedTitles[ id( ply:SteamID() ) ] = self.CheckedTitles[ id( ply:SteamID() ) ] or {}
    self.CheckedTitles[ id( ply:SteamID() ) ][ titleid ] = true

    local color_green = Color( 102, 255, 51 )
    local color_white = Color( 255, 255, 255 )
    ply:ChatPrintColor( color_white, "You have reached an achievement! You have received the title ", color_green, "[" .. GAMEMODE:GetTitleTable( titleid ).title .. "]", color_white, " which asked you to: ", GAMEMODE:GetTitleTable( titleid ).description )
    ply:SendLua([[surface.PlaySound( "ui/levelup.wav" )]])
end

--//Any time a new title is equipped, saves the list of all currently equipped, so players who re-join are greeted to the same title being equipped
function GM:SaveCurrentTitles()
    file.Write( "tdm/users/titles/equippedtitles.txt", util.TableToJSON( self.EquippedTitles ))
end

--//Makes sure to check if the player owns the title, doesn't check for bad messages, though, unlike the shop
net.Receive( "EquipTitle", function( len, ply )
    local desiredTitle = net.ReadString()
    local fil = util.JSONToTable( file.Read( "tdm/users/titles/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) )
	local ttab = fil[ 2 ]
    local ownstitle --Was originally just gonna be a bool, but I needed to save the title id
    for k, v in pairs( ttab ) do
        if v == desiredTitle then
            ownstitle = GAMEMODE:GetTitleTable( v ).id
        end
    end

    if ownstitle then
        GAMEMODE.EquippedTitles[ id( ply:SteamID() ) ] = ownstitle
        GAMEMODE:SaveCurrentTitles()

        net.Start( "EquipTitleCallback" )
            net.WriteString( ownstitle )
        net.Send( ply )
    end
end )

--//Adds the tag to chat messages - requires additional work to color the titles something other than the defautl chat color
hook.Add( "PlayerSay", "ChatTag", function( ply, msg, teamOnly )
    if GAMEMODE.EquippedTitles[ id( ply:SteamID() ) ] then
        local tab = GAMEMODE:GetTitleTable( GAMEMODE.EquippedTitles[ id( ply:SteamID() ) ] )
        --//May be able to implement color into the messages, run if-then statements dependent on special chat addons, run GlobalChatPrint instead
        return "[" .. tab.title .. "] " .. msg
    end
end )

hook.Add( "PlayerLoadedIn", "SendLastTitle", function( ply )
    if GAMEMODE.EquippedTitles[ id( ply:SteamID() ) ] then
        net.Start( "EquipTitleCallback" )
            net.WriteString( GAMEMODE.EquippedTitles[ id( ply:SteamID() ) ] )
        net.Send( ply )
    end
end )

--//Hooks for titles
--//GivePlayerTitle is NOT called exclusively in this file
--//When implementing future title tracking, keep in mind GetPData returns the value as a STRING. Simple comparisons for if-then statements will SILENTLY FAIL

hook.Add( "WeaponMasteryAchieved", "KillsByWeapon", function( ply, wep )
    GAMEMODE:GivePlayerTitle( ply, wep .. "_mastery" )
end )

hook.Add( "KillFeedHeadshot", "CountLifetimeHeadshots", function( ply )
    local tab = GAMEMODE:GetTitleTable( "headshot" )
    ply:SetPData( tab.id .. "count", ply:GetPData( tab.id .. "count" ) + 1 )

    if tonumber( ply:GetPData( tab.id .. "count" ) ) == tab.req then
        GAMEMODE:GivePlayerTitle( ply, tab.id )
    end
end )

hook.Add( "KillfeedFirstBlood", "FirstBloodCounting", function( ply )
    local tab = GAMEMODE:GetTitleTable( "fastestdraw" )
    ply:SetPData( tab.id .. "count", ply:GetPData( tab.id .. "count" ) + 1 )

    if tonumber( ply:GetPData( tab.id .. "count" ) ) == tab.req then
        GAMEMODE:GivePlayerTitle( ply, tab.id )
    end
end )

hook.Add( "KillFeedPayback", "PaybackCounting", function( ply )
    local tab = GAMEMODE:GetTitleTable( "bsc" )
    ply:SetPData( tab.id .. "count", ply:GetPData( tab.id .. "count" ) + 1 )

    if tonumber( ply:GetPData( tab.id .. "count" ) ) == tab.req then
        GAMEMODE:GivePlayerTitle( ply, tab.id )
    end
end )

hook.Add( "KillFeedHumiliator", "HumiliatorCounting", function( ply )
    local tab = GAMEMODE:GetTitleTable( "humiliator" )
    ply:SetPData( tab.id .. "count", ply:GetPData( tab.id .. "count" ) + 1 )

    if tonumber( ply:GetPData( tab.id .. "count" ) ) == tab.req then
        GAMEMODE:GivePlayerTitle( ply, tab.id )
    end
end )

hook.Add( "KillFeedHumiliated", "HumiliatedCounting", function( ply )
    local tab = GAMEMODE:GetTitleTable( "humiliated" )
    ply:SetPData( tab.id .. "count", ply:GetPData( tab.id .. "count" ) + 1 )

    if tonumber( ply:GetPData( tab.id .. "count" ) ) == tab.req then
        GAMEMODE:GivePlayerTitle( ply, tab.id )
    end
end )

hook.Add( "KillFeedRevenger", "RevengerCounting", function( ply )
    local tab = GAMEMODE:GetTitleTable( "revenger" )
    ply:SetPData( tab.id .. "count", ply:GetPData( tab.id .. "count" ) + 1 )

    if tonumber( ply:GetPData( tab.id .. "count" ) ) == tab.req then
        GAMEMODE:GivePlayerTitle( ply, tab.id )
    end
end )

hook.Add( "KillFeedHeadhunter", "HeadhunterCounting", function( ply )
    local tab = GAMEMODE:GetTitleTable( "headhunter" )
    ply:SetPData( tab.id .. "count", ply:GetPData( tab.id .. "count" ) + 1 )

    if tonumber( ply:GetPData( tab.id .. "count" ) ) == tab.req then
        GAMEMODE:GivePlayerTitle( ply, tab.id )
    end
end )

hook.Add( "KillFeedLowHealth", "BulletProofCounting", function( ply )
    local tab = GAMEMODE:GetTitleTable( "bulletproof" )
    ply:SetPData( tab.id .. "count", ply:GetPData( tab.id .. "count" ) + 1 )

    if tonumber( ply:GetPData( tab.id .. "count" ) ) == tab.req then
        GAMEMODE:GivePlayerTitle( ply, tab.id )
    end
end )

hook.Add( "KillFeedAfterlife", "AfterlifeCounting", function( ply )
    local tab = GAMEMODE:GetTitleTable( "necromancer" )
    ply:SetPData( tab.id .. "count", ply:GetPData( tab.id .. "count" ) + 1 )

    if tonumber( ply:GetPData( tab.id .. "count" ) ) == tab.req then
        GAMEMODE:GivePlayerTitle( ply, tab.id )
    end
end )

hook.Add( "KillFeedEndKillspree", "DenierCounting", function( ply )
    local tab = GAMEMODE:GetTitleTable( "denier" )
    ply:SetPData( tab.id .. "count", ply:GetPData( tab.id .. "count" ) + 1 )

    if tonumber( ply:GetPData( tab.id .. "count" ) ) == tab.req then
        GAMEMODE:GivePlayerTitle( ply, tab.id )
    end
end )

hook.Add( "KillFeedEndKillstreak", "RejectorCounting", function( ply )
    local tab = GAMEMODE:GetTitleTable( "rejector" )
    ply:SetPData( tab.id .. "count", ply:GetPData( tab.id .. "count" ) + 1 )

    if tonumber( ply:GetPData( tab.id .. "count" ) ) == tab.req then
        GAMEMODE:GivePlayerTitle( ply, tab.id )
    end
end )

hook.Add( "KillFeedKillspree", "KillspreeCounting", function( ply, level )
    local throwaway = { doublekill = "2fer", multikill = "3threat", megakill = "4killer", ultrakill = "5up", unreal = "thegod" }
    local tab = GAMEMODE:GetTitleTable( throwaway[ level ] )
    ply:SetPData( tab.id .. "count", ply:GetPData( tab.id .. "count" ) + 1 )

    if tonumber( ply:GetPData( tab.id .. "count" ) ) == tab.req then
        GAMEMODE:GivePlayerTitle( ply, tab.id )
    end
end )

hook.Add( "KillFeedKillstreak", "KillstreakCounting", function( ply, level )
    local throwaway = { DOMINATING = "thedominator", [ "BLAZE OF GLORY" ] = "bog", [ "TOP GUN" ] = "topgun", [ "SHAFT-MASTER" ] = "shaftmaster" }
    if throwaway[ level ] then
        local tab = GAMEMODE:GetTitleTable( throwaway[ level ] )
        ply:SetPData( tab.id .. "count", ply:GetPData( tab.id .. "count" ) + 1 )

        if tonumber( ply:GetPData( tab.id .. "count" ) ) == tab.req then
            GAMEMODE:GivePlayerTitle( ply, tab.id )
        end
    end
end )

--[[hook.Add( "", "", function( ply )
    local tab = GAMEMODE:GetTitleTable( "" )
    ply:SetPData( "count", ply:GetPData( "count" ) + 1 )

    if tonumber( ply:GetPData( tab.id .. "count" ) ) == tab.req then
        GAMEMODE:GivePlayerTitle( ply, tab.id )
    end
end )]]