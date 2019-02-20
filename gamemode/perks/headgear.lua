hook.Add( "ScalePlayerDamage", "KevlarVest", function( ply, hitgroup, dmginfo )
	if CheckPerk( ply ) == "kevlar" and hitgroup == HITGROUP_HEAD then
		dmginfo:ScaleDamage( 0.5 )
	end
end )

RegisterPerk( "Headgear", "helmet", 46, "Equip a protective headgear that reduces head damage by 50%" )