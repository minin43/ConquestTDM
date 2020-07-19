GM.FlagTable = {}
GM.FlagTableOrdered = {} --Doesn't contain flag information - only numerically indexes the table names for loops that need it

net.Start( "DoesMapHaveFlags" )
net.SendToServer()

local offset = Vector( 0, 0, 85 )
hook.Add( "PostDrawOpaqueRenderables", "DrawFlags", function()
	for flagname, flaginfo in pairs( GAMEMODE.FlagTable ) do
		local col = Color( 255, 255, 255 )
		if flaginfo.control == 1 or flaginfo.count == 0 then
			col = Color( 255, 0, 0 )
		elseif flaginfo.control == 2 or flaginfo.count == 20 then
			col = Color( 0, 0, 255 )
		end

		local trace = flaginfo.pos
		local ang = LocalPlayer():EyeAngles()
		local pos = trace + offset + ang:Up()
		
		ang:RotateAroundAxis( ang:Forward(), 90 )
		ang:RotateAroundAxis( ang:Right(), 90 )
		surface.SetDrawColor( col )
		cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.25 )
			surface.DrawLine( 0, -100, 0, 375 )
			surface.DrawLine( 0, -100, 70, 20 )
			surface.DrawLine( 0, 20, 70, 20 )
		cam.End3D2D()
	end
end )

--//Draws the "progress" bar across the bottom
local progress = vgui.Create( "DPanel" )
progress:SetSize( 300, 20 )
local sectionsize = progress:GetWide() / 20
progress.Paint = function()
	if GAMEMODE.CurrentFlag then
		local flaginfo = GAMEMODE.FlagTable[ GAMEMODE.CurrentFlag ]
		if LocalPlayer():Team() == 1 then
			if flaginfo.lastcontrol == 2 and flaginfo.control == 0 and flaginfo.count != 0 then
				if not fade then fade = 1 end
				fade = math.Round( math.Clamp( fade - 0.01, 0, 1 ), 2 )
				surface.SetDrawColor( 50, 50, 50 )
				surface.DrawRect( 0, 0, progress:GetWide(), progress:GetTall() )
				surface.SetDrawColor( 0, 0, 255, 255 * fade )
				surface.DrawRect( 0, 0, progress:GetWide(), progress:GetTall() )
				surface.SetDrawColor( 0, 0, 255, 200 )
				surface.SetTexture( GAMEMODE.GradientTexture )
				surface.DrawTexturedRectRotated( progress:GetWide() - 4, progress:GetTall() / 2, 8, progress:GetTall(), 180 )
			else
				fade = 1
				surface.SetDrawColor( 0, 0, 255 )
				surface.DrawRect( 0, 0, progress:GetWide(), progress:GetTall() )
			end

			surface.SetDrawColor( 255, 0, 0 )
			surface.DrawRect( 0, 0, sectionsize * ( 20 - flaginfo.count ), progress:GetTall() )
		elseif LocalPlayer():Team() == 2 then
			if flaginfo.lastcontrol == 1 and flaginfo.control == 0 and flaginfo.count != 20 then
				if not fade then fade = 1 end
				fade = math.Round( math.Clamp( fade - 0.01, 0, 1 ), 2 )
				surface.SetDrawColor( 50, 50, 50 )
				surface.DrawRect( 0, 0, progress:GetWide(), progress:GetTall() )
				surface.SetDrawColor( 255, 0, 0, 255 * fade )
				surface.DrawRect( 0, 0, progress:GetWide(), progress:GetTall() )
				surface.SetDrawColor( 255, 0, 0 )
				surface.SetTexture( GAMEMODE.GradientTexture )
				surface.DrawTexturedRectRotated( progress:GetWide() - 4, progress:GetTall() / 2, 8, progress:GetTall(), 180 )
			else
				fade = 1
				surface.SetDrawColor( 255, 0, 0 )
				surface.DrawRect( 0, 0, progress:GetWide(), progress:GetTall() )
			end

			surface.SetDrawColor( 0, 0, 255 )
			surface.DrawRect( 0, 0, sectionsize * flaginfo.count, progress:GetTall() )
		end

		if flaginfo.count != 20 and flaginfo.count != 0 then --//A visual representation of the "neutralization" spot
			surface.SetDrawColor( 55, 55, 55 )
			surface.DrawLine( progress:GetWide() / 2 - 1, 0, progress:GetWide() / 2 + 1, progress:GetTall() )
			surface.DrawLine( progress:GetWide() / 2, 0, progress:GetWide() / 2, progress:GetTall() )
			surface.DrawLine( progress:GetWide() / 2 + 1, 0, progress:GetWide() / 2 - 1, progress:GetTall() )
		end

		return true
	end
end
progress:SetVisible( false )
progress:SetPos( ScrW() / 2 - ( progress:GetWide() / 2 ), ScrH() - ( progress:GetTall() * 2 ) )

hook.Add( "HUDPaint", "ProgressBar", function()
	if GAMEMODE.CurrentFlag then
		progress:SetVisible( true )
	else
		progress:SetVisible( false )
	end
end )

hook.Add( "Think", "GetInitialFlagShit", function()
    if not GAMEMODE.FlagTableOrdered then
        RequestInitialFlagInfo()
    end
end )

net.Receive( "UpdateFlagInfo", function()
	local flag = net.ReadString()
	local pos = net.ReadVector()
	local count = net.ReadInt( 6 )
	local control = net.ReadInt( 3 )
    local lastcontrol = net.ReadInt( 3 )

	GAMEMODE.FlagTable[ flag ] = { pos = pos, count = count, control = control, lastcontrol = lastcontrol }

    if progress:IsVisible() and count > 0 and count < 20 then
		surface.PlaySound( "ui/hud_capping_flag_01_wave.mp3" ) --//Standard capture "tick" sound
    end
end )

net.Receive( "IsOnFlag", function()
	local flagname = net.ReadString()

	GAMEMODE.CurrentFlag = flagname
end )

net.Receive( "IsOffFlag", function()
	local flagname = net.ReadString()
	if GAMEMODE.CurrentFlag and flagname == GAMEMODE.CurrentFlag then --//This will be sent every tick
		GAMEMODE.CurrentFlag = nil
	end
end )

net.Receive( "DoesMapHaveFlagsCallback", function()
    net.Start( "RequestInitialFlagStatus" ) --//This is called back as UpdateFlagInfo
    net.SendToServer()

    net.Start( "RequestFlagOrder" )
    net.SendToServer()
end )

net.Receive( "RequestFlagOrderCallback", function()
    GAMEMODE.FlagTableOrdered = {}
    GAMEMODE.FlagTableOrdered = net.ReadTable() --//It's generally recommended you don't send tables, since they're expensive, but since this is infreqent, w/e
end )

net.Receive( "FullFlagReset", function()
    GAMEMODE.FlagTable = {}
end )