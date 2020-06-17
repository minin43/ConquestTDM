GM.BodyArmorUsers = {}

hook.Add( "ScalePlayerDamage", "BodyArmorDamageScaling", function( ply, hitgroup, dmginfo )
    if !dmginfo:GetAttacker():IsPlayer() then return end

    local bodyarmor = GAMEMODE.BodyArmorUsers[ ply ]
    if bodyarmor then
        local displayIcon = false
        if bodyarmor == "flak" then
            if dmginfo:IsExplosionDamage() then
                dmginfo:ScaleDamage( 0.25 )
                displayIcon = true
            end
        elseif bodyarmor == "hyperweave" then
            if dmginfo:IsBulletDamage() and dmginfo:GetDamage() > 50 then
                dmginfo:ScaleDamage( 0.9 )
                ply:EmitSound( "physics/flesh/flesh_strider_impact_bullet1.wav" )
                displayIcon = true
            elseif dmginfo:IsExplosionDamage() then
                dmginfo:ScaleDamage( 0.5 )
                displayIcon = true
            end
        end

        if displayIcon == true then
            GAMEMODE:QueueIcon( dmginfo:GetAttacker(), "bodyarmor" )
        end
    end
end )

hook.Add( "PlayerDeath", "RemoveBodyArmor", function( ply, wep, att )
    GAMEMODE.BodyArmorUsers[ ply ] = nil
end )