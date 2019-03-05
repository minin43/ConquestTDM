hook.Add( "EntityTakeDamage", "VultureDamage", function( ply, dmginfo )
	local att = dmginfo:GetAttacker()
	if CheckPerk( att ) == "vulture" then
		if ply and ply:IsPlayer() and att and att:IsPlayer() then
			if (ply:Health() - dmginfo:GetDamage()) < 11 then
				dmginfo:AddDamage(10)
			end
		end
	end
end )

hook.Add( "PlayerDeath", "VultureDrop", function( ply, inf, att )
	if att and IsValid( att ) and att ~= NULL and load[ att ] ~= nil then
		if load[ att ].perk and load[ att ].perk ~= nil and load[ att ].perk == "vulture" then
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

RegisterPerk( "Vulture", "vulture", 46, "Execute enemies low on life! Enemies will also drop ammo packs when killed." )