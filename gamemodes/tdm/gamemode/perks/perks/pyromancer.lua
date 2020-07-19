hook.Add( "EntityTakeDamage", "Pyro", function( ply, dmginfo )
    local att = dmginfo:GetAttacker()
    if not IsValid( ply ) or dmginfo == nil or att == nil then return end

	if att:IsPlayer() and ply:IsPlayer() and dmginfo:IsBulletDamage() and att:Team() ~= ply:Team() then
        if CheckPerk( att ) == "pyro" then
            if timer.Exists( id( ply:SteamID() ) .. "ShotgunPyroFix" ) or timer.Exists( id( ply:SteamID() ) .. "ShotgunPyroFix2" ) then return end
			local num = math.random( 1, 1000 )
			
			if num < 100 and ply:IsOnFire() then
				local explosion = ents.Create( "env_explosion" )
                GAMEMODE.PyroChecks[ id( ply:SteamID() ) ] = nil

				if IsValid( explosion ) then
					explosion:SetPos( ply:GetPos() )
					explosion:SetOwner( att )
					explosion:Spawn()
					explosion:SetKeyValue( "iMagnitude", ply:Health() * 2 )
                    explosion:Fire( "Explode", 0, 0 )
                    util.BlastDamage( explosion, att, ply:GetPos(), ply:Health() * 2, ply:Health() ) 

                    GAMEMODE:QueueIcon( att, "pyro" )
				end

                --A small cooldown window the same time allotment as the shotgun fix
                timer.Create( id( ply:SteamID() ) .. "PyroCooldown", 0.5, 1, function() end )
			elseif num < 200 then
                GAMEMODE.PyroChecks[ id( ply:SteamID() ) ] = att
				ply:Ignite( 3 )
                timer.Simple( 3.5, function()
                    GAMEMODE.PyroChecks[ id( ply:SteamID() ) ] = nil
                end)
                timer.Create( id( ply:SteamID() ) .. "ShotgunPyroFix", 0.5, 1, function() end )
            end
            
            timer.Create( id( ply:SteamID() ) .. "ShotgunPyroFix2", 0.1, 1, function() end )
		end
	end
end )

RegisterPerk( "Pyromancer", "pyro", 0, "Set enemies aflame! Ignited enemies have a small chance to explode when shot." )