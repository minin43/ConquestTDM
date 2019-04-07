include( "shared.lua" )
include( "cl_hud.lua" )
include( "cl_spawnmenu.lua" )
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
include( "sh_weaponbalancing.lua" )

net.Start( "RequestTeams" )
net.SendToServer()

net.Receive( "RequestTeamsCallback", function()
	print( "CLIENT received RequestTeamsCallback" )
	GAMEMODE.redTeamName = net.ReadString()
	GAMEMODE.blueTeamName = net.ReadString()

	team.SetUp( 1, GAMEMODE.redTeamName, Color( 255, 0, 0 ) )
	team.SetUp( 2, GAMEMODE.blueTeamName, Color( 0, 0, 255 ) )
	print( "Team names: ", GAMEMODE.redTeamName, GAMEMODE.blueTeamName )
	print( "Team colors: " ,team.GetColor(1), team.GetColor(2) )
end )

colorScheme = {
	[0] = { --spectator/misc colors
		--unique to spectator
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
		["PlayerNameBG"] = Color(0, 0, 0, 255), --in the lower-left corner of the hud
		["ExperienceBar"] = Color(0, 0, 0, 200),
		["RecvGameDataShadow"] = Color(0, 0, 0, 255), --when stil recieving game data like level, money, etc it displays as such
		["ExperienceTextShadow"] = Color(0, 0, 0, 255),
		["ExperiencePctTextShadow"] = Color(0, 0, 0, 255)
		--team vars
		
	} --[[,
	--[1] = { --red

	}
	[2] = { --blue

	}]]
}

hook.Add( "Think", "SetColors", function()
	if LocalPlayer():Team() == 1 then
		GAMEMODE.TeamColor = Color( 244, 67, 54 )
	elseif LocalPlayer():Team() == 2 then
		GAMEMODE.TeamColor = Color( 33, 150, 243 )
	else
		GAMEMODE.TeamColor = Color( 76, 175, 80 )
	end
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
end )










