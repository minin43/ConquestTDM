hook.Add( "PostGiveLoadout", "Hunter", function( ply )
	if CheckPerk( ply ) == "hunter" then
		ply:SetWalkSpeed( GAMEMODE.DefaultWalkSpeed - 40 )
		ply:SetRunSpeed( GAMEMODE.DefaultRunSpeed + 80 )
	end
end )

RegisterPerk( "Hunter", "hunter", 4, "Reduced walking speed, highly boosted sprinting speed" )
