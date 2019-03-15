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

local time
local Main
local grow
local showtext
usermessage.Hook( "DeathScreen", function( um )
	surface.PlaySound( "ui/UX_Deploy_DeployTImer_Wave.mp3" )

	time = um:ReadShort()
	local att = um:ReadEntity() --attacker
	local vic = um:ReadEntity() --victim
	local perk = um:ReadString() --attacker's perk
	local hitgroup = um:ReadString() --where the last bullet landed
	local wep = um:ReadString() --weapon used
	local killstreak = um:ReadString() --Killstreak
	local damagedone = um:ReadString() --Damage you did to attacker their & your life
	local Vendetta = false
	
	if wep and weapons.Get( wep ) then
		wep = weapons.Get( wep ).PrintName
	else
		wep = "unknown"
	end

	if !perk or perk == "[NULL Entity]" then
		perk = "none"
	end

	GAMEMODE.VendettaList = GAMEMODE.VendettaList or { }
	
	Main = vgui.Create( "DFrame" )
	Main:SetSize( 700, 125 )
	Main:Center()
	Main:SetTitle( "" )
	Main:ShowCloseButton( false )
	Main.Paint = function()
		surface.SetDrawColor( 0, 0, 0, 75 )
		surface.DrawRect( 0, 0, Main:GetWide(), Main:GetTall() - 30 )
		surface.SetDrawColor( 0, 0, 0, 150 )
		surface.DrawRect( 0, Main:GetTall() - 30, Main:GetWide(), 30 )
	end
	local attID, vicID = id( att:SteamID() ), id( vic:SteamID() )
	Main.Think = function()
		if GAMEMODE.VendettaPlayers[ attID ] == att then
			Vendetta = true
		end
	end

	--Draws killer's image
	local AttAvatar = vgui.Create( "AvatarImage", Main )
	AttAvatar:SetPos( 3, 3 )
	AttAvatar:SetSize( Main:GetTall() - 36, Main:GetTall() - 36 )
	AttAvatar:SetPlayer( att, 64 )
	
	--Draws "Killer:"
	local title1 = vgui.Create( "DLabel", Main )
	title1:SetPos( AttAvatar:GetWide() + 5, Main:GetTall() / 16 )
	title1:SetFont( "ds_spawn" )
	title1:SetTextColor( Color( 255, 255, 255, 200) )
	title1:SetText( "Killer:" )
	title1:SizeToContents()
	
	--Draws killer's name
	local name = vgui.Create( "DLabel", Main )
	name:SetPos( title1:GetWide() + AttAvatar:GetWide() + 11, -5 )
	name:SetFont( "ds_name" )
	name:SetTextColor( Color( 255, 255, 255 ) )
	if not att or att == NULL then
		name:SetText( "World" )
	else
		if att and att:IsPlayer() and att:Name() and vic != att then
			name:SetText( att:Name() )
		elseif vic == att then
			name:SetText( "Yourself")
		else
			name:SetText( "World" )
		end
	end
	name:SizeToContents()
	
	--Draws "Perk:"
	local title2 = vgui.Create( "DLabel", Main )
	--title2:SetPos( AttAvatar:GetWide() + 5, Main:GetTall() / 3 - 3) --Old position
	title2:SetPos( AttAvatar:GetWide() + 5, Main:GetTall() / 2 + 5)
	title2:SetFont( "ds_spawn" )
	title2:SetTextColor( Color( 255, 255, 255, 200) )
	title2:SetText( "Perk: " .. perk )
	title2:SizeToContents()
	
	--Draws "Weapon:" 
	local title3 = vgui.Create( "DLabel", Main)
	--title3:SetPos( AttAvatar:GetWide() + 5, Main:GetTall() / 2 + 5) --Old position
	title3:SetPos( AttAvatar:GetWide() + 5, Main:GetTall() / 3 - 3)
	title3:SetFont( "ds_spawn" )
	title3:SetTextColor( Color( 255, 255, 255, 200) )
	title3:SetText( "Weapon: " .. wep )
	title3:SizeToContents() 
	
	--Draw hitgroup information (killed by: bullet to stomach)
	local title4 = vgui.Create( "DLabel", Main)
	title4:SetPos( Main:GetWide() / 3 * 2, Main:GetTall() / 3 - 3)
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
	local title5 = vgui.Create( "DLabel", Main)
	title5:SetPos( Main:GetWide() / 3 * 2, Main:GetTall() / 2 + 5)
	title5:SetFont( "ds_spawn" )
	title5:SetTextColor( Color( 255, 255, 255, 200) )
	killstreak = tonumber( killstreak ) or 0
	title5:SetText( "Their killstreak: " .. killstreak )
	title5:SizeToContents() 

	--Damage done
	local done = vgui.Create( "DLabel", Main )
	--done:SetPos( Main:GetWide() / 3 + 10, Main:GetTall() / 3 - 3 ) --Old position
	done:SetPos( Main:GetWide() / 3 + 30, Main:GetTall() / 2 + 5 )
	done:SetFont( "ds_spawn" )
	done:SetTextColor( Color( 255, 255, 255, 200) )
	done:SetText( "Damage done: " .. math.Clamp( math.Truncate( damagedone ), 0, att:GetMaxHealth() ) )
	done:SizeToContents()

	--Health remaining
	local left = vgui.Create( "DLabel", Main )
	--left:SetPos( Main:GetWide() / 3 + 10, Main:GetTall() / 2 + 5 ) --Old position
	left:SetPos( Main:GetWide() / 3 + 30, Main:GetTall() / 3 - 3 )
	left:SetFont( "ds_spawn" )
	left:SetTextColor( Color( 255, 255, 255, 200) )
	left:SetText( "Health remaining: " .. math.Clamp( att:Health(), 0, att:GetMaxHealth() ) )
	left:SizeToContents()
	
	--Bottom bar
	local spawnin = vgui.Create( "DLabel", Main )
	spawnin:SetPos( 6, Main:GetTall() - 27 )
	spawnin:SetFont( "ds_spawn" )
	spawnin:SetTextColor( Color( 255, 255, 255 ) )
	spawnin:SetText( "" )
	spawnin.Think = function()
		if time == 0 then
			spawnin:SetText( "Press [space] to spawn" )
		elseif time > 0 and time < 6 then
			spawnin:SetText( "Spawning in " .. tostring( time ) .. "..." )
		else
			spawnin:SetText( "Spawning in 5..." )
		end	
		spawnin:SizeToContents()
	end

	local vendettaNotice = vgui.Create( "DLabel", Main )
	vendettaNotice:SetFont( "ds_spawn" )
	vendettaNotice:SetTextColor( Color( 250, 100, 100 ) )
	vendettaNotice:SetText( "" )
	vendettaNotice.Think = function()
		if not Main and Main:IsValid() then return end
		if Vendetta then
			vendettaNotice:SetText( att:Nick() .. " is now your vendetta!")
		end
		vendettaNotice:SizeToContents()
		vendettaNotice:SetPos( Main:GetWide() - vendettaNotice:GetWide() - 6, Main:GetTall() - 27 )
	end
	
	usermessage.Hook( "CloseDeathScreen", function()
		Main:Remove()
	end )
end )

usermessage.Hook( "UpdateDeathScreen", function( um )
	local t = um:ReadShort()
	time = t
	if time > 0 then
		surface.PlaySound( "ui/UX_Deploy_DeployTImer_Wave.mp3" )
	elseif time == 0 then
		surface.PlaySound( "ui/UX_Deploy_DeployReady_Wave.mp3" )
	end
end )