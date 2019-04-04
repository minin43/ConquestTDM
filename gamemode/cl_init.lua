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

colorScheme = {
	[0] = { --spectator/misc colors
		["SpectatorText"] = Color(255, 255, 255, 255), --the "Press R" spectator text
		["SpectatorTextShadow"] = Color(0, 0, 0, 255),
		["IceOverlay"] = Color(255, 255, 255, 120), --not implemented until cl_hud:197 TODO is complete
		["GameTimerBG"] = Color(0, 0, 0, 200),
		["GameScoreBG"] = Color(0, 0, 0, 200),
		["GameTimerLow"] = Color(255, 0, 0, 255), --Timer text color when <60 seconds on clock
		["GameTimer"] = Color(255, 255, 255, 200),
		["HelpMenuShade"] = Color(0, 0, 0, 50), -- name might not be accurate, but i believe this is used to darken the "help menu" (F1/F2 tooltips in the corner).
		["HelpMenuText"] = Color(255, 255, 255, 200)
	} --[[,
	--[1] = { --red

	}
	[2] = { --blue

	}]]
}

local groups = { --TODO: when these are rewritten please use [keys] instead of this format.
	{ "vip", Color( 0, 200, 0 ), "VIP" },
	{ "operator", Color( 180, 180, 180 ), "Operator" },
	{ "vip+", Color( 0, 255, 0 ), "VIP+" },
	{ "owner", Color( 255, 0, 0 ), "Owner" },
	{ "creator", Color( 200, 0, 0 ), "Creator" },
	{ "coowner", Color( 255, 0, 0 ), "Co-Owner" },
	{ "Developer", Color( 179, 225, 0 ), "Developer" },
	{ "superadmin", Color( 255, 0, 0 ), "Superadmin" },
	{ "admin", Color( 220, 180, 0 ), "Admin" }
}

local ccolors = { --Same here.
	{ "red", Color( 255, 0, 0 ) },
	{ "blue", Color( 0, 0, 255 ) },
	{ "yellow", Color( 255, 255, 0 ) },
	{ "black", Color( 0, 0, 0 ) },
	{ "white", Color( 255, 255, 255 ) },
	{ "green", Color( 0, 255, 0 ) },
	{ "orange", Color( 255, 120, 0 ) },
	{ "pink", Color( 255, 0, 255 ) },
	{ "purple", Color( 270, 0, 255 ) }
}

local ti = table.insert
local IsValid = IsValid
local Color = Color
local unpack = unpack
local white = color_white

function id( steamid )
	local x = string.gsub( steamid, ":", "x" )
	return x
end

function unid( steamid )
	local x = string.gsub( steamid, "x", ":" )
	return string.upper( x )
end

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










