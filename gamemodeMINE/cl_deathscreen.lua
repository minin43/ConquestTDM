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
	size = 80,
	weight = 100, 
	antialias = true 
} )	

local time
local main
local grow
local showtext
usermessage.Hook( "DeathScreen", function( um )
	grow = ( ScrH() / 3 )
	showtext = 0
	--surface.PlaySound( "ui/UX_Deploy_DeployTImer_Wave.mp3" )
	surface.PlaySound( "gunshot.ogg" )

	--[[Att = attacker, vic = victim, perk = attacker's perk if attacker isn't the victim (suicide), hitgroup = where the last bullet landed, 
		wep = weapon used to kill victim, time = seconds left to spawn]]
	time = um:ReadShort()
	local att = um:ReadEntity()
	local vic = um:ReadEntity()
	local perk = um:ReadString()
	local hitgroup = um:ReadString()
	local wep = um:ReadString()
	
	if wep and weapons.Get( wep ) then
		wep = weapons.Get( wep ).PrintName
	else
		wep = "unknown"
	end
	
	--local cover = math.Approach( 0, 255, 5 )
	--surface.SetDrawColor( 0, 0, 0, cover )
	--surface.DrawRect( 0, 0, ScrW(), ScrH() )
	main = vgui.Create( "DPanel" )
	main:SetSize( ScrW(), ScrH() )
	--main:Center()
	main.Paint = function()
		--Draws black background boxes
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( 0, 0, main:GetWide(), grow )
		--surface.SetDrawColor( 0, 0, 0, 150 )
		--surface.DrawRect( 0, main:GetTall() - 30, main:GetWide(), 30 )
	end
	
	--Draws killer's image
	--[[local av = vgui.Create( "AvatarImage", main )
	av:SetPos( 3, 3 )
	av:SetSize( main:GetTall() - 36, main:GetTall() - 36 )
	av:SetPlayer( att, 64 )
	
	--Draws "Killer:"
	local title1 = vgui.Create( "DLabel", main )
	title1:SetPos( av:GetWide() + 5, main:GetTall() / 16 )
	title1:SetFont( "ds_spawn" )
	title1:SetTextColor( Color( 255, 255, 255, 200) )
	title1:SetText( "Killer:" )
	title1:SizeToContents()
	
	--Draws killer's name
	local name = vgui.Create( "DLabel", main )
	name:SetPos( title1:GetWide() + av:GetWide() + 11, -5 )
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
	local title2 = vgui.Create( "DLabel", main )
	title2:SetPos( av:GetWide() + 5, main:GetTall() / 3 - 3)
	title2:SetFont( "ds_spawn" )
	title2:SetTextColor( Color( 255, 255, 255, 200) )
	title2:SetText( "Perk:" )
	title2:SizeToContents() 
	
	--Draws killer's perk name
	local kperk = vgui.Create( "DLabel", main )
	kperk:SetPos( title2:GetWide() + av:GetWide() + 11, main:GetTall() / 3 - 3)
	kperk:SetFont( "ds_spawn" )
	kperk:SetTextColor( Color( 255, 255, 255, 200) )
	kperk:SetText( perk )
	kperk:SizeToContents() 
	--print( "Perk: ", perk )
	
	--Draws "Weapon:" 
	local title3 = vgui.Create( "DLabel", main)
	title3:SetPos( av:GetWide() + 5, main:GetTall() / 2 + 5)
	title3:SetFont( "ds_spawn" )
	title3:SetTextColor( Color( 255, 255, 255, 200) )
	title3:SetText( "Weapon:" )
	title3:SizeToContents() 
	
	--Draws killer's weapon name
	local weapon = vgui.Create( "DLabel", main )
	weapon:SetPos( title3:GetWide() + av:GetWide() + 11, main:GetTall() / 2 + 5)
	weapon:SetFont( "ds_spawn" )
	weapon:SetTextColor( Color( 255, 255, 255, 200) )
	weapon:SetText( wep )
	weapon:SizeToContents() 
	
	--Draw hitgroup information (killed by: bullet to stomach)
	local title4 = vgui.Create( "DLabel", main)
	title4:SetPos( main:GetWide() / 2, main:GetTall() / 3 - 3)
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
	local title5 = vgui.Create( "DLabel", main)
	title5:SetPos( main:GetWide() / 2, main:GetTall() / 2 + 5)
	title5:SetFont( "ds_spawn" )
	title5:SetTextColor( Color( 255, 255, 255, 200) )
	local killstreak = att.killsThisLife
	if att.killsThisLife == nil then killstreak = 0 end
	title5:SetText( "Their killstreak: " .. killstreak )
	title5:SizeToContents() 
	
	--Beta
	local beta = vgui.Create( "DLabel", main)
	beta:SetPos( main:GetWide() - 50, 2 )
	beta:SetFont( "ds_spawn" )
	beta:SetTextColor( Color( 255, 255, 255, 100) )
	beta:SetText( "BETA" )
	beta:SizeToContents() 
	
	--[[local wepn = vgui.Create( "DLabel", main )
	wepn:SetPos( 6 + av:GetWide() + 5, ( main:GetTall() - 30 ) / 3 + ( main:GetTall() - 30 ) / 3 )
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
	
	local spawnin = vgui.Create( "DLabel", main )
	spawnin:SetPos( ScrW() / 3.25, ScrH() / 3 )
	spawnin:SetFont( "ds_spawn" )
	spawnin:SetTextColor( Color( 255, 255, 255 ) )
	spawnin:SetText( "Spawning in 5 seconds" )
	spawnin.Think = function()
		if showtext != 3 then
			spawnin:SetText( "" )
		else
			spawnin:SetText( "Press [SPACE] to respawn" )
		end	
		spawnin:SizeToContents()
	end
	
	usermessage.Hook( "CloseDeathScreen", function()
		main:Remove()
	end )
end )

usermessage.Hook( "UpdateDeathScreen", function( um )
	grow = grow * 2
	showtext = showtext + 1
	surface.PlaySound( "gunshot.ogg" )
end )