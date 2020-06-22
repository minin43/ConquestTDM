GM.DefaultScheme = Color( 255, 255, 255, 200 )
GM.RedScheme = Color( 175, 0, 0, 150)
GM.BlueScheme = Color( 0, 0, 255, 150)
GM.CurrentScheme = GM.DefaultScheme
GM.Release = "Release 06172020"
local draw = draw
local hook = hook
local math = math
local surface = surface
local table = table

local gradient = surface.GetTextureID( "gui/gradient" )
local damage = Material( "tdm/damage.png" )

--//This is a lot of fucking fonts, whuppo
surface.CreateFont( "BigNotify", { font = "BF4 Numbers", size = 70, weight = 1, antialias = true } )
surface.CreateFont( "AltAmmo", { font = "BF4 Numbers", size = 40, weight = 1, antialias = true } )
surface.CreateFont( "Time", { font = "BF4 Numbers", size = 30, weight = 1, antialias = true } )
surface.CreateFont( "SpecTime", { font = "BF4 Numbers", size = 42, weight = 1, antialias = true } )
surface.CreateFont( "HP", { font = "BF4 Numbers", size = 23, weight = 1, antialias = true } )
surface.CreateFont( "LVL", { font = "BF4 Numbers", size = 15, weight = 600, antialias = true } ) --'lvl' == kills?
surface.CreateFont( "Flags", { font = "BF4 Numbers", size = 25,	weight = 1, antialias = true } )
surface.CreateFont( "PrimaryAmmo", { font = "Exo 2", size = 80 } )
surface.CreateFont( "PrimaryAmmoBG", { font = "Exo 2", size = 80, blursize = 6 } )
surface.CreateFont( "SecondaryAmmo", { font = "Exo 2", size = 40 } )
surface.CreateFont( "SecondaryAmmoBG", { font = "Exo 2", size = 40, blursize = 6 } )
surface.CreateFont( "Health", { font = "Exo 2", size = 40, weight = 500, antialias = true } )
surface.CreateFont( "HealthBG", { font = "Exo 2", size = 100, weight = 600, antialias = true } )
surface.CreateFont( "Info", { font = "Exo 2", size = 24, weight = 1 } )
surface.CreateFont( "Killfeed", { font = "BF4 Numbers", size = 20, weight = 1 } )
surface.CreateFont( "Name", { font = "Exo 2", size = 24 } )
surface.CreateFont( "NameBG", { font = "Exo 2", size = 24, blursize = 2 } )
surface.CreateFont( "Level", { font = "Exo 2", size = 18 } )
surface.CreateFont( "LevelBG", { font = "Exo 2", size = 18, blursize = 2 } )
surface.CreateFont( "KillStreak", { font = "BF4 Numbers", size = 20, weight = 1, antialias = true } )

CreateClientConVar( "hud_lag", 1, true, true )
CreateClientConVar( "hud_halo", 1, true, true )
CreateClientConVar( "hud_fade", 1, true, true )
CreateClientConVar( "hud_indicator", 1, true, true )
CreateClientConVar( "hud_showexp", 0, true, true )
CreateClientConVar( "hud_old", 1, true, true )

weps = {}
CurrentLifeWeps = {}
capture = {}

net.Receive( "SendInitialStatTrak", function()
	CurrentLifeWeps = net.ReadTable()
	weps = net.ReadTable()
end )

net.Receive( "UpdateStatTrak", function()
	local wep = net.ReadString()
	local newnum = net.ReadString()

	for k, v in next, CurrentLifeWeps do
		if v[ 1 ] == wep then
			v[ 2 ] = newnum
		end
	end
end )

net.Receive( "BroadcastCaptures", function()
	local tab = net.ReadTable()
	capture = tab
end )

local HideTheseElements = {
	[ "CHudHealth"] =  true,
	[ "CHudBattery"] =  true,
	[ "CHudAmmo"] =  true,
	[ "CHudSecondaryAmmo"] =  true,
	[ "CHudDamageIndicator" ] = true,
	[ "CHudCloseCaption" ] = true,
	[ "CHudPoisonDamageIndicator" ] = true,
	[ "CHudSquadStatus" ] = true,
	[ "CHudTrain" ] = true,
	[ "CHudVehicle" ] = true,
	[ "CHudCrosshair" ] = true
}

hook.Add( "HUDShouldDraw", "HideHL2Hud", function( part )
	if HideTheseElements[ part ] then
		return false
	end
end )

function surface.DrawFadingText( col, text )
	local alpha = math.Round( 0.5 * ( 1 + math.sin( 2 * math.pi * 0.6 * CurTime() ) ), 3 )
	local color = col
	color.a = alpha * 255
	surface.SetTextColor( color )
	surface.DrawText( text )
end

local hl = {}

hitpos = {}
local hpdrain = 0

usermessage.Hook( "damage", function( msg )
	if GetConVarNumber( "hud_indicator" ) == 0 then return end

	local dmg = msg:ReadVector()
	local pos = LocalPlayer():GetPos()
	local png = LocalPlayer():EyeAngles()
	if png.y < -90 and png.y > 90 then
		png.y = png.y + 360
	elseif png.y > 90 and png.y < -90 then
		png.y = png.y - 360
	end
	local vec = dmg - pos
	local ang = vec:Angle()
	local ttl = 4
	table.insert( hitpos, { ang.y - png.y, ttl } )
end )

usermessage.Hook( "damage_death", function()
	hitpos = {}
end )

local drawtime = {
	{ x = ScrW() / 2 - 90 + 20, y = 0 },
	{ x = ScrW() / 2 + 90 - 22, y = 0 },
	{ x = ScrW() / 2 + 75 - 22, y = 30 },
	{ x = ScrW() / 2 - 75 + 20, y = 30 }
}
local drawtime_fix = {
	{ x = ScrW() / 2 - 90 + 20, y = 22 },
	{ x = ScrW() / 2 + 90 - 22, y = 22 },
	{ x = ScrW() / 2 + 75 - 22, y = 30 },
	{ x = ScrW() / 2 - 75 + 20, y = 30 }
}
local drawscore = {
	{ x = ScrW() / 2 - 90 - 40, y = 0 },
	{ x = ScrW() / 2 + 90 + 42, y = 0 },
	{ x = ScrW() / 2 + 75 + 42, y = 22 },
	{ x = ScrW() / 2 - 75 - 40, y = 22 }
}

globalblue, globalred, bluealpha, redalpha = 0, 0, 0, 0
levelpercent = 0
curmoney = 0

hook.Add( "Think", "TeamColors", function()
	if LocalPlayer():Team() == 1 then
		GAMEMODE.CurrentScheme = GAMEMODE.RedScheme
	elseif LocalPlayer():Team() == 2 then
		GAMEMODE.CurrentScheme = GAMEMODE.BlueScheme
	else
		GAMEMODE.CurrentScheme = GAMEMODE.DefaultScheme
	end
end )

--//Draws spectator information text
hook.Add( "HUDPaint", "HUD_Spectator", function()
	if LocalPlayer():Team() == 0 then
		if LocalPlayer():GetObserverTarget() and LocalPlayer():GetObserverTarget():IsValid() then
			n = LocalPlayer():GetObserverTarget():Name() or ""
			nhp = LocalPlayer():GetObserverTarget():Health() or 0
		else
			n = "Nobody"
			nhp = 100
		end

		if LocalPlayer():GetObserverMode() == OBS_MODE_ROAMING then
			draw.SimpleText( "Press [R] to change to First-Person", "DermaDefault", ScrW() / 2 + 1, ScrH() - 50 + 1, colorScheme[0]["SpectatorTextShadow"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( "Press [R] to change to First-Person", "DermaDefault", ScrW() / 2, ScrH() - 50, colorScheme[0]["SpectatorText"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		elseif LocalPlayer():GetObserverMode() == OBS_MODE_CHASE then
			draw.SimpleText( "Press [R] to change to Free Roam", "DermaDefault", ScrW() / 2 + 1, ScrH() - 50 + 1, colorScheme[0]["SpectatorTextShadow"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( "Press [R] to change to Free Roam", "DermaDefault", ScrW() / 2, ScrH() - 50, colorScheme[0]["SpectatorText"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( "Spectating: " .. n .. " (" .. nhp .. "%)", "DermaDefault", ScrW() / 2 + 1, ScrH() - 32 + 1, colorScheme[0]["SpectatorTextShadow"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( "Spectating: " .. n .. " (" .. nhp .. "%)", "DermaDefault", ScrW() / 2, ScrH() - 32, colorScheme[0]["SpectatorText"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		elseif LocalPlayer():GetObserverMode() == OBS_MODE_IN_EYE then
			draw.SimpleText( "Press [R] to change to Third-Person", "DermaDefault", ScrW() / 2 + 1, ScrH() - 50 + 1, colorScheme[0]["SpectatorTextShadow"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( "Press [R] to change to Third-Person", "DermaDefault", ScrW() / 2, ScrH() - 50, colorScheme[0]["SpectatorText"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( "Spectating: " .. n .. " (" .. nhp .. "%)", "DermaDefault", ScrW() / 2 + 1, ScrH() - 32 + 1, colorScheme[0]["SpectatorTextShadow"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( "Spectating: " .. n .. " (" .. nhp .. "%)", "DermaDefault", ScrW() / 2, ScrH() - 32, colorScheme[0]["SpectatorText"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		end
	end
end )

--//Disables the rest of the HUD components if the round's finished, or the HUD's been disabled
hook.Add( "HUDPaint", "HUD_DisableChecks", function()
	if GetGlobalBool( "RoundFinished" ) == true or GetConVarNumber( "hud_disable" ) != 0 or LocalPlayer().disablehud == true --[[or !LocalPlayer():Alive()]] then
		return true
	end
end )

local overlayTable = {
	slaw_overlay = Material( "vgui/frosted.png" ),
	slaw_rate = 0,
	--[[lifeline_overlay = Material( "" ),
	lifeline_rate = 0,
	thornmail_overlay = Material( "" ),
	thornmail_rate = 0,
	vengeance_overlay = Material( "" ),
    vengeance_rate = 0,]]
    bleedout_rate = 0,
	spawn_rate = 0
}
--//Handles perk overlays, net.Receive's found lower in file. Surface draws are drawn in order, so important overlays should be drawn last
hook.Add( "HUDPaint", "HUD_OverlayEffects", function()
    if not LocalPlayer():Alive() then 
        overlayTable.slaw_rate = 0
        overlayTable.bleedout_rate = 0
        return 
    end
    
    if GAMEMODE.ShouldDrawBleedout then
		overlayTable.bleedout_rate = 1
	else
		overlayTable.bleedout_rate = overlayTable.bleedout_rate - 0.005
	end

	surface.SetTexture( gradient )
	surface.SetDrawColor( 255, 0, 0, math.Clamp( 100 * overlayTable.bleedout_rate, 0, 100 ) )
    surface.DrawTexturedRectRotated( 25, ScrH() / 2, 50, ScrH(), 0 )
    surface.DrawTexturedRectRotated( ScrW() / 2, 25, 50, ScrW(), 270 )
    surface.DrawTexturedRectRotated( ScrW() - 25, ScrH() / 2, 50, ScrH(), 180 )
    surface.DrawTexturedRectRotated( ScrW() / 2, ScrH() - 25, 50, ScrW(), 90 )
    draw.NoTexture()

	--[[if GAMEMODE.ShouldDrawThornmail then
		overlayTable.thornmail_rate = 1
	else
		overlayTable.thornmail_rate = overlayTable.thornmail_rate - 0.01
	end

	surface.SetMaterial( overlayTable.thornmail_overlay )
	surface.SetDrawColor( 255, 255, 255, math.Clamp( 200 * overlayTable.thornmail_rate, 0, 200 ) )
	surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )

	if GAMEMODE.ShouldDrawLifeline then
		overlayTable.lifeline_rate = overlayTable.lifeline_rate + 0.01
	else
		overlayTable.lifeline_rate = overlayTable.lifeline_rate - 0.01
	end

	surface.SetMaterial( overlayTable.lifeline_overlay )
	surface.SetDrawColor( 255, 255, 255, math.Clamp( 120 * overlayTable.lifeline_rate, 0, 120 ) )
	surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )]]

	if GAMEMODE.ShouldDrawIce then
		overlayTable.slaw_rate = 1
	else
		overlayTable.slaw_rate = overlayTable.slaw_rate - 0.01
	end

	surface.SetMaterial( overlayTable.slaw_overlay )
	surface.SetDrawColor( 255, 255, 255, math.Clamp( 100 * overlayTable.slaw_rate, 0, 100 ) )
	surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
end )

--//Spawn Protection text - fades when spawn protection is gone
hook.Add( "HUDPaint", "HUD_SpawnOverlay", function()
	if GAMEMODE.ShouldDrawProtection then 
		overlayTable.spawn_rate = 1
	else
		overlayTable.spawn_rate = overlayTable.spawn_rate - 0.02
	end

	surface.SetFont( "BigNotify" )
	local tw, th = surface.GetTextSize( "[Spawn Protection Enabled]" )

	surface.SetTextColor( 255, 255, 255, overlayTable.spawn_rate * 255 )
	surface.SetTextPos( ( ScrW() / 2 ) - ( tw / 2 ), ScrH() - ( ScrH() / 1.1 ) )
	surface.DrawText( "[Spawn Protection Enabled]" )
end )

--Newly improved low-health HUD effect - should be less intrusive and more immersive
local blood_overlay = Material("hud/damageoverlay.png", "unlitgeneric smooth")
hook.Add( "HUDPaint", "HUD_LowHealth", function()
	if not LocalPlayer():Alive() then LocalPlayer():SetDSP( 0, false ) return end
	local EffectDecay = 200 --Time before effect begins to grayscale
	local EffectStart = 30 --HP requirement before effects play
	GAMEMODE.LastHP = GAMEMODE.LastHP or LocalPlayer():Health() or 0
	local CurrentHP = LocalPlayer():Health() or 0
	GAMEMODE.GrayScale = GAMEMODE.GrayScale or 1
	local WaitTimer = WaitTimer or 0

	if CurrentHP > EffectStart then GAMEMODE.LastHP = LocalPlayer():Health() return end

	surface.SetMaterial( blood_overlay )
	surface.SetDrawColor( 255 * math.Clamp( GAMEMODE.GrayScale, 0, 1 ), 255 * math.Clamp( GAMEMODE.GrayScale, 0, 1 ), 255 * math.Clamp( GAMEMODE.GrayScale, 0, 1 ), (EffectStart - CurrentHP) / EffectStart * 175 )
	surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() ) --These values were -10 and + 20, for some reason

	if GAMEMODE.LastHP > CurrentHP then --Only runs if we've taken some amount of damage the last tick
		if CurrentHP <= 0 then LocalPlayer():SetDSP( 0, false ) return end
		GAMEMODE.LastHP = CurrentHP
		LocalPlayer():SetDSP( 34, true )
		--[[timer.Simple( 0.1, function()
			LocalPlayer():SetDSP( 15, false )
			timer.Simple( 0, function()
				LocalPlayer():SetDSP( 34, false ) --3, 15, 16 is muffled and echoed, 24 with heavy echo, 31 heavy muffle, 32 extreme muffle, 33 muffle on treble sounds, 38 muffle bass sounds
			--46 prevents sounds shorter than 1 second from playing
			end )
		end )]]
		GAMEMODE.GrayScale = 0.5
		WaitTimer = CurTime() + EffectDecay
	else
		if WaitTimer < CurTime() then
			GAMEMODE.GrayScale = GAMEMODE.GrayScale - 0.001
		end
	end

	--//Not sure what this does
	--This LERPs the HP loss when you take damage, I think
	local maxhp = LocalPlayer():GetMaxHealth()
	if hpdrain > CurrentHP then
		hpdrain = Lerp( FrameTime() * 2, hpdrain, CurrentHP )
	else
		hpdrain = CurrentHP
	end

	CurrentHP = math.Clamp( CurrentHP, 0, maxhp )
	hpdrain = math.Clamp( hpdrain, 0, maxhp )
	
end )

--//Draws the round information: time, score, flag status, as well as the "change team/loadout" keys
hook.Add( "HUDPaint", "HUD_RoundInfo", function()

	draw.NoTexture()
	surface.SetDrawColor( colorScheme[0]["GameTimerBG"] )
	surface.DrawPoly( drawtime )
	surface.DrawPoly( drawtime_fix )
	surface.SetDrawColor( colorScheme[0]["GameScoreBG"] )
	surface.DrawPoly( drawscore )
	local num = GetGlobalInt( "RoundTime" )
	local col = colorScheme[0]["GameTimer"]
	--Sets time red with 1 minute remaining
	if num <= 60 then
		col = colorScheme[0]["GameTimerLow"]
	end
	
	local t = string.FormattedTime( tostring( num ) )
	t.m = tostring( t.m )
	t.s = tostring( t.s )
	if #t.m == 1 then
		t.m = "0" .. t.m
	end
	if #t.s == 1 then
		t.s = "0" .. t.s
	end
	draw.SimpleText( t.m .. ":" .. t.s, "SpecTime", ScrW() / 2, 11, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	if GetGlobalBool( "ticketmode" ) == true then
		redtix = GetGlobalInt( "RedTickets" )
		draw.SimpleText( redtix, "Time", ScrW() / 2 - 70, 9, Color( 255, 0, 0, 177 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		
		bluetix = GetGlobalInt( "BlueTickets" )
		draw.SimpleText( bluetix, "Time", ScrW() / 2 + 70, 9, Color( 0, 0, 255, 177 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	else
		--//I know it's messy, but I don't care enough about something this small to rewrite it in a more appropriate fashion
		local redkills, redExtra = GetGlobalInt( "RedKills" )
		if redkills < 10 then
			draw.SimpleText( "00", "Time", ScrW() / 2 - 85, 9, colorScheme[0]["KillsPlaceholderText"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		elseif redkills < 100 then
			draw.SimpleText( "0", "Time", ScrW() / 2 - 100, 9, colorScheme[0]["KillsPlaceholderText"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		elseif redkills > 999 then
			draw.SimpleText( ">1k", "Time", ScrW() / 2 - 70, 9, Color( 255, 0, 0, 177 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			redkills = ""
		end
		draw.SimpleText( "kills", "LVL", ScrW() / 2 - 73, 27, colorScheme[0]["KillsLabelText"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		draw.SimpleText( redkills, "Time", ScrW() / 2 - 70, 9, Color( 255, 0, 0, 177 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		--draw.SimpleText( redExtra, "Time", ScrW() / 2 - 70, 9, Color( 255, 255, 255, 177 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

		local bluekills, blueExtra = GetGlobalInt( "BlueKills" )
		if bluekills < 10 then
			draw.SimpleText( "00", "Time", ScrW() / 2 + 100, 9, colorScheme[0]["KillsPlaceholderText"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		elseif bluekills < 100 then
			draw.SimpleText( "0", "Time", ScrW() / 2 + 85, 9, colorScheme[0]["KillsPlaceholderText"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		elseif bluekills > 999 then
			draw.SimpleText( ">1k", "Time", ScrW() / 2 + 80, 9, Color( 0, 0, 255, 177 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			bluekills = ""
		end
		draw.SimpleText( "kills", "LVL", ScrW() / 2 + 70, 27, colorScheme[0]["KillsLabelText"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( bluekills, "Time", ScrW() / 2 + 115, 9, Color( 0, 0, 255, 177 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		--draw.SimpleText( blueExtra, "Time", ScrW() / 2 + 70, 9, Color( 255, 255, 255, 177 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end

	surface.SetFont( "Info" )
	local info = "[F1] Menu | [F2] Loadout | [F3] Shop | [F4] Choose Team"
    local infowidth, infoheight = surface.GetTextSize( info )
    --local info2 = "[F3] Open Shop | [F4] Choose Team"
    local info2width, info2height = 0, 0 --surface.GetTextSize( info )
	
	--Creates the boxes in the top left hand corner for F1 and F2 commands
	surface.SetDrawColor( GAMEMODE.CurrentScheme ) 
	surface.SetTexture( gradient )
	surface.DrawRect( 32, 32, infowidth + 9, infoheight + info2height + 5 ) --Align it with gamemode name/version text set below
	surface.SetDrawColor( colorScheme[0]["HelpMenuShade"] )
	surface.DrawRect( 32, 32, infowidth + 11, infoheight + info2height + 7 )

	--Writes the text in string "info" set above
	surface.SetFont( "Info" )
	surface.SetTextColor( colorScheme[0]["HelpMenuText"] )
	surface.SetTextPos( 36, 33 )
    surface.DrawText( info )
    --surface.SetTextPos( 35, 33 + infoheight )
    --surface.DrawText( info2 )

	--Gamemode name & version number
	surface.SetTextColor( colorScheme[0]["GamemodeVersionText"] )
	surface.SetTextPos( 32, 38 + infoheight + info2height ) --Align it with grey box in the top left hand corner rectangle set above
	surface.DrawText( GAMEMODE.Version .. " " .. GAMEMODE.Release )
end )

--//Draws the damage indicator 
hook.Add( "HUDPaint", "HUD_NearMiss", function()
	if LocalPlayer():Alive() then
		for k, v in next, hitpos do
			surface.SetMaterial( damage ) --*v[2]
			surface.SetDrawColor( alterColorRGB(colorScheme[0]["DamageIndicatorShade"], 0, 0, 0, 255 * v[2]) )
			surface.DrawTexturedRectRotated( ScrW() / 2, ScrH() / 2, 288, 288, v[ 1 ] - 180 )
			v[ 2 ] = v[ 2 ] - 0.1
			if v[ 2 ] <= 0 then
				table.remove( hitpos, k )
			end
		end
	end
end )

--//Draws Health, Ammo
hook.Add( "HUDPaint", "HUD_HealthAndAmmo", function()
	if !LocalPlayer():Alive() or LocalPlayer():Team() == 0 then return end

	--//Health
	draw.SimpleText( math.Clamp( LocalPlayer():Health(), 0, LocalPlayer():GetMaxHealth() + 100 ), "HealthBG", ScrW() - 210, ScrH() - 65, GAMEMODE.CurrentScheme, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
	draw.SimpleText( "HP", "Health", ScrW() - 160, ScrH() - 105, GAMEMODE.CurrentScheme, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
	draw.SimpleText( "/ " .. LocalPlayer():GetMaxHealth() .. " MAX", "Health", ScrW() - 54, ScrH() - 65, colorScheme[0]["MaxHPTextShadow"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
	draw.SimpleText( "/ " .. LocalPlayer():GetMaxHealth() .. " MAX", "Health", ScrW() - 56, ScrH() - 65, colorScheme[0]["MaxHPText"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )

	--//Ammo information, currently disabled in favor of CW2.0's floating text information
	--[[if LocalPlayer():GetActiveWeapon() ~= NULL then
		local activewep = LocalPlayer():GetActiveWeapon()
		local primaryammo = activewep:GetPrimaryAmmoType()
		local ammocount = LocalPlayer():GetAmmoCount( primaryammo )
		local c1 = activewep:Clip1()
		local _c1, _ammocount

		if( activewep ~= NULL and primaryammo ~= NULL and ammocount > -1 ) then
			if( c1 < 0 ) then
				c1 = "---"
			end
			if( ammocount <= 0 ) then
				ammocount = "---"
			end
			
			if string.len( tostring( c1 ) ) == 2 then
				_c1 = "0" .. c1
			elseif string.len( tostring( c1 ) ) == 1 then
				_c1 = "00" .. c1
			else
				_c1 = ""
			end
			--Ammo count on right side of screen, keeping just in case we ever need it
			draw.SimpleText( _c1, "PrimaryAmmo", ScrW() - 290, ScrH() - 110, Color( 0, 0, 0, 120 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( c1, "PrimaryAmmo", ScrW() - 290, ScrH() - 110, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )

			draw.SimpleText( ammocount, "SecondaryAmmoBG", ScrW() - 80, ScrH() - 130, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
			if string.len( tostring( ammocount ) ) == 2 then
				_ammocount = "0" .. ammocount
			elseif string.len( tostring( ammocount ) ) == 1 then
				_ammocount = "00" .. ammocount
			else
				_ammocount = ""
			end
			draw.SimpleText( _ammocount, "SecondaryAmmo", ScrW() - 220, ScrH() - 100, Color( 0, 0, 0, 120 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( ammocount, "SecondaryAmmo", ScrW() - 220, ScrH() - 100, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )

			surface.SetFont( "AltAmmo" )
			surface.SetTextColor( Color( 255, 255, 255, 200 ) )
			surface.SetTextPos( ScrW() - 285, ScrH() - 155 )
			surface.DrawText( "/" )
			
		end
	end]]
end )

--//Draws your individual information, your $ and level - this is LEGACY code, I don't write this messy
hook.Add( "HUDPaint", "HUD_PersonalInfo", function()
	local teamcolor = team.GetColor( LocalPlayer():Team() )
	local n = 11
	teamcolor = Color( math.Clamp( teamcolor.r, 255 / n * ( n - 1 ), 255 ), math.Clamp( teamcolor.g, 255 / n * ( n - 1 ), 255 ), math.Clamp( teamcolor.b, 255 / n * ( n - 1 ), 255 ) )

	local exp = currentexp --why is both exp and currentexp used?
	local nextexp = nextlvlexp --same question
	local lvl = currentlvl --it looks like one is only checked to see if its -1 and the other is actually used as a number. but why?
	
	local percent = exp / nextexp
	local loading

	if currentlvl == -1 and currentexp == -1 and nextlvlexp == -1 then
		if CurTime() % 2 >= 0 and CurTime() % 2 <= 2 / 3 then
			loading = "."
		elseif CurTime() % 2 >= 2 / 3 and CurTime() % 2 <= 2 / 3 * 2 then
			loading = ".."
		elseif CurTime() % 2 >= 2 / 3 * 2 and CurTime() % 2 <= 2 then
			loading = "..."
		end
	else
		levelpercent = Lerp( FrameTime() * 8, levelpercent, percent )
	end

	--Experience Bar & Level shite
	surface.SetDrawColor( colorScheme[0]["ExperienceBar"] )
	surface.DrawRect( 44, ScrH() - 106, 231, 10 )
	
	surface.SetDrawColor( GAMEMODE.CurrentScheme )
	surface.DrawRect( 44, ScrH() - 106, 1 + ( 231 * levelpercent ), 10 )
	surface.SetDrawColor( teamcolor )
	surface.DrawRect( 44, ScrH() - 96, 231, 2 )

	for i = 0, 4 do 
		draw.SimpleText( LocalPlayer():GetName(), "NameBG", 48, ScrH() - 135, colorScheme[0]["PlayerNameShadow"], TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
		if currentlvl == -1 and currentexp == -1 and nextlvlexp == -1 then
			draw.SimpleText( "Receiving game data" .. loading, "LevelBG", 50, ScrH() - 110, colorScheme[0]["RecvGameDataShadow"], TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
		else
			if GetConVarNumber( "hud_showexp" ) == 0 then
				draw.SimpleText( "[ " .. math.Round( percent * 100, 1 ) .. "% ] Level " .. lvl, "LevelBG", 50, ScrH() - 110, colorScheme[0]["ExperiencePctTextShadow"], TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
			else
				draw.SimpleText( "[ " .. exp .. " / " .. nextexp .. " ] Level " .. lvl, "LevelBG", 50, ScrH() - 110, colorScheme[0]["ExperienceTextShadow"], TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
			end
		end
	end
	draw.SimpleText( LocalPlayer():GetName(), "Name", 48, ScrH() - 135, teamcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
	if currentlvl == -1 and currentexp == -1 and nextlvlexp == -1 then
		draw.SimpleText( "Receiving game data" .. loading, "Level", 50, ScrH() - 110, teamcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
	else
		if GetConVarNumber( "hud_showexp" ) == 0 then
			draw.SimpleText( "[ " .. math.Round( percent * 100, 1 ) .. "% ] Level " .. lvl, "Level", 50, ScrH() - 110, teamcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
		else
			draw.SimpleText( "[ " .. exp .. " / " .. nextexp .. " ] Level " .. lvl, "Level", 50, ScrH() - 110, teamcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
		end
	end

	curmoney = Lerp( FrameTime() * 12, curmoney, math.Clamp( curAmt, 0, curAmt ) )

	for i = 0, 4 do
		draw.SimpleText( "$" .. comma_value( math.Round( curmoney ) ), "LevelBG", 48, ScrH() - 76, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
	end
	draw.SimpleText( "$" .. comma_value( math.Round( curmoney ) ), "Level", 48, ScrH() - 76, teamcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

	local wep = LocalPlayer():GetActiveWeapon()
	
	if wep and wep ~= NULL then 

		wep = wep:GetClass()
		
		local num
		for k, v in next, CurrentLifeWeps do
			if v[ 1 ] == wep then
				num = tostring( v[ 2 ] )
			end
		end
		if not num then 
			num = "0"
		end
		
		local cnum = 0
		local curnum = 0
		for k, v in next, weps do
			if wep == k then
				curnum = table.Count( weps[ k ] )
				for k, v in next, weps[ k ] do
					if tonumber( num ) >= v[ 2 ] then
						cnum = cnum + 1
					end
				end
			end
		end

		if cnum >= curnum then
			cnum = 0
			curnum = 0 
		end

		if cnum != 0 or curnum != 0 then
			for i = 0, 4 do
				draw.SimpleText( num .. " / " .. tostring( weps[ wep ][ cnum + 1 ][ 2 ] ) .. " KILLS", "LevelBG", 48, ScrH() - 58, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
			end
			draw.SimpleText( num .. " / " .. tostring( weps[ wep ][ cnum + 1 ][ 2 ] ) .. " KILLS", "Level", 48, ScrH() - 58, teamcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
		else
			for i = 0, 4 do
				draw.SimpleText( num .. " KILLS", "LevelBG", 48, ScrH() - 58, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
			end
			draw.SimpleText( num .. " KILLS", "Level", 48, ScrH() - 58, teamcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
		end
		
	end
end )

--//Draws all the flag information - Some legacy code
hook.Add( "HUDPaint", "HUD_Flags", function()
	if GetGlobalBool( "ticketmode" ) == true then

		local offsetx = 30
		local offsety = -31
		
		--//Draws the flags markers that float in 3d space and around your screen
		for flagname, flaginfo in pairs( GAMEMODE.FlagTable ) do
			local col = Color( 255, 255, 255 )
			if flaginfo.control == 1 or flaginfo.count == 0 then
				col = Color( 255, 0, 0 )
			elseif flaginfo.control == 2 or flaginfo.count == 20 then
				col = Color( 0, 0, 255 )
			end

			local pos = ( flaginfo.pos + Vector( 0, 0, 150 ) ):ToScreen()
			local xx = flaginfo.pos
			local dist = xx:Distance( LocalPlayer():GetPos() ) / 39
			if pos.x > ScrW() then	
				pos.x = ScrW() - 40
			end
			if pos.x <= 0 then
				pos.x = 20
			end
			if pos.y > ScrH() then
				pos.y = ScrH() - 20
			end
			if pos.y < 0 then
				pos.y = 20
			end
			
			surface.SetFont( "Flags" )
			surface.SetTextPos( pos.x, pos.y )
			surface.SetTextColor( col )
			if GAMEMODE.CurrentFlag and GAMEMODE.CurrentFlag == flagname and flaginfo.control != LocalPlayer():Team() then
				surface.DrawFadingText( col, flagname )
			else
				surface.DrawText( flagname )
			end		
			surface.SetFont( "DermaDefault" )
			surface.DrawText( " " .. tostring( math.Round( dist ) ) .. "m" )
		end

		--//Draws the flags that sit underneath the round timer and ticket counts
		if LocalPlayer():Alive() then
			local screenCenter = ScrW() / 2
			local flagCount = 0
			local displayOffset = 5
			displayOffset = displayOffset - ( 22 * ( table.Count( GAMEMODE.FlagTable ) / 2 ) )
			for order, flaginfo in pairs( GAMEMODE.FlagTableOrdered ) do
				local flagname = flaginfo
				flaginfo = GAMEMODE.FlagTable[ flagname ]
                if !flaginfo then return end
                
				surface.SetFont( "Flags" )
				local col = Color( 255, 255, 255 )
				if flaginfo.control == 1 or flaginfo.count == 0 then
					col = Color( 255, 0, 0 )
				elseif flaginfo.control == 2 or flaginfo.count == 20 then
					col = Color( 0, 0, 255 )
				end

				--surface.SetDrawColor( col )
				surface.SetTextPos( ( ScrW() / 2 ) + ( 22 * flagCount ) + displayOffset, 33 )

				if GAMEMODE.CurrentFlag and GAMEMODE.CurrentFlag == flagname and flaginfo.control != LocalPlayer():Team() then
					surface.DrawFadingText( col, flagname )
				else
					surface.SetTextColor( col )
					surface.DrawText( flagname )
				end
				
				flagCount = flagCount + 1
			end
		end
	end
end )

local function GetPrintName( wep )
    if wep == nil || wep == NULL then return end
    if weapons.Get(wep) == nil then return "" end 
	if weapons.Get( wep ).PrintName ~= nil then
		return weapons.Get( wep ).PrintName
	elseif weapons.Get( wep ).ClassName ~= nil then
		return weapons.Get( wep ):GetClass()
	else
		return tostring( wep )
	end
end

local killtables = {}
net.Receive( "tdm_deathnotice", function()
	local victim = net.ReadEntity()
	local inf = net.ReadString()
	local attacker = net.ReadEntity()
	local hs = tobool( net.ReadString() )
	
	if attacker and victim and IsValid( attacker ) and IsValid( victim ) and attacker ~= NULL and victim ~= NULL then
		local aname = attacker:Nick()
		local ateam = attacker:Team()
		local vname = victim:Nick()
		local vteam = victim:Team()
		--local wepname = weapons.Get( attacker:GetActiveWeapon():GetClass() ).PrintName
		local wepname = GetPrintName( inf )

		if not table.HasValue( killtables, wepname ) then
			killicon.AddFont( wepname, "Killfeed", "[ " .. wepname .." ]", Color( 255, 255, 255, 255 ) )
			killicon.AddFont( wepname .. "-hs", "Killfeed", "[ " .. wepname .." - HEAD ]", Color( 255, 255, 255, 255 ) )
		end
		if hs then
			if aname == LocalPlayer():Nick() then
				GAMEMODE:AddDeathNotice( aname, 3, wepname .. "-hs", vname, vteam )
			else
				GAMEMODE:AddDeathNotice( aname, ateam, wepname .. "-hs", vname, vteam )
			end
		else
			if aname == LocalPlayer():Nick() then
				GAMEMODE:AddDeathNotice( aname, 3, wepname, vname, vteam )
			else
				GAMEMODE:AddDeathNotice( aname, ateam, wepname, vname, vteam )
			end
		end
	end
end )

net.Receive( "tdm_killcountnotice", function()
	local attacker = net.ReadEntity()
	local killcount = tonumber( net.ReadString() )
	
	if attacker and IsValid( attacker ) and attacker ~= NULL then
		local aname = attacker:Nick()
		local ateam = attacker:Team()
		
		local kcname = "\"something\" KILL"
		if killcount == 2 then
			kcname = "DOUBLE KILL"
		elseif killcount == 3 then
			kcname = "MULTI KILL"
		elseif killcount == 4 then
			kcname = "MEGA KILL"
		elseif killcount == 5 then
			kcname = "ULTRA KILL"
		elseif killcount >= 6 then
			kcname = "UNREAL"
		end
		
		if not table.HasValue( killtables, kcname ) then
			killicon.AddFont( kcname, "KillStreak", "[ " .. kcname .. " ]", Color( 255, 64, 64, 255 ) )
			draw.DrawText( kcname, "default", ScrW() * 0.5, ScrH() * 0.25, Color( 255, 0, 0, 255), TEXT_ALIGN_CENTER)
		end
		
		if aname == LocalPlayer():Nick() then
			GAMEMODE:AddDeathNotice( aname, 3, kcname, "", 0 )
		else
			GAMEMODE:AddDeathNotice( aname, ateam, kcname, "", 0 )
		end
	end
end )

net.Receive( "StartSpawnOverlay", function()
	GAMEMODE.ShouldDrawProtection = true
end )

net.Receive( "StopSpawnOverlay", function()
	GAMEMODE.ShouldDrawProtection = false
end )

net.Receive( "IceScreen", function()
	GAMEMODE.ShouldDrawIce = true
end )

net.Receive( "EndIceScreen", function()
	GAMEMODE.ShouldDrawIce = false
end )

net.Receive( "Lifeline", function()
	GAMEMODE.ShouldDrawLifeline = true
end )

net.Receive( "EndLifeline", function()
	GAMEMODE.ShouldDrawLifeline = false
end )

net.Receive( "BleedOverlay", function()
    GAMEMODE.ShouldDrawBleedout = true
end )

net.Receive( "EndBleedOverlay", function()
    GAMEMODE.ShouldDrawBleedout = false
end )

--Grenade indicator
surface.CreateFont( "nade", { font = "Arial", size = 30, weight = 4000 } )
local function nade()
	if not LocalPlayer() then LocalPlayer = LocalPlayer end
	local dist = 800
	if LocalPlayer():Team() ~= 0 then
		for k, v in pairs( ents.GetAll() ) do
			if( IsValid( v ) and ( not v:IsPlayer() ) ) then
				if( v:GetClass() == "fas2_thrown_m67" or v:GetClass() == "fas2_40mm_frag" or v:GetClass() == "cw_grenade_thrown" ) then
					if( v:GetPos():Distance( LocalPlayer():GetPos() ) < dist ) then
						local Pos = v:GetPos():ToScreen()
						surface.DrawCircle( Pos.x, Pos.y, 16.5, Color( 220, 65, 15, 200 ) )
						
						if( v:GetPos():Distance( LocalPlayer():GetPos() ) < ( dist / 2 ) ) then
							draw.SimpleText( "!", "nade", Pos.x, Pos.y - 15, Color( 220, 65, 15, 200 ), TEXT_ALIGN_CENTER )
						end
					end
				end
			end
		end
	end
end
hook.Add( "HUDPaint", "nade", nade )

hook.Add( "PostPlayerDraw", "hud_icon", function( ply )
	if !IsValid( ply ) then return end
	if ply == LocalPlayer() then return end
	if !ply:Alive() then return end
	if GetConVarNumber( "tdm_ffa" ) == 1 then return end
	if not LocalPlayer():Alive() or LocalPlayer():Team() == 0 then return end
	if ply:Team() == LocalPlayer():Team() then
		local offset = Vector( 0, 0, 80 )
		local ang = LocalPlayer():EyeAngles()
		local pos = ply:GetPos() + offset + ang:Up()
	 
		ang:RotateAroundAxis( ang:Forward(), 90 )
		ang:RotateAroundAxis( ang:Right(), 90 )

		cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.25 )
			draw.DrawText( ply:GetName(), "Exo 2 Content Blur", 0 + 1, -6 + 1, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER )
			draw.DrawText( ply:GetName(), "Exo 2 Content", 0, -6, team.GetColor( ply:Team() ), TEXT_ALIGN_CENTER )
			surface.SetDrawColor( Color( 0, 0, 0 ) )
			surface.DrawRect( -48, 20, 96, 6 )
			surface.SetTexture( gradient )
			surface.SetDrawColor( team.GetColor( ply:Team() ) )
			surface.DrawOutlinedRect( -50, 18, 100, 10 )
			surface.DrawRect( -48, 20, 96 * ( math.Clamp( ply:Health(), 0, 100 ) / 100 ), 6 )
			surface.SetDrawColor( Color( 0, 0, 0 ) )
			surface.DrawTexturedRectRotated( -( 48 - 96 * ( math.Clamp( ply:Health(), 0, 100 ) / 100 ) / 2 ), 24, 3, 96 * ( math.Clamp( ply:Health(), 0, 100 ) / 100 ), 270 )
			surface.DrawTexturedRectRotated( -( 48 - 96 * ( math.Clamp( ply:Health(), 0, 100 ) / 100 ) / 2 ), 21, 3, 96 * ( math.Clamp( ply:Health(), 0, 100 ) / 100 ), 90 )
		cam.End3D2D()
	end
end )

hook.Add( "PreDrawHalos", "AddHalos", function()
	if GetConVarNumber( "tdm_ffa" ) == 1 then
		return
	end
	if GetConVarNumber( "hud_halo" ) == 0 then
		return
	end
	local halo_ply = {}
	local halo_ply_team1 = {}
	local halo_ply_team2 = {}
	for k, v in pairs( player.GetAll() ) do
		if LocalPlayer():Team() ~= 0 then
			if ( v:IsPlayer() and v:IsValid() and v:Alive() and v ~= LocalPlayer() and v:Team() == LocalPlayer():Team() ) then
				table.insert( halo_ply, v )
			end
		else
			if ( v:IsPlayer() and v:IsValid() and v:Alive() and v ~= LocalPlayer() and v:Team() == 1 ) then
				table.insert( halo_ply_team1, v )
			elseif ( v:IsPlayer() and v:IsValid() and v:Alive() and v ~= LocalPlayer() and v:Team() == 2 ) then
				table.insert( halo_ply_team2, v )
			end
		end
	end
	if LocalPlayer():Team() ~= 0 then
		halo.Add( halo_ply, team.GetColor( LocalPlayer():Team() ), 1, 1, 1 )
	else
		halo.Add( halo_ply_team1, team.GetColor( 1 ), 1, 1, 1, true, true )
		halo.Add( halo_ply_team2, team.GetColor( 2 ), 1, 1, 1, true, true )
	end
end )

usermessage.Hook( "enemyflagcaptured", function( um )
	surface.PlaySound( "ui/hud_ctf_enemycapturesflag_xp0_wave.mp3" )

	local flag = um:ReadString()
	local alpha = 1
	local off = false
	hook.Add( "HUDPaint", "efc", function()
		surface.SetFont( "BigNotify" )
		surface.SetTextColor( 0, 0, 0, alpha )
		local str = "FLAG " .. flag .. " LOST"
		local strsize = surface.GetTextSize( str )
		surface.SetTextPos( ScrW() / 2 - ( strsize / 2 ) + 2, 250 + 2 )
		surface.DrawText( str )
		surface.SetTextColor( 255, 255, 255, alpha )
		local str = "FLAG " .. flag .. " LOST"
		local strsize = surface.GetTextSize( str )
		surface.SetTextPos( ScrW() / 2 - ( strsize / 2 ), 250 )	
		surface.DrawText( str )
		if off == false then
			alpha = alpha + 1.5
			if alpha > 255 then 
				alpha = 255
			end
		else
			alpha = alpha - 1.5
		end
		if alpha <= 0 then
			hook.Remove( "HUDPaint", "efc" )
			alpha = 1
		end
	end )
	timer.Simple( 3, function()
		off = true
	end )
end )

usermessage.Hook( "friendlyflagcaptured", function( um )
	surface.PlaySound( "ui/hud_ctf_friendlycapturesflag_xp0_wave.mp3" )

	local flag = um:ReadString()
	local alpha = 1
	local off = false
	hook.Add( "HUDPaint", "efc", function()
		surface.SetFont( "BigNotify" )
		surface.SetTextColor( 0, 0, 0, alpha )
		local str = "FLAG " .. flag .. " CAPTURED"
		local strsize = surface.GetTextSize( str )
		surface.SetTextPos( ScrW() / 2 - ( strsize / 2 ) + 2, 250 + 2 )
		surface.DrawText( str )
		surface.SetTextColor( 255, 255, 255, alpha )
		local str = "FLAG " .. flag .. " CAPTURED"
		local strsize = surface.GetTextSize( str )
		surface.SetTextPos( ScrW() / 2 - ( strsize / 2 ), 250 )	
		surface.DrawText( str )
		if off == false then
			alpha = alpha + 1.5
			if alpha > 255 then 
				alpha = 255
			end
		else
			alpha = alpha - 1.5
		end
		if alpha <= 0 then
			hook.Remove( "HUDPaint", "efc" )
			alpha = 1
		end
	end )
	timer.Simple( 3, function()
		off = true
	end )
end )

function PostProcess()
	if GetConVarNumber( "hud_fade" ) == 0 then
		return
	end
	if not LocalPlayer() then LocalPlayer = LocalPlayer end
	local num = 1

	if LocalPlayer():Alive() and LocalPlayer():Team() ~= 0 then
		if LocalPlayer():Health() <= 50 then
			local x = LocalPlayer():Health()
			num = 0.02 * x - .03
		else
			num = 1
		end
	elseif not LocalPlayer():Alive() and LocalPlayer():Team() ~= 0 then
		num = 0.02 * 1 - 0.03
	end

    local tab = {}
	tab[ "$pp_colour_addr" ] = 0
	tab[ "$pp_colour_addg" ] = 0
	tab[ "$pp_colour_addb" ] = 0
	tab[ "$pp_colour_brightness" ] = 0
	tab[ "$pp_colour_contrast" ] = 1
	tab[ "$pp_colour_colour" ] = num
	tab[ "$pp_colour_mulr" ] = 0
	tab[ "$pp_colour_mulg" ] = 0
    tab[ "$pp_colour_mulb" ] = 0
	
    DrawColorModify( tab )
	if LocalPlayer():Health() <= 20 or ( not LocalPlayer():Alive() and LocalPlayer():Team() ~= 0 ) then
		DrawMotionBlur( 0.4, 0.25, 0.01 )
	end
	
end
hook.Add( "RenderScreenspaceEffects", "PostProcessing", PostProcess )

surface.CreateFont( "wlarge", {
 font = "BF4 Numbers",
 size = 100,
 weight = 0,
 antialias = true
} )

surface.CreateFont( "wsmall", {
 font = "BF4 Numbers",
 size = 60,
 weight = 0,
 antialias = true
} )

local data
hook.Add( "PostDrawOpaqueRenderables", "DrawWeaponHints", function()
	local ent = LocalPlayer():GetEyeTrace().Entity
	if ent then
		if IsValid( ent ) and ent:IsWeapon() and ent:GetPos():Distance( LocalPlayer():GetPos() ) <= 400 then
            local data = data or weapons.Get( ent:GetClass() )
            if not IsValid( data ) then return end
			
			function GetInfo( check, check2 )
				if check then
					return check
				elseif check2 then
					return check2
				else
					return 0
				end
			end
			
			local info = {
				[ 1 ] = GetInfo( data.PrintName, data.ClassName ),
				[ 2 ] = GetInfo( data.Damage, data.Primary.Damage ),
				[ 3 ] = GetInfo( data.HipCone, data.Primary.Spray ),
				[ 4 ] = GetInfo( data.AimCone, data.Primary.Cone ),
				[ 5 ] = GetInfo( data.ReloadTime ),
				[ 6 ] = GetInfo( data.Recoil, data.Primary.KickUp ),
				[ 7 ] = GetInfo( ent.Primary.ClipSize )
			}
			
			local ang = LocalPlayer():EyeAngles()
			local pos = ent:GetPos() + ang:Up()
		 
			ang:RotateAroundAxis( ang:Forward(), 90 )
			ang:RotateAroundAxis( ang:Right(), 90 )

			cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.1 )
				surface.SetDrawColor( Color( 0, 0, 0, 150 ) )
				surface.DrawRect( -250, -70, 500, -390 )
				local tc = {
					x = -250,
					y = -390 - 70
				}
				
				draw.DrawText( info[ 1 ], "wlarge", 0, tc.y - 10, color_white, TEXT_ALIGN_CENTER )
				surface.SetDrawColor( color_white )
				surface.DrawLine( tc.x + 50, tc.y + 97, tc.x + 450, tc.y + 100 )
				
				local col0
				local text0
				if info[ 2 ] >= 40 then
					col0 = Color( 0, 255, 0, 255 )
				elseif info[ 2 ] <= 25 then
					col0 = Color( 255, 0, 0, 255 )
				else
					col0 = Color( 255, 210, 0, 255 )
				end
				
				draw.DrawText( "Damage", "wsmall", tc.x + 20, tc.y + 102, col0, TEXT_ALIGN_LEFT )
				draw.DrawText( info[ 2 ], "wsmall", tc.x + 480, tc.y + 102, col0, TEXT_ALIGN_RIGHT )
				
				local col
				local text
				if info[ 4 ] >= 0.01 then
					col = Color( 255, 0, 0, 255 )
					text = "Poor"
				elseif info[ 4 ] <= 0.001 then
					col = Color( 0, 255, 0, 255 )
					text = "Good"
				else
					col = Color( 255, 210, 0, 255 )
					text = "Average"
				end
				draw.DrawText( "Accuracy", "wsmall", tc.x + 20, tc.y + 154, col, TEXT_ALIGN_LEFT )
				draw.DrawText( text, "wsmall", tc.x + 480, tc.y + 154, col, TEXT_ALIGN_RIGHT )
				
				local col2
				if info[ 5 ] then
					text2 = info[ 5 ] .. "s"
					if info[ 5 ] >= 3 then
						col2 = Color( 255, 0, 0, 255 )
					elseif info[ 5 ] < 2 then
						col2 = Color( 0, 255, 0, 255 )
					else
						col2 = Color( 255, 210, 0, 255 )
					end
				elseif info[ 5 ] == nil then
					col2 = color_white
					text2 = "N/A"
				end
				
				draw.DrawText( "Reload", "wsmall", tc.x + 20, tc.y + 206, col2, TEXT_ALIGN_LEFT )
				draw.DrawText( text2, "wsmall", tc.x + 480, tc.y + 206, col2, TEXT_ALIGN_RIGHT )
				
				local col3
				local text3
				if info[ 6 ] >= 1.5 then
					col3 = Color( 255, 0, 0, 255 )
					text3 = "High"
				elseif info[ 6 ] <= 0.7 then
					col3 = Color( 0, 255, 0, 255 )
					text3 = "Low"
				else
					col3 = Color( 255, 210, 0, 255 )
					text3 = "Average"
				end
				draw.DrawText( "Recoil", "wsmall", tc.x + 20, tc.y + 258, col3, TEXT_ALIGN_LEFT )
				draw.DrawText( text3, "wsmall", tc.x + 480, tc.y + 258, col3, TEXT_ALIGN_RIGHT )
				
				local col4
				if info[ 7 ] > 30 then
					col4 = Color( 0, 255, 0, 255 )
				elseif info[ 7 ] <= 20 then
					col4 = Color( 255, 0, 0, 255 )
				else
					col4 = Color( 255, 210, 0, 255 )
				end
				
				draw.DrawText( "Clip Size", "wsmall", tc.x + 20, tc.y + 310, col4, TEXT_ALIGN_LEFT )
				draw.DrawText( info[ 7 ], "wsmall", tc.x + 480, tc.y + 310, col4, TEXT_ALIGN_RIGHT )
				
			cam.End3D2D()
			
		end
	end
end )

--First person death
 hook.Add( "CalcView", "CalcView:GmodDeathView", function( player, origin, angles, fov )
    if( IsValid(player:GetRagdollEntity()) ) then 
		local CameraPos = player:GetRagdollEntity():GetAttachment( player:GetRagdollEntity():LookupAttachment( "eyes" ) )  
		if CameraPos and CameraPos.Pos and CameraPos.Ang then
			return { origin = CameraPos.Pos, angles = CameraPos.Ang, fov = 90 }
		end
	end
end)