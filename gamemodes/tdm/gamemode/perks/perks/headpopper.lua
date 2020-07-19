hook.Add( "DoPlayerDeath", "HEAD-POPPER", function( vic, att, dmginfo )
    if vic:LastHitGroup() == HITGROUP_HEAD and CheckPerk( att ) == "headpopper" then
        local explosion = ents.Create( "env_explosion" )

        if IsValid( explosion ) then
            local explosionRadius = math.Clamp( math.Round( att:GetPos():Distance( vic:GetPos() ) / 12 ), 10, 1000 )
            explosion:SetPos( vic:GetPos() )
            explosion:SetOwner( att )
            explosion:Spawn()
            explosion:SetKeyValue( "iMagnitude", explosionRadius )
            explosion.headpopper = true
            timer.Simple( 0, function()
                explosion:Fire( "Explode", 0, 0 )
                util.BlastDamage( explosion, att, vic:GetPos(), explosionRadius * 2, explosionRadius ) --Since an explosion entity doesn't do damage
            end )

            GAMEMODE:QueueIcon( att, "headpopper" )
        end
    end
end )

hook.Add( "EntityTakeDamage", "ExtraHeadshotDamage", function( ply, dmginfo )
    if dmginfo:GetAttacker():IsPlayer() and ply:IsPlayer() and dmginfo:GetAttacker():Team() ~= ply:Team() and CheckPerk( dmginfo:GetAttacker() ) == "headpopper" then
        if ply:LastHitGroup() == HITGROUP_HEAD then
            dmginfo:ScaleDamage( 1.33 ) --Since headshots are already 1.5x, we want to add 1/3 for 2.0x total damage
        end
    end
end )

RegisterPerk( "Headpopper", "headpopper", 0, "Increased headshot damage, killing an enemy with a headshot creates an explosion, damaging any surrounding enemies.")