util.AddNetworkString( "CloseDeathScreen" )
util.AddNetworkString( "StartDeathScreen" )
util.AddNetworkString( "UpdateDeathScreen" )
util.AddNetworkString( "PreDeathScreen" )

function GM:PlayerDeathThink( ply )
	if ply.NextSpawnTime and ply.NextSpawnTime > CurTime() then 
		return
	end
	if ply:KeyPressed( IN_JUMP ) then
		ply:Spawn()
        net.Start( "CloseDeathScreen" )
        net.Send( ply )
	end
end

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
    ply.NextSpawnTime = CurTime() + 4.5
    ply:SendSound( "ui/UI_HUD_OutOfBounds_Count_Wave.mp3" )
	
	--//If what you died to wasn't a player, defaulting to your own fault (this includes trigger_hurt, trigger_kill, worldspawn, and more)
	if !att:IsPlayer() then att = ply elseif ply:IsBot() then return true end

	--//Killer's perk
	local perk = GAMEMODE.PerkTracking[ id( att:SteamID() ) ].ActivePerk or "none"
	
	--//Killer's entity
	local attacker = att or ply

	--//Killer's HP, saved here instead of in 1.5 seconds when their health may or may not have changed
	local remaininghp = attacker:Health() or 0

	--//Killshot position
	local killshots = {
		HITGROUP_HEAD = "head",
		HITGROUP_CHEST = "chest",
		HITGROUP_STOMACH = "stomach",
		HITGROUP_LEFTARM = "left arm",
		HITGROUP_RIGHTARM = "right arm",
		HITGROUP_LEFTLEG = "left leg",
		HITGROUP_RIGHTLEG = "right leg"
	}
	local hitgroup = "suicide"
	if dmginfo:IsBulletDamage() then
		hitgroup = killshots[ ply:LastHitGroup() ] or "unknown"
	elseif dmginfo:IsExplosionDamage() then
		hitgroup = "internal"
	elseif dmginfo:IsFallDamage() then
		hitgroup = "ground"
	end
	
	--//Weapon used
	local wepused
	if att and att:IsValid() and att:IsPlayer() and dmginfo:IsBulletDamage() then
		if att:Alive() and att:GetActiveWeapon() and att != ply then
			wepused = att:GetActiveWeapon():GetClass()
		else
			wepused = att.LastUsedWep or "unknown" 
		end
	else
		wepused = "none"
	end
	
	local damagedone = 0
	timer.Simple( 0, function()
		if ply != att and att:IsPlayer() then
			damagedone = GAMEMODE.DamageSaving[ id(attacker:SteamID()) ][ id(ply:SteamID()) ] or dmginfo:GetDamage()
		end

		net.Start( "PreDeathScreen" )
			net.WriteTable( GAMEMODE.DamageSaving[ id(ply:SteamID()) ] )
		net.Send( ply )
	end )

	local wasVendetta = false
	if GAMEMODE.VendettaList[ id( attacker:SteamID() ) ].ActiveSaves and GAMEMODE.VendettaList[ id( attacker:SteamID() ) ].ActiveSaves[ id( ply:SteamID() ) ] then
		wasVendetta = true
	end

	local title = GAMEMODE.EquippedTitles[ id( attacker:SteamID() ) ] or ""

	--//Flavor timer
	timer.Simple( 1.5, function()
		ply.num = 3 --3 seconds, after the deathscreen shows up, before you can spawn (total of 4.5 seconds before respawning)
		
        net.Start( "StartDeathScreen" )
            net.WriteInt( ply.num, 4 )
            net.WriteEntity( attacker )
            net.WriteEntity( ply )
            net.WriteString( perk )
            net.WriteString( hitgroup )
            net.WriteString( wepused )
			net.WriteString( title )
			net.WriteInt( remaininghp, 8 )
            net.WriteInt( GAMEMODE.KillInfoTracking[ id( att:SteamID() ) ].KillsThisLife, 8 )
            net.WriteInt( damagedone, 16 )
            net.WriteBool( wasVendetta )
        net.Send( ply )
		
		local stid = ply:SteamID()
		timer.Create( "SendUpdates_" .. stid, 1, 3, function()
			if ply:IsValid() and ply:IsPlayer() and !ply:Alive() then
                ply.num = ply.num - 1
                if ply.num < 0 then
                    ply.num = 0
                end

                net.Start( "UpdateDeathScreen" )
					net.WriteInt( ply.num, 4 )
				net.Send( ply )
			end
		end )
	end )
end )

hook.Add( "PlayerSpawn", "SetupInfo&CloseDeathScreen", function( ply )
	if ply:IsBot() then return end
    net.Start( "CloseDeathScreen" )
    net.Send( ply )

	GAMEMODE.DamageSaving[ id(ply:SteamID()) ] = {}
	for k, v in pairs( player.GetAll() ) do
		GAMEMODE.DamageSaving[ id(v:SteamID()) ][ id(ply:SteamID()) ] = 0
	end
end )

hook.Add( "EntityTakeDamage", "TrackDamage", function( vic, dmginfo )
	local att = dmginfo:GetAttacker()
	if vic and vic:IsPlayer() and !vic:IsBot() and att and att:IsPlayer() then
		local vicID = id( vic:SteamID() )
		local attID = id( att:SteamID() )

		local damagedone = vic:Health() -- dmginfo:GetDamage()
		--//Track damage throughout your current life, wait for server to calculate damage reduction from other mechanics
		timer.Simple( 0, function()
			damagedone = damagedone - vic:Health()
			GAMEMODE.DamageSaving[ vicID ][ attID ] = (GAMEMODE.DamageSaving[ vicID ][ attID ] or 0) + damagedone
		end )
	end
end )