hook.Add( "SetupMove", "MarathonPerk", function( ply, mv, cmd )
	if CheckPerk( ply ) == "marathon" then
		if mv:GetMaxSpeed() >= 200 then
			if not timer.Exists( "marathon_" .. ply:SteamID() ) then
				timer.Create( "marathon_" .. ply:SteamID(), 2, 0, function()
					if not timer.Exists( "marathonflinch_" .. ply:SteamID() ) then
						if ply:GetRunSpeed() < 600 then
							ply:SetRunSpeed( ply:GetRunSpeed() + ( ply:GetRunSpeed() * 0.05 ) )
						end
						if ply:GetRunSpeed() > 600 then
							ply:SetRunSpeed( 600 )
						end
					end
				end )
			end
		else
			ply:SetRunSpeed( 300 )
			if timer.Exists( "marathon_" .. ply:SteamID() ) then
				timer.Destroy( "marathon_" .. ply:SteamID() )
			end
		end
	end
end )

hook.Add( "PlayerHurt", "MarathonFlinch", function( ply, att )
	if ply and IsValid( ply ) and ply ~= NULL and load[ ply ] ~= nil then
		if load[ ply ].perk and load[ ply ].perk ~= nil and load[ ply ].perk == "marathon" then
			if not timer.Exists( "marathonflinch_" .. ply:SteamID() ) then
				ply:SetRunSpeed( ply:GetRunSpeed() - ( ply:GetRunSpeed() * 0.5 ) )
				if ply:GetRunSpeed() < 300 then
					ply:SetRunSpeed( 300 )
				end
				timer.Create( "marathonflinch_", 3, 0, function()
					timer.Destroy( "marathonflinch_" .. ply:SteamID() )
				end )
			else
				timer.Adjust( "marathonflinch_", 3, 0, function()
					timer.Destroy( "marathonflinch_" .. ply:SteamID() )
				end )
			end
		end
	end
end )

hook.Add( "PlayerDeath", "RemoveMarathon", function( ply )
	if timer.Exists( "marathon_" .. ply:SteamID() ) then
		timer.Destroy( "marathon_" .. ply:SteamID() )
	end
	if timer.Exists( "marathonflinch_" .. ply:SteamID() ) then
		timer.Destroy( "marathonflinch_" .. ply:SteamID() )
	end
end )

RegisterPerk( "Marathon", "marathon", 60, "Sprinting is a gradual increase of speed. Maximum Speed is 200% of original speed. You will \'flinch\' when you take damage; you will lose 50% of current speed, and will be unable to gain more speed temporarily." )