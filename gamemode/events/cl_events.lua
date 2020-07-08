surface.CreateFont( "MenuAnnouncements", { font = "Exo 2", size = 20, weight = 400 } )
surface.CreateFont( "MenuAnnouncementsBold", { font = "Exo 2", size = 20, weight = 600 } )

--//Called in teamselect as well
net.Start( "RequestActiveEvents" )
net.SendToServer()

net.Receive( "RequestActiveEventsCallback", function()
    GAMEMODE.ActiveEvents = net.ReadTable()
    GAMEMODE.EventTimers = net.ReadTable()
end )

net.Receive( "StartedNewEvent", function()
    surface.PlaySound( "ui/gman_timeagain.wav" )
end )

--This is actually just for the two timed events that currently run 24/7, not for the single events
function GM:DrawEventStatuses( parentFrame )
    if not GAMEMODE.ActiveEvents or not GAMEMODE.EventTimers or not IsValid( parentFrame ) then return end
    self.Events = self.Events or {}

    if self.Events.HappyHour and self.Events.HappyHour:IsValid() and self.Events.DXPWeekend and self.Events.DXPWeekend:IsValid() then
        self.Events.HappyHour:Close()
        self.Events.DXPWeekend:Close()
        timer.Simple(0, function()
            GAMEMODE.DrawEventStatuses( parentFrame )
        end)
    end

    local happyhourStarted = false
    local hhmarkupobj, hhmarkupwidth, hhtimeleft
    if GAMEMODE.ActiveEvents.happyhour then
        happyhourStarted = true
        hhtimeleft = math.Round( GAMEMODE.EventTimers.Active.happyhour / 60, 2 )
        local s = "minutes"
        if hhtimeleft == 1.0 then s = "minute" end
        hhmarkupobj = markup.Parse( "<font=MenuAnnouncementsBold><colour=0,0,0>It's Happy Hour! 1.5x point accumulation! Happy hour ends in </colour><colour=76,175,80>" .. hhtimeleft .. "</colour><colour=0,0,0> " .. s .. "</font>", ScrW() )
        hhmarkupwidth = hhmarkupobj:GetWidth()
    else
        hhtimeleft = math.Round( GAMEMODE.EventTimers.Dormant.happyhour / 3600, 2 )
        local s = "hours"
        if hhtimeleft == 1.0 then s = "hour" end
        hhmarkupobj = markup.Parse( "<font=MenuAnnouncements><colour=0,0,0>Happy Hour starts in </colour><colour=76,175,80>" .. hhtimeleft .. "</colour><colour=0,0,0> " .. s .. "</font>", ScrW() )
        hhmarkupwidth = hhmarkupobj:GetWidth()
    end

    self.Events.HappyHour = vgui.Create( "DFrame" )
    self.Events.HappyHour:SetSize( hhmarkupwidth + 16, 56 / 2 )
    local ChooseMainx, ChooseMainy = parentFrame:GetPos() 
    self.Events.HappyHour:SetPos( ChooseMainx + ( parentFrame:GetWide() / 2 ) - ( self.Events.HappyHour:GetWide() / 2 ), ChooseMainy - self.Events.HappyHour:GetTall() - 10 )
    self.Events.HappyHour:SetTitle( "" )
    self.Events.HappyHour:SetVisible( true )
    self.Events.HappyHour:SetDraggable( false )
    self.Events.HappyHour:ShowCloseButton( false )
    self.Events.HappyHour:MakePopup()
    self.Events.HappyHour.Paint = function( _, w, h )
        if !self.Events.HappyHour then return end
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawRect( 0, 0, w, h )
        surface.SetDrawColor( GAMEMODE.TeamColor )
        surface.DrawOutlinedRect( 0, 0, w, h )
        surface.DrawOutlinedRect( 1, 1, w - 2, h - 2 )
        hhmarkupobj:Draw( 5, h / 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end
    self.Events.HappyHour.Think = function()
        if self.Events.HappyHour and self.Events.HappyHour:IsValid() then
            if not IsValid( parentFrame ) then
                self.Events.HappyHour:Close()
                parentFrame = nil
            else
                self.Events.HappyHour:MakePopup()
            end
        end
    end

    local weekendstart = false
    local wmarkupobj, wmarkupwidth, wtimeleft
    if GAMEMODE.ActiveEvents.weekends then
        weekendstart = true
        wtimeleft = math.Round( GAMEMODE.EventTimers.Active.weekends / 3600, 2 )
        local s = "hours"
        if hhtimeleft == 1 then s = "hour" end
        wmarkupobj = markup.Parse( "<font=MenuAnnouncementsBold><colour=0,0,0>It's Double XP Weekend! 2x point accumulation! Double XP Weekend ends in </colour><colour=76,175,80>" .. wtimeleft .. "</colour><colour=0,0,0> " .. s .. "</font>", ScrW() )
        wmarkupwidth = wmarkupobj:GetWidth()
    else
        wtimeleft = math.Round( GAMEMODE.EventTimers.Dormant.weekends / ( 3600 * 24 ), 2 )
        local s = "days"
        if hhtimeleft == 1 then s = "day" end
        wmarkupobj = markup.Parse( "<font=MenuAnnouncements><colour=0,0,0>Double XP Weekend starts in </colour><colour=76,175,80>" .. wtimeleft .. "</colour><colour=0,0,0> " .. s .. "</font>", ScrW() )
        wmarkupwidth = wmarkupobj:GetWidth()
    end

    self.Events.DXPWeekend = vgui.Create( "DFrame" )
    self.Events.DXPWeekend:SetSize( wmarkupwidth + 16, 56 / 2 )
    --local ChooseMainx, ChooseMainy = parentFrame:GetPos() --Created above
    self.Events.DXPWeekend:SetPos( ChooseMainx + ( parentFrame:GetWide() / 2 ) - ( self.Events.DXPWeekend:GetWide() / 2 ), ChooseMainy + parentFrame:GetTall() + 10 )
    self.Events.DXPWeekend:SetTitle( "" )
    self.Events.DXPWeekend:SetVisible( true )
    self.Events.DXPWeekend:SetDraggable( false )
    self.Events.DXPWeekend:ShowCloseButton( false )
    self.Events.DXPWeekend:MakePopup()
    self.Events.DXPWeekend.Paint = function( _, w, h )
        if !self.Events.DXPWeekend then return end
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawRect( 0, 0, w, h )
        surface.SetDrawColor( GAMEMODE.TeamColor )
        surface.DrawOutlinedRect( 0, 0, w, h )
        surface.DrawOutlinedRect( 1, 1, w - 2, h - 2 )
        wmarkupobj:Draw( 5, h / 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end
    self.Events.DXPWeekend.Think = function()
        if self.Events.DXPWeekend and self.Events.DXPWeekend:IsValid() then
            if not IsValid( parentFrame ) then
                self.Events.DXPWeekend:Close()
                parentFrame = nil
            else
                self.Events.DXPWeekend:MakePopup()
            end
        end
    end
end

--This is what actually draws the single-game events - separated because, even though they're both built modular-ly, this requires more space,
--and so is only called in menu.lua and teamselect.lua, where DrawEventStatuses can be called in every menu window.
function GM:DrawSingleEventStatus( parentFrame )
    if not self.SingleEventID or self.SingleEventID == "" or not IsValid( parentFrame ) then return end
    self.Events = self.Events or {}

    if self.Events.Single and self.Events.Single:IsValid() then
        self.Events.Single:Close()
        timer.Simple(0, function()
            GAMEMODE.DrawSingleEventStatus( parentFrame )
        end)
    end

    self.Events.Single = vgui.Create( "DFrame" )
    self.Events.Single:SetSize( 160, 250 )
    local parentFramex, parentFramey = parentFrame:GetPos() 
    self.Events.Single:SetPos( parentFramex + ( parentFrame:GetWide() ) + 10, parentFramey + (parentFrame:GetTall() / 2) - (self.Events.Single:GetTall() / 2) )
    self.Events.Single:SetTitle( "" )
    self.Events.Single:SetVisible( true )
    self.Events.Single:SetDraggable( false )
    self.Events.Single:ShowCloseButton( false )
    self.Events.Single:MakePopup()
    local eventinfo = RetrieveEventTable( self.SingleEventID )
    local descriptionmarkup = markup.Parse( "<font=Exo-20-600><color=66,66,66>" .. eventinfo.desc .. "</color></font>", self.Events.Single:GetWide() - 8 )
    self.Events.Single.Paint = function( _, w, h )
        if !self.Events.Single then return end
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawRect( 0, 0, w, h )
        surface.SetDrawColor( GAMEMODE.TeamColor )
        surface.DrawOutlinedRect( 0, 0, w, h )
        surface.DrawOutlinedRect( 1, 1, w - 2, h - 2 )
        draw.SimpleText( "Event:", "Exo-20-600", w / 2, 16, Color( 66, 66, 66 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        surface.SetFont( "Exo-32-400" )
        surface.SetTextColor( GAMEMODE.TeamColor )
        local tw, th = surface.GetTextSize( eventinfo.name )
        surface.DrawLine( w / 2 - (tw / 2) - 4, 26 + (th), w / 2 + (tw / 2) + 4, 26 + (th) )
        surface.SetTextPos( w / 2 - (tw / 2), 26 )
        surface.DrawText( eventinfo.name )
        descriptionmarkup:Draw( 4, 30 + (th) + 6, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    end
    self.Events.Single.Think = function()
        if self.Events.Single and self.Events.Single:IsValid() then
            if not IsValid( parentFrame ) then
                self.Events.Single:Close()
                parentFrame = nil
            else
                self.Events.Single:MakePopup()
            end
        end
    end
end

hook.Add( "InitPostEntity", "CheckSingleEvents", function()
    net.Start( "RequestSingleEventStatus" )
    net.SendToServer()

    net.Receive( "RequestSingleEventStatusCallback", function()
        GAMEMODE.SingleEventID = net.ReadString() or ""
        local eventtable = RetrieveEventTable( GAMEMODE.SingleEventID )
        if eventtable then
            eventtable.func()
        end
    end )
end )