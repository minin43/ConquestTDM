hook.Add( "PlayerSpawn", "DoubleJumpIncreease", function( ply )
	timer.Simple( 0, function()
		if CheckPerk( ply ) == "dbjump" then
			ply:SetJumpPower( 215 )
		end
	end )
end )

tf2_dbjumpsound = {
	Sound( "player/pl_scout_jump1.wav" ),
	Sound( "player/pl_scout_jump2.wav" ),
	Sound( "player/pl_scout_jump3.wav" ),
	Sound( "player/pl_scout_jump4.wav" )
}

hook.Add( "SetupMove", "DoubleJump", function( ply, mv, cmd )

	ply.CanDoubleJump = ply.CanDoubleJump and true

	if CheckPerk( ply ) == "dbjump" then
		if mv:KeyPressed( IN_JUMP ) and !ply:IsOnGround() and ply.CanDoubleJump then
			local Vel = mv:GetVelocity()
			local zVel = 0
			if Vel.z <= -10 then zVel = math.abs( Vel.z ) end
			mv:SetVelocity( Vel + Vector( 0, 0, ( ply:GetJumpPower() * 1.34 ) + zVel ) )
			sound.Play( table.Random( tf2_dbjumpsound ), ply:GetPos(), 80, 100 )
			ply.CanDoubleJump = false
		elseif ply:IsOnGround() then
			ply.CanDoubleJump = true
		end
	end

end )

--RegisterPerk( "Double Jump", "doublejump", 0, "Gain the ability to double jump, jump height is slightly increased." )