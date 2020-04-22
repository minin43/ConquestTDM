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

    net.Start( "GetDonatorCredits")
    net.SendToServer()

	self.ShopMain = vgui.Create( "DFrame" )
	self.ShopMain:SetSize( 750, 600 )
	self.ShopMain:SetTitle( "" )
	self.ShopMain:SetVisible( true )
	self.ShopMain:SetDraggable( false )
	self.ShopMain:ShowCloseButton( false )
	self.ShopMain:Center()
	self.ShopMain:MakePopup()
	--[[self.ShopMain.Think = function()
		self.ShopMain.x, self.ShopMain.y = self.ShopMain:GetPos()
    end]]
    self.ShopMainTitleBar = 56
    local iconSize = 24
    local iconOffsetY = 1
    self.ShopMain.Paint = function()
        --Do a blur and draw the TeamColor title bar along the top
        Derma_DrawBackgroundBlur( self.ShopMain, CurTime() )
		surface.SetDrawColor( self.TeamColor )
		surface.DrawRect( 0, 0, self.ShopMain:GetWide(), self.ShopMainTitleBar )

        --Draw the "Shop" text along the top
        surface.SetFont( "Exo 2" )
		surface.SetTextColor( Color( 255, 255, 255 ) )
		surface.SetTextPos( self.ShopMain:GetWide() / 2 - surface.GetTextSize("Shop") / 2, 16 )
		surface.DrawText( "Shop" )

        --Draw a white background
		surface.SetDrawColor( 255, 255, 255 )
        surface.DrawRect( 0, self.ShopMainTitleBar, self.ShopMain:GetWide(), self.ShopMain:GetTall() )
        
        --Draw the TeamColor bar along the bottom of the menu
		surface.SetDrawColor( self.TeamColor )
        surface.DrawRect( 0, self.ShopMain:GetTall() - ( self.ShopMainTitleBar / 2 ), self.ShopMain:GetWide(), self.ShopMain:GetTall() )
        
        --Display player level on the left-hand side of the bottom bar
        surface.SetFont( "ExoTitleFont" )
        surface.SetTextPos( 5, self.ShopMain:GetTall() - ( self.ShopMainTitleBar / 2 ) + 4 )
        surface.DrawText( "Level: " .. self.MyLevel )

        --Display player money with an icon & value
        surface.SetDrawColor( 255, 255, 255 )
        surface.SetMaterial( GAMEMODE.Icons.Menu.cashIconSmall )
        --surface.DrawTexturedRect( self.ShopMain:GetWide() / 3, self.ShopMain:GetTall() - ( self.ShopMainTitleBar / 4 ) - ( iconSize / 2 ), iconSize, iconSize )
        --surface.SetTextPos( self.ShopMain:GetWide() / 3 + iconSize, self.ShopMain:GetTall() - ( self.ShopMainTitleBar / 2 ) + 4 )
        surface.DrawTexturedRect( self.ShopMain:GetWide() / 3 - --[[( iconSize / 2 ) -]] ( surface.GetTextSize( ": $" .. comma_value( self.MyMoney ) ) ), self.ShopMain:GetTall() - ( self.ShopMainTitleBar / 4 ) - ( iconSize / 2 ) + iconOffsetY, iconSize, iconSize )
        surface.SetTextPos( self.ShopMain:GetWide() / 3 + iconSize - --[[( iconSize / 2 ) -]] ( surface.GetTextSize( ": $" .. comma_value( self.MyMoney ) ) ), self.ShopMain:GetTall() - ( self.ShopMainTitleBar / 2 ) + 4 )
        surface.DrawText( ": $" .. comma_value( self.MyMoney ) )

        --Display player prestige tokens with icon & value 
        surface.SetMaterial( GAMEMODE.Icons.Menu.tokensIconSmall )
        surface.DrawTexturedRect( self.ShopMain:GetWide() / 3 * 2, self.ShopMain:GetTall() - ( self.ShopMainTitleBar / 4 ) - ( iconSize / 2 ) + iconOffsetY, iconSize, iconSize )
        surface.SetTextPos( self.ShopMain:GetWide() / 3 * 2 + iconSize, self.ShopMain:GetTall() - ( self.ShopMainTitleBar / 2 ) + 4 )
        surface.DrawText( ": " .. self.MyPrestigeTokens )

        --Display player donator credits with icon & value
        surface.SetTextPos( self.ShopMain:GetWide() - surface.GetTextSize( ": " .. self.MyCredits ) - 5, self.ShopMain:GetTall() - ( self.ShopMainTitleBar / 2 ) + 4 )
        surface.DrawText( ": " .. self.MyCredits )
        surface.SetMaterial( GAMEMODE.Icons.Menu.creditsIconSmall )
        surface.DrawTexturedRect( self.ShopMain:GetWide() - surface.GetTextSize( ": " .. self.MyCredits ) - iconSize - 4, self.ShopMain:GetTall() - ( self.ShopMainTitleBar / 4 ) - ( iconSize / 2 ) + iconOffsetY, iconSize, iconSize )

        --Do some gradient drawing along the bottom
        surface.SetTexture( GAMEMODE.GradientTexture )
        surface.SetDrawColor( 0, 0, 0, 164 )
        surface.DrawTexturedRectRotated( self.ShopMain:GetWide() / 2, self.ShopMain:GetTall() - ( self.ShopMainTitleBar / 2 ) - 4, 8, self.ShopMain:GetWide(), 90 )
    end

    local back = vgui.Create( "DButton", self.ShopMain )
    back:SetSize( 40, 40 )
    back:SetPos( 8, 8 )
    back:SetText( "" )
    back.DoClick = function()
        self.ShopMain:Close()
        GAMEMODE:MenuMain()
    end
    back.Paint = function()
        if back.hover then
            surface.SetDrawColor( colorScheme[ LocalPlayer():Team() ].ButtonIndicator )
        else
            surface.SetDrawColor( 0, 0, 0, 220 )
        end
        surface.SetMaterial( GAMEMODE.Icons.Menu.backIcon )
        surface.DrawTexturedRect( 0, 0, back:GetWide(), back:GetTall() )
    end
    back.OnCursorEntered = function()
        back.hover = true
    end
    back.OnCursorExited = function()
        back.hover = false
    end

    local close = vgui.Create( "DButton", self.ShopMain )
    close:SetSize( 40, 40 )
    close:SetPos( self.ShopMain:GetWide() - 8 - close:GetWide(), 8 )
    close:SetText( "" )
    close.DoClick = function()
        self.ShopMain:Close()
    end
    close.Paint = function()
        if close.hover then
            surface.SetDrawColor( colorScheme[ LocalPlayer():Team() ].ButtonIndicator )
        else
            surface.SetDrawColor( 0, 0, 0, 220 )
        end
        surface.SetMaterial( GAMEMODE.Icons.Menu.cancelIcon )
        surface.DrawTexturedRect( 0, 0, close:GetWide(), close:GetTall() )
    end
    close.OnCursorEntered = function()
        close.hover = true
    end
    close.OnCursorExited = function()
        close.hover = false
    end
    
    self.ShopParentSheet = vgui.Create( "DPropertySheet", self.ShopMain )
    self.ShopParentSheet:SetPos( -8, self.ShopMainTitleBar + 8 )
    self.ShopParentSheet:SetSize( self.ShopMain:GetWide() + 16, self.ShopMain:GetTall() - ( self.ShopMainTitleBar * 1.5 ) )
    self.ShopParentSheet.Paint = function() return true end

    self.ShopWeaponsSheet = vgui.Create( "WeaponsShopPanel", self.ShopParentSheet )
    self.ShopWeaponsSheet:SetSize( self.ShopParentSheet:GetWide(), self.ShopParentSheet:GetTall() )
    self.ShopWeaponsSheet:SetPos( 0, 0 )
    self.ShopWeaponsSheet:DoSetup()
    local WeaponsSheetTable = self.ShopParentSheet:AddSheet( "Weapons", self.ShopWeaponsSheet )

    self.ShopWeaponsButton = vgui.Create( "PropertySheetButton", self.ShopMain )
    self.ShopWeaponsButton:SetPos( 0, self.ShopMainTitleBar )
    self.ShopWeaponsButton:SetSize( self.ShopMain:GetWide() / 3, 36 )
    self.ShopWeaponsButton:SetParentSheet( self.ShopParentSheet )
    self.ShopWeaponsButton:SetTab( WeaponsSheetTable.Tab )
    self.ShopWeaponsButton:SetText( "Weapons" )
    self.ShopWeaponsButton:SetFont( "ExoTitleFont" )

    self.ShopSkinsSheet = vgui.Create( "SkinsShopPanel", self.ShopParentSheet )
    self.ShopSkinsSheet:SetSize( self.ShopParentSheet:GetWide(), self.ShopParentSheet:GetTall() - ( 56 / 2 ) - 8 ) --Dunno why this needs these extra size measurements
    self.ShopSkinsSheet:SetPos( 0, 0 )
    self.ShopSkinsSheet:DoSetup()
    local ShopSheetTable = self.ShopParentSheet:AddSheet( "Skins", self.ShopSkinsSheet )

    self.ShopSkinsButton = vgui.Create( "PropertySheetButton", self.ShopMain )
    self.ShopSkinsButton:SetPos( self.ShopMain:GetWide() / 3, self.ShopMainTitleBar )
    self.ShopSkinsButton:SetSize( self.ShopMain:GetWide() / 3, 36 )
    self.ShopSkinsButton:SetParentSheet( self.ShopParentSheet )
    self.ShopSkinsButton:SetTab( ShopSheetTable.Tab )
    self.ShopSkinsButton:SetText( "Weapon Skins" )
    self.ShopSkinsButton:SetFont( "ExoTitleFont" )

    self.ShopModelsSheet = vgui.Create( "ModelsShopPanel", self.ShopParentSheet )
    self.ShopModelsSheet:SetSize( self.ShopParentSheet:GetWide(), self.ShopParentSheet:GetTall() - ( 56 / 2 ) - 8 ) --Dunno why this needs these extra size measurements
    self.ShopModelsSheet:SetPos( 0, 0 )
    self.ShopModelsSheet:DoSetup()
    --[[self.ShopModelsSheet.Paint = function()
        --draw.RoundedBox( 8, 0, 0, self.ShopModelsSheet:GetWide(), self.ShopModelsSheet:GetTall(), Color( 0, 0, 255 ) )
        --surface.SetDrawColor( Color( 0, 0, 255 ) )
        --surface.DrawRect( 0, 0, self.ShopWeaponsSheet:GetWide(), self.ShopWeaponsSheet:GetTall() )
        draw.SimpleText( "UNDER CONSTRUCTION", "ExoTitleFont", self.ShopModelsSheet:GetWide() / 2, self.ShopModelsSheet:GetTall() / 2, GAMEMODE.TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end]]
    local ModelSheetTable = self.ShopParentSheet:AddSheet( "Playermodels", self.ShopModelsSheet )

    self.ShopModelsButton = vgui.Create( "PropertySheetButton", self.ShopMain )
    self.ShopModelsButton:SetPos( self.ShopMain:GetWide() / 3 * 2, self.ShopMainTitleBar )
    self.ShopModelsButton:SetSize( self.ShopMain:GetWide() / 3, 36 )
    self.ShopModelsButton:SetParentSheet( self.ShopParentSheet )
    self.ShopModelsButton:SetTab( ModelSheetTable.Tab )
    self.ShopModelsButton:SetText( "Playermodels" )
    self.ShopModelsButton:SetFont( "ExoTitleFont" )

    for k, v in pairs( self.ShopParentSheet.Items ) do
		if ( !v.Tab ) then continue end

        v.Tab.Paint = function() return true end
        v.Tab.DoClick = function() return true end --May need to remove - may unintentionally disable desired functionality
    end
    --print(GAMEMODE, self, self.ShopMain)
    --self:DrawEventStatuses( self.ShopMain )
end

function GM:AttemptBuyWeapon( wepclass )
    if not self.lockedweapons then
        net.Start( "RequestLockedWeapons" )
        net.SendToServer()
        return false
    end

    for k, v in pairs( self.WeaponsList ) do
        if v[ 2 ] == wepclass then
            net.Start( "BuyWeapon" )
                net.WriteInt( k, 16 )
            net.SendToServer()
            return true
        end
    end
    return false
end

function GM:AttemptBuyWepSkin( skindir, currency )
    if !self.lockedskins then
        net.Start( "RequestLockedSkins" )
        net.SendToServer()
        return false
    end

    for k, v in pairs( self.WeaponSkins ) do
        if v.directory == skindir then
            net.Start( "BuySkin" )
                net.WriteInt( k, 8 )
                net.WriteString( currency )
            net.SendToServer()
            return true
        end
    end
    return false
end

function GM:AttemptBuyPModel( model, currency )
    if !self.lockedmodels then
        net.Start( "RequestLockedModels" )
        net.SendToServer()
        return false
    end

    for k, v in pairs( self.PlayerModels ) do
        if v.model == model then
            net.Start( "BuyModel" )
                net.WriteInt( k, 8 )
                net.WriteString( currency )
            net.SendToServer()
            return true
        end
    end
end