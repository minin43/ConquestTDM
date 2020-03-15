util.AddNetworkString( "StartedNewEvent" )
util.AddNetworkString( "RequestActiveEvents" )
util.AddNetworkString( "RequestActiveEventsCallback" )

GM.ActiveEvents = {}
GM.EventTimers = GM.EventTimers or {}
GM.EventTimers.Active = GM.EventTimers.Active or {}
GM.EventTimers.Dormant = GM.EventTimers.Dormant or {}

GM.EventTableFunctions = {
    instagib = function()

    end
}

--//Counts how many seconds have passed from the start of the year to the given time
function GetTimeInSeconds( tab )
    if not istable( tab ) then return 0 end
    local timeSec = 0

    if tab.yday then --//If we're given yday, it already accounts for leap years & 30 day months, so counting is much faster/easier
        for k, v in pairs( tab ) do
            if k == "sec" then
                timeSec = timeSec + v
            elseif k == "min" then
                timeSec = timeSec + ( v * 60 )
            elseif k == "hour" then
                timeSec = timeSec + ( v * 60 * 60 )
            end
        end
        timeSec = timeSec + (tab.yday * 24 * 60 * 60)
    else
        local monthDays = {[1] = 31, [2] = 28, [3] = 31, [4] = 30, [5] = 31, [6] = 30, [7] = 31, [8] = 31, [9] = 30, [10] = 31, [11] = 30, [12] = 31}
        if tab.year and tab.year % 4 == 0 then
            if tab.month and tab.month > 2 then
                leapYear = true
            end
        end

        for k, v in pairs( tab ) do
            if k == "sec" then
                timeSec = timeSec + v
            elseif k == "min" then
                timeSec = timeSec + ( v * 60 )
            elseif k == "hour" then
                timeSec = timeSec + ( v * 60 * 60 )
            elseif k == "day" then
                timeSec = timeSec + ( v * 60 * 60 * 24 )
            elseif k == "month" then
                --timeSec = timeSec + ( v * 60 * 60 * 24 * ( 365 / 12 ) )
                for monthCount = 1, v - 1 do
                    if leapYear and monthCount == 2 then
                        timeSec = timeSec + ( 60 * 60 * 24 * 29 )
                    else
                        timeSec = timeSec + ( 60 * 60 * 24 * monthDays[monthCount] )
                    end
                end
            end
        end
    end

    return timeSec
end

--//Returns how much time remains between a given date (usually today) and a date in its future this year, assumes certain times if compareTable doesn't have them
function TimeLeft( dateTable, compareTable )
    print("TimeLeft debug called with arguments", dateTable, compareTable)
    local startTime = GetTimeInSeconds( dateTable )
    local whatIsAssumed = {}
    
    if not compareTable.sec then
        compareTable.sec = 1
        whatIsAssumed.sec = true
    end
    if not compareTable.min then
        compareTable.min = 0
        whatIsAssumed.min = true
    end
    if not compareTable.hour then
        compareTable.hour = 0
        whatIsAssumed.hour = true
    end
    
    if not compareTable.day then
        if not compareTable.wday then
            if not compareTable.month then
                compareTable.day = dateTable.day
            else
                compareTable.day = 1
            end
            whatIsAssumed.day = true
        else
            if dateTable.wday < compareTable.wday then
                compareTable.day = dateTable.day + ( compareTable.wday - dateTable.wday )
            else
                compareTable.day = dateTable.day + 7 - ( dateTable.wday - compareTable.wday )
            end
        end
    end
    if not compareTable.month then
        compareTable.month = dateTable.month
        whatIsAssumed.month = true
    end

    if compareTable.sec <= dateTable.sec and whatIsAssumed.min and whatIsAssumed.hour and whatIsAssumed.day and whatIsAssumed.month then
        compareTable.min = compareTable.min + 1
    elseif compareTable.min <= dateTable.min and whatIsAssumed.sec and whatIsAssumed.hour and whatIsAssumed.day and whatIsAssumed.month then
        compareTable.hour = compareTable.hour + 1
    elseif compareTable.hour <= dateTable.hour and whatIsAssumed.sec and whatIsAssumed.min and whatIsAssumed.day and whatIsAssumed.month then
        compareTable.day = compareTable.day + 1
    elseif compareTable.day <= dateTable.day and whatIsAssumed.sec and whatIsAssumed.min and whatIsAssumed.hour and whatIsAssumed.month then
        compareTable.month = compareTable.month + 1
    --[[elseif compareTable.month > dateTable.month and whatIsAssumed.sec and whatIsAssumed.min and whatIsAssumed.hour and whatIsAssumed.day then
        compareTable. = compareTable. + 1]]
    end
    
    local compareTime = GetTimeInSeconds( compareTable )
    
    return math.max( compareTime - startTime, 0 )
end

function parseDate(seconds)
    local secondsDisplay = seconds % 60
    local minutes = math.Round(seconds / 60)
    local minutesDisplay = minutes % 60
    local hours = math.Round(minutes / 60)
    local hoursDisplay = hours % 24
    local days = math.Round(hours / 24)

    return "Seconds: " .. secondsDisplay .. "\nMinutes: " .. minutesDisplay .. "\nHours: " .. hoursDisplay .. "\nDays: " .. days
end

function CreateTimedEventTimers()
    for _, eventTable in pairs( GAMEMODE.EventTable.Reoccuring ) do
        local today = os.date( "*t", os.time() )
        --[[Quick note about this: os.date returns TODAY, I'm looking for how much time as passed UP TO TODAY, which means I don't want to be counting an extra 24 hours.
        January 3rd returns yday = 3, but if I'm counting up to Jan 3rd at noon, I want 2 full days + the 12 hours up to noon. If I wasn't giving TimeLeft a table with
        yday in it, I'd be subtracting day by the month count instead]]
        today.yday = today.yday - 1
        
        if GAMEMODE.ActiveEvents[ eventTable.id ] then
            local timeleft = TimeLeft( today, eventTable.endTime )
            
            GAMEMODE.EventTimers.Dormant[ eventTable.id ] = nil
            GAMEMODE.EventTimers.Active[ eventTable.id ] = timeleft

            timer.Create( "TimeLeft" .. eventTable.id, timeleft, 1, function()
                GAMEMODE.EventTimers.Active[ eventTable.id ] = GAMEMODE.EventTimers.Active[ eventTable.id ] - 1
                SendPlayersEventTimes()
                if GAMEMODE.EventTimers.Active[ eventTable.id ] == 0 then
                    EndTimedEvent( eventTable.id )
                    timer.Remove( "TimeLeft" .. eventTable.id )
                end
            end )
        else
            local timeuntil = TimeLeft( today, eventTable.startTime )
            GAMEMODE.EventTimers.Active[ eventTable.id ] = nil
            GAMEMODE.EventTimers.Dormant[ eventTable.id ] = timeuntil
            
            timer.Create( "TimeLeft" .. eventTable.id, timeuntil, 1, function()
                GAMEMODE.EventTimers.Dormant[ eventTable.id ] = GAMEMODE.EventTimers.Dormant[ eventTable.id ] - 1
                SendPlayersEventTimes()
                if GAMEMODE.EventTimers.Active[ eventTable.id ] == 0 then
                    StartTimedEvent( eventTable.id )
                    timer.Remove( "TimeLeft" .. eventTable.id )
                end
            end )
        end
    end

    timer.Create( "UpdateEventTimesClientside", 1, 0, function()
        SendPlayersEventTimes()
    end )
end

function StartTimedEvent( eventID )
    --//Make some announcements about the event starting
    --Remember not to overlay the map selection menu with the event announcement
    net.Start( "StartedNewEvent" )
        net.WriteString( eventID )
    net.Broadcast()

    local tab = RetrieveEventTable( eventID )
    GlobalChatPrintColor( Color( 255, 255, 255 ), "**--NEW EVENT STARTING--**" )
    GlobalChatPrintColor( Color( 102, 255, 51 ), tab.name, Color( 255, 255, 255 ), " starts now!" )
    GlobalChatPrintColor( Color( 255, 255, 255 ), "Event ends in ", Color( 102, 255, 51 ), tab.displayLength )

    ContinueTimedEvent( eventID )
end

function ContinueTimedEvent( eventID )
    GAMEMODE.ActiveEvents[ eventID ] = true
    --//Set up backend crap, so clients can request any info as necessary
    CreateTimedEventTimers()
end

function SendPlayersEventTimes( ply )
    net.Start( "RequestActiveEventsCallback" )
        net.WriteTable( GAMEMODE.ActiveEvents )
        net.WriteTable( GAMEMODE.EventTimers )
    if ply then
        net.Send( ply )
    else
        net.Broadcast()
    end
end

function StartSingleEvent( eventID )

end

--//When the server changes maps or boots up, check to see if any event should be running
hook.Add( "Initialize", "CheckTimeBasedEventsAtMatchStart", function()
    local dateData = os.date( "*t", os.time() )

    --//Happy Hour
    local happyhourinfo = RetrieveEventTable( "happyhour" )
    local happyhourstarttime = happyhourinfo.startTime
    if dateData.hour == happyhourstarttime.hour then
        ContinueTimedEvent( "happyhour" )
    elseif dateData.hour == ( happyhourstarttime.hour - 1 ) and dateData.min >= ( GAMEMODE.GameTime / 60 ) then
        local timeuntil = ( ( 60 - dateData.min ) * 60 ) + ( 60 - dateData.sec )
        timer.Create( "CountdownToHappyHour", timeuntil, 1, function()
            StartTimedEvent( "happyhour" )
            CreateTimedEventTimers()
        end )
    end

    --//Double EXP Weekends
    local doublexpweekendinfo = RetrieveEventTable( "weekends" )
    if dateData.wday == doublexpweekendinfo.startTime.wday or dateData.wday == doublexpweekendinfo.endTime.wday then
        ContinueTimedEvent( "weekends" )
    elseif dateData.day == 6 and dateData.hour == 23 and dateData.min >= ( GAMEMODE.GameTime / 60 ) then
        local timeuntil = ( ( 60 - dateData.min ) * 60 ) + ( 60 - dateData.sec )
        timer.Create( "CountdownToWeekends", timeuntil, 1, function()
            StartTimedEvent( "weekends" )
            CreateTimedEventTimers()
        end )
    end

    CreateTimedEventTimers()
end )

--[[
    > PrintTable( os.date( "*t", os.time() ) )...
    day	    =	22
    hour	=	23
    isdst	=	true
    min	    =	43
    month	=	8
    sec	    =	57
    wday	=	5
    yday	=	234
    year	=	2019
]]

net.Receive( "RequestActiveEvents", function( len, ply )
    SendPlayersEventTimes( ply )
end )
