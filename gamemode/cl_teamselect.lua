surface.CreateFont( "Exo 2", {
	font = "Exo 2",
	size = 24,
	weight = 400
} )

surface.CreateFont( "Exo 2 Subhead", {
	font = "Exo 2",
	size = 16,
	weight = 400
} )

surface.CreateFont( "Exo 2 Button", {
	font = "Exo 2",
	size = 14,
	weight = 700
} )

--[[GM.Icons = {
	[ "Red Team" ] = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" ),
	[ "Blue Team" ] = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" ),
	Default = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" ),
	Rebels = Material( "vgui/rebelIcon.png", "smooth" ),
	Combine = Material( "vgui/combineIcon.png", "smooth" ),
	Insurgents = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" ),
	Security = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" ),
	Spetsnaz = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" ),
	OpFor = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" ),
	Milita = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" ),
	[ "TF 141" ] = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" ),
	Rangers = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" ),
	Seals = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" )
}]]

GM.TeamIcon = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" )
GM.GradientTexture = surface.GetTextureID( "gui/gradient" )
GM.FirstSelect = true
GM.TeamColor = Color( 76, 175, 80 )

function GM:TeamMenu()
	if ( main and main:IsValid() ) or ( self.main and self.main:IsValid() ) or ( self.TeamMain and self.TeamMain:IsValid() ) then return end
	self.TeamMain = vgui.Create( "DFrame" )
	self.TeamMain:SetSize( 400, 280 )
	self.TeamMain:SetTitle( "" )
	self.TeamMain:SetVisible( true )
	self.TeamMain:SetDraggable( false )
	self.TeamMain:ShowCloseButton( true )
	self.TeamMain:MakePopup()
	self.TeamMain:Center()
	self.TeamMain.Think = function()
		if #team.GetPlayers( 1 ) - #team.GetPlayers( 2 ) >= 1 then
			self.CanJoinRed = false
		else 
			self.CanJoinRed = true
		end
		if #team.GetPlayers( 2 ) - #team.GetPlayers( 1 ) >= 1 then
			self.CanJoinBlue = false
		else
			self.CanJoinBlue = true
		end
	end
	self.TeamMain.Paint = function()
		Derma_DrawBackgroundBlur( self.TeamMain, CurTime() )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawRect( 0, 0, self.TeamMain:GetWide(), self.TeamMain:GetTall() )

		--[[surface.SetTexture( GAMEMODE.GradientTexture )
		surface.SetDrawColor( 0, 0, 0, 164 )
		surface.DrawTexturedRectRotated( self.TeamMain:GetWide() / 2, self.TeamMainTitleSize + 4, 8, self.TeamMain:GetWide(), 270 )]]
	end

	self.TeamMainTitleSize = 56 --To be kept consistent across all menus
	self.TeamMainTitle = vgui.Create( "DPanel", self.TeamMain )
	self.TeamMainTitle:SetPos( 0, 0 )
	self.TeamMainTitle:SetSize( self.TeamMain:GetWide(), self.TeamMainTitleSize )
	self.TeamMainTitle.Paint = function()
		surface.SetDrawColor( GAMEMODE.TeamColor )
		surface.DrawRect( 0, 0, self.TeamMainTitle:GetWide(), self.TeamMainTitle:GetTall() )
		draw.SimpleText( "Choose Team", "Exo 2", self.TeamMainTitle:GetWide() / 4, self.TeamMainTitle:GetTall() / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	self.TeamMainClose = vgui.Create( "DButton", self.TeamMainTitle )
	self.TeamMainClose:SetSize( self.TeamMainTitle:GetWide() / 4, self.TeamMainTitle:GetTall() )
	self.TeamMainClose:SetPos( self.TeamMainTitle:GetWide() / 4 * 3, 0 )
	
	self.TeamMainClose.Paint = function()
		if not self.TeamMain then return end
		if self.TeamMainClose.Hover then
			draw.RoundedBox( 4, 0, 0, self.TeamMainClose:GetWide(), self.TeamMainClose:GetTall(), Color( 0, 0, 0, 255 * 0.2 ) )
		end
		if self.TeamMainClose.Click then
			draw.RoundedBox( 4, 0, 0, self.TeamMainClose:GetWide(), self.TeamMainClose:GetTall(), Color( 0, 0, 0, 255 * 0.2 ) )
		end
		draw.SimpleText( "CLOSE", "Exo 2 Button", self.TeamMainClose:GetWide() / 2, self.TeamMainClose:GetTall() / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		return true
	end

	self.TeamMainClose.OnCursorEntered = function()
		self.TeamMainClose.Hover = true
	end
	self.TeamMainClose.OnCursorExited = function()
		self.TeamMainClose.Hover = false
	end

	self.TeamMainClose.OnMousePressed = function()
		LocalPlayer():EmitSound( "buttons/button22.wav" )
		self.TeamMainClose.Click = true
	end
	self.TeamMainClose.OnMouseReleased = function()
		self.TeamMainClose.Click = false
		self.TeamMain:Close()
	end

	--//Onto the buttons: normally these would be custom vgui elements, however, since there are only 3, I'm taking the lazy route and just using DButton
	self.TeamMainIconSize = 60
	if LocalPlayer():Team() != 1 then --If the player isn't already on red team
		self.TeamMainRed = vgui.Create( "DButton", self.TeamMain )
		self.TeamMainRed:SetPos( 0, self.TeamMainTitleSize )
		self.TeamMainRed:SetSize( self.TeamMain:GetWide(), ( self.TeamMain:GetTall() - self.TeamMainTitleSize ) / 2 )
		self.TeamMainRed:SetText( "" )
		self.TeamMainRed.Paint = function()
			surface.SetDrawColor( 0, 0, 0, 64 )
			surface.DrawLine( self.TeamMainIconSize * 1.5, self.TeamMainRed:GetTall() / 2, self.TeamMainRed:GetWide(), self.TeamMainRed:GetTall() / 2 )
			surface.DrawLine( 8, self.TeamMainRed:GetTall() - 1, self.TeamMainRed:GetWide() - 8, self.TeamMainRed:GetTall() - 1 )

			surface.SetDrawColor( ( GAMEMODE.Icons.Teams[ team.GetName( 1 ) .. "Color" ] ) or Color( 213, 0, 0, 255 ) )
			surface.SetMaterial( GAMEMODE.Icons.Teams[ team.GetName( 1 ) ] )
			surface.DrawTexturedRect( self.TeamMainIconSize / 4, ( self.TeamMainRed:GetTall() / 2 ) - ( self.TeamMainIconSize / 2 ), self.TeamMainIconSize , self.TeamMainIconSize )

			local starttextpos = self.TeamMainIconSize * 1.5 --width of the icon + a buffer
			draw.SimpleText( team.GetName( 1 ), "Exo 2", starttextpos + 14, self.TeamMainRed:GetTall() / 3, Color( 0, 0, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Currently: " .. self.TeamMainRed.NumberPlayers .. " player(s) on this team.", "Exo 2 Subhead", starttextpos + 14, self.TeamMainRed:GetTall() / 3 * 2, Color( 128, 128, 128 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			
			if !self.TeamMainRed.Hover then
				surface.SetTexture( GAMEMODE.GradientTexture )
				surface.SetDrawColor( 0, 0, 0, 164 )
				surface.DrawTexturedRectRotated( self.TeamMainRed:GetWide() / 2, 4, 8, self.TeamMain:GetWide(), 270 )
				surface.DrawTexturedRectRotated( self.TeamMainRed:GetWide() / 2, self.TeamMainRed:GetTall() - 4, 8, self.TeamMain:GetWide(), 90 )
			end
			if not self.CanJoinRed then
				surface.SetDrawColor( Color( 0, 0, 0, 160 ) )
				surface.DrawRect( 0, 0, self.TeamMainRed:GetWide(), self.TeamMainRed:GetTall() )
				draw.SimpleText( "PLAYER DIFFERENCE TOO LARGE", "Exo 2", self.TeamMainRed:GetWide() / 2, self.TeamMainRed:GetTall() / 2, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
		self.TeamMainRed.DoClick = function()
			if self.CanJoinRed then
				--[[RunConsoleCommand( "tdm_setteam", "1" )
				LocalPlayer():EmitSound( "buttons/button22.wav" )
				self.TeamMain:Close()]]

				if LocalPlayer():Team() != 0 then
					LocalPlayer():ConCommand( "kill" )
				end
				LocalPlayer().blue = false
				LocalPlayer().red = true
				self.TeamMain:Close()
				LoadoutMenu()
			end
		end
		self.TeamMainRed.OnCursorEntered = function()
			if self.CanJoinRed then
				self.TeamMainRed.Hover = true
			end
		end
		self.TeamMainRed.OnCursorExited = function()
			self.TeamMainRed.Hover = false
		end
		self.TeamMainRed.Think = function()
			self.TeamMainRed.NumberPlayers = #team.GetPlayers( 1 )
			if not self.CanJoinRed and self.TeamMainRed.Hover then
				self.TeamMainRed.Hover = false
			end
		end
	end

	if LocalPlayer():Team() != 2 then
		self.TeamMainBlue = vgui.Create( "DButton", self.TeamMain )
		self.TeamMainBlue:SetSize( self.TeamMain:GetWide(), ( self.TeamMain:GetTall() - self.TeamMainTitleSize ) / 2 )
		if LocalPlayer():Team() == 1 then --If you're on red team, the button to join blue team is listed first and the button to join spectator is listed second
			self.TeamMainBlue:SetPos( 0, self.TeamMainTitleSize )
		else --If you're joining/spectating, it's listed after after red team
			self.TeamMainBlue:SetPos( 0, self.TeamMainTitleSize + self.TeamMainRed:GetTall() )
		end
		self.TeamMainBlue:SetText( "" )
		self.TeamMainBlue.Paint = function()
			surface.SetDrawColor( 0, 0, 0, 64 )
			surface.DrawLine( self.TeamMainIconSize * 1.5, self.TeamMainBlue:GetTall() / 2, self.TeamMainBlue:GetWide(), self.TeamMainBlue:GetTall() / 2 )
			if LocalPlayer():Team() == 0 then
				surface.DrawLine( 8, 0, self.TeamMainBlue:GetWide() - 8, 0 )
			else
				surface.DrawLine( 8, self.TeamMainBlue:GetTall() - 1, self.TeamMainBlue:GetWide() - 8, self.TeamMainBlue:GetTall() - 1 )
			end

			surface.SetDrawColor( ( GAMEMODE.Icons.Teams[ team.GetName( 2 ) .. "Color" ] ) or Color( 41, 98, 255, 255 ) )
			surface.SetMaterial( GAMEMODE.Icons.Teams[ team.GetName( 2 ) ] )
			surface.DrawTexturedRect( self.TeamMainIconSize / 4, ( self.TeamMainBlue:GetTall() / 2 ) - ( self.TeamMainIconSize / 2 ), self.TeamMainIconSize , self.TeamMainIconSize )

			local starttextpos = self.TeamMainIconSize * 1.5 --width of the icon + a buffer
			draw.SimpleText( team.GetName( 2 ), "Exo 2", starttextpos + 14, self.TeamMainBlue:GetTall() / 3, Color( 0, 0, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Currently: " .. self.TeamMainBlue.NumberPlayers .. " player(s) on this team.", "Exo 2 Subhead", starttextpos + 14, self.TeamMainBlue:GetTall() / 3 * 2, Color( 128, 128, 128 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			
			if !self.TeamMainBlue.Hover then
				surface.SetTexture( GAMEMODE.GradientTexture )
				surface.SetDrawColor( 0, 0, 0, 164 )
				surface.DrawTexturedRectRotated( self.TeamMainBlue:GetWide() / 2, 4, 8, self.TeamMain:GetWide(), 270 )
				if LocalPlayer():Team() == 1 then
					surface.DrawTexturedRectRotated( self.TeamMainBlue:GetWide() / 2, self.TeamMainBlue:GetTall() - 4, 8, self.TeamMain:GetWide(), 90 )
				end
			end
			if not self.CanJoinBlue then
				surface.SetDrawColor( Color( 0, 0, 0, 160 ) )
				surface.DrawRect( 0, 0, self.TeamMainBlue:GetWide(), self.TeamMainBlue:GetTall() )
				draw.SimpleText( "PLAYER DIFFERENCE TOO LARGE", "Exo 2", self.TeamMainBlue:GetWide() / 2, self.TeamMainBlue:GetTall() / 2, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
		self.TeamMainBlue.DoClick = function()
			if self.CanJoinBlue then
				--[[RunConsoleCommand( "tdm_setteam", "2" )
				LocalPlayer():EmitSound( "buttons/button22.wav" )
				self.TeamMain:Close()]]

				if LocalPlayer():Team() != 0 then
					LocalPlayer():ConCommand( "kill" )
				end
				LocalPlayer().blue = true
				LocalPlayer().red = false
				self.TeamMain:Close()
				LoadoutMenu()
			end
		end
		self.TeamMainBlue.OnCursorEntered = function()
			if self.CanJoinBlue then
				self.TeamMainBlue.Hover = true
			end
		end
		self.TeamMainBlue.OnCursorExited = function()
			self.TeamMainBlue.Hover = false
		end
		self.TeamMainBlue.Think = function()
			self.TeamMainBlue.NumberPlayers = #team.GetPlayers( 2 )
			if not self.CanJoinBlue and self.TeamMainBlue.Hover then
				self.TeamMainBlue.Hover = false
			end
		end
	end

	if LocalPlayer():Team() != 0 then
		self.TeamMainGreen = vgui.Create( "DButton", self.TeamMain )
		self.TeamMainGreen:SetSize( self.TeamMain:GetWide(), ( self.TeamMain:GetTall() - self.TeamMainTitleSize ) / 2 )
		if self.TeamMainBlue and self.TeamMainBlue:IsValid() then 
			self.TeamMainGreen:SetPos( 0, self.TeamMainTitleSize + self.TeamMainBlue:GetTall() )
		else
			self.TeamMainGreen:SetPos( 0, self.TeamMainTitleSize + self.TeamMainRed:GetTall() )
		end
		self.TeamMainGreen:SetText( "" )
		self.TeamMainGreen.Paint = function()
			surface.SetDrawColor( 0, 0, 0, 64 )
			surface.DrawLine( self.TeamMainIconSize * 1.5, self.TeamMainGreen:GetTall() / 2, self.TeamMainGreen:GetWide(), self.TeamMainGreen:GetTall() / 2 )
			surface.DrawLine( 8, 0, self.TeamMainGreen:GetWide() - 8, 0 )

			surface.SetDrawColor( 56, 142, 60, 255 )
			surface.SetMaterial( GAMEMODE.TeamIcon )
			surface.DrawTexturedRect( self.TeamMainIconSize / 4, ( self.TeamMainGreen:GetTall() / 2 ) - ( self.TeamMainIconSize / 2 ), self.TeamMainIconSize , self.TeamMainIconSize )

			local starttextpos = self.TeamMainIconSize * 1.5 --width of the icon + a buffer
			draw.SimpleText( "Spectators", "Exo 2", starttextpos + 14, self.TeamMainGreen:GetTall() / 3, Color( 0, 0, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Currently: " .. self.TeamMainGreen.NumberPlayers .. " player(s) spectating this team.", "Exo 2 Subhead", starttextpos + 14, self.TeamMainGreen:GetTall() / 3 * 2, Color( 128, 128, 128 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			
			if !self.TeamMainGreen.Hover then
				surface.SetTexture( GAMEMODE.GradientTexture )
				surface.SetDrawColor( 0, 0, 0, 164 )
				surface.DrawTexturedRectRotated( self.TeamMainGreen:GetWide() / 2, 4, 8, self.TeamMain:GetWide(), 270 )
				--surface.DrawTexturedRectRotated( self.TeamMainGreen:GetWide() / 2, self.TeamMainGreen:GetTall() - 4, 8, self.TeamMain:GetWide(), 90 )
			end
		end
		self.TeamMainGreen.DoClick = function()
			RunConsoleCommand( "tdm_setteam", "0" )
			LocalPlayer():EmitSound( "buttons/button22.wav" )
			self.TeamMain:Close()
		end
		self.TeamMainGreen.OnCursorEntered = function()
			self.TeamMainGreen.Hover = true
		end
		self.TeamMainGreen.OnCursorExited = function()
			self.TeamMainGreen.Hover = false
		end
		self.TeamMainGreen.Think = function()
			self.TeamMainGreen.NumberPlayers = #team.GetPlayers( 0 )
		end
	end
end

concommand.Add( "tdm_spawnmenu", GM.TeamMenu )