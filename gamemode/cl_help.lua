function GM:OpenHelp()
    if self.HelpMain and self.HelpMain:IsValid() then return end

    self.HelpMain = vgui.Create( "DFrame" )
    self.HelpMain:SetSize( 450, 300 )
	self.HelpMain:SetTitle( "" )
	self.HelpMain:SetVisible( true )
	self.HelpMain:SetDraggable( false )
	--self.HelpMain:ShowCloseButton( false )
	self.HelpMain:Center()
	self.HelpMain:MakePopup()
	self.HelpMain.Think = function()
		self.HelpMain.x, self.HelpMain.y = self.HelpMain:GetPos()
    end
    self.HelpMainTitleBar = 56
    self.HelpMain.Paint = function()
        Derma_DrawBackgroundBlur( self.HelpMain, CurTime() )
		surface.SetDrawColor( self.TeamColor )
		surface.DrawRect( 0, 0, self.HelpMain:GetWide(), self.HelpMainTitleBar )

        surface.SetFont( "Exo 2" )
		surface.SetTextColor( Color( 255, 255, 255 ) )
		surface.SetTextPos( self.HelpMain:GetWide() / 2 - surface.GetTextSize("Help Menu") / 2, 16 )
		surface.DrawText( "Help Menu" )

		surface.SetDrawColor( Color( 255, 255, 255 ) )
		surface.DrawRect( 0, self.HelpMainTitleBar, self.HelpMain:GetWide(), self.HelpMain:GetTall() )
    end
end