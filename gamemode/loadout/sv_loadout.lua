--Player can't set a loadout unless they've opened up loadout menu, which calls GetUnlocked___ that populates UnlockedMasterTable, so don't need to worry about validity
GM.UnlockedMasterTable = GM.UnlockedMasterTable or {}
GM.UnlockedMasterTableClassKey = GM.UnlockedMasterTableClassKey or {}
GM.RecacheUnlockedTable = GM.RecacheUnlockedTable or {}

util.AddNetworkString( "GetUnlockedWeapons" )
util.AddNetworkString( "GetUnlockedWeaponsCallback" )
util.AddNetworkString( "GetUnlockedModels" )
util.AddNetworkString( "GetUnlockedModelsCallback" )
util.AddNetworkString( "GetUnlockedSkins" )
util.AddNetworkString( "GetUnlockedSkinsCallback" )
util.AddNetworkString( "GetUnlockedPerks" )
util.AddNetworkString( "GetUnlockedPerksCallback" )
util.AddNetworkString( "SetLoadout" )

function OwnsWeapon( wepclass, ply )
    if !wepclass then return true end

    if IsDefaultWeapon( wepclass ) then
        return true
    end
    
    if !GAMEMODE.UnlockedMasterTableClassKey[ ply ].wep then
        return false
    end

    return GAMEMODE.UnlockedMasterTableClassKey[ ply ].wep[ wepclass ] or false
end

function OwnsModel( mdl, ply )
    if !mdl then return true end

    if IsDefaultModel( mdl ) then
        return true
    end
    if !GAMEMODE.UnlockedMasterTableClassKey[ ply ].model then
        return false
    end

    return GAMEMODE.UnlockedMasterTableClassKey[ ply ].model[ mdl ] or false
end

function OwnsWepSkin( skin, ply )
    if !skin or skin == "" then return true end

    if !GAMEMODE.UnlockedMasterTableClassKey[ ply ].skin then
        return false
    end

    return GAMEMODE.UnlockedMasterTableClassKey[ ply ].skin[ skin ] or false
end

net.Receive( "GetUnlockedWeapons", function( len, ply )
    if GAMEMODE.RecacheUnlockedTable[ ply ].wep then
        local fil = util.JSONToTable( file.Read( "tdm/users/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) )
        local unlockedweps = fil[ 2 ]
        local throwaway = {}
        
        for k, v in pairs( unlockedweps ) do
            throwaway[ v ] = true
        end

        GAMEMODE.UnlockedMasterTable[ ply ].wep = {}
        GAMEMODE.UnlockedMasterTableClassKey[ ply ].wep = {}
        for k, v in pairs( GAMEMODE.WeaponsList ) do
            if throwaway[ v[ 2 ] ] or (v[ 3 ] == 0 and v[ 5 ] == 0) then
                table.insert( GAMEMODE.UnlockedMasterTable[ ply ].wep, k )
                GAMEMODE.UnlockedMasterTableClassKey[ ply ].wep[ v[2] ] = true
            end
        end
        
        GAMEMODE.RecacheUnlockedTable[ ply ].wep = false
    end
    
    net.Start( "GetUnlockedWeaponsCallback" )
        net.WriteTable( GAMEMODE.UnlockedMasterTable[ ply ].wep )
    net.Send( ply )
end )
net.Receive( "GetUnlockedSkins", function( len, ply )
    if GAMEMODE.RecacheUnlockedTable[ ply ].skin then
        local fil = util.JSONToTable( file.Read( "tdm/users/skins/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) )
        local unlockedskins = fil[ 2 ]
        local throwaway = {}

        for k, v in pairs( unlockedskins ) do    
            throwaway[ v ] = true
        end

        GAMEMODE.UnlockedMasterTable[ ply ].skin = {}
        GAMEMODE.UnlockedMasterTableClassKey[ ply ].skin = {}
        for k, v in pairs( GAMEMODE.WeaponSkins ) do
            if throwaway[ v.directory ] then
                table.insert( GAMEMODE.UnlockedMasterTable[ ply ].skin, k )
                GAMEMODE.UnlockedMasterTableClassKey[ ply ].skin[ v.directory ] = true
            end
        end

        GAMEMODE.RecacheUnlockedTable[ ply ].skin = false
    end

    net.Start( "GetUnlockedSkinsCallback" )
        net.WriteTable( GAMEMODE.UnlockedMasterTable[ ply ].skin )
    net.Send( ply )
end )
net.Receive( "GetUnlockedModels", function( len, ply )
    if GAMEMODE.RecacheUnlockedTable[ ply ].model then
        local fil = util.JSONToTable( file.Read( "tdm/users/models/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) )
        local unlockedmodels = fil[ 2 ]
        local throwaway = {}

        for k, v in pairs( unlockedmodels ) do      
            throwaway[ v ] = true
        end

        GAMEMODE.UnlockedMasterTable[ ply ].model = {}
        GAMEMODE.UnlockedMasterTableClassKey[ ply ].model = {}
        for k, v in pairs( GAMEMODE.PlayerModels ) do
            if throwaway[ v.model ] then --//Have to save by model, since naming can be changed
                table.insert( GAMEMODE.UnlockedMasterTable[ ply ].model, k )
                GAMEMODE.UnlockedMasterTableClassKey[ ply ].model[ v.model ] = true
            end
        end

        GAMEMODE.RecacheUnlockedTable[ ply ].model = false
    end
    
    net.Start( "GetUnlockedModelsCallback" )
        net.WriteTable( GAMEMODE.UnlockedMasterTable[ ply ].model )
    net.Send( ply )
end )
net.Receive( "GetUnlockedPerks", function( len, ply )
    if GAMEMODE.RecacheUnlockedTable[ ply ].perk then
        local tosend = { locked = {} }
        for _, perkinfo in pairs( GAMEMODE.Perks ) do
            if perkinfo[ 3 ] <= lvl.GetLevel( ply ) then
                tosend[ #tosend + 1 ] = perkinfo
            else
                tosend.locked[ #tosend.locked + 1 ] = perkinfo
            end
        end

        GAMEMODE.UnlockedMasterTable[ ply ].perk = tosend
        GAMEMODE.RecacheUnlockedTable[ ply ].perk = false
    end

    net.Start( "GetUnlockedPerksCallback" )
        net.WriteTable( GAMEMODE.UnlockedMasterTable[ ply ].perk )
    net.Send( ply )
end )
net.Receive( "SetLoadout", function( len, ply )
    local newloadout = net.ReadTable()
    local primary = newloadout[1][1]
    local primaryskin = newloadout[1][2]
    local secondary = newloadout[2][1]
    local secondaryskin = newloadout[2][2]
    local equipment = newloadout[3]
    local perk = newloadout[4]
    local pm = newloadout[5][1]
    local pmskin = newloadout[5][2]
    local pmbgroups = newloadout[5][3]

    if !OwnsWeapon( primary, ply ) then
        CaughtCheater(ply, "Attempted to spawn with primary they don't have access to - " .. primary)
        return
    end
    if !OwnsWeapon( secondary, ply ) then
        CaughtCheater(ply, "Attempted to spawn with secondary they don't have access to - " .. primary)
        return
    end
    if !OwnsWeapon( equipment, ply ) then
        CaughtCheater(ply, "Attempted to spawn with equipment they don't have access to - " .. primary)
        return
    end

    if perk and lvl.GetLevel( ply ) < GetPerkTable(perk)[ 3 ] then
        CaughtCheater( ply, "Attempted to spawn with perk they don't have access to - " .. perk .. ", " .. lvl.GetLevel( ply ))
        return
    end
    if !OwnsModel( pm, ply ) then
        CaughtCheater(ply, "Attempted to spawn with model they don't have access to - " .. pm)
        return
    end

    if !OwnsWepSkin( primaryskin, ply ) or !OwnsWepSkin( secondaryskin, ply ) then
        CaughtCheater(ply, "Attempted to spawn with primary weapon skin they don't have access to - ", primaryskin)
        return
    end
    if !OwnsWepSkin( secondaryskin, ply ) then
        CaughtCheater(ply, "Attempted to spawn with secondary weapon skin they don't have access to - ", secondaryskin)
        return
    end

    GAMEMODE.PlayerLoadouts[ ply ] = {
        primary = primary,
        primaryskin = primaryskin,
        secondary = secondary,
        secondaryskin = secondaryskin,
        extra = equipment,
        perk = perk,
        playermodel = pm,
        playermodelskin = pmskin,
        playermodelbodygroups = pmbgroups
    }
end )

hook.Add( "PlayerInitialSpawn", "SetupPrecacheEnvironment", function( ply )
    GAMEMODE.RecacheUnlockedTable[ ply ] = {wep = true, skin = true, model = true, perk = true}
    GAMEMODE.UnlockedMasterTable[ ply ] = {wep = {}, skin = {}, model = {}, perk = {}}
    GAMEMODE.UnlockedMasterTableClassKey[ ply ] = {wep = {}, skin = {}, model = {}}
end ) 

function FixExploit( ply, wep )
	ply:StripWeapon( wep )
	local ent = ents.Create( wep )
	ent:SetPos( ply:GetPos() )
	ent:Spawn()
end

--To remove when I rework weapon pickup
function CheckWeapons()
	for k, v in next, player.GetAll() do
		if v and v ~= NULL and IsValid( v ) and v:Alive() then
			if v:GetWeapons() then
				local foundp = false
				local founds = false
				local founde = false
				for q, w in next, v:GetWeapons() do
					if isPrimary( w:GetClass() ) then
						if foundp then
							FixExploit( v, w:GetClass() )
						else
							v.curprimary = w:GetClass()
							foundp = true
						end
					elseif isSecondary( w:GetClass() ) then
						if founds then
							FixExploit( v, w:GetClass() )
						else
							v.cursecondary = w:GetClass() 
							founds = true
						end
					elseif isExtra( w:GetClass() ) then
						if founde then
							FixExploit( v, w:GetClass() )
						else
							v.curextra = w:GetClass()
							founde = true
						end
					end
				end
				if foundp == false then
					v.curprimary = nil
				end
				if founds == false then
					v.cursecondary = nil
				end
				if founde == false then
					v.curextra = nil
				end
			end
		end
	end
end
hook.Add( "Think", "CheckPlayersWeapons", CheckWeapons )

--//Disabling because we only want players dropping their weapons when they pick up a different one
--To remove when I rework weapon pickup
hook.Add( "PlayerButtonDown", "DropWeapons", function( ply, bind ) 
	if bind == KEY_Q then
		if not ply.spawning then
			if ply and IsValid( ply ) and ply:IsPlayer() and ply:Team() ~= nil and ply:Team() ~= 0 then
				if ply:GetActiveWeapon() and ply:GetActiveWeapon() ~= NULL then
					if isExtra( ply:GetActiveWeapon():GetClass() ) then
						return
					end
					local wep = ply:GetActiveWeapon()
					local toSpawn = ents.Create( wep:GetClass() )
					toSpawn:SetClip1( wep:Clip1() )
					toSpawn:SetClip2( wep:Clip2() )
					ply:StripWeapon( wep:GetClass() )
					toSpawn:SetPos( ply:GetShootPos() + ( ply:GetAimVector() * 20 ) )
					toSpawn:Spawn()
					toSpawn.rspawn = true
					timer.Simple( 0.5, function()
						toSpawn.rspawn = nil
					end )
					timer.Simple( 15, function()
                        if toSpawn == nil or !toSpawn:IsValid() or toSpawn:GetOwner() == nil then 
                            return 
                        end -- fixed by cobalt 1/30/16
						if toSpawn:GetOwner():IsValid() and toSpawn:GetOwner():IsPlayer() then 
						else
							toSpawn:Remove()
						end
					end )
					local phys = toSpawn:GetPhysicsObject()
					if phys and IsValid( phys ) and phys ~= NULL then
						phys:SetVelocity( ply:EyeAngles():Forward() * 300 )
					end
				end
			end
		end
	end
end )

--//The point of this is to remove one magazine's worth of ammo from the player's ammo pool - WAS written extremely poorly
function GM:WeaponEquip( wep )
	timer.Simple( 0, function() -- this will call the following on the next frame
		if IsValid( wep ) and wep:GetOwner() then
			if wep.Base == "cw_base" then
				wep:GetOwner():RemoveAmmo( wep:Clip1(), wep:GetPrimaryAmmoType() )
			end
		end
	end )
end

--To remove when I rework weapon pickup
hook.Add( "PlayerCanPickupWeapon", "NoAutoPickup", function( ply, wep )
	--return --This will be done with a button prompt
	if isPrimary( wep:GetClass() ) then
		if ply.curprimary == nil then
			if wep.rspawn then
				return false
			else
				return true
			end
		else
			return false
		end
	elseif isSecondary( wep:GetClass() ) then
		if ply.cursecondary == nil then
			if wep.rspawn then
				return false
			else		
				return true
			end
		else
			return false
		end
	elseif isExtra( wep:GetClass() ) then
		if ply.curextra == nil then
			if wep.rspawn then
				return false
			else		
				return true
			end
		else
			return false
		end
	end
end )

--//Used to remove dropped weapons to prevent entity buildup
hook.Add( "PlayerDeath", "ClearDroppedWeapons", function( ply )
	if ply.LastUsedWep then
		if !isUnique( ply.LastUsedWep) and !isExtra( ply.LastUsedWep ) then
			local ent = ents.Create( ply.LastUsedWep )
			ent:SetPos( ply:GetPos() )
			ent:Spawn()
			timer.Simple( 60, function()
				if ent and ent:IsValid() then
					ent:Remove()
				end
			end )
		end
	end
	--To remove when I rework weapon pickup
	ply.curprimary = nil
	ply.cursecondary = nil
	ply.curextra = nil
end )