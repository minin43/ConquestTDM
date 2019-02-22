hook.Add( "PlayerSpawn", "LifelineSpawn", function( ply )
	if CheckPerk( ply ) == "lifeline" then
		GAMEMODE.PerkTracking[ id( ply ) ].LifelineBonus = GAMEMODE.PerkTracking[ id( ply ) ].LifelineBonus or 0
		GAMEMODE.PerkTracking.LifelineList[ ply ] = true
		timer.Simple( 0.1, function()			
			ply:SetMaxHealth( 100 + GAMEMODE.PerkTracking[ id( ply ) ].LifelineBonus ) 
			ply:SetHealth( 100 + GAMEMODE.PerkTracking[ id( ply ) ].LifelineBonus )
		end )
	else
		if GAMEMODE.PerkTracking.LifelineList[ ply ] then
			GAMEMODE.PerkTracking.LifelineList[ ply ] = nil
		end
	end
end )

hook.Add( "PlayerDeath", "LifelineKill", function( ply, wep, att )
	if CheckPerk( att ) == "lifeline" and ply != att then
		if att:Health() <= 20 or ply:LastHitGroup() == HITGROUP_HEAD then
			GAMEMODE.PerkTracking[ id( ply ) ].LifelineBonus = GAMEMODE.PerkTracking[ id( ply ) ].LifelineBonus + 10
			att:SetMaxHealth( att:GetMaxHealth() + 10 )
			att:SetHealth( att:Health() + 50 )
		end
	end
end )

--//A bit expensive
hook.Add( "Think", "LifelineChecks", function()
	for k, v in pairs( GAMEMODE.PerkTracking.LifelineList ) do
		k:SetWalkSpeed( 150 * (1 + ( ( k:GetMaxHealth() - k:Health() ) / 100 ) ) )
		k:SetRunSpeed ( 250 * (1 + ( ( k:GetMaxHealth() - k:Health() ) / 100 ) ) )
		k:SetJumpPower( 150 * (1 + ( ( k:GetMaxHealth() - k:Health() ) / 70 ) ) )
	end
end )

RegisterPerk( "Lifeline", "lifeline", 42, "Walk speed, sprint speed, & jump height are based on missing health. Headshots and kills while damage low revitalizes you, increasing your health by 50 and max health by 10." )