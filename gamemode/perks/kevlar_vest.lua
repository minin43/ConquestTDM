hook.Add( "ScalePlayerDamage", "KevlarVest", function( ply, hitgroup, dmginfo )
	if CheckPerk( ply ) == "kevlar" then
		if hitgroup == HITGROUP_CHEST then
			dmginfo:ScaleDamage( 0.6 )
		elseif hitgroup == HITGROUP_STOMACH then
			dmginfo:ScaleDamage( 0.5 )
		end
	end
end )

RegisterPerk( "Kevlar Vest", "kevlar", 42, "Equip a bulletproof vest that reduces chest and stomach damage by 25%" )