hook.Add( "PlayerDeath", "Excited", function( ply, inf, att )
	if CheckPerk( att ) == "excited" then
		local StartWalkSpeed = GAMEMODE.DefaultWalkSpeed
		local StartRunSpeed = GAMEMODE.DefaultRunSpeed
		local MaxedWalkedSpeed = StartWalkSpeed * 2.75
		local MaxedRunSpeed = StartRunSpeed * 2.75
		local decayWSpeed = ( MaxedWalkedSpeed - StartWalkSpeed ) / 40
		local decayRSpeed = ( MaxedRunSpeed - StartRunSpeed ) / 40
		
		att:SetWalkSpeed( MaxedWalkedSpeed )
		att:SetRunSpeed( MaxedRunSpeed )
		
		if not timer.Exists( "excited_" .. att:SteamID() ) then
			timer.Create( "excited_" .. att:SteamID(), 0.1, 40, function()
				att:SetWalkSpeed( att:GetWalkSpeed() - decayWSpeed )
				att:SetRunSpeed( att:GetRunSpeed() - decayRSpeed )
				
				if att:GetWalkSpeed() < StartWalkSpeed then
					att:SetWalkSpeed( StartWalkSpeed )
				end
				if att:GetRunSpeed() < StartRunSpeed then
					att:SetRunSpeed( StartRunSpeed )
				end
			end )
		else
			timer.Adjust( "excited_" .. att:SteamID(), 0.1, 40, function()
				att:SetWalkSpeed( att:GetWalkSpeed() - decayWSpeed )
				att:SetRunSpeed( att:GetRunSpeed() - decayRSpeed )
				
				if att:GetWalkSpeed() < StartWalkSpeed then
					att:SetWalkSpeed( StartWalkSpeed )
				end
				if att:GetRunSpeed() < StartRunSpeed then
					att:SetRunSpeed( StartRunSpeed )
				end
			end )
		end
	end
end )

RegisterPerk( "Excited", "excited", 31, "Killing an enemy will grant you a 175% speed boost which decays over 4 seconds." )