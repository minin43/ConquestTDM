print( "setting up colorScheme" )
colorScheme = {
	[0] = { --spectator/misc colors
		--unique to spectator
		["TeamColor"] = Color(76, 175, 80),
		["DefaultFontColor"] = Color(255, 255, 255),
		["ButtonIndicator"] = Color(175, 76, 171, 255),
		["SpectatorText"] = Color(255, 255, 255, 255), --the "Press R" spectator text
		["SpectatorTextShadow"] = Color(0, 0, 0, 255),
		["IceOverlay"] = Color(255, 255, 255, 120), --the overlay color when hit by Slaw. changing alpha does not change the rate of decay!
		["GameTimerBG"] = Color(0, 0, 0, 200),
		["GameScoreBG"] = Color(0, 0, 0, 200),
		["GameTimerLow"] = Color(255, 0, 0, 255), --Timer text color when <60 seconds on clock
		["GameTimer"] = Color(255, 255, 255, 200),
		["HelpMenuShade"] = Color(0, 0, 0, 50), -- name might not be accurate, but i believe this is used to darken the "help menu" (F1/F2 tooltips in the corner).
		["HelpMenuText"] = Color(255, 255, 255, 200),
		["GamemodeVersionText"] = Color(255, 255, 255, 135),
		["KillsPlaceholderText"] = Color(255, 255, 255, 177), --when on tdm mode, the color of the leading 0s before the kill counter
		["KillsLabelText"] = Color(255, 255, 255, 100), --the word 'kills' under the number of kills in tdm mode
		["DamageIndicatorShade"] = Color(0, 0, 0, 0), --sets the opacity of the damage indicator over time, but you could use this to color it differently i guess
		["MaxHPText"] = Color(255, 255, 255, 255),
		["MaxHPTextShadow"] = Color(0, 0, 0, 200),
		["PlayerNameShadow"] = Color(0, 0, 0, 255), --in the lower-left corner of the hud
		["ExperienceBar"] = Color(0, 0, 0, 200),
		["RecvGameDataShadow"] = Color(0, 0, 0, 255), --when stil recieving game data like level, money, etc it displays as such
		["ExperienceTextShadow"] = Color(0, 0, 0, 255),
		["ExperiencePctTextShadow"] = Color(0, 0, 0, 255)
		--will finish implementing later (maybe)
		
		--team vars
		
	},
	[1] = { --red
		["TeamColor"] = Color(244, 67, 54),
		["ButtonIndicator"] = Color(255, 255, 0, 255)
	},
	[2] = { --blue
		["TeamColor"] = Color(33, 150, 243),
		["ButtonIndicator"] = Color(255, 255, 0, 255)
	}
}

GM.Icons = {
	Teams = {
		[ "Red Team" ] = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" ),
		[ "Blue Team" ] = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" ),
		Default = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" ),
		Rebels = Material( "vgui/rebelIcon.png", "smooth" ),
		Combine = Material( "vgui/combineIcon.png", "smooth" ),
		Insurgents = Material( "vgui/insurgenticon.png", "noclamp smooth" ),
		InsurgentsColor = Color( 255, 255, 255 ), --//white, because the icon comes pre-colored
		Security = Material( "vgui/securityicon.png", "noclamp smooth" ),
		SecurityColor = Color( 255, 255, 255 ), --//white, because the icon comes pre-colored
		Spetsnaz = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" ),
		OpFor = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" ),
		Milita = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" ),
		[ "TF 141" ] = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" ),
		Rangers = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" ),
		Seals = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" )
	},
	Weapons = {
		primary = Material( "vgui/primary_icon.png", "smooth" ),
		secondary = Material( "vgui/secondary_icon.png", "smooth" ),
		equipment = Material( "vgui/equipment_icon.png", "smooth" ),
		[1] = Material( "vgui/primary_icon.png", "smooth" ),
		[2] = Material( "vgui/secondary_icon.png", "smooth" ),
        [3] = Material( "vgui/equipment_icon.png", "smooth" ),
        ar = Material( "vgui/ar_icon.png", "smooth" ),
        smg = Material( "vgui/smg_icon.png", "smooth" ),
        sg = Material( "vgui/shotgun_icon.png", "smooth" ),
        sr = Material( "vgui/sniper_icon.png", "smooth" ),
        lmg = Material( "vgui/lmg_icon.png", "smooth" ),
        pt = Material( "vgui/pistol_icon.png", "smooth" ),
        mn = Material( "vgui/magnum_icon.png", "smooth" ),
        eq = Material( "vgui/equipment_icon.png", "smooth" )
	},
	Perks = {
		
	},
	Mapvote = { --//Any icons for the tags found in MapTable
		snipers = Material( "vgui/sniper_icon.png", "smooth" ), --same material as GAMEMODE.Icons.Weapons.Sniper
		flags = Material( "vgui/flagIcon.png", "smooth" )
    },
    Menu = {
        moneylocked = Material( "vgui/money_locked.png", "smooth" ),
        moneyunlocked = Material( "vgui/money_unlocked.png", "smooth" ),
        levellocked = Material( "vgui/level_locked.png", "smooth" ),
        levelunlocked = Material( "vgui/level_unlocked.png", "smooth" )
    }
}

include( "shared.lua" )
include( "cl_hud.lua" )
--include( "cl_spawnmenu.lua" )
include( "cl_scoreboard.lua" )
include( "cl_lvl.lua" )
include( "cl_loadout.lua" )
include( "cl_loadout_setup.lua" )
include( "cl_money.lua" )
include( "cl_flags.lua" )
include( "cl_feed.lua" )
include( "cl_deathscreen.lua" )
include( "cl_customspawns.lua" )
include( "cl_leaderboards.lua" )
include( "cl_playercards.lua" )
include( "cl_mapvote.lua" )
include( "cl_mapvote_setup.lua" )
include( "cl_stattrack.lua" )
include( "cl_vendetta.lua" )
include( "cl_teamselect.lua" )
include( "cl_character_interaction.lua" )
include( "cl_perks.lua" )
include( "cl_shop.lua" )
include( "cl_shop_setup.lua" )
include( "cl_titles.lua" )
include( "cl_help.lua" )
include( "sh_loadout.lua" )
include( "sh_shop.lua" )
include( "sh_weaponbalancing.lua" )
include( "sh_titles.lua" )

if not file.Exists( "tdm", "DATA" ) then
	file.CreateDir( "tdm" )
end

if not file.Exists( "tdm/saves", "DATA" ) then
	file.CreateDir( "tdm/saves" )
end

function unid( steamid )
    local x = string.gsub( steamid, "x", ":" )
    return string.upper( x )
end

hook.Add( "Think", "SetColors", function()
	GAMEMODE.TeamColor = colorScheme[LocalPlayer():Team()]["TeamColor"]

	if !GAMEMODE.ReceivedTeams then
		net.Start( "RequestTeams" )
		net.SendToServer()
	end
end )

net.Receive( "RequestTeamsCallback", function()
	GAMEMODE.ReceivedTeams = true
	GAMEMODE.redTeamName = net.ReadString()
	GAMEMODE.blueTeamName = net.ReadString()

	team.SetUp( 0, "Spectators", Color( 0, 0, 0 ) )
	team.SetUp( 1, GAMEMODE.redTeamName, Color( 255, 0, 0 ) )
	team.SetUp( 2, GAMEMODE.blueTeamName, Color( 0, 0, 255 ) )
	team.SetUp( 3, "deathSelf", Color( 158, 253, 56 ) )

	LocalPlayer():ConCommand( "tdm_spawnmenu" )
end )

net.Receive( "GlobalChatColor", function()
	local tab = net.ReadTable()
	local fixedtab = {}

	for k, v in pairs( tab ) do
		if isstring( v ) or IsColor( v ) then
			fixedtab[ #fixedtab + 1 ] = v
		end
	end
	chat.AddText( unpack( fixedtab ) )
end )

net.Receive( "PlayerChatColor", function()
	local tab = net.ReadTable()
	local fixedtab = {}

	for k, v in pairs( tab ) do
		if isstring( v ) or IsColor( v ) then
			fixedtab[ #fixedtab + 1 ] = v
		end
	end
	chat.AddText( unpack( fixedtab ) )
end )
--[[
net.Receive( "SetMagician", function()
	local bool = net.ReadBool()
	local wep = net.ReadEntity()
	local num = net.ReadInt( 32 )
	local tbl = {}
	
	if bool and tbl[num] == nil then
		wep["ReloadSpeed"] = ( wep["ReloadSpeed"] * 1.5 )
		--wep["DelpoyTime"] = ( wep["DelpoyTime"] / 2 )
		tbl[num] = wep
	elseif !bool and tbl[num] == wep then
		savedwep["ReloadSpeed"] = ( savedwep["ReloadSpeed"] / 1.5 )
		--savedwep["DelpoyTime"] = ( savedwep["DelpoyTime"] * 2 )
	end
end)

net.Receive( "FixReloadSpeeds", function()
	local wep = net.ReadString()
	timer.Simple( 1, function() 
		GAMEMODE.PreReloadFixValues = GAMEMODE.PreReloadFixValues or { }
		GAMEMODE.PreReloadFixValues[ wep ] = { }
		wep = LocalPlayer():GetWeapon( wep )

		if wep.Shots == 1 then
			GAMEMODE.PreReloadFixValues[ wep:GetClass() ] = { wep.ReloadSpeed }
			wep.ReloadSpeed = wep.ReloadSpeed * 1.2
			weapons.GetStored( wep:GetClass() ).ReloadSpeed = weapons.GetStored( wep:GetClass() ).ReloadSpeed * 1.2
		else
			GAMEMODE.PreReloadFixValues[ wep:GetClass() ] = { wep.InsertShellTime, wep.ReloadStartTime }
			wep.InsertShellTime = wep.InsertShellTime * 0.8
			wep.ReloadStartTime = wep.ReloadStartTime * 0.8
			weapons.GetStored( wep:GetClass() ).InsertShellTime = weapons.GetStored( wep:GetClass() ).InsertShellTime * 0.8
			weapons.GetStored( wep:GetClass() ).ReloadStartTime = weapons.GetStored( wep:GetClass() ).ReloadStartTime * 0.8
		end
	end )
end )

net.Receive( "UnFixReloadSpeeds", function()
	for k, v in pairs( GAMEMODE.PreReloadFixValues ) do
		if #v == 1 then
			weapons.GetStored( k ).ReloadSpeed = v[1]
		else
			weapons.GetStored( k ).InsertShellTime = v[1]
			weapons.GetStored( k ).ReloadStartTime = v[2]
		end
	end
end )]]










