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

GM.RespawnTime = 0
net.Receive( "StartDeathScreen", function()
	surface.PlaySound( "ui/ux_deploy_deploytimer_wave.mp3" )

	GAMEMODE.RespawnTime = net.ReadInt( 4 )
	local att = net.ReadEntity() --attacker
	local vic = net.ReadEntity() --victim
	local perk = net.ReadString() --attacker's perk
	local hitgroup = net.ReadString() --where the last bullet landed
	local wep = net.ReadString() --weapon used
	local killstreak = net.ReadString() --Killstreak
	local damagedone = net.ReadString() --Damage you did to attacker their & your life
	local title = net.ReadString()
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
	
	GAMEMODE.DeathMain = vgui.Create( "DFrame" )
	GAMEMODE.DeathMain:SetSize( 775, 125 )
	GAMEMODE.DeathMain:Center()
	GAMEMODE.DeathMain:SetTitle( "" )
	GAMEMODE.DeathMain:ShowCloseButton( false )
    GAMEMODE.DeathMain.Paint = function()
        if not GAMEMODE.DeathMain or not GAMEMODE.DeathMain:IsValid() then return end
		surface.SetDrawColor( 0, 0, 0, 75 )
        surface.DrawRect( 0, 0, GAMEMODE.DeathMain:GetWide(), GAMEMODE.DeathMain:GetTall() - 30 )

		surface.SetDrawColor( 0, 0, 0, 150 )
        surface.DrawRect( 0, GAMEMODE.DeathMain:GetTall() - 30, GAMEMODE.DeathMain:GetWide(), 30 )
        surface.DrawLine( 0, 0, 0, GAMEMODE.DeathMain:GetTall() - 30 )
        surface.DrawLine( 0, 0, GAMEMODE.DeathMain:GetWide(), 0 )
        surface.DrawLine( GAMEMODE.DeathMain:GetWide() - 1, 0, GAMEMODE.DeathMain:GetWide() - 1, GAMEMODE.DeathMain:GetTall() - 30 )
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

	--Draws killer's image
	local AttAvatar = vgui.Create( "AvatarImage", GAMEMODE.DeathMain )
	AttAvatar:SetPos( 3, 3 )
	AttAvatar:SetSize( GAMEMODE.DeathMain:GetTall() - 36, GAMEMODE.DeathMain:GetTall() - 36 )
	AttAvatar:SetPlayer( att, 64 )
	
	--Draws "Killer:"
	local title1 = vgui.Create( "DLabel", GAMEMODE.DeathMain )
	title1:SetPos( AttAvatar:GetWide() + 5, GAMEMODE.DeathMain:GetTall() / 16 )
	title1:SetFont( "ds_spawn" )
	title1:SetTextColor( Color( 255, 255, 255, 200) )
	title1:SetText( "Killer:" )
	title1:SizeToContents()
	
	--Draws killer's name
	local name = vgui.Create( "DLabel", GAMEMODE.DeathMain )
	name:SetPos( title1:GetWide() + AttAvatar:GetWide() + 11, -5 )
	name:SetFont( "ds_name" )
	name:SetTextColor( Color( 255, 255, 255 ) )
	if not att or att == NULL then
		name:SetText( "World" )
	else
		if att and att:IsPlayer() and att:Name() and vic != att then
			--if title == "" then
				name:SetText( att:Name() )
			--[[else
				name:SetText( "[" .. GAMEMODE:GetTitleTable( title ).title .. "] " .. att:Name() )
			end]]
		elseif vic == att then
			name:SetText( "Yourself")
		else
			name:SetText( "World" )
		end
	end
	name:SizeToContents()
	
	--Draws "Perk:"
	local title2 = vgui.Create( "DLabel", GAMEMODE.DeathMain )
	--title2:SetPos( AttAvatar:GetWide() + 5, GAMEMODE.DeathMain:GetTall() / 3 - 3) --Old position
	title2:SetPos( AttAvatar:GetWide() + 5, GAMEMODE.DeathMain:GetTall() / 2 + 5)
	title2:SetFont( "ds_spawn" )
	title2:SetTextColor( Color( 255, 255, 255, 200) )
	title2:SetText( "Perk: " .. perk )
	title2:SizeToContents()
	
	--Draws "Weapon:" 
	local title3 = vgui.Create( "DLabel", GAMEMODE.DeathMain)
	--title3:SetPos( AttAvatar:GetWide() + 5, GAMEMODE.DeathMain:GetTall() / 2 + 5) --Old position
	title3:SetPos( AttAvatar:GetWide() + 5, GAMEMODE.DeathMain:GetTall() / 3 - 3)
	title3:SetFont( "ds_spawn" )
	title3:SetTextColor( Color( 255, 255, 255, 200) )
	title3:SetText( "Weapon: " .. wep )
	title3:SizeToContents() 
	
	--Draw hitgroup information (killed by: bullet to stomach)
	local title4 = vgui.Create( "DLabel", GAMEMODE.DeathMain)
	title4:SetPos( GAMEMODE.DeathMain:GetWide() / 3 * 2 + 10, GAMEMODE.DeathMain:GetTall() / 3 - 3)
	title4:SetFont( "ds_spawn" )
	title4:SetTextColor( Color( 255, 255, 255, 200) )
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
	title4:SetText( "Killed by: " .. reason )
	title4:SizeToContents() 
	
	--Draw killer's killstreak
	local title5 = vgui.Create( "DLabel", GAMEMODE.DeathMain)
	title5:SetPos( GAMEMODE.DeathMain:GetWide() / 3 * 2 + 10, GAMEMODE.DeathMain:GetTall() / 2 + 5)
	title5:SetFont( "ds_spawn" )
	title5:SetTextColor( Color( 255, 255, 255, 200) )
	killstreak = tonumber( killstreak ) or 0
	title5:SetText( "Their killstreak: " .. killstreak )
	title5:SizeToContents() 

	--Damage done
	local done = vgui.Create( "DLabel", GAMEMODE.DeathMain )
	--done:SetPos( GAMEMODE.DeathMain:GetWide() / 3 + 10, GAMEMODE.DeathMain:GetTall() / 3 - 3 ) --Old position
	done:SetPos( GAMEMODE.DeathMain:GetWide() / 3 + 50, GAMEMODE.DeathMain:GetTall() / 2 + 5 )
	done:SetFont( "ds_spawn" )
	done:SetTextColor( Color( 255, 255, 255, 200) )
	done:SetText( "Damage done: " .. math.Truncate( math.Clamp( tonumber( damagedone ), 0, att:GetMaxHealth() ) ) )
	done:SizeToContents()

	--Health remaining
	local left = vgui.Create( "DLabel", GAMEMODE.DeathMain )
	--left:SetPos( GAMEMODE.DeathMain:GetWide() / 3 + 10, GAMEMODE.DeathMain:GetTall() / 2 + 5 ) --Old position
	left:SetPos( GAMEMODE.DeathMain:GetWide() / 3 + 50, GAMEMODE.DeathMain:GetTall() / 3 - 3 )
	left:SetFont( "ds_spawn" )
	left:SetTextColor( Color( 255, 255, 255, 200) )
	left:SetText( "Health remaining: " .. math.Clamp( att:Health(), 0, att:GetMaxHealth() ) )
	left:SizeToContents()
	
	--Bottom bar
	local spawnin = vgui.Create( "DLabel", GAMEMODE.DeathMain )
	spawnin:SetPos( 6, GAMEMODE.DeathMain:GetTall() - 27 )
	spawnin:SetFont( "ds_spawn" )
	spawnin:SetTextColor( Color( 255, 255, 255 ) )
	spawnin:SetText( "" )
	spawnin.Think = function()
		if GAMEMODE.RespawnTime == 0 then
			spawnin:SetText( "Press [space] to spawn" )
		elseif GAMEMODE.RespawnTime > 0 and GAMEMODE.RespawnTime < 6 then
			spawnin:SetText( "Spawning in " .. tostring( GAMEMODE.RespawnTime ) .. "..." )
		else
			spawnin:SetText( "Spawning in 5..." )
		end	
		spawnin:SizeToContents()
	end

	local vendettaNotice = vgui.Create( "DLabel", GAMEMODE.DeathMain )
	vendettaNotice:SetFont( "ds_spawn" )
	vendettaNotice:SetTextColor( Color( 250, 100, 100 ) )
	vendettaNotice:SetText( "" )
	vendettaNotice.Think = function()
		if not (GAMEMODE.DeathMain and GAMEMODE.DeathMain:IsValid()) then return end
		if Vendetta then
			vendettaNotice:SetText( att:Nick() .. " is now your vendetta!")
		end
		vendettaNotice:SizeToContents()
		vendettaNotice:SetPos( GAMEMODE.DeathMain:GetWide() - vendettaNotice:GetWide() - 6, GAMEMODE.DeathMain:GetTall() - 27 )
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