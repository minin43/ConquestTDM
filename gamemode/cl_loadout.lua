surface.CreateFont( "Exo 2 Tab", {
	font = "Exo 2",
	size = 14,
	weight = 400
} )

surface.CreateFont( "Exo 2 Hint" , {
	font = "Exo 2",
	size = 18,
	weight = 400
} )

surface.CreateFont( "Exo 2 Hint Empty", {
	font = "Exo 2",
	size = 16,
	weight = 400,
	italic = true
} )

surface.CreateFont( "Exo-24-400", { font = "Exo 2", size = 24 } )

local gradient = surface.GetTextureID( "gui/gradient" )

function GM:LoadoutMenu( switchingTo )
    if self.LoadoutMain and IsValid( self.LoadoutMain )--[[:IsValid()]] then return end
    if switchingTo then
        self.oldcolor = self.TeamColor 
        self.TeamColor = colorScheme[ switchingTo ].TeamColor
    else
        switchingTo = LocalPlayer():Team()
        self.oldcolor = colorScheme[ switchingTo ].TeamColor
    end
    
    self.MyPrestigeTokens = self.MyPrestigeTokens or 0
    net.Start( "GetPrestigeTokens" )
    net.SendToServer()

    self.MyMoney = self.MyMoney or 0
    net.Start( "RequestMoney" )
    net.SendToServer()

    self.MyCredits = self.MyCreditsor or 0
    net.Start( "GetDonatorCredits")
    net.SendToServer()

    self.MySkins = self.MySkins or {}
    net.Start( "GetUnlockedSkins" )
    net.SendToServer()

    net.Receive( "GetUnlockedSkinsCallback", function()
        self.MySkins = net.ReadTable()
        --ResetPMSelectionButton()
    end )

    self.MyModels = self.MyModels or {}
    net.Start( "GetUnlockedModels" )
    net.SendToServer()

    net.Receive( "GetUnlockedModelsCallback", function()
        self.MyModels = net.ReadTable()
        self.LoadoutMain:ResetPMSelectionButton()
    end )

	self.LoadoutMain = vgui.Create( "DFrame" )
	self.LoadoutMain:SetSize( ScrW() / 1.5, ScrH() / 3 * 2 )
	self.LoadoutMain:SetTitle( "" )
	self.LoadoutMain:SetVisible( true )
	self.LoadoutMain:SetDraggable( false )
	self.LoadoutMain:ShowCloseButton( false )
	self.LoadoutMain:Center()
	self.LoadoutMain:MakePopup()
    self.TitleBar = 56
    local iconSize = 24
    local iconOffsetY = 1
    self.LoadoutMain.Paint = function()
        --Do a blur and draw the TeamColor title bar along the top
        Derma_DrawBackgroundBlur( self.LoadoutMain, CurTime() )
		surface.SetDrawColor( self.TeamColor )
		surface.DrawRect( 0, 0, self.LoadoutMain:GetWide(), self.TitleBar )

        --Draw the "Shop" text along the top
        surface.SetFont( "Exo 2" )
		surface.SetTextColor( Color( 255, 255, 255 ) )
		surface.SetTextPos( self.LoadoutMain:GetWide() / 2 - surface.GetTextSize("Loadout") / 2, 16 )
		surface.DrawText( "Loadout" )

        --Draw a white background
		surface.SetDrawColor( 255, 255, 255 )
        surface.DrawRect( 0, self.TitleBar, self.LoadoutMain:GetWide(), self.LoadoutMain:GetTall() )
        
        --Draw the TeamColor bar along the bottom of the menu
		surface.SetDrawColor( self.TeamColor )
        surface.DrawRect( 0, self.LoadoutMain:GetTall() - ( self.TitleBar / 2 ), self.LoadoutMain:GetWide(), self.LoadoutMain:GetTall() )
        
        --Display player level on the left-hand side of the bottom bar
        surface.SetFont( "ExoTitleFont" )
        surface.SetTextPos( 5, self.LoadoutMain:GetTall() - ( self.TitleBar / 2 ) + 4 )
        surface.DrawText( "Level: " .. self.MyLevel )

        --Display player money with an icon & value
        surface.SetDrawColor( 255, 255, 255 )
        surface.SetMaterial( GAMEMODE.Icons.Menu.cashIconSmall )
        --surface.DrawTexturedRect( self.LoadoutMain:GetWide() / 3, self.LoadoutMain:GetTall() - ( self.TitleBar / 4 ) - ( iconSize / 2 ), iconSize, iconSize )
        --surface.SetTextPos( self.LoadoutMain:GetWide() / 3 + iconSize, self.LoadoutMain:GetTall() - ( self.TitleBar / 2 ) + 4 )
        surface.DrawTexturedRect( self.LoadoutMain:GetWide() / 3 - --[[( iconSize / 2 ) -]] ( surface.GetTextSize( ": $" .. comma_value( self.MyMoney ) ) ), self.LoadoutMain:GetTall() - ( self.TitleBar / 4 ) - ( iconSize / 2 ) + iconOffsetY, iconSize, iconSize )
        surface.SetTextPos( self.LoadoutMain:GetWide() / 3 + iconSize - --[[( iconSize / 2 ) -]] ( surface.GetTextSize( ": $" .. comma_value( self.MyMoney ) ) ), self.LoadoutMain:GetTall() - ( self.TitleBar / 2 ) + 4 )
        surface.DrawText( " $" .. comma_value( self.MyMoney ) )

        --Display player prestige tokens with icon & value 
        surface.SetMaterial( GAMEMODE.Icons.Menu.tokensIconSmall )
        surface.DrawTexturedRect( self.LoadoutMain:GetWide() / 3 * 2, self.LoadoutMain:GetTall() - ( self.TitleBar / 4 ) - ( iconSize / 2 ) + iconOffsetY, iconSize, iconSize )
        surface.SetTextPos( self.LoadoutMain:GetWide() / 3 * 2 + iconSize, self.LoadoutMain:GetTall() - ( self.TitleBar / 2 ) + 4 )
        surface.DrawText( " " .. self.MyPrestigeTokens )

        --Display player donator credits with icon & value
        surface.SetTextPos( self.LoadoutMain:GetWide() - surface.GetTextSize( ": " .. self.MyCredits ) - 5, self.LoadoutMain:GetTall() - ( self.TitleBar / 2 ) + 4 )
        surface.DrawText( " " .. self.MyCredits )
        surface.SetMaterial( GAMEMODE.Icons.Menu.creditsIconSmall )
        surface.DrawTexturedRect( self.LoadoutMain:GetWide() - surface.GetTextSize( ": " .. self.MyCredits ) - iconSize - 4, self.LoadoutMain:GetTall() - ( self.TitleBar / 4 ) - ( iconSize / 2 ) + iconOffsetY, iconSize, iconSize )
    
        surface.SetDrawColor( 0, 0, 0, 220 )
        --surface.DrawLine( self.LoadoutMain:GetWide() / 4, GAMEMODE.TitleBar + 8, self.LoadoutMain:GetWide() / 4, self.LoadoutMain:GetTall() - (GAMEMODE.TitleBar / 2) - 8 )
        surface.DrawLine( self.LoadoutMain:GetWide() / 5, GAMEMODE.TitleBar, self.LoadoutMain:GetWide() / 5, self.LoadoutMain:GetTall() - (GAMEMODE.TitleBar / 2) )
        surface.DrawLine( self.LoadoutMain:GetWide() / 5 * 2, GAMEMODE.TitleBar, self.LoadoutMain:GetWide() / 5 * 2, self.LoadoutMain:GetTall() - (GAMEMODE.TitleBar / 2) )
        surface.DrawLine( self.LoadoutMain:GetWide() / 5 * 3, GAMEMODE.TitleBar, self.LoadoutMain:GetWide() / 5 * 3, self.LoadoutMain:GetTall() - (GAMEMODE.TitleBar / 2) )
        surface.DrawLine( self.LoadoutMain:GetWide() / 5 * 4, GAMEMODE.TitleBar, self.LoadoutMain:GetWide() / 5 * 4, self.LoadoutMain:GetTall() - (GAMEMODE.TitleBar / 2) )
    end
    self.LoadoutMain.PaintOver = function()
        surface.SetTexture( GAMEMODE.GradientTexture )
        surface.SetDrawColor( 0, 0, 0, 164 )
        surface.DrawTexturedRectRotated( self.LoadoutMain:GetWide() / 2, self.LoadoutMain:GetTall() - ( self.TitleBar / 2 ) - 4, 8, self.LoadoutMain:GetWide(), 90 )
        surface.DrawTexturedRectRotated( self.LoadoutMain:GetWide() / 2, self.TitleBar + 4, 8, self.LoadoutMain:GetWide(), -90 )
        surface.DrawTexturedRectRotated( self.LoadoutMain:GetWide() / 10 * 9, self.LoadoutMain:GetTall() - (self.TitleBar * 1.5) - 4, 8, self.LoadoutMain:GetWide() / 5, 90 )
    end

    local back = vgui.Create( "DButton", self.LoadoutMain )
    back:SetSize( 40, 40 )
    back:SetPos( 8, 8 )
    back:SetText( "" )
    back.DoClick = function()
        self.LoadoutMain:Close()
        self.TeamColor = self.oldcolor
        GAMEMODE:MenuMain()
    end
    back.Paint = function()
        if back.hover then
            surface.SetDrawColor( colorScheme[ switchingTo ].ButtonIndicator )
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

    local close = vgui.Create( "DButton", self.LoadoutMain )
    close:SetSize( 40, 40 )
    close:SetPos( self.LoadoutMain:GetWide() - 8 - close:GetWide(), 8 )
    close:SetText( "" )
    close.DoClick = function()
        self.LoadoutMain:Close()
        self.TeamColor = self.oldcolor
    end
    close.Paint = function()
        if close.hover then
            surface.SetDrawColor( colorScheme[ switchingTo ].ButtonIndicator )
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

    local PMPanel = vgui.Create( "PlayermodelPanel", self.LoadoutMain )
    PMPanel:SetSize( self.LoadoutMain:GetWide() / 5, self.LoadoutMain:GetTall() - (self.TitleBar * 1.5) )
    PMPanel:SetPos( 0, self.TitleBar )
    PMPanel:SetDefaultModel( self.DefaultModels[ team.GetName( switchingTo ) ][ math.random( #self.DefaultModels[ team.GetName( switchingTo ) ] ) ] )
    PMPanel:SetModel( nil, "models/weapons/w_rif_m4a1.mdl" )
    PMPanel:SetFOV( 60 )
    PMPanel.PaintOver = function( _, w, h )
        --surface.SetDrawColor(0, 0, 0)
        --surface.DrawOutlinedRect(0, 0, w, h)
    end
    self.LoadoutMain.PMPanel = PMPanel

    function self.LoadoutMain:ResetPMSelectionButton()
        if self.PMSelection and self.PMSelection:IsValid() then
            self.PMSelection:Remove()
        end
        if self.PMOptions and self.PMOptions:IsValid() then
            self.PMOptions:Remove()
        end

        local PMSelection = vgui.Create( "PlayermodelPanelModels", self )
        PMSelection:SetSize( self.PMPanel:GetWide(), GAMEMODE.TitleBar / 2)
        PMSelection:SetPos( 0, GAMEMODE.TitleBar + self.PMPanel:GetTall() - PMSelection:GetTall() )
        PMSelection:SetModels( GAMEMODE.MyModels )
        PMSelection:SetTrueParent( self.PMPanel )
        --self.PMPanel:SetOptionsPanel( PMSelection:GetMovingPanel() )
        self.PMSelection = PMSelection

        local PMOptions = vgui.Create( "PlayermodelPanelOptions", self )
        PMOptions:SetSize( self.PMPanel:GetWide(), PMPanel:GetTall() / 4 ) --Unfortunately, the height of the options panel needs to be manually set since I don't know how to scale it with self.LoadoutMain
        PMOptions:SetPos( 0, GAMEMODE.TitleBar )
        PMOptions:SetModelPanel( self.PMPanel )
        self.PMPanel:SetOptionsButton( PMOptions )
        self.PMOptions = PMOptions
    end

    local PPanel = vgui.Create( "PrimariesPanel", self.LoadoutMain )
    PPanel:SetSize( self.LoadoutMain:GetWide() / 5, self.LoadoutMain:GetTall() - (GAMEMODE.TitleBar * 1.5) )
    PPanel:SetPos( self.LoadoutMain:GetWide() / 5, GAMEMODE.TitleBar )
    PPanel:SetReferenceModelPanel( self.LoadoutMain.PMPanel )
    PPanel:DoSetup()

    local SPanel = vgui.Create( "SecondariesPanel", self.LoadoutMain )
    SPanel:SetSize( self.LoadoutMain:GetWide() / 5, self.LoadoutMain:GetTall() - (GAMEMODE.TitleBar * 1.5) )
    SPanel:SetPos( self.LoadoutMain:GetWide() / 5 * 2, GAMEMODE.TitleBar )
    SPanel:DoSetup()

    local EPanel = vgui.Create( "EquipmentPanel", self.LoadoutMain )
    EPanel:SetSize( self.LoadoutMain:GetWide() / 5, self.LoadoutMain:GetTall() - (GAMEMODE.TitleBar * 1.5) )
    EPanel:SetPos( self.LoadoutMain:GetWide() / 5 * 3, GAMEMODE.TitleBar )
    EPanel:DoSetup()

    local PerkPanel = vgui.Create( "PerksPanel", self.LoadoutMain )
    PerkPanel:SetSize( self.LoadoutMain:GetWide() / 5, self.LoadoutMain:GetTall() - (GAMEMODE.TitleBar * 1.5) )
    PerkPanel:SetPos( self.LoadoutMain:GetWide() / 5 * 4, GAMEMODE.TitleBar )
    PerkPanel:DoSetup()

    local AcceptButton = vgui.Create( "LoganButton", self.LoadoutMain )
    AcceptButton:SetSize( self.LoadoutMain:GetWide() / 5, GAMEMODE.TitleBar )
    AcceptButton:SetPos( self.LoadoutMain:GetWide() / 5 * 4, PerkPanel:GetTall() )
    local todisplay = "Set Loadout"
    if LocalPlayer():Team() != 1 and LocalPlayer():Team() != 2 then todisplay = "Spawn" end
    AcceptButton.Paint = function( panel, w, h )
        surface.SetDrawColor( GAMEMODE.TeamColor )
        surface.DrawRect( 0, 0, AcceptButton:GetWide(), AcceptButton:GetTall() )
        surface.SetFont( "Exo-32-400" )
        local w, h = surface.GetTextSize( todisplay )
        surface.SetTextPos( AcceptButton:GetWide() / 2 - (w / 2), AcceptButton:GetTall() / 2 - (h / 2) - 4 )
        surface.SetTextColor( 255, 255, 255 )
        if AcceptButton.hover then
            surface.SetTextColor( colorScheme[ switchingTo ].ButtonIndicator )
        end
        surface.DrawText( todisplay )

        surface.SetDrawColor( 66, 66, 66 )
        surface.DrawLine( 0, 0, 0, AcceptButton:GetTall() )

        --[[surface.SetDrawColor( 88, 88, 88 )
        if AcceptButton.hover then
            surface.SetDrawColor( GAMEMODE.TeamColor )
        end
        surface.SetMaterial( GAMEMODE.typematerials.ar )
        surface.DrawTexturedRect( AcceptButton:GetWide() / 2 + (w / 2), AcceptButton:GetTall() / 2 - 24, 48, 48 )
        surface.DrawTexturedRectUV( AcceptButton:GetWide() / 2 + (w / 2) - 4, AcceptButton:GetTall() / 2 - 24, 48, 48, 1, 0, 0, 1 )
        surface.DrawTexturedRect( AcceptButton:GetWide() / 2 - (w / 2) - 48, AcceptButton:GetTall() / 2 - 24, 48, 48 )
        surface.DrawTexturedRectUV( AcceptButton:GetWide() / 2 - (w / 2) - 48 - 4, AcceptButton:GetTall() / 2 - 24, 48, 48, 1, 0, 0, 1 )]]
        return true
    end
    AcceptButton.DoClick = function()
        surface.PlaySound( GAMEMODE.ButtonSounds.Accept[ math.random( #GAMEMODE.ButtonSounds.Accept ) ] )

        local tosend = {}
        tosend[1] = { PPanel.selectedweapon or "cw_ar15" }
        tosend[2] = { SPanel.selectedweapon or "" }
        tosend[3] = EPanel.selectedweapon or ""
        tosend[4] = PerkPanel.selectedperk or ""
        tosend[5] = { PMPanel.model, PMPanel.EntitySkin or 0, PMPanel.EntityBodygroup }

        net.Start( "SetLoadout" )
            net.WriteTable( tosend )
        net.SendToServer()

        if switchingTo != LocalPlayer():Team() then
            RunConsoleCommand( "tdm_setteam", tostring( switchingTo ) )
        else
            chat.AddText( "Your loadout will be given on your next spawn" )
        end
        self.LoadoutMain:Close()
    end
end

surface.CreateFont( "ExoTitleFont" , { font = "Exo 2", size = 20, weight = 400 } )
surface.CreateFont( "ExoInfoFont", { font = "Exo 2", size = 24, weight = 400 } )