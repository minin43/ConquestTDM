util.AddNetworkString( "Lifeline" )
util.AddNetworkString( "EndLifeline" )

hook.Add( "PostGiveLoadout", "LifelineSpawn", function( ply )
	if CheckPerk( ply ) == "lifeline" then
		--GAMEMODE.PerkTracking[ id( ply:SteamID() ) ].LifelineBonus = GAMEMODE.PerkTracking[ id( ply:SteamID() ) ].LifelineBonus or 0
		GAMEMODE.PerkTracking.LifelineList[ ply ] = true
		--[[timer.Simple( 0.1, function()			
			ply:SetMaxHealth( 100 + GAMEMODE.PerkTracking[ id( ply:SteamID() ) ].LifelineBonus ) 
			ply:SetHealth( 100 + GAMEMODE.PerkTracking[ id( ply:SteamID() ) ].LifelineBonus )
		end )]]
	else
		if GAMEMODE.PerkTracking.LifelineList[ ply ] then
			GAMEMODE.PerkTracking.LifelineList[ ply ] = nil
		end
	end
end )

--//A bit expensive
hook.Add( "Think", "LifelineMovementSetting", function()
	for k, v in pairs( GAMEMODE.PerkTracking.LifelineList ) do
		if v and k:IsValid() then
			k:SetWalkSpeed( math.Round( ( GAMEMODE.DefaultWalkSpeed - 30 ) + ( GAMEMODE.DefaultWalkSpeed - 30 ) * ( 1 - ( k:Health() / k:GetMaxHealth() ) ) ) )
			k:SetRunSpeed ( math.Round( ( GAMEMODE.DefaultRunSpeed - 50 ) + ( GAMEMODE.DefaultRunSpeed - 50 ) * ( 1 - ( k:Health() / k:GetMaxHealth() ) ) ) )
			k:SetJumpPower( math.Round( ( GAMEMODE.DefaultJumpPower - 30 ) + ( GAMEMODE.DefaultJumpPower - 30 ) * ( 1 - ( k:Health() / k:GetMaxHealth() ) ) ) )
		else
			k = nil
		end
	end
end )

hook.Add( "EntityTakeDamage", "LifelineDamageReduction", function( ply, dmginfo )
    if ply:IsValid() and ply:IsPlayer() then
		if CheckPerk( ply ) == "lifeline" then
			dmginfo:ScaleDamage( math.Clamp( 1 - ( ( ply:GetMaxHealth() - ply:Health() ) / 105 ), 0, 1 ) ) --//Not very complicated scaling, might make this mechanic too strong
		end
	end
end )

RegisterPerk( "Lifeline", "lifeline", 50, "Walk speed, sprint speed, jump height, & damage taken all scale with missing health; the lower, the better, the higher the worse." )