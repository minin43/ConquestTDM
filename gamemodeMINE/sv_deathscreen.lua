local preventWeps = 0
hook.Add( "Think", "GetWeps", function()
	if CurTime() > preventWeps then
		preventWeps = CurTime() + 4
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
	end
end )

hook.Add( "DoPlayerDeath", "SendDeathScreen", function( ply, att, dmginfo )

	ply.NextSpawnTime = CurTime() + 4.5
	ply:SendLua( [[surface.PlaySound( "ui/UI_HUD_OutOfBounds_Count_Wave.mp3" )]] )
	local perk = "unknown"
	if att.class then perk = att.class elseif att.class == "unknown" or att.class == NULL then perk = "none" end
	local attacker
	if att and IsValid( att ) then attacker = att else attacker = ply end
	local hitgroup
	local wepused
	
	if ply:LastHitGroup() == HITGROUP_HEAD then
				hitgroup = "head"
			elseif ply:LastHitGroup() == HITGROUP_CHEST then
				hitgroup = "chest"
			elseif ply:LastHitGroup() == HITGROUP_STOMACH then
				hitgroup = "stomach"
			elseif ply:LastHitGroup() == HITGROUP_LEFTARM then
				hitgroup = "left arm"
			elseif ply:LastHitGroup() == HITGROUP_RIGHTARM then
				hitgroup = "right arm"
			elseif ply:LastHitGroup() == HITGROUP_LEFTLEG then
				hitgroup = "left leg"
			elseif ply:LastHitGroup() == HITGROUP_RIGHTLEG then
				hitgroup = "right leg"
			else 
				hitgroup = "unknown" 
		end
		
	if att and IsValid( att ) and att ~= NULL and att:IsPlayer() then
		if att:Alive() and att:GetActiveWeapon() and att:GetActiveWeapon() ~= NULL then
			wepused = att:GetActiveWeapon():GetClass()
		else
			wepused = att.LastUsedWep and att.LastUsedWep or "" 
		end
	else
		wepused = "unknown"
	end
	
	timer.Simple( 1.5, function()
		ply.num = 3
		
		umsg.Start( "DeathScreen", ply )
			umsg.Short( ply.num )
			umsg.Entity( attacker )
			umsg.Entity( ply )
			umsg.String( perk )
			umsg.String( hitgroup )
			umsg.String( wepused )
		umsg.End()
		
		local stid = ply:SteamID()
		timer.Create( "SendUpdates_" .. stid, 1, 3, function()
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