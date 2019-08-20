hook.Add( "EntityTakeDamage", "Pyro", function( ply, dmginfo )
    local att = dmginfo:GetAttacker()
    if ply == nil or !ply:IsPlayer() or dmginfo == nil or att == nil then return end

	if att:IsPlayer() and dmginfo:IsBulletDamage() and att:Team() ~= ply:Team() then
        if CheckPerk( att ) == "pyro" then
            if timer.Exists( id( ply:SteamID() ) .. "ShotgunPyroFix" ) then return end
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

				--[[if not ply:Alive() then
					ply:Kill()
                end]]
                timer.Create( id( ply:SteamID() ) .. "ShotgunPyroFix", 0.5, 1, function() end )
			elseif num < 200 then
                GAMEMODE.PyroChecks[ id( ply:SteamID() ) ] = att
				ply:Ignite( 3 )
                timer.Simple( 3.5, function()
                    GAMEMODE.PyroChecks[ id( ply:SteamID() ) ] = nil
                end)
                timer.Create( id( ply:SteamID() ) .. "ShotgunPyroFix", 0.5, 1, function() end )
			end
		end
	end
end )

--[[hook.Add("EntityTakeDamage", "getFireDeaths", function(victim, dmginfo)
    if !IsValid(victim) && victim:IsPlayer() then
        return
    end
    if dmginfo:GetDamageType() == DMG_FIRE && dmginfo:GetDamage() >= victim:Health() then
        hook.Run("PlayerFireDamageDeath", victim)
    end
end )

hook.Add("PlayerFireDamageDeath", "fireDeath", function(victim)
    ULib.tsay(nil, "PlayerFireDamageDeath called")
    if IsValid(victim.pyroOnFire) then
        ULib.tsay(nil, "found player on fire")
        local killer = victim.pyroOnFire -- Get the stored player
        ULib.tsay(nil, "killer = " .. tostring(killer))
        if (killer == nil || !IsValid(killer)) then 
            ULib.tsay(nil, "Killer is not valid")
            return 
        end
        killer:AddFrags(1);
        local col = Color(255, 0, 83)
        AddNotice(killer, victim:Name(), SCORECOUNTS.KILL, NOTICETYPES.KILL, col)
    end
end)]]

RegisterPerk( "Pyromancer", "pyro", 60, "Set enemies aflame! Ignited enemies have a small chance to explode when shot." )