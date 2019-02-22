hook.Add( "PlayerSpawn", "Hunter", function( ply )
	timer.Simple( 0, function()
		if CheckPerk( ply ) == "hunter" then
			ply:SetWalkSpeed( 300 )
			ply:SetRunSpeed( 500 )
		end
	end )
end )

RegisterPerk( "Hunter", "hunt", 7, "Reduced walking speed, highly boosted sprinting speed" )
