util.AddNetworkString( "TookThornmailDamage" )

hook.Add( "EntityTakeDamage", "Thornmail", function( ply, dmginfo )
	if dmginfo:GetAttacker():IsPlayer() and dmginfo:IsBulletDamage() and dmginfo:GetAttacker():Team() ~= ply:Team() then
		if CheckPerk( dmginfo:GetAttacker() ) == "thorns" then
			dmginfo:GetAttacker():TakeDamage( dmginfo:GetDamage() * 0.05 )
			dmginfo:ScaleDamage( 0.85 )
			net.Start( "TookThornmailDamage" )
			net.Send( dmginfo:GetAttacker() )
		end
	end
end )

RegisterPerk( "Thornmail", "thornmail", 65, "Absorb 10% of incoming damage, and deflect 5% back to the attacker." )