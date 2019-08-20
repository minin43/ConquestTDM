util.AddNetworkString( "TookThornmailDamage" )

hook.Add( "EntityTakeDamage", "Thornmail", function( ply, dmginfo )
	if dmginfo:GetAttacker():IsPlayer() and ply:IsPlayer() and dmginfo:GetAttacker():Team() != ply:Team() then
		if CheckPerk( ply ) == "thornmail" and dmginfo:IsBulletDamage() then
			if dmginfo:GetAttacker():Health() < dmginfo:GetDamage() * 0.1 then
				dmginfo:GetAttacker():TakeDamage( dmginfo:GetAttacker():Health() - 1, ply )
			else
				dmginfo:GetAttacker():TakeDamage( dmginfo:GetDamage() * 0.1, ply )
			end

			net.Start( "TookThornmailDamage" )
			net.Send( dmginfo:GetAttacker() )
		end
	end
end )

RegisterPerk( "Thornmail", "thornmail", 40, "Reflects 10% of bullet damage back to the attacker, causing disorientation." )