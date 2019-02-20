surface.CreateFont( "ds_name", { 
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
local main
usermessage.Hook( "DeathScreen", function( um )

	local att = um:ReadEntity()
	local hs = um:ReadBool()
	local wep = um:ReadString()
	time = um:ReadShort()
	
	if wep and weapons.Get( wep ) then
		wep = weapons.Get( wep ).PrintName
	end
	
	main = vgui.Create( "DPanel" )
	main:SetSize( 600, 100 )
	main:Center()
	main.Paint = function()
		surface.SetDrawColor( 0, 0, 0, 200 )
		surface.DrawRect( 0, 0, main:GetWide(), main:GetTall() - 30 )
		surface.SetDrawColor( 0, 0, 0, 150 )
		surface.DrawRect( 0, main:GetTall() - 30, main:GetWide(), 30 )
	end
	
	local av = vgui.Create( "AvatarImage", main )
	av:SetPos( 3, 3 )
	av:SetSize( main:GetTall() - 36, main:GetTall() - 36 )
	av:SetPlayer( att, 64 )
	
	local name = vgui.Create( "DLabel", main )
	name:SetPos( 6 + av:GetWide() + 5, ( main:GetTall() - 30 ) / 3 - 20 )
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
	
	local wepn = vgui.Create( "DLabel", main )
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
	
	local spawnin = vgui.Create( "DLabel", main )
	spawnin:SetPos( 6, main:GetTall() - 27 )
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
		main:Remove()
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