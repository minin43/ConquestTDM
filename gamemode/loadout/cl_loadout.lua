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
        if self.LoadoutMainPPanel then
            self.LoadoutMainPPanel:SetSkins( self.MySkins )
            --self.LoadoutMainPPanel:DrawSkinsButton()
        end
        if self.LoadoutMainSPanel then
            self.LoadoutMainSPanel:SetSkins( self.MySkins )
            --self.LoadoutMainSPanel:DrawSkinsButton()
        end
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

        --If we have new unlocks
        if self.NotifyUnlocks and self.NotifyUnlocks > 0 then
            local text = "weapon"
            if self.NotifyUnlocks > 1 then text = "weapons" end
            local w, h = surface.GetTextSize( "You've unlocked " .. self.NotifyUnlocks .. " new " .. text .. " in the shop!")
            surface.SetTextPos( self.LoadoutMain:GetWide() / 2 - (w / 2), self.LoadoutMain:GetTall() - ( self.TitleBar / 2 ) + 4 )
            local fade = math.abs(math.sin(CurTime() * 4))
            local crazycolor = Color( colorScheme[switchingTo].ButtonIndicator.r + ((255 - colorScheme[switchingTo].ButtonIndicator.r) * fade), colorScheme[switchingTo].ButtonIndicator.g + ((255 - colorScheme[switchingTo].ButtonIndicator.g) * fade), colorScheme[switchingTo].ButtonIndicator.b + ((255 - colorScheme[switchingTo].ButtonIndicator.b) * fade) )
            surface.SetTextColor( crazycolor )
            surface.DrawText( "You've unlocked " .. self.NotifyUnlocks .. " new " .. text .. " in the shop!" )
        end
        surface.SetTextColor( Color( 255, 255, 255 ) )

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
    if self.LastSentLoadout then
        if IsDefaultModel(self.LastSentLoadout[5][1]) then
            PMPanel:SetModel( nil, "models/weapons/w_rif_m4a1.mdl" )
        else
            PMPanel:SetModel( self.LastSentLoadout[5][1], "models/weapons/w_rif_m4a1.mdl" )
        end
        PMPanel:SetSkin( self.LastSentLoadout[5][2] )

        if self.LastSentLoadout[5][3] then
            for k, v in pairs( self.LastSentLoadout[5][3] ) do
                PMPanel:SetBodygroup( k, v )
            end
        end
    else
        PMPanel:SetModel( nil, "models/weapons/w_rif_m4a1.mdl" )
    end
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
        PMSelection:SetSize( self.PMPanel:GetWide(), GAMEMODE.TitleBar )
        PMSelection:SetPos( 0, GAMEMODE.TitleBar + self.PMPanel:GetTall() - PMSelection:GetTall() )
        PMSelection:SetModels( GAMEMODE.MyModels )
        PMSelection:SetTrueParent( self.PMPanel )
        --self.PMPanel:SetOptionsPanel( PMSelection:GetMovingPanel() )
        self.PMSelection = PMSelection

        local PMOptions = vgui.Create( "PlayermodelPanelOptions", self )
        PMOptions:SetSize( self.PMPanel:GetWide(), PMPanel:GetTall() / 4 )
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
    self.LoadoutMainPPanel = PPanel

    local SPanel = vgui.Create( "SecondariesPanel", self.LoadoutMain )
    SPanel:SetSize( self.LoadoutMain:GetWide() / 5, self.LoadoutMain:GetTall() - (GAMEMODE.TitleBar * 1.5) )
    SPanel:SetPos( self.LoadoutMain:GetWide() / 5 * 2, GAMEMODE.TitleBar )
    SPanel:DoSetup()
    self.LoadoutMainSPanel = SPanel

    local EPanel = vgui.Create( "EquipmentPanel", self.LoadoutMain )
    EPanel:SetSize( self.LoadoutMain:GetWide() / 5, self.LoadoutMain:GetTall() - (GAMEMODE.TitleBar * 1.5) )
    EPanel:SetPos( self.LoadoutMain:GetWide() / 5 * 3, GAMEMODE.TitleBar )
    EPanel:DoSetup()
    self.LoadoutMainEPanel = EPanel

    local PerkPanel = vgui.Create( "PerksPanel", self.LoadoutMain )
    PerkPanel:SetSize( self.LoadoutMain:GetWide() / 5, self.LoadoutMain:GetTall() - (GAMEMODE.TitleBar * 1.5) )
    PerkPanel:SetPos( self.LoadoutMain:GetWide() / 5 * 4, GAMEMODE.TitleBar )
    PerkPanel:DoSetup()
    self.LoadoutMainPerkPanel = PerkPanel

    timer.Simple( 0.2, function()
        if !self.LoadoutMain then return end

        if self.LastSentLoadout then
            if self.LastSentLoadout[1][1] and PPanel.scrollpanel.buttons[ self.LastSentLoadout[1][1] ] then
                PPanel.scrollpanel:ScrollToChild( PPanel.scrollpanel.buttons[ self.LastSentLoadout[1][1] ] )
                PPanel:SelectWeapon( self.LastSentLoadout[1][1] )
                PPanel:SelectSkin( self.LastSentLoadout[1][2] or "" )
            end
            if self.LastSentLoadout[2][1] and SPanel.scrollpanel.buttons[ self.LastSentLoadout[2][1] ] then
                SPanel.scrollpanel:ScrollToChild( SPanel.scrollpanel.buttons[ self.LastSentLoadout[2][1] ] )
                SPanel:SelectWeapon( self.LastSentLoadout[2][1] )
                SPanel:SelectSkin( self.LastSentLoadout[2][2] or "" )
            end
            if self.LastSentLoadout[3] and EPanel.scrollpanel.buttons[ self.LastSentLoadout[3] ] then
                EPanel.scrollpanel:ScrollToChild( EPanel.scrollpanel.buttons[ self.LastSentLoadout[3] ] )
                EPanel:SelectWeapon( self.LastSentLoadout[3] )
            end
            if self.LastSentLoadout[4] and PerkPanel.scrollpanel.buttons[ self.LastSentLoadout[4] ] then
                PerkPanel.scrollpanel:ScrollToChild( PerkPanel.scrollpanel.buttons[ self.LastSentLoadout[4] ] )
                PerkPanel:SelectPerk( GetPerkTable(self.LastSentLoadout[4]) )
            end
        end
    end )

    local canPrestige = GAMEMODE.MyLevel >= 100
	local PrestigeButton = vgui.Create( "DButton", GAMEMODE.LoadoutMain )
	PrestigeButton:SetSize( EPanel:GetWide(), GAMEMODE.TitleBar )
    PrestigeButton:SetPos( GAMEMODE.LoadoutMain:GetWide() / 5 * 3, GAMEMODE.TitleBar + EPanel:GetTall() - PrestigeButton:GetTall() )
    PrestigeButton.Paint = function()
        if canPrestige then
            surface.SetDrawColor( GAMEMODE.TeamColor )
            surface.DrawRect( 0, 0, PrestigeButton:GetWide(), PrestigeButton:GetTall() )
            surface.SetTextColor( 255, 255, 255 )
            surface.SetFont( "Exo-32-400" )
            local w, h = surface.GetTextSize( "Prestige" )
            surface.SetTextPos( PrestigeButton:GetWide() / 2 - (w / 2), PrestigeButton:GetTall() / 2 - (h / 2) - 4 ) 
        else
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawRect( 0, 0, PrestigeButton:GetWide(), PrestigeButton:GetTall() )
            surface.SetTextColor( 0, 0, 0, 200 )
            surface.SetFont( "Exo-24-400" )
            local w, h = surface.GetTextSize( "Prestige" )
            surface.SetTextPos( PrestigeButton:GetWide() / 2 - (w / 2), PrestigeButton:GetTall() / 2 - (h / 2) )
        end
        
        if PrestigeButton.hover then
            surface.SetTextColor( colorScheme[ switchingTo ].ButtonIndicator )
        end
        surface.DrawText( "Prestige" )

        surface.SetDrawColor( 0, 0, 0, 200 )
        surface.DrawLine( 0, -1, 0, PrestigeButton:GetTall() )
		return true
	end
    PrestigeButton.OnCursorEntered = function()
        if canPrestige then
            PrestigeButton.hover = true
        end
	end
	PrestigeButton.OnCursorExited = function()
		PrestigeButton.hover = false
	end
    PrestigeButton.DoClick = function()
        if canPrestige then
            GAMEMODE.LoadoutMain:Close()
            OpenConfirmationPanel()
            surface.PlaySound( GAMEMODE.ButtonSounds.Accept[ math.random( #GAMEMODE.ButtonSounds.Accept ) ] )
        else
            surface.PlaySound( GAMEMODE.ButtonSounds.Deny[ math.random( #GAMEMODE.ButtonSounds.Deny ) ] )
        end
	end

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

        surface.SetDrawColor( 0, 0, 0, 200 )
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
        tosend[1] = { PPanel.selectedweapon or "cw_ar15", PPanel.selectedskin }
        tosend[2] = { SPanel.selectedweapon, SPanel.selectedskin }
        tosend[3] = EPanel.selectedweapon
        tosend[4] = PerkPanel.selectedperk
        tosend[5] = { PMPanel.model, PMPanel.EntitySkin or 0, PMPanel.EntityBodygroup }
        GAMEMODE.LastSentLoadout = tosend

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

--The old prestige shit I wrote for the old loadoutmenu, adapted for the current one. Just got really lazy and didn't want to rewrite any of this
function OpenConfirmationPanel()
    confirmationpanel = vgui.Create( "DFrame" )
    confirmationpanel:SetSize( 450, 180 )
    confirmationpanel:SetTitle( "" )
    confirmationpanel:SetVisible( true )
    confirmationpanel:SetDraggable( false )
    confirmationpanel:ShowCloseButton( false )
    confirmationpanel:Center()
    confirmationpanel.Think = function()
        confirmationpanel:MakePopup()
    end
    confirmationpanel.Paint = function()
        Derma_DrawBackgroundBlur( confirmationpanel, CurTime() )
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawRect( 0, 0, confirmationpanel:GetWide(), confirmationpanel:GetTall() )
        surface.SetDrawColor( GAMEMODE.TeamColor )
        surface.DrawRect( 0, 0, confirmationpanel:GetWide(), 56 )
        surface.SetFont( "Exo 2" )
        surface.SetTextColor( Color( 255, 255, 255 ) )
        surface.SetTextPos( confirmationpanel:GetWide() / 2 - surface.GetTextSize("Prestige") / 2, 16 )
        surface.DrawText( "Prestige" )
        surface.SetTexture( gradient )

        draw.SimpleText( "Are you sure you wish to prestige?", "Exo 2", confirmationpanel:GetWide() / 2, confirmationpanel:GetTall() / 2 - 5, GAMEMODE.TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText( "This cannot be undone!", "Exo 2", confirmationpanel:GetWide() / 2, confirmationpanel:GetTall() / 2 + 20, GAMEMODE.TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    confirmationpanel.PaintOver = function()
        surface.SetTexture( gradient )
        surface.SetDrawColor( 0, 0, 0, 164 )
        surface.DrawTexturedRectRotated( confirmationpanel:GetWide() / 2, 56 + 4, 8, confirmationpanel:GetWide(), 270 )
    end
    confirmationpanel.OnClose = function()
        confirmationpanel:Remove()
        confirmationpanel = nil
    end

    local acceptbutton = vgui.Create( "DButton", confirmationpanel )
    acceptbutton:SetSize( 64, 36 )
    acceptbutton:SetPos( 32, confirmationpanel:GetTall() - acceptbutton:GetTall() - 8 )
    acceptbutton:SetText( "" )
    acceptbutton.Paint = function()
        if acceptbutton.Hover then
            draw.RoundedBox( 4, 0, 0, acceptbutton:GetWide(), acceptbutton:GetTall(), Color( 0, 0, 0, 255 * 0.2 ) )
        end
        if acceptbutton.Click then
            draw.RoundedBox( 4, 0, 0, acceptbutton:GetWide(), acceptbutton:GetTall(), Color( 0, 0, 0, 255 * 0.2 ) )
        end
        draw.SimpleText( "CONFIRM", "Exo 2 Button", acceptbutton:GetWide() / 2, acceptbutton:GetTall() / 2, GAMEMODE.TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        return true
    end
    acceptbutton.OnCursorEntered = function()
        acceptbutton.Hover = true
    end
    acceptbutton.OnCursorExited = function()
        acceptbutton.Hover = false
    end
    acceptbutton.OnMousePressed = function()
        --LocalPlayer():EmitSound( "buttons/button22.wav" )
        acceptbutton.Click = true
    end
    acceptbutton.OnMouseReleased = function()
        acceptbutton.Click = false

        if acceptbutton.once then return end
        acceptbutton.once = true
        net.Start( "PlayerAttemptPrestige" )
        net.SendToServer()
        
        net.Receive( "AttemptPrestigeCallback", function()
            GAMEMODE.MyPrestigeTokens = net.ReadInt( 16 )
            DoClientPrestige( GAMEMODE.MyPrestigeTokens )
        end )
    end
    
    local cancelbutton = vgui.Create( "DButton", confirmationpanel )
    cancelbutton:SetSize( 64, 36 )
    cancelbutton:SetPos( confirmationpanel:GetWide() - cancelbutton:GetWide() - 32, confirmationpanel:GetTall() - cancelbutton:GetTall() - 8 )
    cancelbutton:SetText( "" )
    cancelbutton.Paint = function()
        if cancelbutton.Hover then
            draw.RoundedBox( 4, 0, 0, cancelbutton:GetWide(), cancelbutton:GetTall(), Color( 0, 0, 0, 255 * 0.2 ) )
        end
        if cancelbutton.Click then
            draw.RoundedBox( 4, 0, 0, cancelbutton:GetWide(), cancelbutton:GetTall(), Color( 0, 0, 0, 255 * 0.2 ) )
        end
        draw.SimpleText( "CANCEL", "Exo 2 Button", cancelbutton:GetWide() / 2, cancelbutton:GetTall() / 2, GAMEMODE.TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        return true
    end
    cancelbutton.OnCursorEntered = function()
        cancelbutton.Hover = true
    end
    cancelbutton.OnCursorExited = function()
        cancelbutton.Hover = false
    end
    cancelbutton.OnMousePressed = function()
        LocalPlayer():EmitSound( "buttons/button22.wav" )
        cancelbutton.Click = true
    end
    cancelbutton.OnMouseReleased = function()
        cancelbutton.Click = false
        confirmationpanel:Close()
        confirmationpanel = nil
    end

    function DoClientPrestige( Tokens )
        acceptbutton:Remove()
        cancelbutton:Remove()
        --timer.Simple( 1, function()
            confirmationpanel.Paint = function()
                if !confirmationpanel then return end
                Derma_DrawBackgroundBlur( confirmationpanel, CurTime() )
                surface.SetDrawColor( 255, 255, 255, 255 )
                surface.DrawRect( 0, 0, confirmationpanel:GetWide(), confirmationpanel:GetTall() )
                surface.SetDrawColor( GAMEMODE.TeamColor )
                surface.DrawRect( 0, 0, confirmationpanel:GetWide(), 56 )
                surface.SetFont( "Exo 2" )
                surface.SetTextColor( Color( 255, 255, 255 ) )
                surface.SetTextPos( confirmationpanel:GetWide() / 2 - surface.GetTextSize("Prestige") / 2, 16 )
                surface.DrawText( "Prestige" )
                surface.SetTexture( gradient )

                draw.SimpleText( "Prestige Succesful!", "Exo 2", confirmationpanel:GetWide() / 2, confirmationpanel:GetTall() / 2 - 5, GAMEMODE.TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                draw.SimpleText( "You have: " .. Tokens .. " prestige token(s)!", "Exo 2", confirmationpanel:GetWide() / 2, confirmationpanel:GetTall() / 2 + 35, GAMEMODE.TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end

            surface.PlaySound( "ui/challengecomplete.wav" )
        --end )

        timer.Simple( 2, function()
            ply:ConCommand( "tdm_setteam 0" )
        end )
        timer.Simple( 3, function()
            confirmationpanel:Remove()
        end )
    end
end

surface.CreateFont( "ExoTitleFont" , { font = "Exo 2", size = 20, weight = 400 } )
surface.CreateFont( "ExoInfoFont", { font = "Exo 2", size = 24, weight = 400 } )

net.Receive( "StartLoadoutDirect", function()
    GAMEMODE:LoadoutMenu()
end )

--The only hook that gets binds sent to it?
hook.Add( "PlayerBindPress", "DropWeapon", function( ply, bind, pressed )
    if ply:Alive() and (bind == "+menu" or bind == "+ctdm_dropweapon") then
        net.Start( "CTDMDropWeapon" )
        net.SendToServer()
    end
end )