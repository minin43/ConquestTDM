hook.Add( "PlayerSpawn", "Illumin", function( ply )
timer.Simple( 0.1, function()
if CheckPerk( ply ) == "illumin" then
	ply.class = "Illumin"
    ply:SetWalkSpeed( 210 ) --default is 180, swiftness' was 215
	ply:SetRunSpeed ( 350 ) --default is 300, swiftness' was 350
    ply:SetJumpPower( 190 ) --default is 170
    
    --[[if (ply:Team() == 1) then
		ply:SetModel( "models/csgoanarchist1pm.mdl" )
	elseif (ply:Team() == 2) then
		ply:SetModel( "models/csgosas1pm.mdl" )
	end]]
    
    ply:SetMaxHealth( 80 )
    ply:SetHealth( 80 )
    end
end )
end )

RegisterPerk( "Illumin", "illumin", 10, "Move speed, sprint speed, and jump height increased by 17%, but start with less health." )