hook.Add( "PlayerDeath", "Leech", function( vic, inf, att )
	if CheckPerk( att ) == "leech" then
		if att:Alive() then
            att:SetHealth( att:Health() + ( ( att:GetMaxHealth() - att:Health() ) / 2 ) )
            GAMEMODE:QueueIcon( att, "leech" )
		end
	end
end )

--//Used in sv_feed in the assist calculation block
function VampirismAssist( ply, value )
	if CheckPerk( ply ) == "leech" then
		if ply:Alive() then
            ply:SetHealth( ply:Health() + ( ( ( ply:GetMaxHealth() - ply:Health() ) / 2 ) * value / ply:GetMaxHealth() ) )
            GAMEMODE:QueueIcon( att, "leech" )
		end
	end
end

RegisterPerk( "Leech", "leech", 55, "Kills and assists on enemies restore 1/2 and % 1/2 of missing health." )