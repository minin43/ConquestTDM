hook.Add( "Think", "GetWeps", function()
	for k, v in next, player.GetAll() do
		if IsValid( v ) and v:Alive() then
			local wep = v:GetActiveWeapon()
			if wep ~= nil and wep ~= NULL then
				if wep:GetClass() then
					v.LastUsedWep = wep:GetClass()
				end
			end
		end
	end
end )

hook.Add( "DoPlayerDeath", "SendDeathScreen", function( ply, att, dmginfo )
	ply.NextSpawnTime = CurTime() + 6.5
	ply:SendLua( [[surface.PlaySound( "ui/UI_HUD_OutOfBounds_Count_Wave.mp3" )]] )
	timer.Simple( 1.5, function()
		if att and IsValid( att ) then
			ply:SpectateEntity( att )
			ply:Spectate( OBS_MODE_CHASE )
		end
		ply.num = 5
		umsg.Start( "DeathScreen", ply )
			if att and IsValid( att ) then
				umsg.Entity( att )
			else
				umsg.Entity( ply )
			end
			umsg.Bool( ply:LastHitGroup() == HITGROUP_HEAD )
			if att and IsValid( att ) and att ~= NULL and att:IsPlayer() then
				if att:Alive() and att:GetActiveWeapon() and att:GetActiveWeapon() ~= NULL then
					umsg.String( att:GetActiveWeapon():GetClass() )
				else
					umsg.String( att.LastUsedWep and att.LastUsedWep or "" )
				end
			else
				umsg.String( "" )
			end
			umsg.Short( ply.num )
		umsg.End()
		local stid = ply:SteamID()
		timer.Create( "SendUpdates_" .. stid, 1, 5, function()
			if ply:IsValid() and ply:IsPlayer() then
				umsg.Start( "UpdateDeathScreen", ply )
					ply.num = ply.num - 1
					if ply.num < 0 then
						ply.num = 0
					end
					umsg.Short( ply.num )
				umsg.End()
			end
		end )
	end )
end )

hook.Add( "PlayerSpawn", "closeds", function( ply )
	umsg.Start( "CloseDeathScreen", ply )
	umsg.End()
end )