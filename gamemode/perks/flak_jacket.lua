hook.Add( "EntityTakeDamage", "FlakJacket", function( ply, dmginfo )
	if ply:IsPlayer() and dmginfo:IsExplosionDamage() and CheckPerk( ply ) == "flak" then
		dmginfo:ScaleDamage( 0.1 )
	end
end )

RegisterPerk( "Flak Jacket", "flak", 23, "Explosive damage is significantly reduced.\n\n\"Explosives? You mean air conditioning?\"" )