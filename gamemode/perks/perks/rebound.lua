hook.Add( "EntityTakeDamage", "ReboundDamageChecks", function( ply, dmginfo )
    local vic = ply

	if !vic:IsPlayer() then return end
	GAMEMODE.ReboundHealthBack = GAMEMODE.ReboundHealthBack or { }

	if CheckPerk( vic ) == "rebound"  then
        GAMEMODE.ReboundHealthBack[ id( vic:SteamID() ) ] = ( GAMEMODE.ReboundHealthBack[ id( vic:SteamID() ) ] or 0 ) + ( dmginfo:GetDamage() * 0.50 )
    end
end )

hook.Add( "PlayerHurt", "ReboundRegen", function( ply, att ) --Ripped right from regeneration w/ minor edits
	if ply:IsValid() and  CheckPerk( ply ) == "rebound" then
		GAMEMODE.ReboundHealthBack[ id( ply:SteamID() ) ] = GAMEMODE.ReboundHealthBack[ id( ply:SteamID() ) ] or 0
		if timer.Exists( "rebound_" .. ply:SteamID() ) then
			timer.Stop( "rebound_" .. ply:SteamID() )
			if timer.Exists( "delay_" .. ply:SteamID() ) then
				timer.Destroy( "delay_" .. ply:SteamID() )
			end
			timer.Create( "delay_" .. ply:SteamID(), 3, 1, function()
				timer.Start( "rebound_" .. ply:SteamID() )
				timer.Destroy( "delay_" .. ply:SteamID() )
			end )
		else
			timer.Create( "delay_" .. ply:SteamID(), 2, 1, function()
				timer.Create( "rebound_" .. ply:SteamID(), 0.3, 0, function()
					if ply:Alive() then
						local hp = ply:Health()
						if hp < hp + GAMEMODE.ReboundHealthBack[ id( ply:SteamID() ) ] then
							ply:SetHealth( math.Clamp( hp + 1, 0, 100 ) )
							GAMEMODE.ReboundHealthBack[ id( ply:SteamID() ) ] = GAMEMODE.ReboundHealthBack[ id( ply:SteamID() ) ] - 1
						end
					end
				end )
				timer.Destroy( "delay_" .. ply:SteamID() )
			end )
		end
	end
end )

hook.Add( "PlayerDeath", "RemoveReboundRegen", function( ply )
	if timer.Exists( "rebound_" .. ply:SteamID() ) then
        timer.Destroy( "rebound_" .. ply:SteamID() )
        GAMEMODE.ReboundHealthBack[ id( ply:SteamID() ) ] = 0
	end
	if timer.Exists( "delay_" .. ply:SteamID() ) then
		timer.Destroy( "delay_" .. ply:SteamID() )
	end
end )

RegisterPerk( "Rebound", "rebound", 15, "Slowly heal back 50% of all damage received after a short delay." )
--RegisterPerk( "Vengeance", "vengeance", 8, "Deal bonus damage to your previous killers & heal back a small % of damage done to you, by them.")