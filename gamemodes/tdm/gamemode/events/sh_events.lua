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
    if !eventID or eventID == "" then return false end

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

function StartInstagib()
    GAMEMODE.PreventLoadoutSaving = true
    local newtable = {}

    if SERVER then
        --resource.AddWorkshop( "2155841271" ) --Gib mod, don't think I want to deal with it
        
        hook.Add( "PostWeaponBalancing", "StartBerserk", function()
            for k, v in pairs( GAMEMODE.WeaponsList ) do
                if v.type == "sr" then
                    newtable[ #newtable + 1 ] = v

                    local wep = weapons.GetStored( v[2] )
                    wep.HipSpread = 0.01
                    wep.AimSpread = 0.001
                    wep.Damage = 500
                end
            end

            GAMEMODE.WeaponsList = newtable
        end )
    else
        for k, v in pairs( GAMEMODE.WeaponsList ) do
            if v.type == "sr" then
                newtable[ #newtable + 1 ] = v

                local wep = weapons.GetStored( v[2] )
                wep.HipSpread = 0.01
                wep.AimSpread = 0.001
                wep.Damage = 500
            end
        end

        GAMEMODE.WeaponsList = newtable
    end
end

function StartLowgrav()
    hook.Add( "OnEntityCreated", "SetLowgrav", function( ent )
        timer.Simple( 0, function()
            if ent and ent:IsValid() then
                ent:SetGravity( 0.4 )
            end
        end )
    end )
end

function StartBighead()
    if SERVER then
        --Check for the head bone? then expand it based on K/D when respawned
        --Common head bone: ValveBiped.Bip01_Head1? https://wiki.facepunch.com/gmod/Entity:LookupBone
        local commonheadbones = { "ValveBiped.Bip01_Head1", "ValveBiped.Bip01_Head", "ValveBiped.head" }
        local scale = { [0] = 1.0, 1.25, 1.5, 1.75, 2.0, 2.25, 2.5, 2.75, 3.0 }
        hook.Add( "PlayerSpawn", "Bigheads", function( ply )
            local headscale = scale[ math.Clamp( ply:Frags() - ply:Deaths(), 0, 8 ) ]
            
            timer.Simple( 0.1, function()
                for k, v in pairs( commonheadbones ) do
                    local toexplode = ply:LookupBone( v )

                    if toexplode then
                        ply:ManipulateBoneScale( toexplode, Vector( headscale, headscale, headscale ) )
                        return
                    end
                end 
            end )
        end )
    end
end

function StartRealism()
    GAMEMODE.Realism = true
    if CLIENT then
        --hook.Add( "InitPostEntity", "RemoveDefaultCWAmmo", function()
            LocalPlayer():ConCommand( "cw_customhud_ammo 0" )
        --end )
    end
end

function StartSlowmo()
    if SERVER then
        timer.Simple( 10, function()
            game.SetTimeScale( 0.7 )
        end )
    end
end

function StartBerserk()
    if SERVER then
        hook.Add( "PostWeaponBalancing", "StartBerserk", function()
            for k, v in pairs( GAMEMODE.WeaponsList ) do
                local wep = weapons.GetStored( v[2] )
                
                if wep and wep.Base == "cw_base" then
                    wep.FireDelay = wep.FireDelay / 2
                end
            end
        end )
    else
        for k, v in pairs( GAMEMODE.WeaponsList ) do
            local wep = weapons.GetStored( v[2] )
            
            if wep and wep.Base == "cw_base" then
                wep.FireDelay = wep.FireDelay / 2
            end
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
                if !ply or !ply:IsValid() or ply:Team() == 0 or !ply:Alive() then timer.Remove( id(ply:SteamID()) .. "CampfireTimer" ) return end
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
                att.CampfireBomb = att.CampfireBomb + 20
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
    GAMEMODE.PreventLoadoutSaving = true
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
            GAMEMODE.KOTKRed = { GetBestPlayerByTeam( 1 ) }
            GAMEMODE.KOTKBlue = { GetBestPlayerByTeam( 2 ) }
        end
        GetKotKHalos()
        
        net.Receive( "UpdateKotKHalos", GetKotKHalos )
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
    GAMEMODE.PreventLoadoutSaving = true
    GAMEMODE.AllowFullShop = true
end

function StartHotbox()
    if CLIENT then return end

    hook.Add( "PlayerDeath", "CandelaEvent", function( vic, wep, att )
        local grenade = ents.Create( "cw_smoke_thrown" )
        grenade:SetPos( vic:GetPos() )
        --grenade:SetAngles(self.Owner:EyeAngles())
        grenade:Spawn()
        grenade:Activate()
        grenade:Fuse( 1 )
        grenade:SetOwner( vic )
    end )
end

function StartSecondaries()
    GAMEMODE.PreventLoadoutSaving = true
    GAMEMODE.PreventLoadout = {}
    GAMEMODE.PreventLoadout.primary = true
    GAMEMODE.PreventLoadout.equipment = true
end

GM.EventTable.Single = {
        { id = "lowgrav", name = "Low-grav", desc = "Everything has 50% reduced gravity. You probably don't want to jump. Or maybe you do?", func = StartLowgrav },
        { id = "bigheads", name = "Big Heads", desc = "As your kill/death ratio grows, so does your head.", func = StartBighead },
        { id = "realism", name = "Realism", desc = "Limited HUD elements. Count your shots!", func = StartRealism },
        { id = "slowmo", name = "Slomo", desc = "30% Reduced game speed. Slooooooow dooooooooooown.", func = StartSlowmo },
        { id = "superberserk", name = "Super Berserk", desc = "All guns shoot 2x as fast. Haha, guns go BRRRT.", func = StartBerserk },
        { id = "vampirism", name = "Vampirism", desc = "Damage done to enemies is immediately gained as life. Better pull out that P90.", func = StartVampirism },
        { id = "campfire", name = "Camp Fire", desc = "Everyone carries a timed bomb on them. Killing enemies increases time before detonation. Tick tock.", func = StartCampfire },
        { id = "kotk", name = "King of the Kill", desc = "The top player of each team can be seen through all walls by all players. Yes, you get wall hacks.", func = StartKing },
        --{ id = "superregadolls", name = "Super Ragdolls", desc = "All deaths result in exaggerated ragdolled bodies.", func = StartRagdolls },
        { id = "unlockedstore", name = "Unlocked Store", desc = "All weapons, perks, and equipment are unlocked for the round. Have fun!", func = StartStore },
        { id = "420", name = "Hotbox", desc = "Everyone drops a smoke grenade on death. 420 blaze it, dude.", func = StartHotbox },
        { id = "instagib", name = "Instagib", desc = "Only sniper rifles can be equipped, all bullet damage kills instantly, and all weapons are 100% accurate.", func = StartInstagib },
        { id = "melee", name = "Melee Only", desc = "Only melee weapons can be equipped, and one of them is a knife. Get stabbing!", func = StartMelee },
        { id = "secondary", name = "Secondaries Only", desc = "Only secondary weapons can be equipped. For all you idiots that wanted pistol-only rounds.", func = StartSecondaries }
}