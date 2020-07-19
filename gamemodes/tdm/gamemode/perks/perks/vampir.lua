GM.VampirDrainMins = { [0] = 100, 40 } --The minimum life you'll drain to after being out of combat for too long, scales with # players on the enemy team
GM.VampirDrainRates = { [0] = 0, 1 } --Drain rates per second, scales with # players on the enemy team
GM.VampirDamageDrain = 0.30 --% of damage that is added to your health
GM.VampirDrainCap = 150 --Max HP cap

hook.Add( "PostGivePlayerLoadout", "VampirSpawn", function( ply )
    timer.Simple( 0, function()
        if CheckPerk( ply ) == "vampir" then
            timer.Create( ply:SteamID() .. "VampTimer", 1, 0, function()
                if !ply:Alive() then timer.Remove( ply:SteamID() .. "VampTimer" ) return end

                local numEnemies = #team.GetPlayers( (ply:Team() % 2) + 1 )
                local drainlimit = GAMEMODE.VampirDrainMins[ numEnemies ] or 30
                if ply:Health() <= drainlimit then return end

                local drainrate = GAMEMODE.VampirDrainRates[ numEnemies ] or 2
                ply:SetHealth( math.max(ply:Health() - drainrate, (GAMEMODE.VampirDrainMins[ numEnemies ] or 20)) )
            end )
        end
    end )
end )

hook.Add( "EntityTakeDamage", "VampirDrain", function( vic, dmginfo )
    local att = dmginfo:GetAttacker()
    if CheckPerk( att ) == "vampir" and vic:IsPlayer() and dmginfo:IsBulletDamage() and att:Team() != vic:Team() then
        local toheal = dmginfo:GetDamage() * GAMEMODE.VampirDamageDrain
        local leechicon = att:Health() + toheal <= 100

        att:SetHealth( math.min(att:Health() + toheal, GAMEMODE.VampirDrainCap) )

        if leechicon then
            GAMEMODE:QueueIcon( att, "leech" )
        else
            GAMEMODE:QueueIcon( att, "overheal" )
        end 
    end

    if CheckPerk( vic ) == "vampir" then
        if vic:Health() > 100 then
            GAMEMODE:QueueIcon( att, "overheal_drain" )
        end
    end
end )

RegisterPerk( "Vampir", "vampir", 0, "Your health slowly drains, but damaging enemies heals you and can overheal you, capping at 150 hp." )