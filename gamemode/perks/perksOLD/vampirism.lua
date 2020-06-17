hook.Add( "PlayerDeath", "Vampirism", function( vic, inf, att )
	if CheckPerk( att ) == "vamp" then
		if att:Alive() then
			att:SetHealth( att:Health() + ( ( 100 - att:Health() ) / 3 ) )
		end
	end
end )

function VampirismAssist( ply, value )
	if CheckPerk( ply ) == "vamp" then
		if ply:Alive() then
			ply:SetHealth( ply:Health() + ( ( ( 100 - ply:Health() ) / 3 ) * value / 100 ) )
		end
	end
end

RegisterPerk( "Vampirism", "vamp", 37, "Killing an enemy will restore 1/3 of your missing health. Getting an assist will restore a % of 1/3 of your missing health." )
