GM.EventTable = {
    Reoccuring = {
        { id = "happyhour", name = "Happy Hour", bonus = 1.5, startTime = { hour = 22 }, endTime = { hour = 23 }, displayLength = "60 minutes", desc = "" },
        { id = "weekends", name = "Double EXP Weekends", bonus = 2, startTime = { wday = 7 }, endTime = { wday = 1 }, displayLength = "48 hours", desc = "" },
        { id = "raceprestige", name = "Race To Prestige", startTime = { day = 1 }, endTime = { day = 1 }, displayLength = "1 month" }
        --{ id = "racemastery", name = "Race To Complete Mastery" }
    },
    Single = {
        { id = "instagib", name = "Instagib", desc = "Sniper rifles only, all bullet damage kills instantly." },
        { id = "lowgrav", name = "Low-grav", desc = "50% reduced gravity. Probably best if you don't jump." },
        { id = "bigheads", name = "Big Heads", desc = "As your kill/death ratio grows, so does your head." },
        { id = "realism", name = "Realism", desc = "Limited HUD elements." },
        { id = "slowmo", name = "Slomo", desc = "Reduced game speed." },
        { id = "superberserk", name = "Super Berserk", desc = "All guns shoot 2x as fast." },
        { id = "vampirism", name = "Vampirism", desc = "Damage done to enemies is immediately gained as life." },
        { id = "campfire", name = "Camp Fire", desc = "Everyone carries a timed bomb on them. Enemy kills increases time before detonation." },
        { id = "melee", name = "Melee Only", desc = "Only melee weapons." },
        { id = "kotk", name = "King of the Kill", desc = "The top player of each team can be seen through all walls by all players." },
        { id = "superregadolls", name = "Super Ragdolls", desc = "All deaths result in exaggerated ragdolled bodies." },
        { id = "unlockedstore", name = "Unlocked Store", desc = "All weapons, perks, and equipment are unlocked for the round." },
        { id = "candela", name = "Candela", desc = "Everyone drops flash grenades on death." }
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
        - Candela (everyone drops flash grenades on death)
    ]]
    --os.date( "", os.time() ) http://wiki.garrysmod.com/page/os/date
}

function RetrieveEventTable( eventID )
    for _, tab in pairs( GAMEMODE.EventTable ) do
        for k, v in pairs( tab ) do
            if v.id == eventID then return v end
        end
    end
    ErrorNoHalt( "Function RetrieveEventTable received invalid eventID - contact gamemode developer" )
    return false
end