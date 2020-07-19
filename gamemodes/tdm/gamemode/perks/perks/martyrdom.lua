hook.Add( "PlayerDeath", "MartyrdomDrop", function( vic, wep, att )
    if CheckPerk( vic ) == "martyrdom" then
        local grenade = ents.Create( "cw_grenade_thrown" )
        grenade:SetPos( vic:GetPos() )
        --grenade:SetAngles(self.Owner:EyeAngles())
        grenade:Spawn()
        grenade:Activate()
        grenade:Fuse( 1 )
        grenade:SetOwner( vic )
    end
end )

hook.Add("EntityTakeDamage", "ScaleMartyrdomExplosiveDamage", function( ply, dmginfo )
    if CheckPerk( ply ) == "martyrdom" then
        if dmginfo:IsExplosionDamage() then
            dmginfo:ScaleDamage( 0.5 )
        end
    end
end )

if CustomizableWeaponry then --//Since the perk uses the thrown grenade entity from the cw2.0 pack, only include the perk if cw2.0 exists
    RegisterPerk( "Martyrdom", "martyrdom", 0, "Gain 50% explosive damage resistance, and drop a live, short-fused grenade upon death." )
end