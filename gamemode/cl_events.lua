surface.CreateFont( "MenuAnnouncements", { font = "Exo 2", size = 20, weight = 400 } )
surface.CreateFont( "MenuAnnouncementsBold", { font = "Exo 2", size = 20, weight = 600 } )

--[[GM.ActiveEvents = {}
GM.EventTimers = {}]]

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

function GM:DrawEventStatuses( parentFrame )

    if not GAMEMODE.ActiveEvents or not GAMEMODE.EventTimers or not IsValid( parentFrame ) then return end
    self.Events = self.Events or {}

    local happyhourStarted = false
    local hhmarkupobj, hhmarkupwidth, hhtimeleft
    if GAMEMODE.ActiveEvents.happyhour then
        happyhourStarted = true
        hhtimeleft = math.Round( GAMEMODE.EventTimers.Active.happyhour / 60, 1 )
        local s = "minutes"
        if hhtimeleft == 1.0 then s = "minute" end
        hhmarkupobj = markup.Parse( "<font=MenuAnnouncementsBold><colour=0,0,0>It's Happy Hour! 1.5x point accumulation! Happy hour ends in </colour><colour=76,175,80>" .. hhtimeleft .. "</colour><colour=0,0,0> " .. s .. "</font>", ScrW() )
        hhmarkupwidth = hhmarkupobj:GetWidth()
    else
        hhtimeleft = math.Round( GAMEMODE.EventTimers.Dormant.happyhour / 3600, 1 )
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
    self.Events.HappyHour.Paint = function()
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawRect( 0, 0, self.Events.HappyHour:GetSize() )
        surface.SetDrawColor( GAMEMODE.TeamColor )
        surface.DrawOutlinedRect( 0, 0, self.Events.HappyHour:GetSize() )
        surface.DrawOutlinedRect( 1, 1, self.Events.HappyHour:GetWide() - 2, self.Events.HappyHour:GetTall() - 2 )
        hhmarkupobj:Draw( 5, self.Events.HappyHour:GetTall() / 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end
    self.Events.HappyHour.Think = function()
        if self.Events.HappyHour then
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
        wtimeleft = math.Round( GAMEMODE.EventTimers.Active.weekends / 3600, 1 )
        local s = "hours"
        if hhtimeleft == 1 then s = "hour" end
        wmarkupobj = markup.Parse( "<font=MenuAnnouncementsBold><colour=0,0,0>It's Double XP Weekend! 2x point accumulation! Double XP Weekend ends in </colour><colour=76,175,80>" .. wtimeleft .. "</colour><colour=0,0,0> " .. s .. "</font>", ScrW() )
        wmarkupwidth = wmarkupobj:GetWidth()
    else
        wtimeleft = math.Round( GAMEMODE.EventTimers.Dormant.weekends / ( 3600 * 24 ), 1 )
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
    self.Events.DXPWeekend.Paint = function()
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawRect( 0, 0, self.Events.DXPWeekend:GetSize() )
        surface.SetDrawColor( GAMEMODE.TeamColor )
        surface.DrawOutlinedRect( 0, 0, self.Events.DXPWeekend:GetSize() )
        surface.DrawOutlinedRect( 1, 1, self.Events.DXPWeekend:GetWide() - 2, self.Events.DXPWeekend:GetTall() - 2 )
        wmarkupobj:Draw( 5, self.Events.DXPWeekend:GetTall() / 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end
    self.Events.DXPWeekend.Think = function()
        if self.Events.DXPWeekend then
            if not IsValid( parentFrame ) then
                self.Events.DXPWeekend:Close()
                parentFrame = nil
            else
                self.Events.DXPWeekend:MakePopup()
            end
        end
    end
end