--[[surface.CreateFont( "ds_name", { 
	font = "BF4 Numbers", 
	size = 45, 
	weight = 600, 
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
usermessage.Hook( "DeathScreen", function( um )

	local att = um:ReadEntity()
	local hs = um:ReadBool()
	local wep = um:ReadString()
	time = um:ReadShort()
	
	if wep and weapons.Get( wep ) then
		wep = weapons.Get( wep ).PrintName
	end
	
	Main = vgui.Create( "DPanel" )
	Main:SetSize( 600, 100 )
	Main:Center()
	Main.Paint = function()
		surface.SetDrawColor( 0, 0, 0, 200 )
		surface.DrawRect( 0, 0, Main:GetWide(), Main:GetTall() - 30 )
		surface.SetDrawColor( 0, 0, 0, 150 )
		surface.DrawRect( 0, Main:GetTall() - 30, Main:GetWide(), 30 )
	end
	
	local AttAvatar = vgui.Create( "AvatarImage", Main )
	AttAvatar:SetPos( 3, 3 )
	AttAvatar:SetSize( Main:GetTall() - 36, Main:GetTall() - 36 )
	AttAvatar:SetPlayer( att, 64 )
	
	local name = vgui.Create( "DLabel", Main )
	name:SetPos( 6 + AttAvatar:GetWide() + 5, ( Main:GetTall() - 30 ) / 3 - 20 )
	name:SetFont( "ds_name" )
	name:SetTextColor( Color( 255, 255, 255 ) )
	if not att or att == NULL then
		name:SetText( "World" )
	else
		if att and att:IsPlayer() and att:Name() then
			name:SetText( att:Name() )
		else
			name:SetText( "World" )
		end
	end
	name:SizeToContents()
	
	local wepn = vgui.Create( "DLabel", Main )
	wepn:SetPos( 6 + AttAvatar:GetWide() + 5, ( Main:GetTall() - 30 ) / 3 + ( Main:GetTall() - 30 ) / 3 )
	wepn:SetFont( "ds_wep" )
	wepn:SetTextColor( Color( 255, 255, 255, 200 ) )
	if not att or att == NULL then
		wepn:SetText( "The world has killed you!" )
	else
		if LocalPlayer() == att then
			wepn:SetText( "You commited suicide!" )
		else
			if att and att:IsPlayer() then
				if hs then
					wepn:SetText( "Killed you with their " .. wep .. " [headshot]" )
				else
					wepn:SetText( "Killed you with their " .. wep )
				end
			else
				wepn:SetText( "U have no skillz m8" )
			end
		end
	end
	wepn:SizeToContents()
	
	local spawnin = vgui.Create( "DLabel", Main )
	spawnin:SetPos( 6, Main:GetTall() - 27 )
	spawnin:SetFont( "ds_spawn" )
	spawnin:SetTextColor( Color( 255, 255, 255 ) )
	spawnin:SetText( "" )
	spawnin.Think = function()
		if time > 0 then
			spawnin:SetText( "Spawning in " .. tostring( time ) )
		else
			spawnin:SetText( "Press [space] to spawn" )
		end	
		spawnin:SizeToContents()
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
end )]]

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
	
	if wep and weapons.Get( wep ) then
		wep = weapons.Get( wep ).PrintName
	else
		wep = "unknown"
	end
	
	Main = vgui.Create( "DFrame" )
	Main:SetSize( 600, 125 )
	Main:Center()
	Main:SetTitle( "" )
	Main:ShowCloseButton( false )
	Main.Paint = function()
		surface.SetDrawColor( 0, 0, 0, 75 )
		surface.DrawRect( 0, 0, Main:GetWide(), Main:GetTall() - 30 )
		surface.SetDrawColor( 0, 0, 0, 150 )
		surface.DrawRect( 0, Main:GetTall() - 30, Main:GetWide(), 30 )
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
	title2:SetPos( AttAvatar:GetWide() + 5, Main:GetTall() / 3 - 3)
	title2:SetFont( "ds_spawn" )
	title2:SetTextColor( Color( 255, 255, 255, 200) )
	title2:SetText( "Perk:" )
	title2:SizeToContents() 
	
	--Draws killer's perk name
	local kperk = vgui.Create( "DLabel", Main )
	kperk:SetPos( title2:GetWide() + AttAvatar:GetWide() + 11, Main:GetTall() / 3 - 3)
	kperk:SetFont( "ds_spawn" )
	kperk:SetTextColor( Color( 255, 255, 255, 200) )
	kperk:SetText( perk )
	kperk:SizeToContents() 
	--print( "Perk: ", perk )
	
	--Draws "Weapon:" 
	local title3 = vgui.Create( "DLabel", Main)
	title3:SetPos( AttAvatar:GetWide() + 5, Main:GetTall() / 2 + 5)
	title3:SetFont( "ds_spawn" )
	title3:SetTextColor( Color( 255, 255, 255, 200) )
	title3:SetText( "Weapon:" )
	title3:SizeToContents() 
	
	--Draws killer's weapon name
	local weapon = vgui.Create( "DLabel", Main )
	weapon:SetPos( title3:GetWide() + AttAvatar:GetWide() + 11, Main:GetTall() / 2 + 5)
	weapon:SetFont( "ds_spawn" )
	weapon:SetTextColor( Color( 255, 255, 255, 200) )
	weapon:SetText( wep )
	weapon:SizeToContents()
	
	--Draw hitgroup information (killed by: bullet to stomach)
	local title4 = vgui.Create( "DLabel", Main)
	title4:SetPos( Main:GetWide() / 2, Main:GetTall() / 3 - 3)
	title4:SetFont( "ds_spawn" )
	title4:SetTextColor( Color( 255, 255, 255, 200) )
	local reason
	if wep != "unknown" and wep != NULL and wep != NIL and hitgroup != "unknown" then
		reason = "a bullet to the " .. hitgroup
	else
		reason = "blunt force trauma"
	end
	title4:SetText( "Killed by: " .. reason )
	title4:SizeToContents() 
	
	--Draw killer's killstreak
	local title5 = vgui.Create( "DLabel", Main)
	title5:SetPos( Main:GetWide() / 2, Main:GetTall() / 2 + 5)
	title5:SetFont( "ds_spawn" )
	title5:SetTextColor( Color( 255, 255, 255, 200) )
	local killstreak = att.killsThisLife
	if att.killsThisLife == nil then killstreak = 0 end
	title5:SetText( "Their killstreak: " .. killstreak )
	title5:SizeToContents() 
	
	--Beta
	local beta = vgui.Create( "DLabel", Main)
	beta:SetPos( Main:GetWide() - 50, 2 )
	beta:SetFont( "ds_spawn" )
	beta:SetTextColor( Color( 255, 255, 255, 100) )
	beta:SetText( "BETA" )
	beta:SizeToContents() 
	
	--[[local wepn = vgui.Create( "DLabel", Main )
	wepn:SetPos( 6 + AttAvatar:GetWide() + 5, ( Main:GetTall() - 30 ) / 3 + ( Main:GetTall() - 30 ) / 3 )
	wepn:SetFont( "ds_wep" )
	wepn:SetTextColor( Color( 255, 255, 255, 200 ) )
	if not att or att == NULL then
		wepn:SetText( "The world has killed you!" )
	else
		if LocalPlayer() == att then
			wepn:SetText( "You commited suicide!" )
		else
			if att and att:IsPlayer() then
					wepn:SetText( "Killed you with their " .. wep )
			else
				wepn:SetText( "U have no skillz m8" )
			end
		end
	end
	wepn:SizeToContents()]]
	
	local spawnin = vgui.Create( "DLabel", Main )
	spawnin:SetPos( 6, Main:GetTall() - 27 )
	spawnin:SetFont( "ds_spawn" )
	spawnin:SetTextColor( Color( 255, 255, 255 ) )
	spawnin:SetText( "" )
	spawnin.Think = function()
		if time > 0 then
			spawnin:SetText( "Spawning in " .. tostring( time ) )
		else
			spawnin:SetText( "Press [space] to spawn" )
		end	
		spawnin:SizeToContents()
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