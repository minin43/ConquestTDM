function GM:OpenShop()
	if self.ShopMain and self.ShopMain:IsValid() then return end

	self.ShopMain = vgui.Create( "DFrame" )
	self.ShopMain:SetSize( 750, 500 )
	self.ShopMain:SetTitle( "" )
	self.ShopMain:SetVisible( true )
	self.ShopMain:SetDraggable( false )
	self.ShopMain:ShowCloseButton( false )
	self.ShopMain:Center()
	self.ShopMain:MakePopup()
	self.ShopMain.Think = function()
		self.ShopMain.x, self.ShopMain.y = self.ShopMain:GetPos()
    end
    self.ShopMainTitleBar = 56
    self.ShopMain.Paint = function()
		surface.SetDrawColor( self.TeamColor )
		surface.DrawRect( 0, 0, self.ShopMain:GetWide(), self.ShopMainTitleBar )

		draw.SimpleText( "Shop", "ExoTitleFont", self.ShopMain:GetWide() / 2, self.ShopMainTitleBar / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		surface.SetDrawColor( Color( 255, 255, 255 ) )
		surface.DrawRect( 0, self.ShopMainTitleBar, self.ShopMain:GetWide(), self.ShopMain:GetTall() )
    end
    
    self.ShopMainParentFrame = vgui.Create( "DPanel", self.ShopMain )
    self.ShopMainParentFrame:SetSize( self.ShopMain:GetWide(), self.ShopMain:GetTall() - self.ShopMainTitleBar )
    self.ShopMainParentFrame:SetPos( 0, self.ShopMainTitleBar )

    --self.
end