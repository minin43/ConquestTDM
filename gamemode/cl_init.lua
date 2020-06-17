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
GM.TeamColor = colorScheme[ 0 ].TeamColor

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
        Spetsnaz = Material( "vgui/spetsnazIcon.png", "noclamp smooth" ),
        SpetsnazColor = Color( 255, 255, 255 ), --//white, because the icon comes pre-colored
        OpFor = Material( "vgui/opforIcon.png", "noclamp smooth" ),
        OpForColor = Color( 255, 255, 255 ), --//white, because the icon comes pre-colored
		Milita = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" ),
        [ "TF 141" ] = Material( "vgui/tf141Icon.png", "noclamp smooth" ),
        [ "TF 141Color" ] = Color( 255, 255, 255 ), --//white, because the icon comes pre-colored
        Rangers = Material( "vgui/rangersIcon.png", "noclamp smooth" ),
        RangersColor = Color( 255, 255, 255 ), --//white, because the icon comes pre-colored
		Seals = Material( "vgui/ic_account_circle_white_24dp.png", "noclamp smooth" )
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
		--//Was originally gonna have the Material calls in cl_perks here
	},
	Mapvote = { --//Any icons for the tags found in MapTable
		snipers = Material( "vgui/sniper_icon.png", "smooth" ), --same material as GAMEMODE.Icons.Weapons.sr
        flags = Material( "vgui/flagIcon.png", "smooth" ),
        resupply = Material( "vgui/resupply_icon.png", "smooth" )
    },
    Menu = {
        moneylocked = Material( "vgui/money_locked.png", "smooth" ),
        moneyunlocked = Material( "vgui/money_unlocked.png", "smooth" ),
        levellocked = Material( "vgui/level_locked.png", "smooth" ),
        levelunlocked = Material( "vgui/level_unlocked.png", "smooth" ),
		shopIcon = Material( "vgui/shopIcon.png", "noclamp smooth" ),
		loadoutIcon = Material( "vgui/backpackIcon.png", "noclamp smooth" ),
		teamChangeIcon = Material( "vgui/two-shadowsIcon.png", "noclamp smooth" ),
		cancelIcon = Material( "vgui/cancelIcon.png", "noclamp smooth" ),
		titleIcon = Material( "vgui/achievement.png", "noclamp smooth" ),
		helpIcon = Material( "vgui/help.png", "noclamp smooth" ),
        backIcon = Material( "vgui/back.png", "noclamp smooth" ),
        cashIcon = Material( "vgui/money_icon.png", "smooth" ),
        cashIconSmall = Material( "vgui/money_icon_small.png", "smooth" ),
        tokensIcon = Material( "vgui/prestige_token_icon.png", "smooth"),
        tokensIconSmall = Material( "vgui/prestige_token_icon_small.png", "smooth"),
        creditsIcon = Material( "vgui/donator_credits_icon.png", "smooth" ),
        creditsIconSmall = Material( "vgui/donator_credits_icon_small.png", "smooth" ),
        bodygroupsIcon = Material( "vgui/bodygroups_icon.png", "smooth" ),
        voiceoverIcon = Material( "vgui/voiceover_icon.png", "smooth" ),
        bodyarmorIcon = Material( "vgui/bodyarmor_icon.png", "smooth" ),
        vipIcon = Material( "vgui/vip_icon.png", "smooth" )
    }
}

GM.ButtonSounds = {
    Accept = { 
        "ambient/machines/keyboard2_clicks.wav",
        "ambient/machines/keyboard3_clicks.wav",
        "ambient/machines/keyboard1_clicks.wav",
        "ambient/machines/keyboard4_clicks.wav",
        "ambient/machines/keyboard5_clicks.wav",
        "ambient/machines/keyboard6_clicks.wav",
        "ambient/machines/keyboard7_clicks_enter.wav"
    },
    Deny = {
        "buttons/combine_button_locked.wav"
    },
    Buy = {
        "ambient/levels/labs/coinslot1.wav"
    }
}

GM.ColorRarities = {
    [ 0 ] = Color( 20, 20, 20, 200 ), --Black/dark gray
    [ 1 ] = Color( 87, 139, 235 ), --//Light blue
    [ 2 ] = Color( 153, 102, 204 ), --//Amethyst purple
    [ 3 ] = Color( 255, 215, 0 ), --//Gold
    [ 4 ] = Color(252, 57, 3 ), --//Red-Orange
    [ 5 ] = Color(0, 255, 255) --//Cyan
}

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
    },
    Spetsnaz = {
        "models/mw2guy/rus/gassoldier.mdl",
        "models/mw2guy/rus/soldier_a.mdl",
        "models/mw2guy/rus/soldier_c.mdl",
        "models/mw2guy/rus/soldier_d.mdl",
        "models/mw2guy/rus/soldier_e.mdl",
        "models/mw2guy/rus/soldier_f.mdl"
    },
    OpFor = {
        "models/cod players/opfor1.mdl",
        "models/cod players/opfor3.mdl",
        "models/cod players/opfor4.mdl",
        "models/cod players/opfor6.mdl"
    },
    --[[Militia = {

    },]]
    Rangers = {
        "models/codmw2/codmw2.mdl",
        "models/codmw2/codmw2h.mdl",
        "models/codmw2/codmw2he.mdl",
        "models/codmw2/codmw2m.mdl"
    },
    --[[Seals = {

    },]]
    [ "TF 141" ] = {
        "models/mw2guy/bz/bzgb01.mdl",
        "models/mw2guy/bz/bzghost.mdl",
        "models/mw2guy/bz/tfbz01.mdl",
        "models/mw2guy/bz/tfbz02.mdl",
        "models/mw2guy/bz/tfbz03.mdl",
        "models/mw2guy/bz/tfbzca01.mdl",
        "models/mw2guy/bz/tfbzca02.mdl",
        "models/mw2guy/bz/tfbzw01.mdl",
        "models/mw2guy/bz/tfbzw02.mdl"
    }
}
GM.DefaultModels[ "Red Team" ] = GM.DefaultModels.Rebels
GM.DefaultModels[ "Blue Team" ] = GM.DefaultModels.Rebels
function IsDefaultModel( mdl )
    if !GAMEMODE.CachedDefaultPlayermodels then
        GAMEMODE.CachedDefaultPlayermodels = {}
        for k, v in pairs( GAMEMODE.DefaultModels ) do
            for k2, v2 in pairs( v ) do
                GAMEMODE.CachedDefaultPlayermodels[ v2 ] = true
            end
        end
    end

    return GAMEMODE.CachedDefaultPlayermodels[ mdl ]
end

include( "shared.lua" )
include( "sh_loader.lua" )

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

hook.Add( "Think", "RequestTeamsInit", function()
	--GAMEMODE.TeamColor = colorScheme[LocalPlayer():Team()]["TeamColor"]

	if !GAMEMODE.ReceivedTeams then
		net.Start( "RequestTeams" )
		net.SendToServer()
	end
end )

--//This function opens up the initial menu for selecting teams, the net.Start can be found in shared.lua
net.Receive( "RequestTeamsCallback", function()
	GAMEMODE.ReceivedTeams = true
	GAMEMODE.redTeamName = net.ReadString()
	GAMEMODE.blueTeamName = net.ReadString()
	local firstJoin = net.ReadBool()

	team.SetUp( 0, "Spectators", Color( 0, 0, 0 ) )
	team.SetUp( 1, GAMEMODE.redTeamName, Color( 255, 0, 0 ) )
	team.SetUp( 2, GAMEMODE.blueTeamName, Color( 0, 0, 255 ) )
	team.SetUp( 3, "deathSelf", Color( 158, 253, 56 ) )

	if firstJoin then
		GAMEMODE:OpenHelp( true )
	else
		LocalPlayer():ConCommand( "tdm_spawnmenu" )
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
        if istable( v ) and !IsColor( v ) then
            for k, v in ipairs( v ) do
                fixedtab[ #fixedtab + 1 ] = v
            end
        else
            fixedtab[ #fixedtab + 1 ] = v
		end
    end
    
	chat.AddText( unpack( fixedtab ) )
end )

net.Receive( "TeamSwapHook", function()
    local newteam = net.ReadInt( 4 )
    GAMEMODE.TeamColor = colorScheme[ newteam ].TeamColor
end )

net.Receive( "SendSingleSound", function()
    local snd = net.ReadString()
    surface.PlaySound( snd )
end )