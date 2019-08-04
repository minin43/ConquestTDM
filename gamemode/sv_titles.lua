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
--//reading new files every kill, flag capture, and minute - this also works great for loop checks
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

function GM:CheckEquippedTitle( ply )
    if self.EquippedTitles[ id( ply:SteamID() ) ] then
        return self.EquippedTitles[ id( ply:SteamID() ) ]
    else
        return ""
    end
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
--//When implementing future title tracking, keep in mind GETPData returns the value as a STRING. Simple comparisons for if-then statements will SILENTLY FAIL

function IncrementTitleCounting( ply, tab )
    if isstring( tab ) then tab = GAMEMODE.GetTitleTable( tab ) end --//I got lazy, see if you can deduce at what point
    ply:SetPData( tab.id .. "count", ply:GetPData( tab.id .. "count" ) + 1 )

    if tonumber( ply:GetPData( tab.id .. "count" ) ) == tab.req then
        GAMEMODE:GivePlayerTitle( ply, tab.id )
    end
end

hook.Add( "WeaponMasteryAchieved", "KillsByWeapon", function( ply, wep )
    if not GAMEMODE:CheckTitleOwnership( ply,  wep .. "_mastery" ) then
        GAMEMODE:GivePlayerTitle( ply,  wep .. "_mastery" )
    end
end )

hook.Add( "AllAttachmentsUnlocked", "AttachmentCounting", function( ply, wep )
    IncrementTitleCounting( ply, "blinged" )
    IncrementTitleCounting( ply, "joat" )

    if not GAMEMODE:CheckTitleOwnership( ply,  wep .. "_attmastery" ) then
        GAMEMODE:GivePlayerTitle( ply,  wep .. "_attmastery" )
    end
end )

hook.Add( "KillFeedStandard", "GeneralDeathCounting", function( att, vic, dmginfo )
    if dmginfo:IsDamageType( DMG_SLASH ) or dmginfo:IsDamageType( DMG_CLUB ) or dmginfo:GetInflictor() == "weapon_fists" then --or dmginfo:GetInflictor() == "" then
        if GAMEMODE:CheckEquippedTitle( att ) == "infected" then
            if not GAMEMODE:CheckTitleOwnership( vic, "infected" ) then
                GAMEMODE:GivePlayerTitle( vic, "infected" )
            end
        end
    end

    --//NEEDS TESTING
    if dmginfo:GetInflictor():GetClass() == "env_explosion" then
        local expent = dmginfo:GetInflictor():GetClass()
        if expent.headpopper then
            IncrementTitleCounting( att, GAMEMODE:GetTitleTable( "brainiac" ) )
        end
    end

    if dmginfo:IsDamageType( DMG_BURN ) then
        if GAMEMODE.ChilledPlayers[ vic ] then
            IncrementTitleCounting( att, GAMEMODE:GetTitleTable( "elements" ) )
        end
    end
end )

hook.Add( "KillFeedHeadshot", "CountLifetimeHeadshots", function( ply )
    IncrementTitleCounting( ply, GAMEMODE:GetTitleTable( "headshot" ) )
end )

hook.Add( "KillfeedFirstBlood", "FirstBloodCounting", function( ply )
    IncrementTitleCounting( ply, GAMEMODE:GetTitleTable( "fastestdraw" ) )
end )

hook.Add( "KillFeedPayback", "PaybackCounting", function( ply )
    IncrementTitleCounting( ply, GAMEMODE:GetTitleTable( "bsc" ) )
end )

hook.Add( "KillFeedHumiliator", "HumiliatorCounting", function( ply )
    IncrementTitleCounting( ply, GAMEMODE:GetTitleTable( "humiliator" ) )
end )

hook.Add( "KillFeedHumiliated", "HumiliatedCounting", function( ply )
    IncrementTitleCounting( ply, GAMEMODE:GetTitleTable( "humiliated" ) )
end )

hook.Add( "KillFeedRevenger", "RevengerCounting", function( ply )
    IncrementTitleCounting( ply, GAMEMODE:GetTitleTable( "revenger" ) )
end )

hook.Add( "KillFeedHeadhunter", "HeadhunterCounting", function( ply )
    IncrementTitleCounting( ply, GAMEMODE:GetTitleTable( "headhunter" ) )
end )

hook.Add( "KillFeedLowHealth", "BulletProofCounting", function( ply )
    IncrementTitleCounting( ply, GAMEMODE:GetTitleTable( "bulletproof" ) )
end )

hook.Add( "KillFeedAfterlife", "AfterlifeCounting", function( ply )
    IncrementTitleCounting( ply, GAMEMODE:GetTitleTable( "necromancer" ) )
end )

hook.Add( "KillFeedEndKillspree", "DenierCounting", function( ply )
    IncrementTitleCounting( ply, GAMEMODE:GetTitleTable( "denier" ) )
end )

hook.Add( "KillFeedEndKillstreak", "RejectorCounting", function( ply )
    IncrementTitleCounting( ply, GAMEMODE:GetTitleTable( "rejector" ) )
end )

hook.Add( "KillFeedKillspree", "KillspreeCounting", function( ply, level )
    local throwaway = { doublekill = "2fer", multikill = "3threat", megakill = "4killer", ultrakill = "5up", unreal = "thegod" }
    IncrementTitleCounting( ply, GAMEMODE:GetTitleTable( throwaway[ level ] ) )
end )

hook.Add( "KillFeedKillstreak", "KillstreakCounting", function( ply, level )
    local throwaway = { DOMINATING = "thedominator", [ "BLAZE OF GLORY" ] = "bog", [ "TOP GUN" ] = "topgun", [ "SHAFT-MASTER" ] = "shaftmaster" }
    if throwaway[ level ] then
        IncrementTitleCounting( ply, GAMEMODE:GetTitleTable( throwaway[ level ] )
    end
end )

GM.HealthTracking = { lasthp = {} }
hook.Add( "Think", "HealthTracking", function()
    local tab = GAMEMODE:GetTitleTable( "unkillble" )
    for k, v in pairs( player.GetAll() ) do
        if not v:Alive() then
            GAMEMODE.HealthTracking[ v ] = 0
            GAMEMODE.HealthTracking.lasthp[ v ] = 100 --//Start tracking at full life
        else
            if v:Health() > GAMEMODE.HealthTracking.lasthp[ v ] then
                GAMEMODE.HealthTracking[ v ] = GAMEMODE.HealthTracking[ v ] + ( v:Health() - GAMEMODE.HealthTracking.lasthp[ v ] )
            end
            GAMEMODE.HealthTracking.lasthp[ v ] = v:Health()
            if GAMEMODE.HealthTracking[ v ] >= 200 then
                if not GAMEMODE:CheckTitleOwnership( v, tab.id ) then
                    GAMEMODE:GivePlayerTitle( v, tab.id )
                end
            end
        end
    end
end )

hook.Add( "DoPlayerDeath", "IsInAir?", function( vic, att, dmginfo )
    if not vic:OnGround() then
        IncrementTitleCounting( att, GAMEMODE:GetTitleTable( "skeetshoot" ) )
    end

    --//CanDoubleJump should ONLY be "false" after the second jump
    if not att:OnGround() and att.CanDoubleJump == false then
        IncrementTitleCounting( att, GAMEMODE:GetTitleTable( "brainiac" ) )
    end
end )

--[[hook.Add( "", "", function( ply )
    IncrementTitleCounting( ply, GAMEMODE:GetTitleTable( "" )
    ply:SetPData( "count", ply:GetPData( "count" ) + 1 )

    if tonumber( ply:GetPData( tab.id .. "count" ) ) == tab.req then
        GAMEMODE:GivePlayerTitle( ply, tab.id )
    end
end )]]