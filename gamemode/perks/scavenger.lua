hook.Add( "PlayerDeath", "Scavenger", function( ply, inf, att )
	if att and IsValid( att ) and att ~= NULL and load[ att ] ~= nil then
		if load[ att ].perk and load[ att ].perk ~= nil and load[ att ].perk == "scavenger" then
			local ammo = ents.Create( "cw_ammo_kit_small" )
			if ( !IsValid( ammo ) ) then return end
			ammo:SetPos( ply:GetPos() )
			ammo.AmmoCapacity = 1
			ammo:Spawn()
			ammo:Activate()
			timer.Simple( 30, function()
				if IsValid( ammo ) then
					ammo:Remove()
				end
			end )
		end
	end
end )

RegisterPerk( "Scavenger", "scavenger", 41, "Killing an enemy will make them drop an ammo pack along with their body. These are explosive, and will disappear within 30 seconds if not picked up." )