print("check second")
GM.Name = "Conquest Team Deathmatch"
GM.Author = "Cobalt, Whuppo, Logan"
GM.Email = "lobsterlogan43@yahoo.com"
GM.Website = "N/A"
GM.Version = "Conquest Team Deathmatch V. 1.5"
GM.redTeamName = "Red Team"
GM.blueTeamName = "Blue Team"

GM.MapTable = { --Controls both the map autodownload and the mapvote information
    [ "gm_lasertag" ] = { id = 473594402, size = "Tiny", img = "vgui/maps/lasertag.png", type = "hl2" },
    [ "gm_floatingworlds_3" ] = { id = 122421739, size = "Enormous", img = "vgui/maps/floatingworlds.png", type = "ins2" },
    [ "gm_forestforts" ] = { id = 253493702, size = "Large", img = "vgui/maps/forestforts.png", type = "hl2" },
    [ "ttt_lazertag" ] = { id = 206405740, size = "Large", img = "vgui/maps/lazertag2.png", type = "hl2" },
    [ "ttt_gunkanjima_v2" ] = { id = 229000479, size = "Small", img = "vgui/maps/gunkanjima.png", type = "ins2" },
    [ "ttt_forest_final" ] = { id = 147635981, size = "Small", img = "vgui/maps/forestfinal.png", type = "hl2" },
    [ "ttt_riverside_b3" ] = { id = 312731430, size = "Small", img = "vgui/maps/riverside.png", type = "hl2" },
    [ "de_asia" ] = { id = 872474392, size = "Midsize", img = "vgui/maps/asia.png", type = "ins2" },
    [ "de_star" ] = { id = 296000772, size = "Large", img = "vgui/maps/star.png", type = "ins2" },
    --[ "dm_canals" ] = { id = 108953008, size = "Large", img = "vgui/maps/canals.png" }, --Fix spawns
    [ "gm_toysoldiers" ] = { id = 313827200, size = "Enormous", img = "vgui/maps/toysoldier.png", type = "ins2" },
    [ "sh_lockdown" ] = { id = 261713202, size = "Large", img = "vgui/maps/lockdown.png", type = "hl2" },
    [ "sh_lockdown_v2" ] = { id = 423308835, size = "Large", img = "vgui/maps/lockdown2.png", type = "ins2" },
    [ "sh_smalltown_c" ] = { id = 865967849, size = "Midsize", img = "vgui/maps/smalltown.png", type = "ins2" },
    [ "ttt_mw2_terminal" ] = { id = 176887855, size = "Midsize", img = "vgui/maps/terminal.png", type = "mw2" },
    --[[[ "cs_assault" ] = { size = "Midsize", img = "vgui/maps/assault.png", type = "ins2" }, --Removed while player count remains low
    [ "cs_italy" ] = { size = "Midsize", img = "vgui/maps/italy.png", type = "ins2" },
    [ "cs_compound" ] = { size = "Small", img = "vgui/maps/compound.png", type = "ins2" },
    [ "de_cbble" ] = { size = "Midsize", img = "vgui/maps/cbbl.png", type = "ins2" },
    [ "de_dust" ] = { size = "Midsize", img = "vgui/maps/dust.png", type = "ins2" },
    [ "de_dust2" ] = { size = "Midsize", img = "vgui/maps/dust2.png", type = "ins2" },
    [ "cs_office" ] = { size = "Small", img = "vgui/maps/office.png", type = "ins2" },]]
    [ "dm_aftermath" ] = { id = 975289333, size = "Large", img = "vgui/maps/aftermath.png", type = "hl2" },
    [ "dm_basebunker" ] = { id = 812797510, size = "Small", img = "vgui/maps/bunker.png", type = "hl2" },
    [ "dm_laststop" ] = { id = 513311726, size = "Midsize", img = "vgui/maps/laststop.png", type = "hl2" },
    [ "dm_powerstation" ] = { id = 446026985, size = "Midsize", img = "vgui/maps/powerstation.png", type = "hl2" },
    [ "dm_plaza17" ] = { id = 1689260918, size = "Large", img = "vgui/maps/plaza17.png", type = "hl2" },
    [ "de_corse" ] = { id = 1689260682, size = "Midsize", img = "vgui/maps/corse.png" },
    [ "de_joint" ] = { id = 1689260841, size = "Large", img = "vgui/maps/joint.png" },
    [ "dm_9rooms_b16" ] = { id = 1642035717, size = "Small", img = "vgui/maps/9rooms.png", type = "hl2" },
    [ "dm_avalon" ] = { id = 1669465120, size = "Midsize", img = "vgui/maps/avalon.png", type = "hl2" },
    [ "dm_bounce" ] = { id = 1645391828, size = "Small", img = "vgui/maps/bounce.png", type = "hl2", extra = { "NoFall" } },
    [ "dm_resident" ] = { id = 1623087187, size = "Midsize", img = "vgui/maps/resident.png", type = "hl2" },
    [ "ttt_mw2_highrise" ] = { id = 290247692, size = "Large", img = "vgui/maps/highrise.png", type = "mw2" },
    [ "ttt_mw2_scrapyard" ] = { id = 294363438, size = "Large", img = "vgui/maps/scrapyard.png", type = "mw2" }
    --[ "gm_blackbrook_asylum" ] = { id = 903842886, size = "Small", img = "vgui/maps/blackbrook.png" } --Seems to be crashing the server
    --[ "" ] = { id = 0, size = "", img = "vgui/maps/.png" },
}

GM.TeamNames = {
    [ "mw2" ] = { [ "red" ] = { "Spetsnaz", "OpFor"--[[, "Milita"]] }, [ "blue" ] = { "TF 141", "Rangers", "Seals" }},
    [ "hl2" ] = { [ "red" ] = { "Combine" }, [ "blue" ] = { "Rebels" } },
    [ "ins2" ] = { [ "red" ] = { "Insurgents" }, [ "blue" ] = { "Security" } }
}

--hardcoded colors. once fully implemented we could change from red v. blue to any two colors.
team.SetUp( 0, "Spectators", Color( 0, 0, 0 ) )
team.SetUp( 1, GM.redTeamName, Color( 255, 0, 0 ) )
team.SetUp( 2, GM.blueTeamName, Color( 0, 0, 255 ) )
team.SetUp( 3, "deathSelf", Color( 158, 253, 56 ) ) --colors defined here will be deprecated soon

if SERVER then
    
	resource.AddWorkshop( "349050451" ) --CW2.0 Base
	resource.AddWorkshop( "358608166" ) --CW2.0 Extra Weapons
	resource.AddWorkshop( "1386774614" ) --CTDM Files
	resource.AddWorkshop( "805601312" ) --INS2 Ambient Noises
	resource.AddWorkshop( "512986704" ) --Knife Kitty's Hitmarker
	resource.AddWorkshop( "1698026320" ) --The 6 new guns
	resource.AddWorkshop( "934839887" ) --The L96
	resource.AddWorkshop( "526188110" ) --Scorpion EVO

	util.AddNetworkString( "RequestTeams" )
	util.AddNetworkString( "RequestTeamsCallback" )

	if GM.MapTable[ game.GetMap() ] then
		if GM.MapTable[ game.GetMap() ].type then
			local redOptions = #GM.TeamNames[ GM.MapTable[ game.GetMap() ].type ].red
			local blueOptions = #GM.TeamNames[ GM.MapTable[ game.GetMap() ].type ].blue

			GM.redTeamName = GM.TeamNames[ GM.MapTable[ game.GetMap() ].type ].red[ math.random( redOptions ) ]
			GM.blueTeamName = GM.TeamNames[ GM.MapTable[ game.GetMap() ].type ].blue[ math.random( blueOptions ) ]
		end
	end
	print( "Setting up teams...", GM.redTeamName, GM.blueTeamName )
	team.SetUp( 1, GM.redTeamName, Color( 255, 0, 0 ) )
	team.SetUp( 2, GM.blueTeamName, Color( 0, 0, 255 ) )
	hook.Run( "FinishTeamSetup" )

	net.Receive( "RequestTeams", function( len, ply )
		print( "SERVER received RequestTeams", GAMEMODE.redTeamName, GAMEMODE.blueTeamName )
		net.Start( "RequestTeamsCallback" )
			net.WriteString( GAMEMODE.redTeamName )
			net.WriteString( GAMEMODE.blueTeamName )
		net.Send( ply )
	end )

	for k, v in pairs( GM.MapTable[ game.GetMap() ] or { } ) do
		if v == "NoFall" then
			GM.PreventFallDamage = true
		end
	end
end

function GM:Initialize()
	self.BaseClass.Initialize( self )
end

local _PLY = FindMetaTable( "Player" )

function _PLY:Score()
	return self:GetNWInt( "tdm_score" )
end

-- http://lua-users.org/wiki/FormattingNumbers
function comma_value( amount )
	local formatted = amount
	while true do  
		formatted, k = string.gsub( formatted, "^(-?%d+)(%d%d%d)", '%1,%2' )
		if ( k == 0 ) then
			break
		end
	end
	return formatted
end

function alterColorRGB( col, rDelta, gDelta, bDelta, aDelta ) --takes a Color as input, and returns it altered by the specified RGB amount. improves code readability without sacrificing constant colors
	return Color(math.Clamp(col.r + rDelta, 0, 255),
				 math.Clamp(col.g + gDelta, 0, 255),
				 math.Clamp(col.b + bDelta, 0, 255),
				 math.Clamp(col.a + aDelta, 0, 255))
end

function alterColorHSV( col, hDelta, sDelta, vDelta, aDelta ) --takes a Color as input, and returns it altered by the given HSV values. can be a lot more useful than simple RGB alterations for making decent procedural color changes
	--warning, colors returned by this function will fail IsColor checks!
	--this can be fixed if needed but it probably doesn't matter
	local h,s,v = ColorToHSV(col)
	return HSVToColor((h + hDelta) % 360,
					 math.Clamp(s + sDelta, 0, 1),
					 math.Clamp(v + vDelta, 0, 1))
end

function id( steamid )
	return string.gsub( steamid, ":", "x" )
end