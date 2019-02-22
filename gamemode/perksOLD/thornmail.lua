--[[hook.Add( "EntityTakeDamage", "Thornmail", function( ply, dmginfo )
	if dmginfo:GetAttacker():IsPlayer() and dmginfo:IsBulletDamage() and dmginfo:GetAttacker():Team() ~= ply:Team() then
		if CheckPerk( dmginfo:GetAttacker() ) == "thorns" then
			dmginfo:GetAttacker():TakeDamage( dmginfo:GetDamage() * 0.1 )
			dmginfo:ScaleDamage( 0.8 )
		end
	end
end )]]--

--RegisterPerk( "Thornmail", "thorns", 65, "Reflect 10% damage and absorb 10% damage." )