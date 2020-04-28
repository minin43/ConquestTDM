GM.UnlockedMasterTable = GM.UnlockedMasterTable or {}

util.AddNetworkString( "GetUnlockedWeapons" )
util.AddNetworkString( "GetUnlockedWeaponsCallback" )
util.AddNetworkString( "GetUnlockedModels" )
util.AddNetworkString( "GetUnlockedModelsCallback" )
util.AddNetworkString( "GetUnlockedSkins" )
util.AddNetworkString( "GetUnlockedSkinsCallback" )
util.AddNetworkString( "GetUnlockedPerks" )
util.AddNetworkString( "GetUnlockedPerksCallback" )
util.AddNetworkString( "SetLoadout" )

net.Receive( "GetUnlockedWeapons", function( len, ply )
    local fil = util.JSONToTable( file.Read( "tdm/users/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) )
    local unlockedweps = fil[ 2 ]
    local throwaway, tosend = {}, {}
    
    GAMEMODE.UnlockedMasterTable[ id(ply:SteamID()) ][1] = { "dummyprimary", "dummysecondary" }
    for k, v in pairs( unlockedweps ) do
        GAMEMODE.UnlockedMasterTable[ id(ply:SteamID()) ][1][ #GAMEMODE.UnlockedMasterTable[ id(ply:SteamID()) ][1] + 1 ] = v
        throwaway[ v ] = true
    end

    for k, v in pairs( GAMEMODE.WeaponsList ) do
        if throwaway[ v[ 2 ] ] or (v[ 3 ] == 0 and v[ 5 ] == 0) then
            tosend[ #tosend + 1 ] = k
        end
    end

    net.Start( "GetUnlockedWeaponsCallback" )
        net.WriteTable( tosend )
    net.Send( ply )
end )
net.Receive( "GetUnlockedSkins", function( len, ply )
    local fil = util.JSONToTable( file.Read( "tdm/users/skins/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) )
    local unlockedskins = fil[ 2 ]
    local throwaway, tosend = {}, {}

    GAMEMODE.UnlockedMasterTable[ id(ply:SteamID()) ][2] = {}
    for k, v in pairs( unlockedskins ) do
        GAMEMODE.UnlockedMasterTable[ id(ply:SteamID()) ][2][ #GAMEMODE.UnlockedMasterTable[ id(ply:SteamID()) ][2] + 1 ] = v        
        throwaway[ v ] = true
    end

    for k, v in pairs( GAMEMODE.WeaponSkins ) do
        if throwaway[ v.directory ] then 
            tosend[ #tosend + 1 ] = k
        end
    end

    net.Start( "GetUnlockedSkinsCallback" )
        net.WriteTable( tosend )
    net.Send( ply )
end )
net.Receive( "GetUnlockedModels", function( len, ply )
	local fil = util.JSONToTable( file.Read( "tdm/users/models/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) )
	local unlockedmodels = fil[ 2 ]
	local throwaway, tosend = {}, {}

    GAMEMODE.UnlockedMasterTable[ id(ply:SteamID()) ][3] = {}
    for k, v in pairs( unlockedmodels ) do
        GAMEMODE.UnlockedMasterTable[ id(ply:SteamID()) ][3][ #GAMEMODE.UnlockedMasterTable[ id(ply:SteamID()) ][3] + 1 ] = v        
        throwaway[ v ] = true
    end

    for k, v in pairs( GAMEMODE.PlayerModels ) do
        if throwaway[ v.model ] then --//Have to save by model, since naming can be changed
            tosend[ #tosend + 1 ] = k
        end
    end

    net.Start( "GetUnlockedModelsCallback" )
        net.WriteTable( tosend )
    net.Send( ply )
end )
net.Receive( "GetUnlockedPerks", function( len, ply )
    local tosend = { locked = {} }
    for _, perkinfo in pairs( GAMEMODE.Perks ) do
        if perkinfo[ 3 ] <= lvl.GetLevel( ply ) then
            tosend[ #tosend + 1 ] = perkinfo
        else
            tosend.locked[ #tosend.locked + 1 ] = perkinfo
        end
    end

    net.Start( "GetUnlockedPerksCallback" )
        net.WriteTable( tosend )
    net.Send( ply )
end )
net.Receive( "SetLoadout", function( len, ply )
    --GAMEMODE.UnlockedMasterTable[ id(ply:SteamID()) ] = GAMEMODE.UnlockedMasterTable[ id(ply:SteamID()) ] or {}
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

    local ownsprim, ownssec, ownsequip, ownsmodel, ownsskin1, ownsskin2
    for k, tbl in pairs( GAMEMODE.UnlockedMasterTable[ id(ply:SteamID()) ] ) do
        for _, class in pairs( tbl ) do
            if k == 1 then
                if !ownsprim and (class == primary or IsDefaultWeapon( primary )) then ownsprim = true print(1) end
                if !ownssec and (class == secondary or IsDefaultWeapon( secondary )) then ownssec = true print(2) end
                if !ownsequip and (class == equipment or IsDefaultWeapon( equipment )) then ownsequip = true print(3) end
            elseif k == 2 then
                if class == primaryskin then ownsskin1 = true print(4) end
                if class == secondaryskin then ownsskin2 = true print(5) end
            else
                if class == pm or IsDefaultModel( pm ) then ownsmodel = true print(6) break end
            end
        end
    end

    if (!ownsprim) then
        CaughtCheater( ply, "Attempted to spawn with primary weapon they don't have access to.")
        return
    elseif (primaryskin and !ownsskin1) or (secondaryskin and !ownsskin2) then
        CaughtCheater( ply, "Attempted to spawn with weapon skin they don't have access to.")
        return
    elseif (secondary and !ownssec) then
        CaughtCheater( ply, "Attempted to spawn with secondary weapon they don't have access to.")
        return
    elseif (equipment and !ownsequip) then
        CaughtCheater( ply, "Attempted to spawn with equipment they don't have access to.")
        return
    elseif (perk and lvl.GetLevel( ply ) < GetPerkTable(perk)[ 3 ]) then
        CaughtCheater( ply, "Attempted to spawn with perk they don't have access to.")
        return
    elseif (pm and !ownsmodel) then
        CaughtCheater( ply, "Attempted to spawn with model they don't have access to.")
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

--[[function FixExploit( ply, wep )
	ply:StripWeapon( wep )
	local ent = ents.Create( wep )
	ent:SetPos( ply:GetPos() )
	ent:Spawn()
end]]

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