hook.Add( "PlayerSpawn", "Lifeline", function( ply )
	if CheckPerk( ply ) == "lifeline" and (ply.MaxHealth == nil or ply.MaxHealth < 101) then
		ply.MaxHealth = 100
	end
	timer.Simple( 0.1, function()
		if CheckPerk( ply ) == "lifeline" then
			ply.class = "Lifeline"
			ply:SetWalkSpeed( 150 ) --default is 180
			ply:SetRunSpeed ( 250 ) --default is 300
			ply:SetJumpPower( 150 ) --default is 170
    
			--[[if (ply:Team() == 1) then
				ply:SetModel( "models/csgopirate3pm.mdl" )
			elseif (ply:Team() == 2) then
				ply:SetModel( "models/csgosas3pm.mdl" )
			end]]
    
			ply:SetMaxHealth( ply.MaxHealth ) 
			ply:SetHealth( ply.MaxHealth )
		end
	end )
end )

hook.Add( "PlayerDeath", "LifeLine", function( ply, inf, att )
	if CheckPerk( att ) == "lifeline" and (att:Health() < 16 or ply:LastHitGroup() == HITGROUP_HEAD) and ply != att then
		att.MaxHealth = att.MaxHealth + 10
		att:SetHealth( att:Health() + 50 )
		--ply.rejuvkills = ply.rejuvkills + 1
		att:SetWalkSpeed( 150 * (1 + ( ( att:GetMaxHealth() - att:Health() ) / 100 ) ) )
		att:SetRunSpeed ( 250 * (1 + ( ( att:GetMaxHealth() - att:Health() ) / 100 ) ) )
		att:SetJumpPower( 150 * (1 + ( ( att:GetMaxHealth() - att:Health() ) / 70 ) ) )
	end
end )

hook.Add( "EntityTakeDamage", "Lifeline", function ( ply, dmginfo )
	if CheckPerk( ply ) == "lifeline" then
		if ply:Health() == 100 and dmginfo:GetDamage() == 0 then 
			return 
		end
		ply:SetWalkSpeed( 150 * (1 + ( ( ply:GetMaxHealth() - ply:Health() ) / 100 ) ) )
		ply:SetRunSpeed ( 250 * (1 + ( ( ply:GetMaxHealth() - ply:Health() ) / 100 ) ) )
		ply:SetJumpPower( 150 * (1 + ( ( ply:GetMaxHealth() - ply:Health() ) / 70 ) ) )
	end

	--if CheckPerk( dmginfo:GetAttacker() ) and 
end )

RegisterPerk( "Lifeline", "lifeline", 60, "Movement speed and sprint speed is based on missing health. Killing someone while having less than 15 health, or getting a headshot, revitalizes you, increasing your health by 50 and max health by 10." )