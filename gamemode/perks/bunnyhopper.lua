hook.Add( "SetupMove", "Bunnyhopper", function( ply, move )
	if CheckPerk( ply ) == "bhop" then
		if not ply:IsOnGround() then
			move:SetButtons( bit.band( move:GetButtons(), bit.bnot( IN_JUMP ) ) )
		end
	end
end )

--RegisterPerk( "Bunnyhopper", "bhop", 10, "Holding down \"Jump\" will cause you to jump immediately when you touch the ground." )