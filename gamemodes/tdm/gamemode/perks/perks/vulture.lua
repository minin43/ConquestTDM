hook.Add( "EntityTakeDamage", "VultureDamage", function( ply, dmginfo )
	local att = dmginfo:GetAttacker()
	if CheckPerk( att ) == "vulture" then
		if IsValid( ply ) and ply:IsPlayer() and IsValid( att ) and att:IsPlayer() and ply:Team() != att:Team() then
			if (ply:Health() - dmginfo:GetDamage()) < 11 and (ply:Health() - dmginfo:GetDamage()) > 0 then
				dmginfo:AddDamage(500) --//Overkill, but necessary to circumvent any damage-reducing mechanics
				GAMEMODE:QueueIcon( dmginfo:GetAttacker(), "vulture" )
			end
		end
	end
end )

hook.Add( "PlayerDeath", "VultureDrop", function( ply, inf, att )
	if att and IsValid( att ) and att ~= NULL and GAMEMODE.PlayerLoadouts[ att ] ~= nil then
		if GAMEMODE.PlayerLoadouts[ att ].perk and GAMEMODE.PlayerLoadouts[ att ].perk ~= nil and GAMEMODE.PlayerLoadouts[ att ].perk == "vulture" then
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

RegisterPerk( "Vulture", "vulture", 0, "Enemies drop ammo boxes on death. If any enemy you're damaging would live with 10 or less life, finish them instead." )