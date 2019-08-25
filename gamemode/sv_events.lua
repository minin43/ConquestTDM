GM.EventTable = {
    Reocurring = {
        { id = "happyhour", name = "Happy Hour", bonus = 3 },
        { id = "weekends", name = "Double EXP Weekends", bonus = 2 }
        { id = "raceprestige", name = "Race To Prestige" },
        { id = "racemastery", name = "Race To Complete Mastery" }
    },
    Single = {

    }
    --[[        
        Singleton Events (i.e. single game mutators):
        - Instagib (only sniper rifles, 10x damage so all shots 1-shot)
        - Low-grav (50% reduced gravity)
        - Big Heads (as your K/D grows, so does your head)
        - Realism (most HUD elements disabled, save round info, player info, and flags)
        - Slomo (reduced game speed - but nothing absurd)
        - Super Berserk (all guns get 2x RPM, or 1/2 firedelay)
        - Vampirism (damage done to enemies = immediate health gained)
        - Camp Fire (everyone carries a timed bomb on them, enemy kills increase time before detonation)
        - Melee Only (fists only, lol)
        - King of the Kill (the top player on each team can be seen through walls)
        - Super Ragdolls (all deaths result in super exaggerated ragdolled bodies)
        - Unlocked Store (some combination of all weapons/perks/attachments being unlocked)
    ]]
    --os.date( "", os.time() ) http://wiki.garrysmod.com/page/os/date
}

function StartTimedEvent( eventID )
    --//Make some announcements about the event starting
    --Remember not to overlay the map selection menu with the event announcement
    ContinueTimedEvent( eventID )
end

function ContinueTimedEvent( eventID )
    --//Set up backend crap, so clients can request any info as necessary
    --Clients need to properly display event information, we can probably just copy the above table and throw it in cl_events (no shared file)
    --Active events listed... in the F2 menu?
end

hook.Add( "Initialize", "CheckTimeBasedEventsAtMatchStart", function()
    local dateData = os.date( "*t", os.time() )

    --//Happy Hour
    local happyhourstarttime = 22
    if dateData.hour == happyhourstarttime then
        if dateData.min == 1 then
            StartTimedEvent( "happyhour" )
        else
            ContinueTimedEvent( "happyhour" )
        end
    else
        if dateData.hour == ( happyhourstarttime - 1 ) and dateData.min >= ( GAMEMODE.GameTime / 60 ) then
            local timeuntil = ( ( 60 - dateData.min ) * 60 ) + ( 60 - dateData.sec )
            timer.Create( "CountdownToHappyHour", timeuntil, 1, function()
                StartTimedEvent( "happyhour" )
            end )
        end
    end

    --//Double EXP Weekends
    if dateData.day == 1 or dateData.day == 7 then
        if dateData.hour == 1 and dateData.min == 1 then
            StartTimedEvent( "weekends" )
        else
            ContinueTimedEvent( "weekends" )
        end
    else
        if dateData.day == 6 and dateData.hour == 23 and dateData.min >= ( GAMEMODE.GameTime / 60 ) then
            local timeuntil = ( ( 60 - dateData.min ) * 60 ) + ( 60 - dateData.sec )
            timer.Create( "CountdownToWeekends", timeuntil, 1, function()
                StartTimedEvent( "weekends" )
            end )
        end
    end
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