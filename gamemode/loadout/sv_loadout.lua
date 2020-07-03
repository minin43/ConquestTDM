--Player can't set a loadout unless they've opened up loadout menu, which calls GetUnlocked___ that populates UnlockedMasterTable, so don't need to worry about validity
GM.UnlockedMasterTable = GM.UnlockedMasterTable or {}
GM.UnlockedMasterTableClassKey = GM.UnlockedMasterTableClassKey or {}
GM.RecacheUnlockedTable = GM.RecacheUnlockedTable or {}
GM.EquippedWeapons = GM.EquippedWeapons or {}

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

    if IsDefaultWeapon( wepclass ) or GAMEMODE.AllowFullShop then
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
            if throwaway[ v[ 2 ] ] or (v[ 3 ] == 0 and v[ 5 ] == 0 and !v.vip) or (v.vip and vip.IsVip( ply )) then
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

    if perk and lvl.GetLevel( ply ) < GetPerkTable(perk)[ 3 ] and !GAMEMODE.AllowFullShop then
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
    if !ply:Alive() and ply.NextSpawnTime <= CurTime() then
        ply:Spawn()
        net.Start( "CloseDeathScreen" )
        net.Send( ply )
    end
end )

hook.Add( "PlayerInitialSpawn", "SetupPrecacheEnvironment", function( ply )
    GAMEMODE.RecacheUnlockedTable[ ply ] = {wep = true, skin = true, model = true, perk = true}
    GAMEMODE.UnlockedMasterTable[ ply ] = {wep = {}, skin = {}, model = {}, perk = {}}
    GAMEMODE.UnlockedMasterTableClassKey[ ply ] = {wep = {}, skin = {}, model = {}}
    GAMEMODE.EquippedWeapons[ ply ] = {}
end )

function GM:DropWeapon( ply )
    if !ply.spawning and ply:Alive() then
        local todrop = ply:GetActiveWeapon()

        if !todrop or !todrop:IsValid() or isExtra( todrop:GetClass() ) then return end
        
        if CustomizableWeaponry and todrop.Base == "cw_base" then
            ply:ConCommand( "cw_dropweapon" )
            if todrop.Slot == 0 then
                GAMEMODE.EquippedWeapons[ ply ].prim = nil
            elseif todrop.Slot == 1 then
                GAMEMODE.EquippedWeapons[ ply ].sec = nil
            end
        else
            local toSpawn = ents.Create( todrop:GetClass() )
            toSpawn:SetClip1( todrop:Clip1() )
            toSpawn:SetClip2( todrop:Clip2() )
            ply:StripWeapon( todrop:GetClass() )
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

util.AddNetworkString( "CTDMDropWeapon" )
net.Receive( "CTDMDropWeapon", function( len, ply )
    GAMEMODE:DropWeapon( ply )
end )

--Since the standard CW2 drop function doesn't create a wep ent, but prop_physics or some shit, we have to do this hacky work-around
hook.Add( "OnEntityCreated", "AlterCW2Pickup", function( wepent )
    if wep:GetClass() == "cw_dropped_weapon" then
        function wepent:canPickup(activator)
            if !activator:IsPlayer() then return end
            
            local canPickupWeapon
            local weptable = RetrieveWeaponTable( self:GetWepClass() ) --GetWepClass is a CW2.0 function
            local canPickupAttachments = false

            if self.giveAttachmentsOnPickup then
                canPickupAttachments = not CustomizableWeaponry:hasSpecifiedAttachments(activator, self.stringAttachmentIDs)
            end

            --Coulda been a table... buuuuuuut... I'm feeling lazy
            if weptable.slot == 1 then
                if GAMEMODE.EquippedWeapons[ activator ].prim == nil then
                    canPickupWeapon = true
                else
                    if GAMEMODE.EquippedWeapons[ activator ].prim == self:GetWepClass() then
                        activator:GiveAmmo( self.magSize, weapons.GetStored( self:GetWepClass() ).Primary.Ammo )
                        if !canPickupAttachments then
                            self:Remove()
                        end
                    end
                end
            elseif weptable.slot == 2 then
                if GAMEMODE.EquippedWeapons[ activator ].sec == nil then
                    canPickupWeapon = true
                else
                    if GAMEMODE.EquippedWeapons[ activator ].sec == self:GetWepClass() then
                        activator:GiveAmmo( self.magSize, weapons.GetStored( self:GetWepClass() ).Primary.Ammo )
                        if !canPickupAttachments then
                            self:Remove()
                        end
                    end
                end
            elseif weptable.slot == 3 then
                if GAMEMODE.EquippedWeapons[ activator ].equip == nil then
                    canPickupWeapon = true
                else
                    if GAMEMODE.EquippedWeapons[ activator ].equip == self:GetWepClass() then
                        activator:GiveAmmo( self.magSize, weapons.GetStored( self:GetWepClass() ).Primary.Ammo )
                        if !canPickupAttachments then
                            self:Remove()
                        end
                    end
                end
            end
            
            return canPickupWeapon, canPickupAttachments
        end

        function wepent:setWeapon(wep)
            self:SetWepClass(wep:GetClass())
            self.magSize = wep:Clip1()
            self.containedAttachments = {} -- for shit like loading them onto a weapon
            self.stringAttachmentIDs = {} -- for shit like displaying the attachment names and giving them to the player upon pickup
            self.useDelay = CurTime() + 1
            
            self:SetModel(wep.WorldModel)
            self:SetMaterial( wep:GetMaterial() --[[or GAMEMODE.PlayerLoadouts[ wep:GetOwner() ]] )
            self:PhysicsInit(SOLID_VPHYSICS)
            self:SetMoveType(MOVETYPE_VPHYSICS)
            self:SetSolid(SOLID_VPHYSICS)
            self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
            local phys = self:GetPhysicsObject()

            if phys and phys:IsValid() then
                phys:Wake()
            end
            
            for key, data in pairs(wep.Attachments) do
                if data.last then
                    self.containedAttachments[key] = data.last
                    self.stringAttachmentIDs[#self.stringAttachmentIDs + 1] = data.atts[data.last]
                end
            end
            
            self.M203Chamber = wep.M203Chamber
        end

        --[[local weptable = RetrieveWeaponTable( self:GetClass() )
        if weptable then
            if weptable.slot == 1 then
                GAMEMODE.PlayerLoadouts[ ply ]
            end
        end]]
    end
end )

--When we equip a weapon, mark down which type it is, so we don't pick up others in the future
hook.Add( "WeaponEquip", "WeaponEquippingShit", function( wep, ply )
    --If the weapon isn't CW2.0, removes 1 mag of ammo from the player's ammo pool - used to be written really shittily
	timer.Simple( 0, function()
		if IsValid( wep ) and IsValid( ply ) then
			if wep.Base != "cw_base" then
				ply:RemoveAmmo( wep:Clip1(), wep:GetPrimaryAmmoType() )
			end
		end
    end )
    
    local wepclass = wep:GetClass()
    if isPrimary( wepclass ) then
        GAMEMODE.EquippedWeapons[ ply ].prim = wepclass
    elseif isSecondary( wepclass ) then
        GAMEMODE.EquippedWeapons[ ply ].sec = wepclass
    elseif isExtra( wepclass ) then
        GAMEMODE.EquippedWeapons[ ply ].equip = wepclass
    end
end )

--CW2 guns need not apply, prevents doubling up on weapons if we start introducing non-CW2 primaries and secondaries
hook.Add( "PlayerCanPickupWeapon", "NoAutoPickup", function( ply, wep )
    if wep.Base == "cw_base" then return end

	if isPrimary( wep:GetClass() ) then
        return GAMEMODE.EquippedWeapons[ ply ].prim == nil
    elseif isSecondary( wep:GetClass() ) then
        return GAMEMODE.EquippedWeapons[ ply ].sec == nil
    elseif isExtra( wep:GetClass() ) then
        return
	end
end )

--//Used to remove dropped weapons to prevent entity buildup
hook.Add( "OnEntityCreated", "DeleteCW2Drops", function( wep )
    if wep:GetClass() == "cw_dropped_weapon" then
        timer.Simple( 60, function()
            if wep and wep:IsValid() then
                wep:Remove()
            end
        end )
    end
end)

--Reset backend saved data on player death
hook.Add( "DoPlayerDeath", "Clear&DropWeapons", function( ply, att, dmginfo ) 
    GAMEMODE:DropWeapon( ply )
	GAMEMODE.EquippedWeapons[ ply ] = {}
end )