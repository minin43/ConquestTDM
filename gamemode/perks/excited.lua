util.AddNetworkString( "ExcitedEffect" )
hook.Add( "PlayerDeath", "Excited", function( ply, inf, att )
	if CheckPerk( att ) == "excited" then
		local StartWalkSpeed = GAMEMODE.DefaultWalkSpeed
		local StartRunSpeed = GAMEMODE.DefaultRunSpeed
		local StartFOV = att:GetFOV()
		local MaxedWalkedSpeed = StartWalkSpeed * 2.75
		local MaxedRunSpeed = StartRunSpeed * 2.75
		local MaxedFOV = StartFOV * 1.75
		local decayWSpeed = ( MaxedWalkedSpeed - StartWalkSpeed ) / 40
		local decayRSpeed = ( MaxedRunSpeed - StartRunSpeed ) / 40
		local decayFSpeed = ( MaxedFOV - StartFOV ) / 40
		
		att:SetWalkSpeed( MaxedWalkedSpeed )
		att:SetRunSpeed( MaxedRunSpeed )
		att:SetFOV( MaxedFOV, 0 )

		--[[net.Start( "ExcitedEffect" )
		net.Send( att )]]
		
		if not timer.Exists( "excited_" .. att:SteamID() ) then
			timer.Create( "excited_" .. att:SteamID(), 0.1, 40, function()
				att:SetWalkSpeed( att:GetWalkSpeed() - decayWSpeed )
				att:SetRunSpeed( att:GetRunSpeed() - decayRSpeed )
				att:SetFOV( att:GetFOV() - decayFSpeed, 0 )
				
				if att:GetWalkSpeed() < StartWalkSpeed then
					att:SetWalkSpeed( StartWalkSpeed )
				end
				if att:GetRunSpeed() < StartRunSpeed then
					att:SetRunSpeed( StartRunSpeed )
				end
				if att:GetFOV() < StartFOV then
					att:SetFOV( StartFOV, 0 )
				end
			end )
		else
			timer.Adjust( "excited_" .. att:SteamID(), 0.1, 40, function()
				att:SetWalkSpeed( att:GetWalkSpeed() - decayWSpeed )
				att:SetRunSpeed( att:GetRunSpeed() - decayRSpeed )
				att:SetFOV( att:GetFOV() - decayFSpeed, 0 )
				
				if att:GetWalkSpeed() < StartWalkSpeed then
					att:SetWalkSpeed( StartWalkSpeed )
				end
				if att:GetRunSpeed() < StartRunSpeed then
					att:SetRunSpeed( StartRunSpeed )
				end
				if att:GetFOV() < StartFOV then
					att:SetFOV( StartFOV, 0 )
				end
			end )
		end
	end
end )

RegisterPerk( "Excited", "excited", 50, "Killing an enemy will grant you a 175% speed boost which decays over 4 seconds." )