hook.Add( "GetFallDamage", "Flopper", function( ply, speed )
	if CheckPerk( ply ) == "flopper" then
		local explosion = ents.Create( "env_explosion" )
		if not IsValid( explosion ) then return 0 end
		explosion:SetPos( ply:GetPos() )
		explosion:SetOwner( ply )
		explosion:Spawn()
		explosion:SetKeyValue( "iMagnitude", speed * ( 100 / ( 1024 - 580 ) ) )
		explosion:Fire( "Explode", 0, 0 )
		
		return 0
	end
end )

RegisterPerk( "Flopper", "flopper", 39, "You will not receive any fall damage, but you will create a small explosion that deals damage equal to the amount of damage you should of taken through falling." )