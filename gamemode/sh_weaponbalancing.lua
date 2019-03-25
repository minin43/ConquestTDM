function weapons.OnLoaded()
    --[[
        Weapon balancing notes:

        No Assault rifle should 
            have a hipspread under 0.1
            have a speeddec under 50
    ]]

    --//Primary Weapons
    if weapons.Get( "cw_ak74" ) then
        local wep = weapons.GetStored( "cw_ak74" )
        wep.Slot = 0
        wep.SpeedDec = 50
        wep.HipSpread = 0.1
    end

    if weapons.Get( "cw_ar15" ) then
        local wep = weapons.GetStored( "cw_ar15" )
        wep.Slot = 0
        wep.ReloadSpeed = 1.1
        wep.FireDelay = 0.079
        wep.Recoil = 1.00
        wep.SpeedDec = 50
        wep.HipSpread = 0.1
    end

    if weapons.Get( "cw_g3a3" ) then
        local wep = weapons.GetStored( "cw_g3a3" )
        wep.Slot = 0
        wep.SpeedDec = 50
        wep.HipSpread = 0.1
    end

    if weapons.Get( "cw_l115" ) then
        local wep = weapons.GetStored( "cw_l115" )
        wep.Damage = 100
        wep.Slot = 0
        wep.Recoil = 3.5
        wep.VelocitySensitivity = 3.5
        wep.MaxSpreadInc = 0.3
        wep.ReloadSpeed = 1.3
        wep.AimSpread = 0.001
        wep.SpeedDec = 70
    end

    if weapons.Get( "cw_mp5" ) then
        local wep = weapons.GetStored( "cw_mp5" )
        wep.Primary.ClipSize = 20
        wep.Primary.DefaultClip	= 20
        wep.Slot = 0
        wep.FireDelay = 0.065
        wep.Recoil = 0.73
        wep.SpeedDec = 30
    end

    if weapons.Get( "cw_g36c" ) then
        local wep = weapons.GetStored( "cw_g36c" )
        wep.Slot = 0
        wep.SpeedDec = 50
        wep.HipSpread = 0.1
    end

    if weapons.Get( "cw_l85a2" ) then
        local wep = weapons.GetStored( "cw_l85a2" )
        wep.Slot = 0
        wep.SpeedDec = 50
        wep.HipSpread = 0.1
    end

    if weapons.Get( "cw_m3super70" ) then
        local wep = weapons.GetStored( "cw_m3super70" )
        wep.Slot = 0
        wep.ClumpSpread = 0.025
        wep.HipSpread = 0.04
        wep.Shots = 14
        wep.Damage = 8
        wep.SpeedDec = 40
    end

    if weapons.Get( "cw_m14" ) then
        local wep = weapons.GetStored( "cw_m14" )
        wep.Slot = 0
        wep.SpeedDec = 70
    end

    if weapons.Get( "cw_m249_official" ) then
        local wep = weapons.GetStored( "cw_m249_official" )
        wep.Slot = 0
        wep.SpeedDec = 90
    end

    if weapons.Get( "cw_scarh" ) then
        local wep = weapons.GetStored( "cw_scarh" )
        wep.Slot = 0
        wep.SpeedDec = 50
        wep.HipSpread = 0.1
    end

    if weapons.Get( "cw_ump45" ) then
        local wep = weapons.GetStored( "cw_ump45" )
        wep.Slot = 0
        wep.Damage = 29
        wep.SpeedDec = 30
    end

    if weapons.Get( "cw_vss" ) then
        local wep = weapons.GetStored( "cw_vss" )
        wep.Primary.ClipSize = 15
        wep.Primary.DefaultClip	= 15
        wep.Slot = 0
        wep.SpeedDec = 30
    end

    --//Secondary Weapons
    if weapons.Get( "cw_m1911" ) then
        local wep = weapons.GetStored( "cw_m1911" )
        wep.Slot = 1
        wep.Damage = 32
        wep.SpeedDec = 20
    end

    if weapons.Get( "cw_deagle" ) then
        local wep = weapons.GetStored( "cw_deagle" )
        wep.Slot = 1
        wep.SpeedDec = 20
    end

    if weapons.Get( "cw_mac11" ) then
        local wep = weapons.GetStored( "cw_mac11" )
        wep.Slot = 1
        wep.SpeedDec = 20
    end

    if weapons.Get( "cw_makarov" ) then
        local wep = weapons.GetStored( "cw_makarov" )
        wep.Slot = 1
        wep.Damage = 35
        wep.SpeedDec = 20
    end

    if weapons.Get( "cw_p99" ) then
        local wep = weapons.GetStored( "cw_p99" )
        wep.Slot = 1
        wep.SpeedDec = 20
    end

    if weapons.Get( "cw_mr96" ) then
        local wep = weapons.GetStored( "cw_mr96" )
        wep.Slot = 1
        wep.SpeedDec = 20
    end

    if weapons.Get( "cw_shorty" ) then
        local wep = weapons.GetStored( "cw_shorty" )
        wep.Slot = 1
        wep.ClumpSpread = 0.03
        wep.Shots = 14
        wep.Damage = 7
        wep.SpeedDec = 20
    end

    if weapons.Get( "cw_fiveseven" ) then
        local wep = weapons.GetStored( "cw_fiveseven" )
        wep.Slot = 1
        wep.FireDelay = 0.11
        wep.SpeedDec = 20
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