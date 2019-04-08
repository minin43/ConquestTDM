util.AddNetworkString( "Lifeline" )
util.AddNetworkString( "EndLifeline" )

hook.Add( "PostGiveLoadout", "LifelineSpawn", function( ply )
	if CheckPerk( ply ) == "lifeline" then
		GAMEMODE.PerkTracking[ id( ply:SteamID() ) ].LifelineBonus = GAMEMODE.PerkTracking[ id( ply:SteamID() ) ].LifelineBonus or 0
		GAMEMODE.PerkTracking.LifelineList[ ply ] = true
		timer.Simple( 0.1, function()			
			ply:SetMaxHealth( 100 + GAMEMODE.PerkTracking[ id( ply:SteamID() ) ].LifelineBonus ) 
			ply:SetHealth( 100 + GAMEMODE.PerkTracking[ id( ply:SteamID() ) ].LifelineBonus )
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
			GAMEMODE.PerkTracking[ id( att:SteamID() ) ].LifelineBonus = GAMEMODE.PerkTracking[ id( att:SteamID() ) ].LifelineBonus + 10
			--att:SetMaxHealth( att:GetMaxHealth() + 10 ) --If this ends up being too strong, we can set the max health to be temporary
			att:SetHealth( math.Clamp( att:Health() + 50, 0, att:GetMaxHealth() ) )

			if timer.Exists( "LifelineEffectTimer" ) then
				timer.Adjust( "LifelineEffectTimer", 2, 1, function()
					net.Start( "EndLifeline" )
					net.Send( att )
					timer.Remove( "LifelineEffectTimer" )
				end )
			else
				net.Start( "Lifeline" )
				net.Send( att )
				
				timer.Create( "LifelineEffectTimer", 2, 1, function()
					net.Start( "EndLifeline" )
					net.Send( att )
					timer.Remove( "LifelineEffectTimer" )
				end )
			end
		end
	end
end )

--//A bit expensive
hook.Add( "Think", "LifelineChecks", function()
	for k, v in pairs( GAMEMODE.PerkTracking.LifelineList ) do
		if k:IsValid() then
			k:SetWalkSpeed( math.Round( ( GAMEMODE.DefaultWalkSpeed - 30 ) + ( GAMEMODE.DefaultWalkSpeed - 30 ) * ( 1 - ( k:Health() / k:GetMaxHealth() ) ) ) )
			k:SetRunSpeed ( math.Round( ( GAMEMODE.DefaultRunSpeed - 50 ) + ( GAMEMODE.DefaultRunSpeed - 50 ) * ( 1 - ( k:Health() / k:GetMaxHealth() ) ) ) )
			k:SetJumpPower( math.Round( ( GAMEMODE.DefaultJumpPower - 30 ) + ( GAMEMODE.DefaultJumpPower - 30 ) * ( 1 - ( k:Health() / k:GetMaxHealth() ) ) ) )
		else
			k = nil
		end
	end
end )

RegisterPerk( "Lifeline", "lifeline", 50, "Walk speed, sprint speed, & jump height are based on missing health. Headshots and kills while low revitalize you,"
	.. " increasing your health by 50 and max health by 10." )