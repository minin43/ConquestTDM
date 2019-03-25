hook.Add( "PostGiveLoadout", "Hunter", function( ply )
	if CheckPerk( ply ) == "hunter" then
		ply:SetWalkSpeed( GAMEMODE.DefaultWalkSpeed - 40 )
		ply:SetRunSpeed( GAMEMODE.DefaultRunSpeed + 90 )
	end
end )

RegisterPerk( "Hunter", "hunter", 5, "Reduced walking speed, highly boosted sprinting speed" )
