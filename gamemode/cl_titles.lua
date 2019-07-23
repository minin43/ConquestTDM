--//Normally I do setup files for menus, but I think this'll be simple enough I shouldn't need to bother with it.

function GM:OpenTitles()
    if self.TitleMain and self.TitleMain:IsValid() then return end

    self.TitleMain = vgui.Create( "DFrame" )
    self.TitleMain:SetSize( 450, 300 )
	self.TitleMain:SetTitle( "" )
	self.TitleMain:SetVisible( true )
	self.TitleMain:SetDraggable( false )
	--self.TitleMain:ShowCloseButton( false )
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
    end

    self.TitleUnlockedList = vgui.Create( "DScrollPanel", self.TitleMain )
    self.TitleUnlockedList:SetPos( 0, self.TitleMainTitleBar )
    self.TitleUnlockedList:SetSize( self.TitleMain:GetWide() / 2, self.TitleMain:GetTall() - self.TitleMainTitleBar )

    self.TitleUnlockedList = vgui.Create( "DScrollPanel", self.TitleMain )
    self.TitleUnlockedList:SetPos( 0, self.TitleMainTitleBar )
    self.TitleUnlockedList:SetSize( self.TitleMain:GetWide() / 2, self.TitleMain:GetTall() - self.TitleMainTitleBar )

    --//Bad programming habbit to get into, this below
    local function SetupLists()
        for k, v in pairs( self.UnlockedTitles ) do
            local pan = vgui.Create( "DPanel", self.TitleUnlockedList )
            pan:SetSize( self.TitleUnlockedList:GetWide(), 50 )
            pan:Dock( TOP )
            pan.Think = function()
                if self.CurrentTitle == v.id then
                    pan.equipped = true
                else
                    pan.equipped = false
                end
            end
            surface.CreateFont( "TitleTitle" , { font = "Exo 2", size = 24, weight = 400 } )
            surface.CreateFont( "SubTitleTitle" , { font = "Exo 2", size = 16, weight = 400 } )
            pan.Paint = function()
                if pan.equipped then
                    --//Icon should be sized 32, 8 space buffer
                end
                surface.SetFont( "TitleTitle" )
                surface.SetTextPos( 48, 4 )
                surface.DrawText( v.title )

                surface.SetFont( "SubTitleTitle" )
                surface.SetTextPos( 56, pan:GetTall() - 4 - 16 )
                surface.DrawText( v.req .. " of " .. v.req .. " completed!" )
            end

            but = vgui.Create( "DButton", pan )
            but:SetSize( 60, pan:GetTall() / 2 )
            but:SetPos( pan:GetWide() - but:GetWide() - 8, pan:GetTall() / 2 - ( but:GetTall() / 2 ) )
            but.Paint = function()
                if pan.equipped then
                    but.displaytext = "EQUIPPED"
                else
                    but.displaytext = "UNSELECTED"
                end

                if but.hover and not pan.equipped then
                    draw.RoundedBox( 4, 0, 0, but:GetWide(), but:GetTall(), Color( 0, 0, 0, 51 ) )
                end
                draw.SimpleText( but.displaytext, "SubTitleTitle", but:GetWide() / 2, but:GetTall() / 2, self.TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end
            but.DoClick = function()
                if pan.equipped then return end
                --surface.PlaySound( "" )
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

        for k, v in pairs( self.LockedTitles ) do
            local pan = vgui.Create( "DPanel", self.TitleUnlockedList )
            pan:SetSize( self.TitleUnlockedList:GetWide(), 50 )
            pan:Dock( TOP )
            pan.Paint = function()
                surface.SetFont( "TitleTitle" )
                surface.SetTextPos( 8, 4 )
                surface.DrawText( v.title )

                surface.SetFont( "SubTitleTitle" )
                surface.SetTextPos( 16, pan:GetTall() - 4 - 16 )
                surface.DrawText( v.cur .. " of " .. v.req .. "." )
                surface.SetDrawColor( self.TeamColor )
                local wide = surface.GetTextSize( v.cur .. " of " .. v.req .. "." )
                surface.DrawOutlinedRect( 16 + wide + 8, pan:GetTall() - 4 - 16, pan:GetWide() - 16 - wide - 16, 16 )
                surface.DrawRect( 16 + wide + 8, pan:GetTall() - 4 - 16, math.Clamp( v.cur / v.req, 0, 1) * ( pan:GetWide() - 16 - wide - 16 ), 16 )
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
end

net.Receive( "EquipTitleCallback", function()
    local newTitle = net.ReadString()

    if newTitle and newTitle != "" then
        GAMEMODE.CurrentTitle = GAMEMODE:GetTitleTable( newTitle ).id
    end
end )