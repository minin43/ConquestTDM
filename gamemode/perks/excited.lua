hook.Add( "PlayerDeath", "Excited", function( ply, inf, att )
	if CheckPerk( att ) == "excited" then
		local defaultWSpeed = defaultWalkSpeed
		local defaultRSpeed = defaultRunSpeed
		local decayWSpeed = ( defaultWSpeed * 2.50 ) / 60
		local decayRSpeed = ( defaultRSpeed * 2.50 ) / 60
		
		att:SetWalkSpeed( defaultWSpeed * 2.25 )
		att:SetRunSpeed( defaultRSpeed * 2.25 )
		
		if not timer.Exists( "excited_" .. att:SteamID() ) then
			timer.Create( "excited_" .. att:SteamID(), 0.1, 40, function()
				att:SetWalkSpeed( att:GetWalkSpeed() - decayWSpeed )
				att:SetRunSpeed( att:GetRunSpeed() - decayRSpeed )
				
				if att:GetWalkSpeed() < defaultWSpeed then
					att:SetWalkSpeed( defaultWSpeed )
				end
				if att:GetRunSpeed() < defaultRSpeed then
					att:SetRunSpeed( defaultRSpeed )
				end
			end )
		else
			timer.Adjust( "excited_" .. att:SteamID(), 0.1, 40, function()
				att:SetWalkSpeed( att:GetWalkSpeed() - decayWSpeed )
				att:SetRunSpeed( att:GetRunSpeed() - decayRSpeed )
				
				if att:GetWalkSpeed() < defaultWSpeed then
					att:SetWalkSpeed( defaultWSpeed )
				end
				if att:GetRunSpeed() < defaultRSpeed then
					att:SetRunSpeed( defaultRSpeed )
				end
			end )
		end
	end
end )

--RegisterPerk( "Excited", "excited", 69, "Killing an enemy will grant you a 175% speed boost which decays over 4 seconds." )