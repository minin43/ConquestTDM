surface.CreateFont( "Exo 2 Playercard", {
	font = "Exo 2",
	size = 18,
	weight = 400,
} )

local gradient = surface.GetTextureID( "gui/gradient" )

local main
function OpenPlayercard( p )
	local ply = p
	local nick = ply:Nick()

	if main then
		main:Close()
	end

	local currentTeam = LocalPlayer():Team()
	local TeamColor, FontColor
	if currentTeam == 0 then --fucking scrubs
		TeamColor = Color( 76, 175, 80 )
		FontColor = Color( 255, 255, 255 )
	elseif currentTeam == 1 then --red
		TeamColor = Color( 244, 67, 54 )
		FontColor = Color( 255, 255, 255 )
	elseif currentTeam == 2 then --blue
		TeamColor = Color( 33, 150, 243 )
		FontColor = Color( 255, 255, 255 )
	end

	main = vgui.Create( "DFrame" )
	main:SetSize( 256, 314 )
	main:SetTitle( "" )
	main:SetVisible( true )
	main:SetDraggable( false )
	main:ShowCloseButton( true )
	main:MakePopup()
	main:Center()	
	main.btnMaxim:Hide()
	main.btnMinim:Hide() 
	main.btnClose:Hide()
	
	main.Paint = function()
		Derma_DrawBackgroundBlur( main, CurTime() )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawRect( 0, 0, main:GetWide(), main:GetTall() )
	end

	inside = vgui.Create( "DFrame", main )
	inside:SetSize( main:GetWide(), 684 - 256 )
	inside:SetTitle( "" )
	inside:SetPos( 0, 0 )
	inside.btnMaxim:Hide()
	inside.btnMinim:Hide() 
	inside.btnClose:Hide()
	inside.Paint = function()
		surface.SetDrawColor( TeamColor )
		surface.DrawRect( 0, 0, main:GetWide(), 56 )
		surface.SetFont( "Exo 2" )
		surface.SetTextColor( FontColor )
		surface.SetTextPos( 72, 16 )
		surface.DrawText( nick )
	end

	inside.PaintOver = function()
		surface.SetTexture( gradient )
		surface.SetDrawColor( 0, 0, 0, 164 )
		surface.DrawTexturedRectRotated( main:GetWide() / 2, 56 + 4, 8, main:GetWide(), 270 )
	end

	local avatar = vgui.Create( "AvatarImage", main )
	local fade = 4
	avatar:SetPos( 16, 8 )
	avatar:SetPlayer( ply, 64 )
	avatar:SetSize( 40, 40 )

	avatar.PaintOver = function()
		for i = 0, 8 do
			surface.DrawCircle( 20, 20, i + 19, Color( TeamColor.r, TeamColor.g, TeamColor.b, ( 255 / fade ) * ( i ) ) )
		end
	end

	net.Start( "GetPlayerInfo" )
		net.WriteEntity( ply )
	net.SendToServer()
	net.Receive( "GetPlayerInfoCallback", function()
		local data = net.ReadTable()
		local stats = vgui.Create( "DListView", inside )
		stats:SetPos( 8, 56 + 8 )
		stats:SetSize( inside:GetWide() - 16, inside:GetTall() - 56 - 36 - 16 - 16 )
		stats:SetHeaderHeight( 0 )
		local col1 = stats:AddColumn( "" )
		local col2 = stats:AddColumn( "" )
		local line = {}
		line[ 1 ] = stats:AddLine( "Kills", data.kills or "Unknown" )
		line[ 2 ] = stats:AddLine( "Deaths", data.deaths or "Unknown" )
		line[ 3 ] = stats:AddLine( "K/D Ratio", math.Round( data.kills/data.deaths, 3 ) or "Unknown" )
		line[ 4 ] = stats:AddLine( "Assists", data.assists or "Unknown" )
		line[ 5 ] = stats:AddLine( "Flag Captures", data.flags or "Unknown" )
		line[ 6 ] = stats:AddLine( "Time Played", math.Round( data.time/60, 2 ) .. " Hours" or "Unknown" )
		line[ 7 ] = stats:AddLine( "Money", comma_value( data.money ) or "Unknown" )
		line[ 8 ] = stats:AddLine( "Level", data.level or "Unknown" )
		line[ 9 ] = stats:AddLine( "Longest HS", data.headshot or "Unknown" )
		line[ 10 ]= stats:AddLine( "Country", data.country or "Unknown" )
		line[ 11 ]= stats:AddLine( "OS", data.os or "Unknown" )
		stats.Paint = function() return true end

		local i = 0
		while i < 11 do
			for id, pnl in pairs( line[ i + 1 ].Columns ) do
				pnl:SetFont( "Exo 2 Playercard" )
				pnl:SetSize( 16, 30 )
			end
			i = i + 1
		end
	end )

	local close = vgui.Create( "DButton", main )
	close.Hover = false
	close.Click = false
	close:SetSize( 64, 36 )
	close:SetPos( main:GetWide() - close:GetWide() - 16, main:GetTall() - close:GetTall() - 8 )
	
	function PaintClose()
		if not main then return end
		if close.Hover then
			draw.RoundedBox( 4, 0, 0, close:GetWide(), close:GetTall(), Color( 0, 0, 0, 255 * 0.2 ) )
		end
		if close.Click then
			draw.RoundedBox( 4, 0, 0, close:GetWide(), close:GetTall(), Color( 0, 0, 0, 255 * 0.2 ) )
		end
		draw.SimpleText( "CLOSE", "Exo 2 Button", close:GetWide() / 2, close:GetTall() / 2, TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		return true
	end
	close.Paint = PaintClose

	close.OnCursorEntered = function()
		close.Hover = true
	end
	close.OnCursorExited = function()
		close.Hover = false
	end

	close.OnMousePressed = function()
		LocalPlayer():EmitSound( "buttons/button22.wav" )
		close.Click = true
	end
	close.OnMouseReleased = function()
		close.Click = false
		main:Close()
	end
	
	main.OnClose = function()
		main:Remove()
		if main then
			main = nil
		end
	end
end

net.Receive( "GetCountry", function()
	local country = system.GetCountry()
	local op
	if system.IsWindows() then
		op = "Windows"
	elseif system.IsOSX() then
		op = "OSX"
	elseif system.IsLinux() then
		op = "Linux"
	end
	net.Start( "GetCountryCallback" )
		net.WriteString( country )
		net.WriteString( op )
	net.SendToServer() 
end )