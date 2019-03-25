hook.Add( "EntityTakeDamage", "VengeanceDamageChecks", function( ply, dmginfo )
    local vic = ply
    local att = dmginfo:GetAttacker()

	if !att:IsPlayer() or !vic:IsPlayer() or att:Team() == vic:Team() then return end
	GAMEMODE.VengeanceHealthBack = GAMEMODE.VengeanceHealthBack or { }

	if CheckPerk( att ) == "vengeance" and GAMEMODE.KillInfoTracking[ id( att:SteamID() ) ].LastKiller == id( vic:SteamID() ) then
        dmginfo:ScaleDamage( 1.2 )
	elseif CheckPerk( vic ) == "vengeance" and GAMEMODE.KillInfoTracking[ id( vic:SteamID() ) ].LastKiller == id( att:SteamID() ) then
        GAMEMODE.VengeanceHealthBack[ id( vic:SteamID() ) ] = GAMEMODE.VengeanceHealthBack[ id( vic:SteamID() ) ] or 0
		GAMEMODE.VengeanceHealthBack[ id( vic:SteamID() ) ] = GAMEMODE.VengeanceHealthBack[ id( vic:SteamID() ) ] + dmginfo:GetDamage() / 3
    end
end )

--//Should probably include kill/death checks for removing vengeance targets from the client

hook.Add( "PlayerHurt", "VengeanceRegen", function( ply, att ) --Ripped right from regeneration w/ minor edits
	if IsValid( ply ) then
        if CheckPerk( ply ) == "vengeance" then
            GAMEMODE.VengeanceHealthBack[ id( ply:SteamID() ) ] = GAMEMODE.VengeanceHealthBack[ id( ply:SteamID() ) ] or 0
			if timer.Exists( "vengeance_" .. ply:SteamID() ) then
				timer.Stop( "vengeance_" .. ply:SteamID() )
				if timer.Exists( "delay_" .. ply:SteamID() ) then
					timer.Destroy( "delay_" .. ply:SteamID() )
				end
				timer.Create( "delay_" .. ply:SteamID(), 3, 1, function()
					timer.Start( "vengeance_" .. ply:SteamID() )
					timer.Destroy( "delay_" .. ply:SteamID() )
				end )
			else
				timer.Create( "delay_" .. ply:SteamID(), 2, 1, function()
					timer.Create( "vengeance_" .. ply:SteamID(), 0.3, 0, function()
						if ply:Alive() then
							local hp = ply:Health()
							if hp < hp + GAMEMODE.VengeanceHealthBack[ id( ply:SteamID() ) ] then
                                ply:SetHealth( hp + 1 )
                                GAMEMODE.VengeanceHealthBack[ id( ply:SteamID() ) ] = GAMEMODE.VengeanceHealthBack[ id( ply:SteamID() ) ] - 1
							end
						end
					end )
					timer.Destroy( "delay_" .. ply:SteamID() )
				end )
			end
		end
	end
end )

hook.Add( "PlayerDeath", "RemoveVengeanceRegen", function( ply )
	if timer.Exists( "vengeance_" .. ply:SteamID() ) then
        timer.Destroy( "vengeance_" .. ply:SteamID() )
        GAMEMODE.VengeanceHealthBack[ id( ply:SteamID() ) ] = 0
	end
	if timer.Exists( "delay_" .. ply:SteamID() ) then
		timer.Destroy( "delay_" .. ply:SteamID() )
	end
end )

RegisterPerk( "Vengeance", "vengeance", 10, "Deal bonus damage to your previous killer, & heal back a small % of damage done by them to you.")