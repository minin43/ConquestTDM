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

GM.TeamIcon = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" )
GM.GradientTexture = surface.GetTextureID( "gui/gradient" )
GM.FirstSelect = true

function GM:TeamMenu()
	if ( main and main:IsValid() ) or ( self.main and self.main:IsValid() ) or ( self.TeamMain and self.TeamMain:IsValid() ) then return end
	
	self.TeamMain = vgui.Create( "DFrame" )
	self.TeamMain:SetSize( 380, 320 )
	self.TeamMain:SetTitle( "" )
	self.TeamMain:SetVisible( true )
	self.TeamMain:SetDraggable( false )
	self.TeamMain:ShowCloseButton( true )
	self.TeamMain:MakePopup()
	self.TeamMain:Center()
	self.TeamMain.Think = function
		if #team.GetPlayers( 1 ) - #team.GetPlayers( 2 ) >= 2 then
			self.CanJoinRed = false
		elseif #team.GetPlayers( 2 ) - #team.GetPlayers( 1 ) >= 2 then
			self.CanJoinBlue = false
		end
	end
	self.TeamMain.Paint = function()
		Derma_DrawBackgroundBlur( self.TeamMain, CurTime() )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawRect( 0, 0, self.TeamMain:GetWide(), self.TeamMain:GetTall() )
	end

	self.TeamMainTitleSize = 56 --To be kept consistent across all menus
	self.TeamMainTitle = vgui.Create( "DPanel", self.TeamMain )
	self.TeamMainTitle:SetPos( 0, 0 )
	self.TeamMainTitle:SetSize( self.TeamMain:GetWide(), self.TeamMainTitleSize )
	self.TeamMainTitle.Paint = function()
		surface.SetDrawColor( TeamColor ) --To change once color becomes globalized
		surface.DrawRect( 0, 0, self.TeamMainTitle:GetWide(), self.TeamMainTitle:GetTall() )
		draw.SimpleText( "Choose Team", "Exo 2", self.TeamMainTitle:GetWide() / 2, self.TeamMainTitle:GetTall() / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		surface.SetTexture( GAMEMODE.GradientTexture )
		surface.SetDrawColor( 0, 0, 0, 164 )
		surface.DrawTexturedRectRotated( self.TeamMainTitle:GetWide() / 2, self.TeamMainTitle:GetTall() + 4, 8, self.TeamMainTitle:GetWide(), 270 )
	end

	--//Onto the buttons: normally these would be custom vgui elements, however, since there are only 2, I'm taking the lazy route and just using DButton
	self.TeamMainIconSize = 24
	self.TeamMainIconPos = ( ( self.TeamMain:GetTall() - self.TeamMainTitleSize - self.TeamMainCloseSize ) / 2 - self.TeamMainIconSize ) / 2 --Used to position the icon in the button - changes dynamically based on icon size & button height
	
	if LocalPlayer():Team() != 1 then --If the player isn't already on red team
		self.TeamMainRed = vgui.Create( "DButton", self.TeamMain )
		self.TeamMainRed:SetPos( 0, self.TeamMainTitleSize )
		self.TeamMainRed:SetSize( self.TeamMain:GetWide(), ( self.TeamMain:GetTall() - self.TeamMainTitleSize - self.TeamMainCloseSize ) / 2 )
		self.TeamMainRed:SetText( "" )
		self.TeamMainRed.Paint = function()
			surface.SetDrawColor( 0, 0, 0, 64 )
			surface.DrawRect( 72, 71, self.TeamMainRed:GetWide(), 1 )

			surface.SetDrawColor( 213, 0, 0, 255 )
			surface.SetMaterial( self.TeamIcon )
			surface.DrawTexturedRect( self.TeamMainIconPos, self.TeamMainIconPos, self.TeamMainIconPos + self.TeamMainIconSize, self.TeamMainIconPos + self.TeamMainIconSize )

			local starttextpos = self.TeamMainIconPos * 2 + self.TeamMainIconSize + 10 --width of the icon, plus a space buffer
			draw.SimpleText( "Red Team", "Exo 2 Subhead", starttextpos, self.TeamMainRed:GetTall() / 3, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Currently: " .. self.NumberPlayers .. " player(s) on this team.", "Exo 2 Subhead", starttextpos + 10, self.TeamMainRed:GetTall() / 3 * 2, Color( 128, 128, 128 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			
			if not self.CanJoinRed then
				surface.SetDrawColor( Color( 0, 0, 0, 160 ) )
				surface.DrawRect( 0, 0, self.TeamMainRed:GetWide(), self.TeamMainRed:GetTall() )
				draw.SimpleText( "CANNOT JOIN - PLAYER DIFFERENCE TOO LARGE", "Exo 2", self.TeamMainRed:GetWide() / 2, self.TeamMainRed:GetTall() / 2, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			elseif self.TeamMainRed.Hover then
				-- Do something cool?
			end
		end
		self.TeamMainRed.DoClick = function()
			if self.CanJoinRed then
				RunConsoleCommand( "tdm_setteam", "1" )
				LocalPlayer():EmitSound( "buttons/button22.wav" )
				self.TeamMain:Close()
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
			self.NumberPlayers = #team.GetPlayers( 1 )
			if not self.CanJoinRed and self.TeamMainRed.Hover then
				self.TeamMainRed.Hover = false
			end
		end
	end
	if LocalPlayer():Team() != 2 then
		self.TeamMainBlue = vgui.Create( "DButton", self.TeamMain )
		self.TeamMainBlue:SetSize( self.TeamMain:GetWide(), ( self.TeamMain:GetTall() - self.TeamMainTitleSize - self.TeamMainCloseSize ) / 2 )
		if LocalPlayer():Team() == 1 then --If you're on red team, the button to join blue team is listed first and the button to join spectator is listed second
			self.TeamMainBlue:SetPos( 0, self.TeamMainTitleSize )
		else --If you're joining/spectating, it's listed after after red team
			self.TeamMainBlue:SetPos( 0, self.TeamMainTitleSize + self.TeamMainRed:GetTall() )
		end
		self.TeamMainBlue:SetText( "" )
		self.TeamMainBlue.Paint = function()
			surface.SetDrawColor( 0, 0, 0, 64 )
			surface.DrawRect( 72, 71, self.TeamMainBlue:GetWide(), 1 )

			surface.SetDrawColor( 213, 0, 0, 255 )
			surface.SetMaterial( self.TeamIcon )
			surface.DrawTexturedRect( self.TeamMainIconPos, self.TeamMainIconPos, self.TeamMainIconPos + self.TeamMainIconSize, self.TeamMainIconPos + self.TeamMainIconSize )

			local starttextpos = self.TeamMainIconPos * 2 + self.TeamMainIconSize + 10 --width of the icon, plus a space buffer
			draw.SimpleText( "Red Team", "Exo 2 Subhead", starttextpos, self.TeamMainBlue:GetTall() / 3, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Currently: " .. self.NumberPlayers .. " player(s) on this team.", "Exo 2 Subhead", starttextpos + 10, self.TeamMainBlue:GetTall() / 3 * 2, Color( 128, 128, 128 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			
			if not self.CanJoinRed then
				surface.SetDrawColor( Color( 0, 0, 0, 160 ) )
				surface.DrawRect( 0, 0, self.TeamMainBlue:GetWide(), self.TeamMainBlue:GetTall() )
				draw.SimpleText( "CANNOT JOIN - PLAYER DIFFERENCE TOO LARGE", "Exo 2", self.TeamMainBlue:GetWide() / 2, self.TeamMainBlue:GetTall() / 2, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			elseif self.TeamMainBlue.Hover then
				-- Do something cool?
			end
		end
		self.TeamMainBlue.DoClick = function()
			if self.CanJoinRed then
				RunConsoleCommand( "tdm_setteam", "2" )
				LocalPlayer():EmitSound( "buttons/button22.wav" )
				self.TeamMain:Close()
			end
		end
		self.TeamMainBlue.OnCursorEntered = function()
			if self.CanJoinRed then
				self.TeamMainBlue.Hover = true
			end
		end
		self.TeamMainBlue.OnCursorExited = function()
			self.TeamMainBlue.Hover = false
		end
		self.TeamMainBlue.Think = function()
			self.NumberPlayers = #team.GetPlayers( 1 )
			if not self.CanJoinRed and self.TeamMainBlue.Hover then
				self.TeamMainBlue.Hover = false
			end
		end
	end
	if LocalPlayer():Team() != 0 then

	end
end