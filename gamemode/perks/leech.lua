hook.Add( "PlayerDeath", "Leech", function( vic, inf, att )
	if CheckPerk( att ) == "leech" then
		if att:Alive() then
			att:SetHealth( att:Health() + ( ( att:GetMaxHealth() - att:Health() ) / 3 ) )
		end
	end
end )

--//Used in sv_feed in the assist calculation block
function VampirismAssist( ply, value )
	if CheckPerk( ply ) == "leech" then
		if ply:Alive() then
			ply:SetHealth( ply:Health() + ( ( ( ply:GetMaxHealth() - ply:Health() ) / 3 ) * value / ply:GetMaxHealth() ) )
		end
	end
end

RegisterPerk( "Leech", "leech", 37, "Kills and assists on enemies restore 1/3 and % 1/3 of missing health." )