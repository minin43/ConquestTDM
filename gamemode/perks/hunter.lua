hook.Add( "PostGiveLoadout", "Hunter", function( ply )
	if CheckPerk( ply ) == "hunter" then
		ply:SetWalkSpeed( GAMEMODE.DefaultWalkSpeed - 40 )
		ply:SetRunSpeed( GAMEMODE.DefaultRunSpeed + 150 )
	end
end )

RegisterPerk( "Hunter", "hunt", 7, "Reduced walking speed, highly boosted sprinting speed" )
