hook.Add( "SetupMove", "Freefall", function( ply, move )
	if CheckPerk( ply ) == "fall" then
		local vel = move:GetVelocity()
		if move:KeyDown( IN_JUMP ) and vel.z < 0 then
			move:SetVelocity( Vector( vel.x, vel.y, Lerp( 1/24, vel.z, 0 ) ) )
		end
	end
end )

hook.Add( "GetFallDamage", "FreefallDamage", function( ply, speed )
	if CheckPerk( ply ) == "fall" then
		speed = speed - 580
		return ( speed * ( 100 / ( 1024 - 580 ) ) ) / 5
	end
end )

RegisterPerk( "SkyDive", "fall", 17, "Reduced gravity while holding \"Jump\" while falling. You also take significantly less fall damage." )