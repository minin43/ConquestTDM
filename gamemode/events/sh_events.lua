GM.EventTable = {
    Reoccuring = {
        { id = "happyhour", name = "Happy Hour", bonus = 1.5, startTime = { hour = 22 }, endTime = { hour = 23 }, displayLength = "60 minutes", desc = "" },
        { id = "weekends", name = "Double EXP Weekends", bonus = 2, startTime = { wday = 6, hour = 18 }, endTime = { wday = 2 }, displayLength = "48 hours", desc = "" },
        { id = "raceprestige", name = "Race To Prestige", startTime = { day = 1 }, endTime = { day = 1 }, displayLength = "1 month" } --Remains unimplemented
        --{ id = "racemastery", name = "Race To Complete Mastery" }
    }
    --os.date( "", os.time() ) http://wiki.garrysmod.com/page/os/date
}

function RetrieveEventTable( eventID )
    for _, tab in pairs( GAMEMODE.EventTable ) do
        for k, v in pairs( tab ) do
            if v.id == eventID then return v end
        end
    end
    ErrorNoHalt( "Function RetrieveEventTable received invalid eventID - contact gamemode developer", eventID )
    return false
end

function GetBestPlayerByTeam( teamid )
    local bestplayer
    local highestscore
    for k, v in pairs( team.GetPlayers( teamid ) ) do
        if !bestplayer then
            bestplayer = v
            highestscore = v:GetNWInt( "tdm_score", 1 )
        elseif highestscore < v:GetNWInt( "tdm_score", 1 ) then
            bestplayer = v
            highestscore = v:GetNWInt( "tdm_score", 1 )
        end
    end

    return bestplayer
end

function GetWorstPlayerByTeam( teamid )
    local worstplayer
    local lowestscore
    for k, v in pairs( team.GetPlayers( teamid ) ) do
        if !worstplayer then
            worstplayer = v
            lowestscore = v:GetNWInt( "tdm_score", 1 )
        elseif lowestscore > v:GetNWInt( "tdm_score", 1 ) then
            worstplayer = v
            lowestscore = v:GetNWInt( "tdm_score", 1 )
        end
    end

    return worstplayer
end

function StartInstagib() --Have players download the giblets mod?
    local newtable = {}

    for k, v in pairs( GAMEMODE.WeaponsList ) do
        if v.type == "sr" then
            newtable[ #newtable + 1 ] = v

            local wep = weapons.GetStored( v[2] )
            wep.HipSpread = 0.0
            wep.AimSpread = 0.0
            wep.Damage = 500
        end
    end

    GAMEMODE.WeaponsList = newtable
end

function StartLowgrav()
    hook.Add( "OnEntityCreated", "SetLowgrav", function( ent )
        timer.Simple( 0, function()
            ent:SetGravity( 120 )
        end )
    end )
end

function StartBighead()
    if SERVER then
        --Check for the head bone? then expand it based on K/D when respawned
        --Common head bone: ValveBiped.Bip01_Head1? https://wiki.facepunch.com/gmod/Entity:LookupBone
    end
end

function StartRealism()
    GAMEMODE.Realism = true
end

function StartSlowmo()
    if SERVER then
        game.SetTimeScale( 0.80 )
    end
end

function StartBerserk()
    for k, v in pairs( GAMEMODE.WeaponsList ) do
        local wep = weapons.GetStored( v[2] )

        if wep then
            wep.FireDelay = wep.FireDelay / 2
        end
    end
end

function StartVampirism()
    if SERVER then
        local remove
        for k, v in pairs( GAMEMODE.Perks ) do
            if v[2] == "vampir" then
                remove = k
            end
        end
        table.remove( GAMEMODE.Perks, remove )

        hook.Add( "EntityTakeDamage", "VampirDrain", function( vic, dmginfo )
            local att = dmginfo:GetAttacker()

            if vic and vic:IsPlayer() and att and att:IsPlayer() and vic:Team() != att:Team() then
                att:SetHealth( math.min( att:Health() + dmginfo:GetDamage(), att:GetMaxHealth() ) ) --Doesn't account for damage-reduction mechanics
                GAMEMODE:QueueIcon( att, "leech" )
            end
        end )
    end
end

function StartCampfire()
    --Need to display campfire bomb status on player's screen
    if SERVER then
        util.AddNetworkString( "UpdateCampfireBomb" )

        hook.Add( "PlayerSpawn", "StartCampfireBomb", function( ply )
            ply.CampfireBomb = 30
            timer.Create( id(ply:SteamID()) .. "CampfireTimer", 1, 0, function()
                if !ply or !ply:IsValid() or ply:Team() == 0 then timer.Remove( id(ply:SteamID()) .. "CampfireTimer" ) end
                ply.CampfireBomb = ply.CampfireBomb - 1

                net.Start( "UpdateCampfireBomb" )
                    net.WriteInt( ply.CampfireBomb, 16 ) --Lots 'o bits, since the number can get big
                net.Send( ply )

                if ply.CampfireBomb <= 0 then
                    if ply:Alive() then ply:Kill() end

                    local explosion = ents.Create( "env_explosion" )
                    if IsValid( explosion ) then
                        local explosionRadius = 300
                        explosion:SetPos( ply:GetPos() )
                        explosion:SetOwner( ply )
                        explosion:Spawn()
                        explosion:SetKeyValue( "iMagnitude", explosionRadius )
                        timer.Simple( 0, function()
                            explosion:Fire( "Explode", 0, 0 )
                            util.BlastDamage( explosion, ply, ply:GetPos(), explosionRadius * 2, explosionRadius )
                        end )
                    end

                    timer.Remove( id(ply:SteamID()) .. "CampfireTimer" )
                end
            end )
        end )

        hook.Add( "PlayerDeath", "IncreaseCampfireBombTimer", function( vic, wep, att )
            if vic and vic:IsValid() and att and att:IsValid() and att:IsPlayer() and vic:Team() != att:Team() then
                att.CampfireBomb = att.CampfireBomb + 30
                net.Start( "UpdateCampfireBomb" )
                    net.WriteInt( att.CampfireBomb, 16 )
                net.Send( att )
            end
        end )
    else
        net.Receive( "UpdateCampfireBomb", function()
            GAMEMODE.CampfireBomb = net.ReadInt( 16 )
        end )
    end
end

function StartMelee()
    GAMEMODE.PreventLoadout = {}
    GAMEMODE.PreventLoadout.primary = true
    GAMEMODE.PreventLoadout.secondary = true
    GAMEMODE.PreventLoadout.equipment = true
    GAMEMODE.PreventLoadout.forced = {
        "cw_extrema_ratio_official"
    }
end

function StartKing()
    if SERVER then
        util.AddNetworkString( "UpdateKotKHalos")
        function UpdateKotKHalos()
            net.Start( "UpdateKotKHalos" )
            net.Broadcast()
        end

        hook.Add( "PostPlayerDeath", "UpdateKotKHalosPlayerDeath", UpdateKotKHalos )
        hook.Add( "PlayerDisconnected", "UpdateKotKHalosPlayerLeave", UpdateKotKHalos )
    else
        function GetKotKHalos()
            GAMEMODE.KOTKRed = GetBestPlayerByTeam( 1 )
            GAMEMODE.KOTKBlue = GetBestPlayerByTeam( 2 )
        end
        GetKotKHalos()
        
        net.Receive( "SendKotKHalos", GetKotKHalos )
        hook.Add( "PreDrawHalos", "DrawKotKHalos", function()
            if GAMEMODE.KOTKRed then
                halo.Add( GAMEMODE.KOTKRed, colorScheme[ 1 ].TeamColor, 2, 2, 1, true, true )
            end
            if GAMEMODE.KOTKBlue then
                halo.Add( GAMEMODE.KOTKBlue, colorScheme[ 2 ].TeamColor, 2, 2, 1, true, true )
            end
        end )
    end
end

function StartRagdolls()
    --What to do? could steal something off the workshop...
end

function StartStore()
    GAMEMODE.AllowFullShop = true
end

function StartCandela()
    if CLIENT then return end

    hook.Add( "PlayerDeath", "CandelaEvent", function( vic, wep, att )
        local grenade = ents.Create( "cw_flash_thrown" )
        grenade:SetPos( vic:GetPos() )
        --grenade:SetAngles(self.Owner:EyeAngles())
        grenade:Spawn()
        grenade:Activate()
        --grenade:Fuse( 1 )
        grenade:SetOwner( vic )
    end )
end

function StartSecondaries()
    GAMEMODE.PreventLoadout = {}
    GAMEMODE.PreventLoadout.primary = true
    GAMEMODE.PreventLoadout.equipment = true
end

GM.EventTable.Single = {
        { id = "instagib", name = "Instagib", desc = "Sniper rifles only, all bullet damage kills instantly, and all weapons are 100% accurate.", func = StartInstagib },
        { id = "lowgrav", name = "Low-grav", desc = "50% reduced gravity. Probably best if you don't jump.", func = StartSlowmo },
        { id = "bigheads", name = "Big Heads", desc = "As your kill/death ratio grows, so does your head.", func = StartBighead },
        { id = "realism", name = "Realism", desc = "Limited HUD elements.", func = StartRealism },
        { id = "slowmo", name = "Slomo", desc = "Reduced game speed.", func = StartSlowmo },
        { id = "superberserk", name = "Super Berserk", desc = "All guns shoot 2x as fast.", func = StartBerserk },
        { id = "vampirism", name = "Vampirism", desc = "Damage done to enemies is immediately gained as life.", func = StartVampirism },
        { id = "campfire", name = "Camp Fire", desc = "Everyone carries a timed bomb on them. Killing enemies increases time before detonation.", func = StartCampfire },
        { id = "melee", name = "Melee Only", desc = "Only melee weapons.", func = StartMelee },
        { id = "kotk", name = "King of the Kill", desc = "The top player of each team can be seen through all walls by all players.", func = StartKing },
        { id = "superregadolls", name = "Super Ragdolls", desc = "All deaths result in exaggerated ragdolled bodies.", func = StartRagdolls },
        { id = "unlockedstore", name = "Unlocked Store", desc = "All weapons, perks, and equipment are unlocked for the round.", func = StartStore },
        { id = "candela", name = "Candela", desc = "Everyone drops flash grenades on death.", func = StartCandela }
        { id = "secondary", name = "Secondaries Only", desc = "Only secondary weapons.", func = StartSecondaries },
    }