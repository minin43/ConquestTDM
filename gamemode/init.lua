GM.PerkTracking = { }
GM.PerkTracking.LifelineList = { }
GM.SavedAttachmentLists = { }
GM.KillInfoTracking = { }
GM.DamageSaving = { }
GM.SpawnSoundsTracking = { }
GM.PreventFallDamage = false
GM.DefaultWalkSpeed = 180
GM.DefaultRunSpeed = 300
GM.DefaultJumpPower = 170
GM.PostGameCountdown = 20 --Amount of time after the game has ended players can whack each other with crowbars, before the mapvote starts
GM.Tickets = 200 --Number of tickets on conquest maps
GM.GameTime = 1200 --Number of seconds for the game to conclude in seconds - currently 20 minutes

GM.DefaultModels = {
	Rebels = {
		"models/player/group03/male_01.mdl",
		"models/player/group03/male_02.mdl",
		"models/player/group03/male_03.mdl",
		"models/player/group03/male_04.mdl",
		"models/player/group03/male_05.mdl",
		"models/player/group03/male_06.mdl",
		"models/player/group03/male_07.mdl",
		"models/player/group03/male_08.mdl",
		"models/player/group03/male_09.mdl"
	},
	Combine = {
		"models/player/police.mdl" --//Unfortunately, only the metropolice model works consistently with cw2.0 animations
	},
	Insurgents = {
		"models/player/ins_insurgent_heavy.mdl",
		"models/player/ins_insurgent_light.mdl",
		"models/player/ins_insurgent_standard.mdl"
	},
	Security = {
		"models/player/ins_security_heavy.mdl",
		"models/player/ins_security_light.mdl",
		"models/player/ins_security_standard.mdl"
	}
}
GM.DefaultModels[ "Red Team" ] = GM.DefaultModels.Rebels
GM.DefaultModels[ "Blue Team" ] = GM.DefaultModels.Rebels

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_spawnmenu.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "cl_lvl.lua" )
AddCSLuaFile( "cl_loadout.lua" )
AddCSLuaFile( "cl_loadout_setup.lua" )
AddCSLuaFile( "cl_money.lua" )
AddCSLuaFile( "cl_flags.lua" )
AddCSLuaFile( "cl_feed.lua" )
AddCSLuaFile( "cl_deathscreen.lua" )
AddCSLuaFile( "cl_customspawns.lua" )
AddCSLuaFile( "cl_leaderboards.lua" )
AddCSLuaFile( "cl_playercards.lua" )
AddCSLuaFile( "cl_mapvote.lua" )
AddCSLuaFile( "cl_mapvote_setup.lua" )
AddCSLuaFile( "cl_stattrack.lua" )
AddCSLuaFile( "cl_vendetta.lua" )
AddCSLuaFile( "cl_teamselect.lua" )
AddCSLuaFile( "cl_character_interaction.lua" )
AddCSLuaFile( "cl_perks.lua" )
AddCSLuaFile( "cl_shop.lua" )
AddCSLuaFile( "cl_shop_setup.lua" )
AddCSLuaFile( "cl_titles.lua" )
AddCSLuaFile( "cl_help.lua" )
AddCSLuaFile( "cl_menu.lua" )
AddCSLuaFile( "cl_menu_setup.lua" )
AddCSLuaFile( "cl_events.lua" )
AddCSLuaFile( "sh_loadout.lua" )
AddCSLuaFile( "sh_shop.lua" )
AddCSLuaFile( "sh_weaponbalancing.lua" )
AddCSLuaFile( "sh_titles.lua" )
AddCSLuaFile( "sh_titles.lua" )
AddCSLuaFile( "sh_skins.lua" )
AddCSLuaFile( "sh_playermodels.lua" )

include( "shared.lua" )
include( "sv_player.lua" )
include( "sv_lvl.lua" )
include( "sv_loadout.lua" )
include( "sv_stattrak.lua" )
include( "sv_money.lua" )
include( "sv_feed.lua" )
include( "sv_flags.lua" )
include( "sv_deathscreen.lua" )
include( "sv_spawning.lua" )
include( "sv_leaderboards.lua" )
include( "sv_teambalance.lua" )
include( "sv_playercards.lua" )
include( "sv_mapvote.lua" )
include( "sv_vendetta.lua" )
include( "sv_teamselect.lua" )
--include( "sv_backgroundgunfire.lua") -- TODO
include( "sv_character_interaction.lua" )
include( "sv_spectator.lua" )
include( "sv_custommaps.lua" )
include( "sv_perks.lua" )
include( "sv_prestige.lua" )
include( "sv_shop.lua" )
include( "sv_donations.lua" )
include( "sv_weapon_submaterials.lua")
include( "sv_titles.lua" )
include( "sv_events.lua" )
include( "sv_skins.lua" )
include( "sv_playermodels.lua" )
include( "sh_loadout.lua" )
include( "sh_shop.lua" )
include( "sh_weaponbalancing.lua" )
include( "sh_titles.lua" )
include( "sh_skins.lua" )
include( "sh_playermodels.lua" )
include( "sh_events.lua" )

local col = {}
col[0] = Vector( 0, 0, 0 )
col[1] = Vector( 1.0, .2, .2 )
col[2] = Vector( .2, .2, 1.0 )

load = load or {}
preload = preload or {}

for k, v in pairs( file.Find( "tdm/gamemode/perks/*.lua", "LUA" ) ) do
	include( "/perks/" .. v )
end

local _Ply = FindMetaTable( "Player" )
function _Ply:AddScore( score )
	local num = self:GetNWInt( "tdm_score" )
	self:SetNWInt( "tdm_score", num + score )
end

function _Ply:ChatPrintColor( ... )
	local args = { ... }
	local tab = {}

    for k, v in pairs( args ) do
        --//We can be sent tables
        --[[if istable( v ) then
            --//Only numerically-indexed tables
            for k2, v2 in ipairs( v ) do
                --//If there are multiple items in the table, add a comma to the end of all except the last
                if k2 == #v then
                    tab[ #tab + 1 ] = v2
                else
                    tab[ #tab + 1 ] = v2 .. ","
                end
            end
        else]]
            tab[ #tab + 1 ] = v
        --end
	end

	net.Start( "PlayerChatColor" )
		net.WriteTable( tab )
	net.Send( self )
end

local _flags = file.Find( "flags/*", "GAME" )
for k, v in next, _flags do
	resource.AddSingleFile( "flags/" .. v )
end

util.AddNetworkString( "tdm_loadout" )
util.AddNetworkString( "tdm_deathnotice" )
util.AddNetworkString( "tdm_killcountnotice" )
util.AddNetworkString( "DoWin" )
util.AddNetworkString( "DoLose" )
util.AddNetworkString( "DoTie" )
util.AddNetworkString( "DoStart" )
util.AddNetworkString( "StartAttTrack" )
util.AddNetworkString( "GlobalChatColor" )
util.AddNetworkString( "PlayerChatColor" )
util.AddNetworkString( "AcceptedHelp" )

CreateConVar( "tdm_friendlyfire", 0, FCVAR_NOTIFY, "1 to enable friendly fire, 0 to disable" )
CreateConVar( "tdm_ffa", 0, FCVAR_NOTIFY, "1 to enable free-for-all mode, 0 to disable" )
CreateConVar( "tdm_xpmulti", 0, FCVAR_NOTIFY, "0 to disable." )
CreateConVar( "tdm_devmode", 0, FCVAR_NOTIFY, "1 to disable ending of round... or something" )

if not file.Exists( "tdm", "DATA" ) then
	file.CreateDir( "tdm" )
end

if not file.Exists( "tdm/users", "DATA" ) then
	file.CreateDir( "tdm/users" )
end

if not file.Exists( "tdm/users/skins", "DATA" ) then
	file.CreateDir( "tdm/users/skins" )
end

if not file.Exists( "tdm/users/models", "DATA" ) then
	file.CreateDir( "tdm/users/models" )
end

if not file.Exists( "tdm/class", "DATA" ) then
	file.CreateDir( "tdm/class" )
end

if not file.Exists( "tdm/cheaters", "DATA" ) then
	file.CreateDir( "tdm/cheaters" )
end

if not file.Exists( "tdm/users/extra", "DATA" ) then
	file.CreateDir( "tdm/users/extra" )
end

if not file.Exists( "tdm/users/extra/helpmenu.txt", "DATA" ) then
	file.Write( "tdm/users/extra/helpmenu.txt", util.TableToJSON( {} ) )
	GM.AcceptedHelp = {}
else
	GM.AcceptedHelp = {}
	local tab = util.JSONToTable( file.Read( "tdm/users/extra/helpmenu.txt" ) )
	for k, v in pairs( tab ) do
		GM.AcceptedHelp[ v ] = true
	end
end

local color_red = Color( 255, 0, 0 )
local color_blue = Color( 0, 0, 255 )
local color_green = Color( 102, 255, 51 )
local color_white = Color( 255, 255, 255 )

function GlobalChatPrintColor( ... )
	local args = { ... }
	local tab = {}

	for k, v in pairs( args ) do
		tab[ #tab + 1 ] = v
	end

	net.Start( "GlobalChatColor" )
		net.WriteTable( tab )
	net.Broadcast()
end

function GM:DoRedWin()
	for k, v in pairs( team.GetPlayers( 1 ) ) do
		AddNotice(v, "WON THE ROUND", SCORECOUNTS.ROUND_WON, NOTICETYPES.ROUND)
		AddRewards(v, SCORECOUNTS.ROUND_WON)
		
		net.Start( "DoWin" )
		net.Send( v )
	end
	for k, v in pairs( team.GetPlayers( 2 ) ) do
		AddNotice(v, "LOST THE ROUND", SCORECOUNTS.ROUND_LOST, NOTICETYPES.ROUND)
		AddRewards(v, SCORECOUNTS.ROUND_LOST)

		net.Start( "DoLose" )
		net.Send( v )
	end

	GlobalChatPrintColor( color_red, team.GetName( 1 ), " Won! ", color_white, "Mapvote will start in ", color_green, self.PostGameCountdown .. " seconds", color_white, "." )
end

function GM:DoBlueWin()
	for k, v in pairs( team.GetPlayers( 1 ) ) do
		AddNotice(v, "LOST THE ROUND", SCORECOUNTS.ROUND_LOST, NOTICETYPES.ROUND)
		AddRewards(v, SCORECOUNTS.ROUND_LOST)

		net.Start( "DoLose" )
		net.Send( v )
	end
	for k, v in pairs( team.GetPlayers( 2 ) ) do
		AddNotice(v, "WON THE ROUND", SCORECOUNTS.ROUND_WON, NOTICETYPES.ROUND)
		AddRewards(v, SCORECOUNTS.ROUND_WON)

		net.Start( "DoWin" )
		net.Send( v )
	end

	GlobalChatPrintColor( color_blue, team.GetName( 2 ), " Won! ", color_white, "Mapvote will start in ", color_green, self.PostGameCountdown .. " seconds", color_white, "." )
end

function GM:DoTie()
	for k, v in next, player.GetAll() do
		AddNotice(v, "TIED", SCORECOUNTS.ROUND_TIED, NOTICETYPES.ROUND)
		AddRewards(v, SCORECOUNTS.ROUND_TIED)

		net.Start( "DoTie" )
		net.Send( v )
	end

	GlobalChatPrintColor( color_green, "Tie! ", color_white, "Mapvote will start in ", color_green, self.PostGameCountdown .. " seconds", color_white, "." )
end

function GM:EndRound( win )
	if !timer.Exists( "RoundTimer" ) then return end
	timer.Destroy( "RoundTimer" )
	timer.Destroy( "Tickets" )
    SetGlobalBool( "RoundFinished", true )
    
	if win == 1 then
		self:DoRedWin()
	elseif win == 2 then
		self:DoBlueWin()
	elseif win == 0 then
		self:DoTie()
	end

	for k, v in pairs( ents.FindByClass( "cw_*" ) ) do
		SafeRemoveEntity( v )
	end

	timer.Create( "StopRespawningWithWeapons", 5, 5, function() 
		for k, v in next, player.GetAll() do
			if v:Team() ~= 0 then
				v:StripWeapons()
				v:Give( "weapon_crowbar" )
				v:SetWalkSpeed( 200 )
				v:SetRunSpeed( 360 )
			end
		end
	end )

	if win != 1 and win != 2 and win != 0 then
		GlobalChatPrintColor( color_green, "Unknown Win Condition, something broke! ", color_white, "Mapvote will start in ", color_green, self.PostGameCountdown .. " seconds", color_white, "." )
	end

	timer.Create( "notify_players", 1, self.PostGameCountdown, function()
		if timer.RepsLeft( "notify_players" ) % 5 == 0 then
			GlobalChatPrintColor( color_white, "Mapvote will start in ", color_green, tostring( timer.RepsLeft( "notify_players" ) ) .. " seconds", color_white, "." )
		end
	end )
	timer.Simple( self.PostGameCountdown, function()
		hook.Call( "StartMapvote", nil, win )
		if MAPVOTE then
			MAPVOTE:StartMapVote()
		end
	end )

	hook.Call( "Pointshop2GmIntegration_RoundEnded" )
end

local function CheckVIP( ply )
	if ply:CheckGroup( "vip" ) or ply:CheckGroup( "vip+" ) or ply:CheckGroup( "ultravip" ) or ply:CheckGroup( "admin" ) or ply:CheckGroup( "superadmin" ) or ply:CheckGroup( "headadmin" ) or ply:CheckGroup( "coowner" ) or ply:CheckGroup( "owner" ) or ply:CheckGroup( "secret" ) then
		return true
	else
		return false
	end
end

function GM:Initialize()

	SetGlobalInt( "RoundTime", self.GameTime )
	SetGlobalBool( "RoundFinished", false )
	
	SetGlobalInt( "RedTickets", self.Tickets )
	SetGlobalInt( "BlueTickets", self.Tickets )
	SetGlobalInt( "MaxTickets", self.Tickets )

	SetGlobalInt( "RedKills", 0 )
	SetGlobalInt( "BlueKills", 0 )
	
	game.ConsoleCommand( "cw_keep_attachments_post_death 0\n" )
	
	timer.Create( "RoundTimer", 1, 0, function()
		local cur = GetGlobalInt( "RoundTime" )
		if cur - 1 > 0 then
			SetGlobalInt( "RoundTime", cur - 1 )
		elseif cur - 1 <= 0 and GetGlobalBool( "RoundFinished" ) ~= true then
			SetGlobalInt( "RoundTime", 0 )
			if GetGlobalBool( "ticketmode" ) then
				local bl = GetGlobalInt( "BlueTickets" )
				local re = GetGlobalInt( "RedTickets" )
				if bl > re then
					GAMEMODE:EndRound( 2 )
				elseif re > bl then
					GAMEMODE:EndRound( 1 )
				elseif re == bl then
					GAMEMODE:EndRound( 0 )
				end
			else
				if GetGlobalInt( "RedKills" ) > GetGlobalInt( "BlueKills" ) then
					GAMEMODE:EndRound( 1 )
				elseif GetGlobalInt( "RedKills" ) < GetGlobalInt( "BlueKills" ) then
					GAMEMODE:EndRound( 2 )
				else
					GAMEMODE:EndRound( 0 )
				end
			end
		end
	end )
end

function GM:PlayerConnect( name, ip )
	GlobalChatPrintColor( Color( 255, 255, 255 ), "Player ", Color( 76, 175, 80 ), name, Color( 255, 255, 255 ), " has begun connection to the server." )
end

function GM:ShowHelp( ply )
	local wep = ply:GetActiveWeapon()
	
	if not IsValid(wep) or not wep.CW20Weapon or wep.dt.State == CW_IDLE then
		ply:ConCommand( "tdm_loadout" )
		umsg.Start( "ClearTable", ply )
		umsg.End()
	end
end

function GM:ShowTeam( ply )
	local wep = ply:GetActiveWeapon()
	
	if not IsValid(wep) or not wep.CW20Weapon or wep.dt.State == CW_IDLE then
		ply:ConCommand( "tdm_loadout" )
		umsg.Start( "ClearTable", ply )
		umsg.End()
	end
end

function GM:ShowSpare1( ply )
	local wep = ply:GetActiveWeapon()
	
	if not IsValid(wep) or not wep.CW20Weapon or wep.dt.State == CW_IDLE then
		--ply:PS_ToggleMenu()
	end
end

function GM:ShowSpare2( ply )
	local tr = util.TraceLine( util.GetPlayerTrace( ply ) )

	if IsValid( tr.Entity ) then ply:PrintMessage( HUD_PRINTCONSOLE, "ent: " .. tr.Entity:GetClass() ) end
end


function GM:PlayerInitialSpawn( ply )
	--//If you're looking for any logic related to finishing loading in, what little code there is can be found in shared.lua in the "if SERVER then" chunk
	--//In the net.Receive for "RequestTeams." The server receives this net message as soon as the client has fully loaded in, as the spawnmenu requires it.
	if not file.Exists( "tdm/users/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) then
		file.Write( "tdm/users/" .. id( ply:SteamID() ) .. ".txt", util.TableToJSON( { ply:Name(), {} } ) )
	else
		local contents = util.JSONToTable( file.Read( "tdm/users/" .. id( ply:SteamID() ) .. ".txt" ) )
		if ply:Name() ~= contents[ 1 ] then
			file.Write( "tdm/users/" .. id( ply:SteamID() ) .. ".txt", util.TableToJSON( { ply:Name(), contents[ 2 ] } ) )
		end
	end

	if not file.Exists( "tdm/users/skins/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) then
		file.Write( "tdm/users/skins/" .. id( ply:SteamID() ) .. ".txt", util.TableToJSON( { ply:Name(), {} } ) )
	else
		local contents = util.JSONToTable( file.Read( "tdm/users/skins/" .. id( ply:SteamID() ) .. ".txt" ) )
		if ply:Name() ~= contents[ 1 ] then
			file.Write( "tdm/users/skins/" .. id( ply:SteamID() ) .. ".txt", util.TableToJSON( { ply:Name(), contents[ 2 ] } ) )
		end
	end

	if not file.Exists( "tdm/users/models/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) then
		file.Write( "tdm/users/models/" .. id( ply:SteamID() ) .. ".txt", util.TableToJSON( { ply:Name(), {} } ) )
	else
		local contents = util.JSONToTable( file.Read( "tdm/users/models/" .. id( ply:SteamID() ) .. ".txt" ) )
		if ply:Name() ~= contents[ 1 ] then
			file.Write( "tdm/users/models/" .. id( ply:SteamID() ) .. ".txt", util.TableToJSON( { ply:Name(), contents[ 2 ] } ) )
		end
    end
    
    self.PerkTracking[ id( ply:SteamID() ) ] = {}
	self.KillInfoTracking[ id( ply:SteamID() ) ] = {} 
	self.KillInfoTracking[ id( ply:SteamID() ) ].KillsThisLife = 0
	self.DamageSaving[ id( ply:SteamID() ) ] = { lifeCount = 0 }

	if ply:IsBot() then
		ply:SetTeam( 1 )
		self.BaseClass:PlayerSpawn( ply )
		return
	end

	ply:ConCommand( "cw_customhud 0" )
	ply:ConCommand( "cw_customhud_ammo 0" )
	ply:ConCommand( "cw_crosshair 1" )
	ply:ConCommand( "cw_blur_reload 0" )
	ply:ConCommand( "cw_blur_customize 0" )
	ply:ConCommand( "cw_blur_aim_telescopic 0" )
	ply:ConCommand( "cw_simple_telescopics 1" )
	ply:ConCommand( "cw_customhud_ammo 1" )
	ply:ConCommand( "cw_laser_quality 1" )
	ply:ConCommand( "cw_alternative_vm_pos 0" )

	ply:ConCommand( "cl_deathview 1" )

	ply:SetTeam( 0 )
	ply:Spectate( OBS_MODE_CHASE )
	--//Opening menu has been moved to a net.Receive in cl_init, now opens a special menu dependent on player's team (which is why it was necessary for it to be rewritten how it is)
	--ply:ConCommand( "tdm_spawnmenu" )

	if not self.AcceptedHelp[ id( ply:SteamID() ) ] then
		self.AcceptedHelp[ id( ply:SteamID() ) ] = false
	end
end

function GM:PlayerDeathSound()
	return true
end

function GM:PlayerDisconnected( ply )
	GlobalChatPrintColor( Color( 255, 255, 255 ), "Player ", Color( 76, 175, 80 ), ply:Nick(), Color( 255, 255, 255 ), " has disconnected (SteamID: ", ply:SteamID(), ")." )
	print( ply:Nick(), " disconnected ", ply:SteamID(), ply:SteamID64() )
end

function GM:PlayerShouldTakeDamage( ply, attacker )
	if( GetConVarNumber( "tdm_ffa" ) == 1 ) then
		return true
	end
	
	if ply and attacker and ply ~= NULL and attacker ~= NULL then
		if IsValid( attacker ) and IsValid( ply ) and attacker:IsPlayer() and ply:IsPlayer() then
			if ply and attacker and ply:Team() ~= nil and attacker:Team() ~= nil then
				if( GetConVarNumber( "tdm_friendlyfire" ) == 0 and ply:Team() == attacker:Team() ) then
					return false
				end
			end
		end
	end
	
	return true
end

net.Receive( "tdm_loadout", function( len, pl )
	local p = net.ReadString() // primary
	local s = net.ReadString() // secondary
	local e = net.ReadString() // extra
	local perks = net.ReadString()
	if( pl:IsValid() ) then
		preload[ pl ] = {
			primary = p,
			secondary = s,
			extra = e,
			perk = perks
		}
		if not load[ pl ] or not pl:Alive() then
			load[ pl ] = {
				primary = p,
				secondary = s,
				extra = e,
				perk = perks
			}
		end
	end
end )

function giveLoadout( ply )
	GAMEMODE.SavedAttachmentLists[ id( ply:SteamID() ) ] = GAMEMODE.SavedAttachmentLists[ id( ply:SteamID() ) ] or { }
	ply:StripWeapons()

	if GetGlobalBool( "RoundFinished" ) then
		ply:Give( "weapon_crowbar" )
		return
	end

	local l = load[ply]
	if( l ) then
		ply:Give( l.primary )
		ply:Give( l.secondary )

		--This sets previous attachments up for the guns
		if GAMEMODE.SavedAttachmentLists[ id( ply:SteamID() ) ][ l.primary ] then
			timer.Simple( 0.5, function()
				for k, v in pairs( GAMEMODE.SavedAttachmentLists[ id( ply:SteamID() ) ][ l.primary ] ) do --bad loop
					if ply:GetWeapon( l.primary ).Base == "cw_base" then
						ply:GetWeapon( l.primary ):attach( k, v - 1 )
					end
				end
			end )
		end
		if GAMEMODE.SavedAttachmentLists[ id( ply:SteamID() ) ][ l.secondary ] then
			timer.Simple( 0.5, function()
				for k, v in pairs( GAMEMODE.SavedAttachmentLists[ id( ply:SteamID() ) ][ l.secondary ] ) do
					if ply:GetWeapon( l.secondary ).Base == "cw_base" then
						ply:GetWeapon( l.secondary ):attach( k, v - 1 )
					end
				end
			end )
		end
		
		if l.extra then
			if l.extra == "grenades" then
				ply:RemoveAmmo( 2, "Frag Grenades" )
				ply:GiveAmmo( 2, "Frag Grenades", true )
			elseif l.extra == "attachment" then
				CustomizableWeaponry.giveAttachments( ply, CustomizableWeaponry.registeredAttachmentsSKey, true )
			else
				ply:Give( l.extra )
			end
		end
		
		if l.perk then
			local t = l.perk
			ply[t] = true
			GAMEMODE.PerkTracking[ id( ply:SteamID() ) ].ActivePerk = t
		else
			GAMEMODE.PerkTracking[ id( ply:SteamID() ) ].ActivePerk = "none"
		end
	end
	hook.Call( "PostGiveLoadout", nil, ply )
end

local dontgive = {
	"fas2_ammobox",
	"fast2_ifak",
	"fas2_m67",
	"seal6-claymore"
}

function GM:PlayerSpawn( ply )
	if ply.curprimary then
		ply.curprimary = nil
	end
	if ply.cursecondary then
		ply.cursecondary = nil
	end
	if ply.curextra then
		ply.curextra = nil
	end

	if( ply:Team() == 0 ) then
		ply:Spectate( OBS_MODE_IN_EYE )
		SetupSpectator( ply )
		return
	end
	
	if ply:IsPlayer() and load[ ply ] ~= nil then
		if( load[ply].perk ~= nil ) then
			ply.perk = true
		else
			ply.perk = false
		end
	end
	
	self.BaseClass:PlayerSpawn( ply )

	ply:SetWalkSpeed( GAMEMODE.DefaultWalkSpeed )
	ply:SetRunSpeed( GAMEMODE.DefaultRunSpeed )
	ply:SetJumpPower( GAMEMODE.DefaultJumpPower )

	ply:AllowFlashlight( true )
	ply:StartSpawnProtection( 5 ) --//Moved to sv_customspawns
	ply:SetNoCollideWithTeammates( true )
	ply:ConCommand( "cw_simple_telescopics 0" )

	if ply:Team() == 1 then
		local teamName = team.GetName( 1 )
		ply:SetModel( self.DefaultModels[ teamName ][ math.random( #self.DefaultModels[ teamName ] ) ] )
	elseif ply:Team() == 2 then
		local teamName = team.GetName( 2 )
		ply:SetModel( self.DefaultModels[ teamName ][ math.random( #self.DefaultModels[ teamName ] ) ] )
	end
	ply:SetPlayerColor( col[ply:Team()] )

	giveLoadout( ply )

	if GetGlobalBool( "RoundFinished" ) then
		ply:SetWalkSpeed( 200 )
		ply:SetRunSpeed( 360 )
	end

	timer.Simple( 1, function()
		if ply:IsPlayer() then
			for k, v in pairs( ply:GetWeapons() ) do
				local x = v:GetPrimaryAmmoType()
				local y = v:Clip1()
				local give = true
				
				for k2, v2 in next, dontgive do
					if v2 == v then
						give = false
						break
					end
				end
				if give == true then
					ply:GiveAmmo( ( y * 3 ), x, true )
				end
			end
			ply:GiveAmmo( 2, "40MM", true )
		end
	end )

	net.Start( "StartAttTrack" )
	net.Send( ply )

	return false
end

function GM:PlayerDeath( vic, inf, att )
    if att:GetClass() == "entityflame" then
        if GAMEMODE.PyroChecks[ id( vic:SteamID() ) ] then
            att = GAMEMODE.PyroChecks[ id( vic:SteamID() ) ]
        end
    end
    
	if not timer.Exists( "RoundTimer" ) then return end

	if( vic:IsValid() and att:IsValid() and att:IsPlayer() ) then
		if( vic == att ) then
			return
		end
		vic:SetFOV( 0, 0 )
		net.Start( "tdm_deathnotice" )
			net.WriteEntity( vic )
			net.WriteString( att.LastUsedWep ) --What does this do?
			net.WriteEntity( att )
			net.WriteString( tostring( vic:LastHitGroup() == HITGROUP_HEAD ) )
		net.Broadcast()
		if GetGlobalBool( "ticketmode" ) then
			local t = vic:Team()
			if t == 1 then
				SetGlobalInt( "RedTickets", GetGlobalInt( "RedTickets" ) - 1 )
				if GetGlobalInt( "RedTickets" ) <= 0 then
					GAMEMODE:EndRound( 2 )
					hook.Run( "GameWinningKill", att, inf )
				end
			elseif t == 2 then
				SetGlobalInt( "BlueTickets", GetGlobalInt( "BlueTickets" ) - 1 )
				if GetGlobalInt( "BlueTickets" ) <= 0 then
					GAMEMODE:EndRound( 1 )
					hook.Run( "GameWinningKill", att, inf )
				end
			end
		else
			if att:Team() == 1 then
				SetGlobalInt( "RedKills", GetGlobalInt( "RedKills" ) + 1 )
			else
				SetGlobalInt( "BlueKills", GetGlobalInt( "BlueKills" ) + 1 )
			end
		end
	end			
	
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
	if hitgroup == HITGROUP_HEAD then
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 1.5 )
		end
	elseif hitgroup == HITGROUP_CHEST then
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 1 )
		end
	elseif hitgroup == HITGROUP_STOMACH then
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 0.9 )
		end
	elseif hitgroup == HITGROUP_LEFTARM then
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 0.8 )
		end
	elseif hitgroup == HITGROUP_RIGHTARM then
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 0.8 )
		end
	elseif hitgroup == HITGROUP_LEFTLEG then
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 0.7 )
		end
	elseif hitgroup == HITGROUP_RIGHTLEG then
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 0.7 )
		end
	else
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 1 )
		end
	end
end

function GM:GetFallDamage( ply, speed )
	if self.PreventFallDamage then return 0 end
    --[[print("Fall damage calculation")
    print( "speed: ", speed )
    print( "suggested damage, speed / 8: ", (speed / 8) )
    print( "optional damage, speed / 12: ", (speed / 12) )
    print( "optional damage, speed / 16: ", (speed / 16) )
    print( "optional damage, my custom: ", math.Clamp( speed - 580, 0, 100 ) )]]
	--//old fall damage calculation
	--[[speed = speed - 540
	return ( speed * ( 100 / ( 1024 - 580 ) ) )]]

	--//suggested fall damage calclulation
	return math.Clamp( speed - 580, 0, 200 )
end

--//Used in server-side menu code to check for players running net messages with values the player set - cheaters
function CaughtCheater( ply, reason )
	if ply:IsValid() and ply:IsPlayer() then
		local id = ply:SteamID()
		local datetime = os.date( "%H:%M:%S - %d/%m/%Y", os.time() ) --This is a string
		local currentname = ply:Nick()

		if not file.Exists( "tdm/cheaters/" .. id( ply:SteamID() ) ".txt", "DATA" ) then
			file.Write( "tdm/cheaters/" .. id( ply:SteamID() ) ".txt", util.TableToJSON( { datetime = { id, currentname, reason } } ) )
		else
			local contents = util.JSONToTable( file.Read( "tdm/users/models/" .. id( ply:SteamID() ) .. ".txt" ) )
			contents[ datetime ] = { id, currentname, reason }
			file.Write( "tdm/users/models/" .. id( ply:SteamID() ) .. ".txt", util.TableToJSON( contents ) )
		end
		--//Maybe do some kind of update even or something - notify superadmins to check the file
	end
end

hook.Add( "PlayerDeath", "FixLoadoutExploit", function( ply, inf, att )
	local pl = preload[ ply ]
	if ( pl ) then
		load[ ply ] = {
			primary = pl.primary,
			secondary = pl.secondary,
			extra = pl.extra,
			perk = pl.perk
		}
	end
end )

hook.Add( "InitPostEntity", "RemoveDMEntities", function()
    -- remove hl2:dm weapons / ammo
	timer.Simple( 0, function()
		for k, v in pairs( ents.FindByClass( "weapon_*" ) ) do
			SafeRemoveEntity( v )
		end
		for k, v in pairs( ents.FindByClass( "item_*" ) ) do
			if v ~= "item_healthcharger" then
				SafeRemoveEntity( v )
			end
		end

		for k, v in pairs( ents.FindByClass( "func_breakable" ) ) do
			SafeRemoveEntity( v )
		end
		for k, v in pairs( ents.FindByClass( "prop_dynamic" ) ) do
			SafeRemoveEntity( v )
		end
	end )
end )

hook.Add( "EntityTakeDamage", "DamageIndicator", function( vic, dmg )
	local ply = dmg:GetAttacker()
	if vic:IsValid() and vic:IsPlayer() and ply:IsValid() and ply:IsPlayer() and ply:Team() ~= vic:Team() then
		umsg.Start( "damage", vic )
			umsg.Vector( ply:GetPos() )
		umsg.End()
	end
end )

hook.Add( "PlayerDeath", "DamageIndicatorClear", function( vic )
	umsg.Start( "damage_death", vic )
	umsg.End()
end )

hook.Add( "PostGiveLoadout", "FirstLoadoutSpawn", function( ply )
	--//Moved here from sv_character_interaction since startMusic is dependent on InteractionType
	if GAMEMODE.ValidModels[ ply:GetModel() ] then
		GAMEMODE.InteractionList[ id( ply:SteamID() ) ] = GAMEMODE.ValidModels[ ply:GetModel() ]
		net.Start( "SetInteractionGroup" )
			net.WriteString( GAMEMODE.InteractionList[ id( ply:SteamID() ) ] )
		net.Send( ply )
	end

	if GAMEMODE.SpawnSoundsTracking[ id( ply:SteamID() ) ] then
		if GAMEMODE.SpawnSoundsTracking[ id( ply:SteamID() ) ] != ply:Team() then
			timer.Simple( 0.5, function()
				net.Start( "DoStart" )
				net.Send( ply )
			end )
			GAMEMODE.SpawnSoundsTracking[ id( ply:SteamID() ) ] = ply:Team()
		end
	else
		timer.Simple( 0.5, function()
			net.Start( "DoStart" )
			net.Send( ply )
		end )
		GAMEMODE.SpawnSoundsTracking[ id( ply:SteamID() ) ] = ply:Team()
	end
end )

--[[hook.Add( "EntityTakeDamage", "FixBulletVelocity", function( ply, dmginfo )
	if ply:IsValid() and ply:IsPlayer() and dmginfo:IsBulletDamage() and ply:Team() != dmginfo:GetAttacker():Team() then
		local dmg = dmginfo:GetDamage()
		dmginfo:SetDamage( 0 )
		ply:SetHealth( ply:Health() - dmg )
	end
end )]]

net.Receive( "AcceptedHelp", function( len, ply )
	GAMEMODE.AcceptedHelp[ id( ply:SteamID() ) ] = true
	local fil = util.JSONToTable( file.Read( "tdm/users/extra/helpmenu.txt" ) )
	fil[ #fil + 1 ] = id( ply:SteamID() )
	file.Write( "tdm/users/extra/helpmenu.txt", util.TableToJSON( fil ) )
end )