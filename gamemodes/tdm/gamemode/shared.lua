GM.Name = "Conquest Team Deathmatch"
GM.Author = "Logan, Whuppo, Cobalt"
GM.Email = "conquesttdm@gmail.com"
GM.Website = "N/A"
GM.Version = "Conquest Team Deathmatch V. 1.20"
GM.redTeamName = "Red Team"
GM.blueTeamName = "Blue Team"

GM.MapTable = { --Controls both the map autodownload and the mapvote information
    --[[[ "cs_assault" ] = { size = "Midsize", img = "vgui/maps/assault.png", type = "ins2" }, --Removed while player count remains low
    [ "cs_italy" ] = { size = "Midsize", img = "vgui/maps/italy.png", type = "ins2" },
    [ "cs_compound" ] = { size = "Small", img = "vgui/maps/compound.png", type = "ins2" },
    [ "de_cbble" ] = { size = "Midsize", img = "vgui/maps/cbbl.png", type = "ins2" },
    [ "de_dust" ] = { size = "Midsize", img = "vgui/maps/dust.png", type = "ins2" },
    [ "de_dust2" ] = { size = "Midsize", img = "vgui/maps/dust2.png", type = "ins2" },
    [ "cs_office" ] = { size = "Small", img = "vgui/maps/office.png", type = "ins2" },]]
    
    --[[ 
        id = Workshop ID
        size = Describes map size in mapvote
        img = Map icon directory
        type = Designated teams (hl2 teams, Insurgency teams, MW2 teams)
        extra = Table of behind-the-scenes "flags" to indicate special rules about the map that don't need displayed (nofall, for example)
        mapevents = Table of map-created entities that can be used/called to run a given event in a map (used specifically in rp_limanskhospital, for example)
        tags = Table of "flags" to indicate special properties about the map (sniper-friendly, for example) used only currently in mapvote
    ]]
	
	[ "gm_lasertag" ] = { id = 473594402, size = "Tiny", img = "vgui/maps/lasertag.png", type = "hl2",
		tags = { } },
    [ "gm_forestforts" ] = { id = 253493702, size = "Large", img = "vgui/maps/forestforts.png", type = "hl2",
		tags = { "snipers" } },
    [ "ttt_forest_final" ] = { id = 147635981, size = "Midsize", img = "vgui/maps/forestfinal.png", type = "hl2",
		tags = { } },
    [ "ttt_riverside_b3" ] = { id = 312731430, size = "Small", img = "vgui/maps/riverside.png", type = "hl2",
		tags = { } },
    [ "de_asia" ] = { id = 872474392, size = "Midsize", img = "vgui/maps/asia.png", type = "ins2",
		tags = { } },
    [ "de_star" ] = { id = 296000772, size = "Midsize", img = "vgui/maps/star.png", type = "ins2",
		tags = { } },
    [ "sh_lockdown_v2" ] = { id = 423308835, size = "Massive", img = "vgui/maps/lockdown2.png", type = "ins2",
		tags = { "snipers" } },
    [ "sh_smalltown_c" ] = { id = 865967849, size = "Large", img = "vgui/maps/smalltown.png", type = "ins2",
		tags = { } },
	[ "ttt_mw2_terminal" ] = { id = 176887855, size = "Large", img = "vgui/maps/terminal.png", type = "mw2",
		tags = { } },
    [ "dm_basebunker" ] = { id = 812797510, size = "Small", img = "vgui/maps/bunker.png", type = "hl2",
		tags = { } },
    [ "dm_powerstation" ] = { id = 446026985, size = "Small", img = "vgui/maps/powerstation.png", type = "hl2",
		tags = { } },
    [ "dm_plaza17" ] = { id = 1689260918, size = "Large", img = "vgui/maps/plaza17.png", type = "hl2",
		tags = { } },
    [ "de_corse" ] = { id = 1689260682, size = "Midsize", img = "vgui/maps/corse.png", type = "ins2",
		tags = { } },
    [ "de_joint" ] = { id = 1689260841, size = "Massive", img = "vgui/maps/joint.png", type = "ins2",
		tags = { } },
    [ "dm_avalon" ] = { id = 1669465120, size = "Midsize", img = "vgui/maps/avalon.png", type = "hl2", extra = { "NoFall" },
		tags = { } },
    [ "dm_bounce" ] = { id = 1645391828, size = "Small", img = "vgui/maps/bounce.png", type = "hl2", extra = { "NoFall" },
		tags = { } },
    [ "ttt_mw2_highrise" ] = { id = 290247692, size = "Large", img = "vgui/maps/highrise.png", type = "mw2",
		tags = { } },
	[ "ttt_mw2_scrapyard" ] = { id = 294363438, size = "Large", img = "vgui/maps/scrapyard.png", type = "mw2",
		tags = { } },
	--//Update 1.6
	[ "de_crash" ] = { id = 671482026, size = "Large", img = "vgui/maps/crash.png", type = "mw2",
		tags = { } },
	[ "dm_mines" ] = { id = 660390276, size = "Small", img = "vgui/maps/mines.png", type = "hl2",
		tags = { } },
	[ "de_boston" ] = { id = 296008620, size = "Large", img = "vgui/maps/boston.png", type = "ins2",
		tags = { } },
	--//Update 1.7
	--[[[ "ttt_cwoffice2019" ] = { id = 1659123269, size = "Large", img = "vgui/maps/cwoffice2019.png", type = "ins2",
		tags = { } },]]
	[ "ba_stadium" ] = { id = 1721873165, size = "Small", img = "vgui/maps/stadium.png", type = "hl2",
		tags = { } },
	[ "de_westwood" ] = { id = 1721873240, size = "Midsize", img = "vgui/maps/westwood.png", type = "ins2",
		tags = { } },
	[ "de_keystone_beta" ] = { id = 508986899, size = "Large", img = "vgui/maps/keystone.png", type = "ins2",
		tags = { "snipers" } },
	--[[[ "gm_devruins" ] = { id = 748863203, size = "Midsize", img = "vgui/maps/devruins.png",
		tags = { } },]] --//Removed until a more balanced spawn file can be found
	[ "dm_octagon" ] = { id = 1727666265, size = "Midsize", img = "vgui/maps/octagon.png", type = "hl2",
        tags = { } },
    --//Update 1.9
    [ "de_halo_battlecreek" ] = { id = 1769486134, size = "Small", img = "vgui/maps/battlecreek.png",
        tags = { } },
    [ "de_stad" ] = { id = 1751765989, size = "Large", img = "vgui/maps/stad.png", type = "ins2",
        tags = { "snipers" } },
    --//Update 1.10
    [ "cs_siege_csgo" ] = { id = 1745687579, size = "Massive", img = "vgui/maps/siege.png", type = "ins2",
        tags = { } },
    --[[[ "de_donya" ] = { id = 1741751353, size = "Midsize", img = "vgui/maps/donya.png", type = "ins2",
        tags = { } },]]
    [ "de_ruins" ] = { id = 1746629314, size = "Large", img = "vgui/maps/ruins.png", type = "ins2",
        tags = { } },
    [ "de_wellness" ] = { id = 1740206351, size = "Large", img = "vgui/maps/wellness.png", type = "ins2",
        tags = { } },
    [ "dm_corrugated" ] = { id = 284612461, size = "Large", img = "vgui/maps/corrugated.png", type = "hl2",
        tags = { } },
    --[[[ "dm_crossfire" ] = { id = 1759999305, size = "Midsize", img = "vgui/maps/crossfire.png", type = "hl2",
        tags = { } },]]
    [ "dm_necessity" ] = { id = 836130258, size = "Small", img = "vgui/maps/necessity.png", type = "hl2",
        tags = { } },
    [ "dm_torque" ] = { id = 442990905, size = "Midsize", img = "vgui/maps/torque.png", type = "hl2",
        tags = { } },
    [ "dm_torrent" ] = { id = 831949808, size = "Massive", img = "vgui/maps/torrent.png", type = "hl2",
        tags = { } },
    [ "gm_thepit" ] = { id = 1808461048, size = "Large", img = "vgui/maps/thepit.png", type = "hl2",
        tags = { } },
    [ "ttt_trinity_church" ] = { id = 1796051616, size = "Large", img = "vgui/maps/trinitychurch.png", type = "ins2",
        tags = { } },
    [ "zs_abstractum_v1" ] = { id = 1708763559, size = "Small", img = "vgui/maps/abstractum.png", type = "ins2",
        tags = { } },
    --Update 1.16
    [ "dm_drift" ] = { id = 837801728, size = "Small", img = "vgui/maps/drift.png", type = "hl2",
        tags = { } },
    [ "de_paris_subway" ] = { id = 439316726, size = "Large", img = "vgui/maps/paris_subway.png", type = "ins2",
        tags = { } },
    [ "cs_east_borough" ] = { id = 296957963, size = "Large", img = "vgui/maps/east_borough.png", type = "ins2",
        tags = { } },
    [ "gm_battleground_nodes" ] = { id = 1425456348, size = "Massive", img = "vgui/maps/battleground.png", type = "hl2",
        tags = { } },
    [ "gm_boreas" ] = { id = 1572373847, size = "Massive", img = "vgui/maps/boreas.png", type = "hl2",
        tags = { "resupply" } },
    [ "npc_galleria_mess" ] = { id = 758683686, size = "Large", img = "vgui/maps/galleria.png", type = "hl2",
        tags = { } },
    --[ "rp_limanskhospital" ] = { id = 1805815551, size = "Midsize", img = "vgui/maps/limansk.png", type = "ins2", mapevents = { 1576, 1577, 1578, 1579 },
        --tags = { } },
    [ "gm_explore_tunnels" ] = { id = 1529025790, size = "Large", img = "vgui/maps/tunnel.png", type = "hl2",
        tags = { } },
    --Update 1.18
    [ "sh_matlane_a2" ] = { id = 903231200, size = "Massive", img = "vgui/maps/matlane.png", type = "ins2",
        tags = { } },
    [ "gm_desert_factory" ] = { id = 2096153942, size = "Midsize", img = "vgui/maps/desert_factory.png", type = "ins2",
        tags = { "snipers" } },
    --Update 1.19
    [ "ttt_tarnish_v1" ] = { id = 551416188, size = "Midsize", img = "vgui/maps/tarnish.png", type = "ins2",
        tags = { } },
    [ "ttt_cod4_vacant" ] = { id = 176894422, size = "Midsize", img = "vgui/maps/vacant.png", type = "mw2",
        tags = { } },
    [ "ttt_cwoffice2019_v3" ] = { id = 1659123269, size = "Large", img = "vgui/maps/office2019.png", type = "ins2",
        tags = { } },
    [ "ttt_heaven" ] = { id = 877419567, size = "Large", img = "vgui/maps/heaven.png", --type = "ins2",
        tags = { "snipers" } },
    [ "ttt_zeta" ] = { id = 2112794784, size = "Midsize", img = "vgui/maps/zeta.png", type = "hl2",
        tags = { } },
    [ "dm_canals" ] = { id = 108953008, size = "Midisze", img = "vgui/maps/canals.png", type = "hl2",
        tags = { } },
    [ "dm_powerhouse" ] = { id = 1644225588, size = "Midisze", img = "vgui/maps/powerhouse.png", type = "hl2", --This map comes in a pack, should use the others
        tags = { } },
    [ "dm_steamlab" ] = { id = 1644225588, size = "Small", img = "vgui/maps/steamlab.png", type = "hl2",
        tags = { } },
    [ "dm_runoff" ] = { id = 1644225588, size = "Midisze", img = "vgui/maps/runoff.png", type = "hl2", mapevents = { 1593 },
        tags = { } },
    [ "dm_underpass" ] = { id = 1644225588, size = "Small", img = "vgui/maps/underpass.png", type = "hl2",
        tags = { } }

    --[ "ba_halo_beavercreek" ] = { id = 1727665956, size = "Small", img = "vgui/maps/beavercreek.png" }, --Unbalanced
	--[ "ttt_bf3_scrapmetal" ] = { id = 228105814, size = "Large", img = "vgui/maps/bf3_scrapmetal.png", type = "mw2" }, --Incredibly unoptimized, bad on framerates
	--[ "dm_aftermath" ] = { id = 975289333, size = "Large", img = "vgui/maps/aftermath.png", type = "hl2" }, --Seems to be crashing clients
	--[ "gm_toysoldiers" ] = { id = 313827200, size = "Enormous", img = "vgui/maps/toysoldier.png", type = "ins2" }, --Too big/open
	--[ "gm_floatingworlds_3" ] = { id = 122421739, size = "Enormous", img = "vgui/maps/floatingworlds.png", type = "ins2" }, --Too big/open
	--[ "dm_9rooms_b16" ] = { id = 1642035717, size = "Small", img = "vgui/maps/9rooms.png", type = "hl2" }, --Not popular
	--[ "dm_resident" ] = { id = 1623087187, size = "Midsize", img = "vgui/maps/resident.png", type = "hl2" }, --Too hard to balance
	--[ "gm_blackbrook_asylum" ] = { id = 903842886, size = "Small", img = "vgui/maps/blackbrook.png" } --Seems to be crashing the server
	--[ "dm_laststop" ] = { id = 513311726, size = "Midsize", img = "vgui/maps/laststop.png", type = "hl2" }, --Unbalanced and unpopular
	--[ "sh_lockdown" ] = { id = 261713202, size = "Large", img = "vgui/maps/lockdown.png", type = "hl2" }, --A copy of a map we already have
	--[ "ttt_lazertag" ] = { id = 206405740, size = "Large", img = "vgui/maps/lazertag2.png", type = "hl2" }, --Unpopular
	--[ "ttt_gunkanjima_v2" ] = { id = 229000479, size = "Small", img = "vgui/maps/gunkanjima.png", type = "ins2" }, --Unbalanced/unfun
	
	--[[[ "" ] = { id = 0, size = "", img = "vgui/maps/.png", type = "",
        tags = { } },]]
}

--//Team names - randomized if more than 1
GM.TeamNames = {
    mw2 = { red = { "Spetsnaz", "OpFor"--[[, "Milita"]] }, blue = { "TF 141", "Rangers"--[[, "Seals"]] }},
    hl2 = { red = { "Rebels" }, blue = { "Combine" } },
    ins2 = { red = { "Insurgents" }, blue = { "Security" } }
}

--//SteamDLs dependent on map 'type' - currently used for playermodel downloads only when they're necessary, but any addon ID can be placed here
GM.DependentDownloads = {
	ins2 = {
		1196565715, --Security Playermodels
		1202342807 --Insurgent Playermodels
    },
    mw2 = {
        176238701 --Spetsnaz, OpFor, 141, and Ranger Playermodels
    }
}

if SERVER then
    --Weapons
	resource.AddWorkshop( "349050451" ) --CW2.0 Base
    resource.AddWorkshop( "358608166" ) --CW2.0 Extra Weapons
    resource.AddWorkshop( "707343339" ) --CW2.0 melee
	resource.AddWorkshop( "2125483966" ) --The 6 new guns (CTDM content pack guns)
	resource.AddWorkshop( "934839887" ) --The L96
	resource.AddWorkshop( "526188110" ) --Scorpion EVO
    resource.AddWorkshop( "1555980538" ) --Sniper pack
    resource.AddWorkshop( "838920776" ) --Bullpup Pack
    resource.AddWorkshop( "1646262010" ) --RFB
    resource.AddWorkshop( "573353347" ) --MP9
    resource.AddWorkshop( "887113423" ) --M1014
    resource.AddWorkshop( "1584952306" ) --TEC-9
    resource.AddWorkshop( "1805065429" ) --R5
    resource.AddWorkshop( "374453458" ) --AAC Honeybadger
    resource.AddWorkshop( "1373175654" ) --Icarus-37
    resource.AddWorkshop( "388093141" ) --BlOps 2 pack
    resource.AddWorkshop( "354842171" ) --HK-316
    resource.AddWorkshop( "605564693" ) --ACR-E
    resource.AddWorkshop( "357365610" ) --PP-19 Bizon
    resource.AddWorkshop( "708840802" ) --LR300
    resource.AddWorkshop( "426465571" ) --G2 Contender
    resource.AddWorkshop( "391446992" ) --Silverballer
    --CTDM content pack part 2 is the now-removed White Snow guns (shotgun + 2 lmgs)
    resource.AddWorkshop( "1423470073" ) --Impulse Grenade
    resource.AddWorkshop( "180842642" ) --Medkit (unused) and adrenaline
    --resource.AddWorkshop( "1459958949" ) --Ballistic Vests    -    Not necessary, included in with content pack 1
    resource.AddWorkshop( "317267606" ) --MGS Box
    resource.AddWorkshop( "682125090" ) --Portable force field grenade
    
    --Server Content
    resource.AddWorkshop( "1386774614" ) --CTDM Files (CTDM content pack part 1) - general content
    resource.AddWorkshop( "1819579704" ) --CTDM Files (CTDM content pack part 3) - all sounds
    resource.AddWorkshop( "512986704" ) --Knife Kitty's Hitmarker

    --Playermodels
    resource.AddWorkshop( "150404359" ) --GMod Tower
    resource.AddWorkshop( "660726443" ) --Necris Part 1 - Yikes these are huge for 2 PMs
    resource.AddWorkshop( "660726791" ) --Necris Part 2
    resource.AddWorkshop( "161451189" ) --Info_Player_Start
    resource.AddWorkshop( "572447657" ) --R6 Kapkan
    resource.AddWorkshop( "1371823037" ) --Thanos
    resource.AddWorkshop( "216408135" ) --GTA V Characters
    resource.AddWorkshop( "1843708002" ) --John Wick

	util.AddNetworkString( "RequestTeams" )
	util.AddNetworkString( "RequestTeamsCallback" )

	if GM.MapTable[ game.GetMap() ] then 
		local mapType = GM.MapTable[ game.GetMap() ].type
		if mapType then
			local redOptions = #GM.TeamNames[ mapType ].red
			local blueOptions = #GM.TeamNames[ mapType ].blue

			GM.redTeamName = GM.TeamNames[ mapType ].red[ math.random( redOptions ) ]
			GM.blueTeamName = GM.TeamNames[ mapType ].blue[ math.random( blueOptions ) ]

			if GM.DependentDownloads[ mapType ] then
				for k, v in pairs( GM.DependentDownloads[ mapType ] ) do
					resource.AddWorkshop( v )
				end
			end
		end
	end
	
	team.SetUp( 0, "Spectators", Color( 0, 0, 0 ) )
	team.SetUp( 1, GM.redTeamName, Color( 255, 0, 0 ) )
	team.SetUp( 2, GM.blueTeamName, Color( 0, 0, 255 ) )
	team.SetUp( 3, "deathSelf", Color( 158, 253, 56 ) )

	hook.Run( "FinishTeamSetup" )

    GM.PreventHookSpam = {}
	net.Receive( "RequestTeams", function( len, ply )
        --//The receive function for this can be found in cl_init
		net.Start( "RequestTeamsCallback" )
			net.WriteString( GAMEMODE.redTeamName )
			net.WriteString( GAMEMODE.blueTeamName )
			net.WriteBool( not GAMEMODE.AcceptedHelp[ id( ply:SteamID() ) ] )
        net.Send( ply )
        
        if not GAMEMODE.PreventHookSpam[ ply ] then
            GAMEMODE.PreventHookSpam[ ply ] = true

            hook.Run( "PlayerLoadedIn", ply )
            GlobalChatPrintColor( Color( 255, 255, 255 ), "Player ", Color( 76, 175, 80 ), ply:Nick(), Color( 255, 255, 255 ), " has loaded into the game." )

            --[[for k, v in pairs( GAMEMODE.PreventHookSpam ) do
                if not IsValid( k ) or k == NULL then
                    table.remove( GAMEMODE.PreventHookSpam, k )
                end
            end]]
        end
	end )

    if GM.MapTable[ game.GetMap() ] then
        if GM.MapTable[ game.GetMap() ].extra then
            for k, v in pairs( GM.MapTable[ game.GetMap() ].extra ) do
                if v == "NoFall" then
                    GM.PreventFallDamage = true
                elseif v == "Flashlights" then
                    GM.PreventFlashlights = true
                end
            end
        end

        if GM.MapTable[ game.GetMap() ].mapevents then
            timer.Create( "MapEventsTimer", 240, 0, function()
                local newChoice

                if #GAMEMODE.MapTable[ game.GetMap() ].mapevents == 1 then
                    newChoice = GAMEMODE.MapTable[ game.GetMap() ].mapevents[1]
                else
                    GAMEMODE.LastMapEvent = GAMEMODE.LastMapEvent or 0
                    newChoice = GAMEMODE.MapTable[ game.GetMap() ].mapevents[ math.random( #GAMEMODE.MapTable[ game.GetMap() ].mapevents ) ]
                    while newChoice == GAMEMODE.LastMapEvent do
                        newChoice = GAMEMODE.MapTable[ game.GetMap() ].mapevents[ math.random( #GAMEMODE.MapTable[ game.GetMap() ].mapevents ) ]
                    end
                end

                ents.GetMapCreatedEntity( newChoice ):Fire("Use")
            end )
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
					 math.Clamp(s, 0, 1),
					 math.Clamp(v, 0, 1))
end

function id( steamid )
	return string.gsub( steamid, ":", "x" )
end

hook.Add( "PlayerSpawn", "PreventFlashlights", function( ply )
    if GAMEMODE.PreventFlashlights and ply and ply:CanUseFlashlight() then
        ply:AllowFlashlight( false )
    end
end )