hook.Add( "PlayerSpawn", "Swiftness", function( ply )
	timer.Simple( 0, function()
		if CheckPerk( ply ) == "swift" then
			ply:SetWalkSpeed( 200 )
			ply:SetRunSpeed( 370 )
		end
	end )
end )

RegisterPerk( "Swiftness", "swift", 20, "Increased movement speed" )