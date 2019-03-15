function weapons.OnLoaded()
    --[[if weapons.Get( "cw_kk_ins2_ak74" ) then
        local wep = weapons.GetStored( "cw_kk_ins2_ak74" )
        --wep.PrintName = ""
        wep.SpeedDec = 0 --Gun Weight
        wep.Slot = 2 --The weapon slot to be used
        --wep.FireModes = {"auto", "semi"} --Available firing types
        wep.Primary.ClipSize = 30 --Weapon clip size
        wep.Primary.DefaultClip	= 30 --Initial clip clip size
        --wep.Primary.Ammo = "" --The ammo type the weapon uses
        wep.FireDelay = 0 --Fire rate
        wep.Recoil = 0 --Recoil
        wep.HipSpread = 0 --Starting spread when firing from the hip
        wep.AimSpread = 0 --Starting spread when firing while aiming
        wep.VelocitySensitivity = 0 --spread increase when whipping your gun around
        wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
        wep.SpreadPerShot = 0 --spread increase per bullet
        wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
        wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
        wep.Damage = 0 --Damage
        wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
        wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
    end]]
    --Above is a template

    --//Primary Weapons
    if weapons.Get( "cw_ak74" ) then
        local wep = weapons.GetStored( "cw_ak74" )
        wep.Slot = 0
    end

    if weapons.Get( "cw_ar15" ) then
        local wep = weapons.GetStored( "cw_ar15" )
        wep.Slot = 0
        wep.ReloadSpeed = 1.2
    end

    if weapons.Get( "cw_g3a3" ) then
        local wep = weapons.GetStored( "cw_g3a3" )
        wep.Slot = 0
    end

    if weapons.Get( "cw_l115" ) then
        local wep = weapons.GetStored( "cw_l115" )
        wep.Damage = 100
        wep.Slot = 0
        wep.Recoil = 3.5
        wep.VelocitySensitivity = 3.5
        wep.MaxSpreadInc = 0.3
        wep.ReloadSpeed = 1.3
    end

    if weapons.Get( "cw_mp5" ) then
        local wep = weapons.GetStored( "cw_mp5" )
        wep.Primary.ClipSize = 20
        wep.Primary.DefaultClip	= 20
        wep.Slot = 0
    end

    if weapons.Get( "cw_g36c" ) then
        local wep = weapons.GetStored( "cw_g36c" )
        wep.Slot = 0
    end

    if weapons.Get( "cw_l85a2" ) then
        local wep = weapons.GetStored( "cw_l85a2" )
        wep.Slot = 0
    end

    if weapons.Get( "cw_m3super90" ) then
        local wep = weapons.GetStored( "cw_m3super90" )
        wep.Slot = 0
        wep.ClumpSpread = 0.025
        wep.HipSpread = 0.04
        wep.Shots = 14
        wep.Damage = 8
    end

    if weapons.Get( "cw_m14" ) then
        local wep = weapons.GetStored( "cw_m14" )
        wep.Slot = 0
    end

    if weapons.Get( "cw_m249_official" ) then
        local wep = weapons.GetStored( "cw_m249_official" )
        wep.Slot = 0
    end

    if weapons.Get( "cw_scarh" ) then
        local wep = weapons.GetStored( "cw_scarh" )
        wep.Slot = 0
    end

    if weapons.Get( "cw_ump45" ) then
        local wep = weapons.GetStored( "cw_ump45" )
        wep.Slot = 0
    end

    if weapons.Get( "cw_vss" ) then
        local wep = weapons.GetStored( "cw_vss" )
        wep.Primary.ClipSize = 15
        wep.Primary.DefaultClip	= 15
        wep.Slot = 0
    end

    --//Secondary Weapons
    if weapons.Get( "cw_m1911" ) then
        local wep = weapons.GetStored( "cw_m1911" )
        wep.Slot = 1
        wep.Damage = 32
    end

    if weapons.Get( "cw_deagle" ) then
        local wep = weapons.GetStored( "cw_deagle" )
        wep.Slot = 1
    end

    if weapons.Get( "cw_mac11" ) then
        local wep = weapons.GetStored( "cw_mac11" )
        wep.Slot = 1
    end

    if weapons.Get( "cw_makarov" ) then
        local wep = weapons.GetStored( "cw_makarov" )
        wep.Slot = 1
        wep.Damage = 35
    end

    if weapons.Get( "cw_p99" ) then
        local wep = weapons.GetStored( "cw_p99" )
        wep.Slot = 1
    end

    if weapons.Get( "cw_mr96" ) then
        local wep = weapons.GetStored( "cw_mr96" )
        wep.Slot = 1
    end

    if weapons.Get( "cw_shorty" ) then
        local wep = weapons.GetStored( "cw_shorty" )
        wep.Slot = 1
        wep.ClumpSpread = 0.03
        wep.Shots = 14
        wep.Damage = 7
    end

    if weapons.Get( "cw_fiveseven" ) then
        local wep = weapons.GetStored( "cw_fiveseven" )
        wep.Slot = 1
        wep.FireDelay = 0.11
    end


    --//Tertiary Weapons
    if weapons.Get( "weapon_fists" ) then
        local wep = weapons.GetStored( "weapon_fists" )
        wep.Slot = 2
    end

    if weapons.Get( "cw_flash_grenade" ) then
        local wep = weapons.GetStored( "cw_flash_grenade" )
        wep.Slot = 2
    end

    if weapons.Get( "cw_smoke_grenade" ) then
        local wep = weapons.GetStored( "cw_smoke_grenade" )
        wep.Slot = 2
    end

    if weapons.Get( "weapon_medkit" ) then
        local wep = weapons.GetStored( "weapon_medkit" )
        wep.Slot = 2
    end

end