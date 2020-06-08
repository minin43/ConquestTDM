GM.RegenCombatDelay = 3 --in seconds
GM.RegenRate = 1.4 --As a percent

--//This is old and poorly optimized, timer.Create checks if the timer exists now and resets it
hook.Add( "PlayerHurt", "Regen", function( ply, att )
	if ply and IsValid( ply ) and ply ~= NULL and GAMEMODE.PlayerLoadouts[ ply ] ~= nil then
		if GAMEMODE.PlayerLoadouts[ ply ].perk and GAMEMODE.PlayerLoadouts[ ply ].perk == "regen" then
			if timer.Exists( "regen_" .. ply:SteamID() ) then
				timer.Stop( "regen_" .. ply:SteamID() )
				if timer.Exists( "delay_" .. ply:SteamID() ) then
					timer.Destroy( "delay_" .. ply:SteamID() )
				end
				timer.Create( "delay_" .. ply:SteamID(), GAMEMODE.RegenCombatDelay, 1, function()
					timer.Start( "regen_" .. ply:SteamID() )
					timer.Destroy( "delay_" .. ply:SteamID() )
				end )
			else
				timer.Create( "delay_" .. ply:SteamID(), GAMEMODE.RegenCombatDelay, 1, function()
					timer.Create( "regen_" .. ply:SteamID(), 1 / GAMEMODE.RegenRate, 0, function()
						if ply:Alive() then
							local hp = ply:Health()
							if hp < ply:GetMaxHealth() then
								ply:SetHealth( hp + 1 )
							end
						end
					end )
					timer.Destroy( "delay_" .. ply:SteamID() )
				end )
			end
		end
	end
end )

hook.Add( "PlayerDeath", "removeregen", function( ply )
	if timer.Exists( "regen_" .. ply:SteamID() ) then
		timer.Destroy( "regen_" .. ply:SteamID() )
	end
	if timer.Exists( "delay_" .. ply:SteamID() ) then
		timer.Destroy( "delay_" .. ply:SteamID() )
	end
end )

RegisterPerk( "Regeneration", "regen", 45, "Regenerate health 3 seconds after taking damage" )