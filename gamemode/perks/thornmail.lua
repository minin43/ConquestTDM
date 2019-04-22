util.AddNetworkString( "TookThornmailDamage" )

hook.Add( "EntityTakeDamage", "Thornmail", function( ply, dmginfo )
	if dmginfo:GetAttacker():IsPlayer() and ply:IsPlayer() and dmginfo:GetAttacker():Team() != ply:Team() then
		if CheckPerk( ply ) == "thornmail" then
			dmginfo:GetAttacker():TakeDamage( dmginfo:GetDamage() * 0.05, ply )
			net.Start( "TookThornmailDamage" )
			net.Send( dmginfo:GetAttacker() )
		end
	end
end )

RegisterPerk( "Thornmail", "thornmail", 28, "Reflects 5% of damage back to the attacker, causing aim knockup." )