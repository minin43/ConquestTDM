function GM:PlayerDeathThink( ply )
	if ply.NextSpawnTime and ply.NextSpawnTime > CurTime() then 
		return
	end
	if ply:KeyPressed( IN_JUMP ) then
		ply:Spawn()
		umsg.Start( "CloseDeathScreen", ply )
		umsg.End()
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
	ply:SendLua( [[surface.PlaySound( "ui/UI_HUD_OutOfBounds_Count_Wave.mp3" )]] )
	
	--//If what you died to wasn't a player, defaulting to your own fault (this includes trigger_hurt, trigger_kill, worldspawn, and more)
	if !att:IsPlayer() then att = ply end

	--//Killer's perk
	local perk = GAMEMODE.PerkTracking[ id( att:SteamID() ) ].ActivePerk or "none"
	
	--//Killer's entity
	local attacker = att or ply

	--//Killshot position
	local hitgroup
	if dmginfo:IsBulletDamage() then
		local throwaway = ply:LastHitGroup()
		if throwaway == HITGROUP_HEAD then
			hitgroup = "head"
		elseif throwaway == HITGROUP_CHEST then
			hitgroup = "chest"
		elseif throwaway == HITGROUP_STOMACH then
			hitgroup = "stomach"
		elseif throwaway == HITGROUP_LEFTARM then
			hitgroup = "left arm"
		elseif throwaway == HITGROUP_RIGHTARM then
			hitgroup = "right arm"
		elseif throwaway == HITGROUP_LEFTLEG then
			hitgroup = "left leg"
		elseif throwaway == HITGROUP_RIGHTLEG then
			hitgroup = "right leg"
		else 
			hitgroup = "unknown" 
		end
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
	if ply != att and att:IsPlayer() then
		if !GAMEMODE.DamageSaving[ id( attacker:SteamID() ) ][ GAMEMODE.DamageSaving[ id( attacker:SteamID() ) ].lifeCount ] or !GAMEMODE.DamageSaving[ id( attacker:SteamID() ) ][ GAMEMODE.DamageSaving[ id( attacker:SteamID() ) ].lifeCount ][ id( ply:SteamID() ) ] then
			damagedone = dmginfo:GetDamage()
		else
			damagedone = GAMEMODE.DamageSaving[ id( attacker:SteamID() ) ][ GAMEMODE.DamageSaving[ id( attacker:SteamID() ) ].lifeCount ][ id( ply:SteamID() ) ][ GAMEMODE.DamageSaving[ id( ply:SteamID() ) ].lifeCount ] or 0
		end
	else
		damagedone = 0
	end

	local wasVendetta = false
	if GAMEMODE.VendettaList[ id( attacker:SteamID() ) ].ActiveSaves and GAMEMODE.VendettaList[ id( attacker:SteamID() ) ].ActiveSaves[ id( ply:SteamID() ) ] then
		wasVendetta = true
		GAMEMODE.VendettaList[ id( attacker:SteamID() ) ].ActiveSaves[ id( ply:SteamID() ) ] = false
	end

	--//Flavor timer
	timer.Simple( 1.5, function()
		ply.num = 3
		
		umsg.Start( "DeathScreen", ply )
			umsg.Short( ply.num )
			umsg.Entity( attacker )
			umsg.Entity( ply )
			umsg.String( perk )
			umsg.String( hitgroup )
			umsg.String( wepused )
			umsg.String( tostring( GAMEMODE.KillInfoTracking[ id( att:SteamID() ) ].KillsThisLife ) )
			umsg.String( damagedone )
			umsg.Bool( wasVendetta )
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
	if ply:IsBot() then return end
	umsg.Start( "CloseDeathScreen", ply )
	umsg.End()
	GAMEMODE.DamageSaving[ id( ply:SteamID() ) ].lifeCount = GAMEMODE.DamageSaving[ id( ply:SteamID() ) ].lifeCount + 1
end )

hook.Add( "EntityTakeDamage", "TrackDamage", function( vic, dmginfo )
	local att = dmginfo:GetAttacker()
	if vic and vic:IsPlayer() and !vic:IsBot() and att and att:IsPlayer() then
		local vicID = id( vic:SteamID() )
		local attID = id( att:SteamID() )
		local Lives = GAMEMODE.DamageSaving[ vicID ].lifeCount

		--//Messy and difficult to read, but necessary to track damage done per life - set up the tables for both the victim and the attacker
		GAMEMODE.DamageSaving[ vicID ][ Lives ] = GAMEMODE.DamageSaving[ vicID ][ Lives ] or { }
		GAMEMODE.DamageSaving[ attID ][ Lives ] = GAMEMODE.DamageSaving[ attID ][ Lives ] or { }
		GAMEMODE.DamageSaving[ vicID ][ Lives ][ attID ] = GAMEMODE.DamageSaving[ vicID ][ Lives ][ attID ] or { }
		GAMEMODE.DamageSaving[ attID ][ Lives ][ vicID ] = GAMEMODE.DamageSaving[ attID ][ Lives ][ vicID ] or { }
		GAMEMODE.DamageSaving[ vicID ][ Lives ][ attID ][ GAMEMODE.DamageSaving[ attID ].lifeCount ] = ( GAMEMODE.DamageSaving[ vicID ][ Lives ][ attID ][ GAMEMODE.DamageSaving[ attID ].lifeCount ] or 0 ) + dmginfo:GetDamage()
	end
end )

--[[
	Above table should look something like this:

	GAMEMODE.DamageSaving = {
		Steamx0x1x123456 = { 			- Victim's SteamID
			1 = { 						- This victim's # of lives up to this point
				Steamx1x1x246832 = {		- Their attacker's SteamID
					1 = 45,				- The attacker's current # of lives = the damage they've done so far in it
					2 = 67,
					3 = 11,
					4 = 90
				}
			}
			2 = {
				Steamx1x1x246832 = {
					4 = 20,
					6 = 30
				}
			}
		}
	}
]]