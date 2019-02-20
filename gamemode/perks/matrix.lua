hook.Add( "EntityTakeDamage", "Matrix", function( ply, dmginfo )
	if CheckPerk( ply ) == "matrix" then
		local num = math.random( 1, 1000 )
		local chance = 120
		
		if num < chance then
			dmginfo:ScaleDamage( 0 )
		end
	end
end )

--RegisterPerk( "Matrix", "matrix", 72, "Have a 3%/5.5%/8%/12% chance to dodge bullets depending if you're running/walking/standing/crouching." )