util.AddNetworkString( "TookThornmailDamage" )

hook.Add( "EntityTakeDamage", "Thornmail", function( ply, dmginfo )
	if dmginfo:GetAttacker():IsPlayer() and ply:IsPlayer() and dmginfo:GetAttacker():Team() != ply:Team() then
		if CheckPerk( ply ) == "thornmail" then
			dmginfo:GetAttacker():TakeDamage( dmginfo:GetDamage() * 0.15 )
			dmginfo:ScaleDamage( 0.85 )
			net.Start( "TookThornmailDamage" )
			net.Send( dmginfo:GetAttacker() )
		end
	end
end )

RegisterPerk( "Thornmail", "thornmail", 26, "Absorb 15% of incoming damage and deflects it back to the attacker." )