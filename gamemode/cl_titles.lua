--//Normally I do setup files for menus, but I think this'll be simple enough I shouldn't need to bother with it.

GM.EquippedTitles = {}

surface.CreateFont( "TitleTitle" , { font = "Exo 2", size = 24, weight = 400 } )
surface.CreateFont( "SubTitleTitle" , { font = "Exo 2", size = 16, weight = 500 } )
surface.CreateFont( "DescTitle" , { font = "Exo 2", size = 16, weight = 550 } )

function GM:OpenTitles()
    if self.TitleMain and self.TitleMain:IsValid() then return end

    self.TitleMain = vgui.Create( "DFrame" )
    self.TitleMain:SetSize( 600, 500 )
	self.TitleMain:SetTitle( "" )
	self.TitleMain:SetVisible( true )
	self.TitleMain:SetDraggable( false )
	self.TitleMain:ShowCloseButton( false )
	self.TitleMain:Center()
	self.TitleMain:MakePopup()
	self.TitleMain.Think = function()
		self.TitleMain.x, self.TitleMain.y = self.TitleMain:GetPos()
    end
    self.TitleMainTitleBar = 56
    self.TitleMain.Paint = function()
        Derma_DrawBackgroundBlur( self.TitleMain, CurTime() )
		surface.SetDrawColor( self.TeamColor )
		surface.DrawRect( 0, 0, self.TitleMain:GetWide(), self.TitleMainTitleBar )

        surface.SetFont( "Exo 2" )
		surface.SetTextColor( Color( 255, 255, 255 ) )
		surface.SetTextPos( self.TitleMain:GetWide() / 2 - surface.GetTextSize("Achievement Titles") / 2, 16 )
		surface.DrawText( "Achievement Titles" )

		surface.SetDrawColor( Color( 255, 255, 255 ) )
		surface.DrawRect( 0, self.TitleMainTitleBar, self.TitleMain:GetWide(), self.TitleMain:GetTall() )

        surface.SetDrawColor( self.TeamColor )
        surface.DrawLine( self.TitleMain:GetWide() / 2, self.TitleMainTitleBar + 4, self.TitleMain:GetWide() / 2, self.TitleMain:GetTall() - 4 )
    
        surface.SetTexture( GAMEMODE.GradientTexture )
        surface.SetDrawColor( 0, 0, 0, 164 )
        surface.DrawTexturedRectRotated( self.TitleMain:GetWide() / 2, self.TitleMainTitleBar + 4, 8, self.TitleMain:GetWide(), 270 )
    end

    local back = vgui.Create( "DButton", self.TitleMain )
    back:SetSize( 40, 40 )
    back:SetPos( 8, 8 )
    back:SetText( "" )
    back.DoClick = function()
        self.TitleMain:Close()
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

    local close = vgui.Create( "DButton", self.TitleMain )
    close:SetSize( 40, 40 )
    close:SetPos( self.TitleMain:GetWide() - 8 - close:GetWide(), 8 )
    close:SetText( "" )
    close.DoClick = function()
        self.TitleMain:Close()
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

    self.TitleUnlockedList = vgui.Create( "DScrollPanel", self.TitleMain )
    self.TitleUnlockedList:SetPos( 2, self.TitleMainTitleBar )
    self.TitleUnlockedList:SetSize( self.TitleMain:GetWide() / 2 - 4, self.TitleMain:GetTall() - self.TitleMainTitleBar )

    self.TitleLockedList = vgui.Create( "DScrollPanel", self.TitleMain )
    self.TitleLockedList:SetPos( self.TitleMain:GetWide() / 2 + 2, self.TitleMainTitleBar )
    self.TitleLockedList:SetSize( self.TitleMain:GetWide() / 2 - 4, self.TitleMain:GetTall() - self.TitleMainTitleBar )

    local ScrollBar = self.TitleUnlockedList:GetVBar()
	ScrollBar.Paint = function() end
	ScrollBar.btnUp.Paint = function() end
	ScrollBar.btnDown.Paint = function() end
	function ScrollBar.btnGrip:Paint( w, h )
		draw.RoundedBox( 4, 7, 0, w / 2, h, Color( 0, 0, 0, 128 ) )
	end

    ScrollBar = self.TitleLockedList:GetVBar()
	ScrollBar.Paint = function() end
	ScrollBar.btnUp.Paint = function() end
	ScrollBar.btnDown.Paint = function() end
	function ScrollBar.btnGrip:Paint( w, h )
		draw.RoundedBox( 4, 7, 0, w / 2, h, Color( 0, 0, 0, 128 ) )
	end

    --//Bad programming habbit to get into, doing this below, these should be custom elements. Laziness just prevails
    local function SetupLists()
        for k, v in pairs( self.UnlockedTitles ) do
            if k == 1 then
                local titlepanel = vgui.Create( "DPanel", self.TitleUnlockedList )
                titlepanel:SetSize( self.TitleUnlockedList:GetWide(), 32 )
                titlepanel:Dock( TOP )
                titlepanel.Paint = function()
                    surface.SetTextColor( GAMEMODE.TeamColor )
                    surface.SetFont( "TitleTitle" )
                    local wide, tall = surface.GetTextSize("UNLOCKED TITLES")
                    surface.SetTextPos( titlepanel:GetWide() / 2 - ( wide / 2 ), titlepanel:GetTall() / 2 - ( tall / 2 ) )
                    surface.DrawText( "UNLOCKED TITLES" )

                    surface.SetDrawColor( GAMEMODE.TeamColor )
                    surface.DrawLine( titlepanel:GetWide() / 2 - ( wide / 2 ) - 2, titlepanel:GetTall() / 2 + ( tall / 2 ) + 2, titlepanel:GetWide() / 2 + ( wide / 2 ) + 2, titlepanel:GetTall() / 2 + ( tall / 2 ) + 2 )
                end
            end

            local pan = vgui.Create( "DPanel", self.TitleUnlockedList )
            local markupobj = markup.Parse( "<font=DescTitle><colour=0,0,0>" .. v.description .. ".", self.TitleLockedList:GetWide() - 110 )
            local tall = markupobj:GetHeight()
            pan:SetSize( self.TitleLockedList:GetWide(), 50 + tall )
            --pan:SetSize( self.TitleUnlockedList:GetWide(), 50 )
            pan:Dock( TOP )
            pan.Think = function()
                if self.CurrentTitle == v.id then
                    pan.equipped = true
                else
                    pan.equipped = false
                end
            end
            pan.Paint = function()
                --[[if pan.equipped then
                    --//Icon should be sized 32, 8 space buffer
                end]]
                surface.SetTexture( GAMEMODE.GradientTexture )
                surface.SetDrawColor( GAMEMODE.ColorRarities[ v.rare ] )
                surface.DrawTexturedRectRotated( pan:GetWide() / 2, pan:GetTall() / 2, pan:GetWide(), pan:GetTall() - 4, 180 )

                surface.SetTextColor( GAMEMODE.TeamColor )
                surface.SetFont( "TitleTitle" )
                surface.SetTextPos( 8, 4 )
                surface.DrawText( v.title )

                markupobj:Draw( 12, 4 + 24 + 4, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
            end

            local but = vgui.Create( "DButton", pan )
            but:SetSize( 90, pan:GetTall() / 3 )
            but:SetPos( pan:GetWide() - but:GetWide() - 16, pan:GetTall() / 2 - ( but:GetTall() / 2 ) )
            but:SetText( "" )
            but.Paint = function()
                if pan.equipped then
                    but.displaytext = "EQUIPPED"
                else
                    but.displaytext = "UNSELECTED"
                end

                if but.hover and not pan.equipped then
                    draw.RoundedBox( 4, 2, 2, but:GetWide() - 4, but:GetTall() - 4, Color( 0, 0, 0, 51 ) )
                end
                draw.SimpleText( but.displaytext, "SubTitleTitle", but:GetWide() / 2, but:GetTall() / 2, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end
            but.DoClick = function()
                if pan.equipped then return end
                surface.PlaySound( GAMEMODE.ButtonSounds.Accept[ math.random( #GAMEMODE.ButtonSounds.Accept ) ] )
                net.Start( "EquipTitle" )
                    net.WriteString( v.id )
                net.SendToServer()
            end
            but.OnCursorEntered = function()
                but.hover = true
            end
            but.OnCursorExited = function()
                but.hover = false
            end
        end
        if #self.UnlockedTitles == 0 then
            local nothinghere = vgui.Create( "DPanel", self.TitleUnlockedList )
            nothinghere:SetSize( self.TitleUnlockedList:GetWide(), 32 )
            nothinghere:SetPos( 0, self.TitleUnlockedList:GetTall() / 2 - ( nothinghere:GetTall() / 2 ) )
            nothinghere.Paint = function()
                surface.SetTextColor( GAMEMODE.TeamColor )
                surface.SetFont( "TitleTitle" )
                local wide, tall = surface.GetTextSize("NOTHING HERE")
                surface.SetTextPos( nothinghere:GetWide() / 2 - ( wide / 2 ), nothinghere:GetTall() / 2 - ( tall / 2 ) )
                surface.DrawText( "NOTHING HERE" )
            end
        end

        for k, v in pairs( self.LockedTitles ) do
            if not v.noshow then
                if k == 1 then
                    local titlepanel = vgui.Create( "DPanel", self.TitleLockedList )
                    titlepanel:SetSize( self.TitleLockedList:GetWide(), 32 )
                    titlepanel:Dock( TOP )
                    titlepanel.Paint = function()
                        surface.SetTextColor( GAMEMODE.TeamColor )
                        surface.SetFont( "TitleTitle" )
                        local wide, tall = surface.GetTextSize("LOCKED TITLES")
                        surface.SetTextPos( titlepanel:GetWide() / 2 - ( wide / 2 ), titlepanel:GetTall() / 2 - ( tall / 2 ) )
                        surface.DrawText( "LOCKED TITLES" )
                        
                        surface.SetDrawColor( GAMEMODE.TeamColor )
                        surface.DrawLine( titlepanel:GetWide() / 2 - ( wide / 2 ) - 2, titlepanel:GetTall() / 2 + ( tall / 2 ) + 2, titlepanel:GetWide() / 2 + ( wide / 2 ) + 2, titlepanel:GetTall() / 2 + ( tall / 2 ) + 2 )
                    end
                end

                local pan = vgui.Create( "DPanel", self.TitleLockedList )
                --local markupobj = markup.Parse( "<font=DescTitle><colour=" .. GAMEMODE.TeamColor.r .. "," .. GAMEMODE.TeamColor.g .. "," .. GAMEMODE.TeamColor.b .. ">" .. v.description .. ".", self.TitleLockedList:GetWide() - 24 )
                local markupobj = markup.Parse( "<font=DescTitle><colour=0,0,0>" .. v.description .. ".", self.TitleLockedList:GetWide() - 24 )
                local tall = markupobj:GetHeight()
                pan:SetSize( self.TitleLockedList:GetWide(), 56 + tall )
                pan:Dock( TOP )
                pan.Paint = function()
                    surface.SetTexture( GAMEMODE.GradientTexture )
                    surface.SetDrawColor( GAMEMODE.ColorRarities[ v.rare ] )
                    surface.DrawTexturedRectRotated( pan:GetWide() / 2, pan:GetTall() / 2, pan:GetWide(), pan:GetTall() - 4, 180 )
                    --surface.DrawTexturedRectRotated(number x, number y, number width, number height, number rotation)
                    
                    surface.SetTextColor( GAMEMODE.TeamColor )
                    surface.SetFont( "TitleTitle" )
                    surface.SetTextPos( 8, 4 )
                    surface.DrawText( v.title )

                    --[[surface.SetFont( "DescTitle" )
                    surface.SetTextPos( 12, pan:GetTall() - 4 - 16 - 2 - 14 )
                    surface.DrawText( v.description .. "." )]]
                    markupobj:Draw( 12, 4 + 24 + 4, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

                    surface.SetFont( "SubTitleTitle" )
                    surface.SetTextPos( 16, pan:GetTall() - 4 - 16 )
                    surface.DrawText( v.cur .. " of " .. v.req .. "." )

                    surface.SetDrawColor( 0, 0, 0 )
                    local wide = surface.GetTextSize( v.cur .. " of " .. v.req .. "." )
                    surface.DrawOutlinedRect( 16 + wide + 8, pan:GetTall() - 4 - 16, pan:GetWide() - 16 - wide - 16, 16 )
                    surface.SetDrawColor( self.TeamColor )
                    surface.DrawRect( 16 + wide + 8 + 1, pan:GetTall() - 4 - 16 + 1, math.Clamp( v.cur / v.req, 0, 1) * ( pan:GetWide() - 16 - wide - 14 ), 14 )
                end
            end
        end
        if #self.LockedTitles == 0 then
            local nothinghere = vgui.Create( "DPanel", self.TitleLockedList )
            nothinghere:SetSize( self.TitleLockedList:GetWide(), 32 )
            nothinghere:SetPos( 0, self.TitleLockedList:GetTall() / 2 - ( nothinghere:GetTall() / 2 ) )
            nothinghere.Paint = function()
                surface.SetTextColor( GAMEMODE.TeamColor )
                surface.SetFont( "TitleTitle" )
                local wide, tall = surface.GetTextSize("NOTHING HERE")
                surface.SetTextPos( nothinghere:GetWide() / 2 - ( wide / 2 ), nothinghere:GetTall() / 2 - ( tall / 2 ) )
                surface.DrawText( "NOTHING HERE" )
            end
        end
    end

    self.UnlockedTitles = {}
    self.LockedTitles = {}
    --//May cause some lag, should look into possible work-arounds if necessary
    for k, v in pairs( self.TitleMasterTable ) do
        net.Start( v.id .. "Status" )
        net.SendToServer()

        net.Receive( v.id .. "StatusCallback", function()
            v.cur = net.ReadInt( 16 )
            if v.cur >= v.req then
                self.UnlockedTitles[ #self.UnlockedTitles + 1 ] = v
            else
                self.LockedTitles[ #self.LockedTitles + 1 ] = v
            end
            if k == #self.TitleMasterTable then
                SetupLists()
            end
        end )
    end

    --GAMEMODE:DrawEventStatuses( self.TitleMain )
end

net.Receive( "EquipTitleCallback", function()
    local newTitle = net.ReadString()

    if newTitle and newTitle != "" then
        GAMEMODE.CurrentTitle = GAMEMODE:GetTitleTable( newTitle ).id
    end
end )

net.Receive( "SendClientEquippedTitles", function()
    local iterations = net.ReadInt( 8 )
    for _ = 1, iterations do
        local playerID = net.ReadString()
        local titleID = net.ReadString()
        GAMEMODE.EquippedTitles[ playerID ] = titleID
    end
end )

hook.Add( "OnPlayerChat", "AppendTitlesBeforeNames", function( ply, msg, isTeam, isDead )
    local chatmessage = {}
    
    if isDead then
        chatmessage[ #chatmessage + 1 ] = Color( 255, 30, 40 )
        chatmessage[ #chatmessage + 1 ] = "*DEAD* "
    end

    if isTeam then
        chatmessage[ #chatmessage + 1 ] = Color( 30, 160, 40 )
        chatmessage[ #chatmessage + 1 ] = "( TEAM ) "
    end

    if ply and IsValid( ply ) then
        if GAMEMODE.EquippedTitles[ id( ply:SteamID() ) ] then
            local tab = GAMEMODE:GetTitleTable( GAMEMODE.EquippedTitles[ id( ply:SteamID() ) ] )
            chatmessage[ #chatmessage + 1 ] = GAMEMODE.ColorRarities[ tab.rare ]
            chatmessage[ #chatmessage + 1 ] = "[" .. tab.title .. "] "
        end

        if isDead then
            chatmessage[ #chatmessage + 1 ] = Color( 255, 30, 40 )
        elseif isTeam then
            chatmessage[ #chatmessage + 1 ] = Color( 30, 160, 40 )
        else
            chatmessage[ #chatmessage + 1 ] = Color( 255, 255, 255 )
        end

        chatmessage[ #chatmessage + 1 ] = ply
    else
        chatmessage[ #chatmessage + 1 ] = "Console"
    end

    chatmessage[ #chatmessage + 1 ] = Color( 255, 255, 255 )
    chatmessage[ #chatmessage + 1 ] = ": " .. msg

    chat.AddText( unpack( chatmessage ) )

    return true
end )