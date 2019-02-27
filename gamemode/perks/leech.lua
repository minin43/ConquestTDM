hook.Add( "PlayerDeath", "Leech", function( vic, inf, att )
	if CheckPerk( att ) == "leech" then
		if att:Alive() then
			att:SetHealth( att:Health() + ( ( att:GetMaxHealth() - att:Health() ) / 3 ) )
		end
	end
end )

--// Currently unused
function VampirismAssist( ply, value )
	if CheckPerk( ply ) == "leech" then
		if ply:Alive() then
			ply:SetHealth( ply:Health() + ( ( ( 100 - ply:Health() ) / 3 ) * value / 100 ) )
		end
	end
end

RegisterPerk( "Leech", "leech", 28, "Killing an enemy will restore 1/3 of your missing health." )