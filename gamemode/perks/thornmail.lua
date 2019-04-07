util.AddNetworkString( "TookThornmailDamage" )

hook.Add( "EntityTakeDamage", "Thornmail", function( ply, dmginfo )
	if dmginfo:GetAttacker():IsPlayer() and ply:IsPlayer() and dmginfo:GetAttacker():Team() != ply:Team() then
		if CheckPerk( ply ) == "thornmail" then
			dmginfo:GetAttacker():TakeDamage( dmginfo:GetDamage() * 0.10, ply )
			dmginfo:ScaleDamage( 0.90 )
			net.Start( "TookThornmailDamage" )
			net.Send( dmginfo:GetAttacker() )
		end
	end
end )

RegisterPerk( "Thornmail", "thornmail", 28, "Absorb 10% of incoming damage and deflects it back to the attacker." )