surface.CreateFont( "ds_name", { 
	font = "BF4 Numbers", 
	size = 45, 
	weight = 600, 
	antialias = true 
} )

surface.CreateFont( "ds_name_small", { 
	font = "BF4 Numbers", 
	size = 435, 
	weight = 500, 
	antialias = true 
} )

surface.CreateFont( "ds_wep", { 
	font = "BF4 Numbers", 
	size = 20, 
	weight = 600, 
	antialias = true 
} )

surface.CreateFont( "ds_spawn", { 
	font = "BF4 Numbers", 
	size = 21,
	weight = 100, 
	antialias = true 
} )	

net.Receive( "PreDeathScreen", function()
	local tab = net.ReadTable()

	GAMEMODE.DamageTakenThisLife = {}
	for k, v in pairs( player.GetAll() ) do
		if tab[ id(v:SteamID()) ] then
			GAMEMODE.DamageTakenThisLife[ #GAMEMODE.DamageTakenThisLife + 1 ] = { damage = tab[ id(v:SteamID()) ], plyinfo = v, name = v:Nick() }
		end		
	end
end )

GM.RespawnTime = 0
net.Receive( "StartDeathScreen", function()
	surface.PlaySound( "ui/ux_deploy_deploytimer_wave.mp3" )

	GAMEMODE.RespawnTime = net.ReadInt( 4 )
	local att = net.ReadEntity() --Attacker
	local vic = net.ReadEntity() --Victim
	local perk = net.ReadString() --Attacker's perk
	local hitgroup = net.ReadString() --Where the last bullet landed
	local wep = net.ReadString() --Weapon used
	local title = net.ReadString() --Attacker's title
	local atthp = net.ReadInt( 8 ) --Attacker's remaining health upon killing you
	local killstreak = net.ReadInt( 8 ) --Attacker's Killstreak
	local damagedone = net.ReadInt( 16 ) --Damage you did to attacker
	local wasVendetta = net.ReadBool() --If your killer was vendetta'd against you
	local Vendetta = false --For when your killer becomes your vendetta
	
	if wep and weapons.Get( wep ) then
		wep = weapons.Get( wep ).PrintName
	else
		wep = "unknown"
	end
	if !perk or perk == "[NULL Entity]" then
		perk = "none"
	end
	GAMEMODE.VendettaList = GAMEMODE.VendettaList or { }

	if Tooltips.MovementPerks[ perk ] then
		Tooltips.IncrementTip( "movement" )
	end
	local weptable = RetrieveWeaponTable[ wep ]
	if weptable and weptable.type = "sr" then
		Tooltips.IncrementTip( "sniper" )
	end
	if hitgroup == "internal" then
		Tooltips.IncrementTip( "explosive" )
	end

	GAMEMODE.DeathMain = vgui.Create( "DFrame" )
	GAMEMODE.DeathMain:SetSize( 775, 175 )
	GAMEMODE.DeathMain:Center()
	GAMEMODE.DeathMain:SetTitle( "" )
	GAMEMODE.DeathMain:ShowCloseButton( false )
    GAMEMODE.DeathMain.Paint = function()
        if not GAMEMODE.DeathMain or not GAMEMODE.DeathMain:IsValid() then return end
		surface.SetDrawColor( 0, 0, 0, 75 )
        surface.DrawRect( 0, 0, GAMEMODE.DeathMain:GetWide(), GAMEMODE.DeathMain:GetTall() )

		surface.SetDrawColor( GAMEMODE.TeamColor )
		surface.DrawOutlinedRect( 0, 0, GAMEMODE.DeathMain:GetWide(), GAMEMODE.DeathMain:GetTall() )

		surface.SetDrawColor( 255, 255, 255 )
		surface.DrawLine( 5, 71, GAMEMODE.DeathMain:GetWide() - 5, 71 )
	end
	local attID, vicID = id( att:SteamID() ), id( vic:SteamID() )
	GAMEMODE.DeathMain.Think = function()
		if GAMEMODE.VendettaPlayers[ attID ] == att then
			Vendetta = true
        end
        if LocalPlayer():Alive() then
            GAMEMODE.DeathMain:Close()
        end
	end

	--Killer's Info
	local info = vgui.Create( "DLabel", GAMEMODE.DeathMain )
	info:SetPos( 2, 2 )
	info:SetFont( "ds_spawn" )
	into:SetTextColor( Color(255, 255, 255, 200) )
	info:SetText( "Killer's Info" )
	info:SizeToContents()

	local lineoney = 2 + info:GetTall() + 2
	local linetwoy = lineoney + 5 + 21 + 2 --21 is the size of the font ds_spawn
	
	--Weapon
	local weaponlabel = vgui.Create( "DLabel", GAMEMODE.DeathMain )
	weaponlabel:SetFont( "ds_spawn" )
	weaponlabel:SetTextColor( Color(255, 255, 255, 200) )
	weaponlabel:SetText( "Weapon: " .. wep )
	weaponlabel:SizeToContents()
	weaponlabel:SetPos( 9, lineoney )

	--Perk
	local perklabel = vgui.Create( "DLabel", GAMEMODE.DeathMain )
	perklabel:SetFont( "ds_spawn" )
	perklabel:SetTextColor( Color(255, 255, 255, 200) )
	perklabel:SetText( "Perk: " .. perk )
	perklabel:SizeToContents()
	perklabel:SetPos( GAMEMODE.DeathMain:GetWide() / 2 - (perklabel:GetWide() / 2), lineoney )
	
	--Health
	local healthlabel = vgui.Create( "DLabel", GAMEMODE.DeathMain )
	healthlabel:SetFont( "ds_spawn" )
	healthlabel:SetTextColor( Color(255, 255, 255, 200) )
	healthlabel:SetText( "Remaining HP: " .. atthp )
	healthlabel:SizeToContents()
	healthlabel:SetPos( GAMEMODE.DeathMain:GetWide() - healthlabel:GetWide() - 9, lineoney )

	--Damage
	local damagelabel = vgui.Create( "DLabel", GAMEMODE.DeathMain )
	damagelabel:SetFont( "ds_spawn" )
	damagelabel:SetTextColor( Color(255, 255, 255, 200) )
	damagelabel:SetText( "Damage done: " .. math.Truncate( math.Clamp( tonumber( damagedone ), 0, att:GetMaxHealth() ) ) )
	damagelabel:SizeToContents()
	damagelabel:SetPos( 9, linetwoy )

	--Killstreak
	local killstreaklabel = vgui.Create( "DLabel", GAMEMODE.DeathMain )
	killstreaklabel:SetFont( "ds_spawn" )
	killstreaklabel:SetTextColor( Color(255, 255, 255, 200) )
	killstreak = tonumber( killstreak ) or 0
	killstreaklabel:SetText( "Their killstreak: " .. killstreak )
	killstreaklabel:SizeToContents()
	killstreaklabel:SetPos( GAMEMODE.DeathMain:GetWide() / 2 - (killstreaklabel:GetWide() / 2), linetwoy )

	--Death reason
	local reason
	if hitgroup == "internal" then
		reason = "an explosion"
	elseif hitgroup == "ground" then
		reason = "a large fall"
	elseif wep != "unknown" and hitgroup != "unknown" then
		reason = "a bullet to the " .. hitgroup
	else
		reason = "blunt force trauma"
	end
	local hitgrouplabel = vgui.Create( "DLabel", GAMEMODE.DeathMain )
	hitgrouplabel:SetFont( "ds_spawn" )
	hitgrouplabel:SetTextColor( Color(255, 255, 255, 200) )
	hitgrouplabel:SetText( "Killed by: " .. reason )
	hitgrouplabel:SizeToContents()
	hitgrouplabel:SetPos( GAMEMODE.DeathMain:GetWide() - hitgrouplabel:GetWide() - 9, linetwoy )

	--Damage taken header
	local damagelistheader = vgui.Create( "DLabel", GAMEMODE.DeathMain )
	damagelistheader:SetFont( "ds_spawn" )
	damagelistheader:SetTextColor( Color(255, 255, 255, 200) )
	damagelistheader:SetText( "Damage taken this life:" )
	damagelistheader:SizeToContents()
	damagelistheader:SetPos( 2, linetwoy + 21 + 2 )

	--List of damage received
	local damagelist = vgui.Create( "DScrollPanel", GAMEMODE.DeathMain )
	damagelist:SetSize( self:GetWide() - 4, self:GetTall() - linetwoy - 4 )
    damagelist:SetPos( 2, linetwoy + 21 + 2 + damagelistheader:GetTall() )
    local sBar = damagelist:GetVBar()
    function sBar:Paint( w, h )
        draw.RoundedBox( 4, w / 4, 16, w / 2, h - 32, Color( 66, 66, 66 ) )
        return 
    end
    function sBar.btnGrip:Paint( w, h )
        draw.RoundedBox( 4, w / 4, 0, w / 2, h, GAMEMODE.TeamColor )
    end
    sBar.btnUp.Paint = function() return end
    sBar.btnDown.Paint = function() return end
	for k, v in pairs( GAMEMODE.DamageTakenThisLife ) do
		if !v or !v:IsValid() or v.plyinfo == att then continue end
		local dmg = vgui.Create( "DPanel", damagelist )
		dmg:SetSize( damagelist:GetWide() / 3 - 8, 21 + 2 + 2 + 1 )
		local x = ((k - 1) % 3)
		local y = math.Truncate( (k - 1) / 3, 1 ) --did I get glua's math.truncate right?
		dmg:SetPos( 2 + (dmg:GetWide() * x) + (2 * x), 2 + (dmg:GetTall() * y) + (2 * y) )
		dmg.Paint = function()
			draw.SimpleText( v.damage, "ds_spawn", 24 + 2 + 4, dmg:GetTall() / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end

		local avatar = vgui.Create( "AvatarImage", dmg )
		avatar:SetPos( 1, 1 )
		avatar:SetSize( dmg:GetTall(), dmg:GetTall() )
		avatar:SetPlayer( v.plyinfo, 24 )
		avatar.PaintOver = function()
			surface.SetDrawColor( colorscheme[ v.plyinfo:Team() ].TeamColor )
			surface.DrawOutlinedRect( 1, 1, avatar:GetWide() - 1, avatar:GetTall() - 1 )
		end
	end

	--Top bar, display attacker name & title
	GAMEMODE.DeathTitle = vgui.Create( "DFrame" )
	GAMEMODE.DeathTitle:SetSize( 775, 75 )
	local dmx, dmy = GAMEMODE.DeathMain:GetPos()
	GAMEMODE.DeathTitle:SetPos( dmx, dmy - 4 - GAMEMODE.DeathTitle:GetTall() )
	GAMEMODE.DeathTitle:SetTitle( "" )
	GAMEMODE.DeathTitle:ShowCloseButton( false )
    GAMEMODE.DeathTitle.Paint = function()
		if not GAMEMODE.DeathMain or not GAMEMODE.DeathMain:IsValid() then return end
		surface.SetDrawColor( 0, 0, 0, 75 )
        surface.DrawRect( 0, 0, GAMEMODE.DeathMain:GetWide(), GAMEMODE.DeathMain:GetTall() )

		surface.SetDrawColor( GAMEMODE.TeamColor )
		surface.DrawOutlinedRect( 0, 0, GAMEMODE.DeathMain:GetWide(), GAMEMODE.DeathMain:GetTall() )
	end
	GAMEMODE.DeathTitle.Think = function()
		if !GAMEMODE.DeathMain or !GAMEMODE.DeathMain:IsValid() then
			GAMEMODE.DeathTitle:Close()
		end
	end

	--Killer label
	local killerlabel = vgui.Create( "DLabel", GAMEMODE.DeathTitle )
	killerlabel:SetFont( "ds_spawn" )
	killerlabel:SetTextColor( Color( 255, 255, 255, 200) )
	killerlabel:SetText( "Killer:" )
	killerlabel:SizeToContents()
	killerlabel:SetPos( 50 - killerlabel:GetWide(), 2 )

	--Killer's avatar
	local attavatar = vgui.Create( "AvatarImage", GAMEMODE.DeathTitle )
	attavatar:SetPos( 1, 24 )
	attavatar:SetSize( GAMEMODE.DeathTitle:GetTall(), GAMEMODE.DeathTitle:GetTall() )
	attavatar:SetPlayer( att, 50 )
	--[[attavatar.PaintOver = function()
		surface.SetDrawColor( GAMEMODE.TeamColor )
		surface.DrawLine( 0, 0, GAMEMODE.DeathTitle:GetTall(), 0 )
		surface.DrawLine( 0, 0, 0, GAMEMODE.DeathTitle:GetTall() )
		surface.DrawLine( 0, GAMEMODE.DeathTitle:GetTall(), GAMEMODE.DeathTitle:GetTall(), GAMEMODE.DeathTitle:GetTall() )
	end]]
	
	--Draws killer's name
	local namelabel = vgui.Create( "DLabel", GAMEMODE.DeathTitle )
	namelabel:SetPos( attavatar:GetWide() + 4, 25 )
	namelabel:SetFont( "ds_name" )
	namelabel:SetTextColor( Color( 255, 255, 255 ) )
	if not att or att == NULL then
		namelabel:SetText( "World" )
	else
		if att and att:IsPlayer() and att:Name() and vic != att then
			namelabel:SetText( att:Name() )
		elseif vic == att then
			namelabel:SetText( "Yourself")
		else
			namelabel:SetText( "World" )
		end
	end
	namelabel:SizeToContents()
	
	--Killer's Title
	if title != "" then
		local titleinfo = GAMEMODE:GetTitleTable( title )
		local titlelabel = vgui.Create( "DLabel", GAMEMODE.DeathTitle )
		titlelabel:SetPos( attavatar:GetWide() + 14, 2 )
		titlelabel:SetFont( "ds_spawn" )
		--titlelabel:SetText( "[" .. title .. "]" )
		titlelabel:SetText( titleinfo.title )
		titlelabel:SetTextColor( GAMEMODE.ColorRarities[ titleinfo.rare ] )
	end
	
	--Respawn text bar
	GAMEMODE.DeathSpawn = vgui.Create( "DFrame" )
	GAMEMODE.DeathSpawn:SetSize( 775, 25 )
	local dmx, dmy = GAMEMODE.DeathMain:GetPos()
	GAMEMODE.DeathSpawn:SetPos( dmx, dmy + 4 )
	GAMEMODE.DeathSpawn:SetTitle( "" )
	GAMEMODE.DeathSpawn:ShowCloseButton( false )
    GAMEMODE.DeathSpawn.Paint = function()
		if not GAMEMODE.DeathSpawn or not GAMEMODE.DeathSpawn:IsValid() then return end
		surface.SetDrawColor( 0, 0, 0, 75 )
        surface.DrawRect( 0, 0, GAMEMODE.DeathSpawn:GetWide(), GAMEMODE.DeathSpawn:GetTall() )

		surface.SetDrawColor( GAMEMODE.TeamColor )
		surface.DrawOutlinedRect( 0, 0, GAMEMODE.DeathSpawn:GetWide(), GAMEMODE.DeathSpawn:GetTall() )
	end
	GAMEMODE.DeathSpawn.Think = function()
		if !GAMEMODE.DeathMain or !GAMEMODE.DeathMain:IsValid() then
			GAMEMODE.DeathSpawn:Close()
		end
	end

	--The actual respawn display
	GAMEMODE.RespawnTimeEcho = 0
	GAMEMODE.SpawnText = nil
	local spawntext = vgui.Create( "DPanel", GAMEMODE.DeathSpawn )
	spawntext:SetPos( 0, 0 )
	spawntext:SetSize( GAMEMODE.DeathSpawn:GetSize() )
	spawntext.Paint = function()
		if GAMEMODE.SpawnText then
			GAMEMODE.SpawnText:Draw( 4, spawntext:GetTall() / 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
	end
	spawntext.Think = function()
		if GAMEMODE.RespawnTime != GAMEMODE.RespawnTimeEcho then
			GAMEMODE.RespawnTimeEcho = GAMEMODE.RespawnTime

			if GAMEMODE.RespawnTime == 0 then
				local r, g, b = GAMEMODE.TeamColor.r, GAMEMODE.TeamColor.g, GAMEMODE.TeamColor.b
				GAMEMODE.SpawnText = markup.Parse( "<font=ds_spawn><colour=255,255,255>Press </colour><colour=" .. r .. "," .. g "," .. b .. ">[SPACE]</colour><colour=255,255,255> to respawn.</colour></font>", spawntext:GetWide() * (2/3) )
			else
				GAMEMODE.SpawnText = markup.Parse( "<font=ds_spawn><colour=255,255,255>Respawning in </colour><colour=" .. r .. "," .. g "," .. b .. ">" .. GAMEMODE.RespawnTime .. "</colour><colour=255,255,255>...</colour></font>", spawntext:GetWide() * (2/3) )
			end
		end
	end

	--Vendetta
    local name = att:Nick()
	local vendettaNotice = vgui.Create( "DLabel", GAMEMODE.DeathSpawn )
	vendettaNotice:SetFont( "ds_spawn" )
	vendettaNotice:SetTextColor( Color( 250, 100, 100 ) )
	vendettaNotice:SetText( "" )
	vendettaNotice.Think = function()
		if not (GAMEMODE.DeathSpawn and GAMEMODE.DeathSpawn:IsValid()) then return end
		if Vendetta then
			vendettaNotice:SetText( name .. " is now your vendetta!")
		end
		vendettaNotice:SizeToContents()
		vendettaNotice:SetPos( GAMEMODE.DeathSpawn:GetWide() - vendettaNotice:GetWide() - 6, GAMEMODE.DeathSpawn:GetTall() - 27 )
	end

	--Tip
	if Tooltips.TipQueue and Tooltips.TipQueue[1] then
		GAMEMODE.DeathTip = vgui.Create( "DFrame" )
		GAMEMODE.DeathTip:SetSize( 775, 25 )
		local dmx, dmy = GAMEMODE.DeathMain:GetPos()
		GAMEMODE.DeathTip:SetPos( dmx, dmy + 4 + GAMEMODE.DeathSpawn:GetTall() + 4 )
		GAMEMODE.DeathTip:SetTitle( "" )
		GAMEMODE.DeathTip:ShowCloseButton( false )
		local display = Tooltips.TipQueue[1]
		GAMEMODE.DeathTip.Paint = function( panel, w, h )
			if not GAMEMODE.DeathTip or not GAMEMODE.DeathTip:IsValid() then return end
			surface.SetDrawColor( 0, 0, 0, 75 )
			surface.DrawRect( 0, 0, GAMEMODE.DeathTip:GetWide(), GAMEMODE.DeathTip:GetTall() )

			surface.SetDrawColor( GAMEMODE.TeamColor )
			surface.DrawOutlinedRect( 0, 0, GAMEMODE.DeathTip:GetWide(), GAMEMODE.DeathTip:GetTall() )

			draw.SimpleText( display, "ds_spawn", w / 2, h / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		GAMEMODE.DeathTip.Think = function()
			if !GAMEMODE.DeathMain or !GAMEMODE.DeathMain:IsValid() then
				GAMEMODE.DeathTip:Close()
			end
		end
		table.remove( Tooltips.TipQueue, 1 )
	end
end )

net.Receive( "UpdateDeathScreen", function()
	local t = net.ReadInt( 4 )
	GAMEMODE.RespawnTime = t
	if GAMEMODE.RespawnTime > 0 then
		surface.PlaySound( "ui/ux_deploy_deploytimer_wave.mp3" )
	elseif GAMEMODE.RespawnTime == 0 then
		surface.PlaySound( "ui/UX_Deploy_DeployReady_Wave.mp3" )
	end
end )

net.Receive( "CloseDeathScreen", function()
    if GAMEMODE.DeathMain and GAMEMODE.DeathMain:IsValid() then
        GAMEMODE.DeathMain:Close()
    end
end )