function GM:OpenShop()
    if self.ShopMain and self.ShopMain:IsValid() then return end
    
    net.Start( "GetPrestigeTokens" )
    net.SendToServer()

    net.Receive( "GetPrestigeTokensCallback", function()
        local tokens = net.ReadInt( 16 )
        GAMEMODE.MyPrestigeTokens = tokens
    end )
    GAMEMODE.MyPrestigeTokens = GAMEMODE.MyPrestigeTokens or 0

    net.Start( "RequestMoney" )
    net.SendToServer()

    net.Receive( "RequestMoneyCallback", function()
        curAmt = tonumber( net.ReadString() ) --Lazy-ass Whuppo
        GAMEMODE.MyMoney = curAmt
    end )

	self.ShopMain = vgui.Create( "DFrame" )
	self.ShopMain:SetSize( 750, 500 )
	self.ShopMain:SetTitle( "" )
	self.ShopMain:SetVisible( true )
	self.ShopMain:SetDraggable( false )
	--self.ShopMain:ShowCloseButton( false )
	self.ShopMain:Center()
	self.ShopMain:MakePopup()
	self.ShopMain.Think = function()
		self.ShopMain.x, self.ShopMain.y = self.ShopMain:GetPos()
    end
    self.ShopMainTitleBar = 56
    self.ShopMain.Paint = function()
        Derma_DrawBackgroundBlur( self.ShopMain, CurTime() )
		surface.SetDrawColor( self.TeamColor )
		surface.DrawRect( 0, 0, self.ShopMain:GetWide(), self.ShopMainTitleBar )

		--draw.SimpleText( "Shop", "ExoTitleFont", self.ShopMain:GetWide() / 2, self.ShopMainTitleBar / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        surface.SetFont( "Exo 2" )
		surface.SetTextColor( Color( 255, 255, 255 ) )
		surface.SetTextPos( self.ShopMain:GetWide() / 2 - surface.GetTextSize("Loadout") / 2, 16 )
		surface.DrawText( "Shop" )

		surface.SetDrawColor( Color( 255, 255, 255 ) )
		surface.DrawRect( 0, self.ShopMainTitleBar, self.ShopMain:GetWide(), self.ShopMain:GetTall() )

		surface.SetDrawColor( self.TeamColor )
        surface.DrawRect( 0, self.ShopMain:GetTall() - ( self.ShopMainTitleBar / 2 ), self.ShopMain:GetWide(), self.ShopMain:GetTall() )
        
        surface.SetFont( "ExoTitleFont" )
        surface.SetTextPos( 4, self.ShopMain:GetTall() - ( self.ShopMainTitleBar / 2 ) + 4 )
        surface.DrawText( "Money: " .. self.MyMoney .. "$" )
		--draw.SimpleText( "Money: " .. self.MyMoney .. "$", "ExoTitleFont", 4, self.ShopMain:GetTall() - ( self.ShopMainTitleBar / 4 ), Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        
        surface.SetTextPos( self.ShopMain:GetWide() / 2 - surface.GetTextSize("Level: " .. self.MyLevel) / 2, self.ShopMain:GetTall() - ( self.ShopMainTitleBar / 2 ) + 4 )
        surface.DrawText( "Level: " .. self.MyLevel )
        --draw.SimpleText( "Level: " .. self.MyLevel, "ExoTitleFont", self.ShopMain:GetWide() / 2, self.ShopMain:GetTall() - ( self.ShopMainTitleBar / 4 ), Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        
        surface.SetTextPos( self.ShopMain:GetWide() - surface.GetTextSize("Prestige Tokens: " .. self.MyPrestigeTokens) - 4, self.ShopMain:GetTall() - ( self.ShopMainTitleBar / 2 ) + 4 )
        surface.DrawText( "Prestige Tokens: " .. self.MyPrestigeTokens )
        --draw.SimpleText( "Prestige Tokens: " .. self.MyPrestigeTokens, "ExoTitleFont", self.ShopMain:GetWide() - 4, self.ShopMain:GetTall() - ( self.ShopMainTitleBar / 4 ), Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
    
        surface.SetTexture( GAMEMODE.GradientTexture )
        surface.SetDrawColor( 0, 0, 0, 164 )
        surface.DrawTexturedRectRotated( self.ShopMain:GetWide() / 2, self.ShopMain:GetTall() - 4, 8, self.ShopMain:GetWide(), 90 )
    end
    
    self.ShopParentSheet = vgui.Create( "DPropertySheet", self.ShopMain )
    self.ShopParentSheet:SetPos( -8, self.ShopMainTitleBar + 20 )
    self.ShopParentSheet:SetSize( self.ShopMain:GetWide() + 16, self.ShopMain:GetTall() - ( self.ShopMainTitleBar * 1.5 ) - 12 )
    self.ShopParentSheet.Paint = function() return true end

    self.ShopWeaponsSheet = vgui.Create( "WeaponsShopPanel", self.ShopParentSheet )
    self.ShopWeaponsSheet:SetSize( self.ShopParentSheet:GetWide(), self.ShopParentSheet:GetTall() )
    self.ShopWeaponsSheet:SetPos( 0, 0 )
    print( self.ShopWeaponsSheet:GetWide(), self.ShopWeaponsSheet:GetTall(), "\n" )
    self.ShopWeaponsSheet:DoSetup()
    --[[self.ShopWeaponsSheet.Paint = function()
        --draw.RoundedBox( 8, 0, 0, self.ShopWeaponsSheet:GetWide(), self.ShopWeaponsSheet:GetTall(), Color( 255, 0, 0 ) )
        surface.SetDrawColor( Color( 255, 0, 0 ) )
        surface.DrawRect( 0, 0, self.ShopWeaponsSheet:GetWide(), self.ShopWeaponsSheet:GetTall() )
    end]]
    local WeaponsSheetTable = self.ShopParentSheet:AddSheet( "Weapons", self.ShopWeaponsSheet )

    self.ShopWeaponsButton = vgui.Create( "PropertySheetButton", self.ShopMain )
    self.ShopWeaponsButton:SetPos( 0, self.ShopMainTitleBar )
    self.ShopWeaponsButton:SetSize( self.ShopMain:GetWide() / 3, 48 )
    self.ShopWeaponsButton:SetParentSheet( self.ShopParentSheet )
    self.ShopWeaponsButton:SetTab( WeaponsSheetTable.Tab )
    self.ShopWeaponsButton:SetText( "Weapons" )
    self.ShopWeaponsButton:SetFont( "ExoTitleFont" )

    self.ShopSkinsSheet = vgui.Create( "DPanel", self.ShopParentSheet )
    self.ShopSkinsSheet:SetSize( self.ShopParentSheet:GetWide(), self.ShopParentSheet:GetTall() )
    self.ShopSkinsSheet:SetPos( 0, 0 )
    self.ShopSkinsSheet.Paint = function()
        draw.RoundedBox( 8, 0, 0, self.ShopSkinsSheet:GetWide(), self.ShopSkinsSheet:GetTall(), Color( 0, 255, 0 ) )
    end
    print( self.ShopSkinsSheet:GetWide(), self.ShopSkinsSheet:GetTall() )
    local ShopSheetTable = self.ShopParentSheet:AddSheet( "Skins", self.ShopSkinsSheet )

    self.ShoSkinsButton = vgui.Create( "PropertySheetButton", self.ShopMain )
    self.ShoSkinsButton:SetPos( self.ShopMain:GetWide() / 3, self.ShopMainTitleBar )
    self.ShoSkinsButton:SetSize( self.ShopMain:GetWide() / 3, 48 )
    self.ShoSkinsButton:SetParentSheet( self.ShopParentSheet )
    self.ShoSkinsButton:SetTab( ShopSheetTable.Tab )
    self.ShoSkinsButton:SetText( "Weapon Skins" )
    self.ShoSkinsButton:SetFont( "ExoTitleFont" )

    self.ShopModelsSheet = vgui.Create( "DPanel", self.ShopParentSheet )
    self.ShopModelsSheet:SetSize( self.ShopParentSheet:GetWide(), self.ShopParentSheet:GetTall() )
    self.ShopModelsSheet:SetPos( 0, 0 )
    self.ShopModelsSheet.Paint = function()
        --draw.RoundedBox( 8, 0, 0, self.ShopModelsSheet:GetWide(), self.ShopModelsSheet:GetTall(), Color( 0, 0, 255 ) )
        surface.SetDrawColor( Color( 0, 0, 255 ) )
        surface.DrawRect( 0, 0, self.ShopWeaponsSheet:GetWide(), self.ShopWeaponsSheet:GetTall() )
    end
    print( self.ShopModelsSheet:GetWide(), self.ShopModelsSheet:GetTall() )
    local ModelSheetTable = self.ShopParentSheet:AddSheet( "Playermodels", self.ShopModelsSheet )

    self.ShopModelsButton = vgui.Create( "PropertySheetButton", self.ShopMain )
    self.ShopModelsButton:SetPos( self.ShopMain:GetWide() / 3 * 2, self.ShopMainTitleBar )
    self.ShopModelsButton:SetSize( self.ShopMain:GetWide() / 3, 48 )
    self.ShopModelsButton:SetParentSheet( self.ShopParentSheet )
    self.ShopModelsButton:SetTab( ModelSheetTable.Tab )
    self.ShopModelsButton:SetText( "Playermodels" )
    self.ShopModelsButton:SetFont( "ExoTitleFont" )

    for k, v in pairs( self.ShopParentSheet.Items ) do
		if ( !v.Tab ) then continue end

        v.Tab.Paint = function() return true end
        v.Tab.DoClick = function() return true end --May need to remove - may unintentionally disable desired functionality
	end
end