hook.Add( "PlayerSpawn", "DefaultClass", function( ply )
    timer.Simple( 0.05, function()
        if CheckPerk( ply ) != "brainstorm" or CheckPerk( ply ) != "murk" or CheckPerk( ply ) != "leech" 
        or CheckPerk( ply ) != "lifeline" or CheckPerk( ply ) != "magician" or CheckPerk( ply ) != "illumin" or CheckPerk( ply ) != "vulture" then
            ply.class = "None" --So when a player kills you when you aren't using a perk, it doesn't phreak out
            --[[if (ply:Team() == 1) then
				ply:SetModel( "models/csgopheonix4pm.mdl" )
			elseif (ply:Team() == 2) then
				ply:SetModel( "models/csgoidf4pm.mdl" )
			end]]
        end
    end )
end )