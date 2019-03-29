function weapons.OnLoaded()

    --//Primary Weapons

    --// ARs //--

    if weapons.Get( "cw_ar15" ) then
        local wep = weapons.GetStored( "cw_ar15" )
        wep.Slot = 0
        wep.Damage = 28
        wep.FireDelay = 0.078
        wep.Recoil = 0.85
        wep.HipSpread = 0.1
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.7
        wep.MaxSpreadInc = 0.06
        wep.SpreadPerShot = 0.001
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 30
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.13
        wep.SpeedDec = 50
    end

    if weapons.Get( "cw_g36c" ) then
        local wep = weapons.GetStored( "cw_g36c" )
        wep.Slot = 0
        wep.Damage = 28
        wep.FireDelay = 0.08
        wep.Recoil = 0.95
        wep.HipSpread = 0.1
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.4
        wep.MaxSpreadInc = 0.05
        wep.SpreadPerShot = 0.001
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 30
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.15
        wep.SpeedDec = 50
    end

    if weapons.Get( "cw_g3a3" ) then
        local wep = weapons.GetStored( "cw_g3a3" )
        wep.Slot = 0
        wep.Damage = 42
        wep.FireDelay = 0.12
        wep.Recoil = 1.5
        wep.HipSpread = 0.15
        wep.AimSpread = 0.005
        wep.VelocitySensitivity = 2
        wep.MaxSpreadInc = 0.1
        wep.SpreadPerShot = 0.001
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 20
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.17
        wep.SpeedDec = 50
    end

    if weapons.Get( "" ) then --FAMAS FELIN
        local wep = weapons.GetStored( "" )
        wep.Slot = 0
        wep.Damage = 26
        wep.FireDelay = 0.075
        wep.Recoil = 0.9
        wep.HipSpread = 0.1
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.6
        wep.MaxSpreadInc = 0.06
        wep.SpreadPerShot = 0.001
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 30
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.15
        wep.SpeedDec = 50
    end

    if weapons.Get( "cw_ak74" ) then
        local wep = weapons.GetStored( "cw_ak74" )
        wep.Slot = 0
        wep.Damage = 33
        wep.FireDelay = 0.0923
        wep.Recoil = 
        wep.HipSpread = 1.2
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.6
        wep.MaxSpreadInc = 0.07
        wep.SpreadPerShot = 0.001
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 30
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.13
        wep.SpeedDec = 50
    end

    if weapons.Get( "cw_l85a2" ) then
        local wep = weapons.GetStored( "cw_l85a2" )
        wep.Slot = 0
        wep.Damage = 30
        wep.FireDelay = 0.92
        wep.Recoil = 1.05
        wep.HipSpread = 0.1
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.8
        wep.MaxSpreadInc = 0.053
        wep.SpreadPerShot = 0.001
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 30
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.16
        wep.SpeedDec = 50
    end

    if weapons.Get( "cw_scarh" ) then
        local wep = weapons.GetStored( "cw_scarh" )
        wep.Slot = 0
        wep.Damage = 40
        wep.FireDelay = 0.096
        wep.Recoil = 1.35
        wep.HipSpread = 0.15
        wep.AimSpread = 0.005
        wep.VelocitySensitivity = 2
        wep.MaxSpreadInc = 0.12
        wep.SpreadPerShot = 0.001
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 20
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.15
        wep.SpeedDec = 50
    end

    --// Snipers //--

    if weapons.Get( "" ) then --L96
        local wep = weapons.GetStored( "" )
        wep.Slot = 0
        wep.Damage = 100
        wep.FireDelay = 1.5
        wep.Recoil = 2.5
        wep.HipSpread = 0.075
        wep.AimSpread = 0.001
        wep.VelocitySensitivity = 2.5
        wep.MaxSpreadInc = 0.2
        wep.SpreadPerShot = 0.1
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 5
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = wep.FireDelay + 0.01
        wep.SpeedDec = 60
    end

    if weapons.Get( "cw_m14" ) then
        local wep = weapons.GetStored( "cw_m14" )
        wep.Slot = 0
        wep.Damage = 42
        wep.FireDelay = 0.09
        wep.Recoil = 1.6
        wep.HipSpread = 0.15
        wep.AimSpread = 0.002
        wep.VelocitySensitivity = 2.1
        wep.MaxSpreadInc = 0.15
        wep.SpreadPerShot = 0.004
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 15
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.12
        wep.SpeedDec = 60
    end

    if weapons.Get( "cw_l115" ) then
        local wep = weapons.GetStored( "cw_l115" )
        wep.Slot = 0
        wep.Damage = 110
        wep.FireDelay = 1.5
        wep.Recoil = 3.5
        wep.HipSpread = 0.075
        wep.AimSpread = 0.001
        wep.VelocitySensitivity = 3.5
        wep.MaxSpreadInc = 0.3
        wep.SpreadPerShot = 0.1
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 5
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = wep.FireDelay + 0.01
        wep.SpeedDec = 60
    end

    --// SMGs //--

    if weapons.Get( "cw_ump45" ) then
        local wep = weapons.GetStored( "cw_ump45" )
        wep.Slot = 0
        wep.Damage = 29
        wep.FireDelay = 0.95
        wep.Recoil = 1.1
        wep.HipSpread = 0.04
        wep.AimSpread = 0.015
        wep.VelocitySensitivity = 1.4
        wep.MaxSpreadInc = 0.035
        wep.SpreadPerShot = 0.002
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 25
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.15
        wep.SpeedDec = 30
    end

    if weapons.Get( "" ) then --Scorpion EVO
        local wep = weapons.GetStored( "" )
        wep.Slot = 0
        wep.Damage = 20
        wep.FireDelay = 0.054
        wep.Recoil = 0.8
        wep.HipSpread = 0.03
        wep.AimSpread = 0.015
        wep.VelocitySensitivity = 1.1
        wep.MaxSpreadInc = 0.03
        wep.SpreadPerShot = 0.004
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 30
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.13
        wep.SpeedDec = 30
    end

    if weapons.Get( "" ) then --P90
        local wep = weapons.GetStored( "" )
        wep.Slot = 0
        wep.Damage = 26
        wep.FireDelay = 0.08
        wep.Recoil = 0.85
        wep.HipSpread = 0.04
        wep.AimSpread = 0.015
        wep.VelocitySensitivity = 1.5
        wep.MaxSpreadInc = 0.06
        wep.SpreadPerShot = 0.003
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 50
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.07
        wep.SpeedDec = 30
    end

    if weapons.Get( "cw_mp5" ) then
        local wep = weapons.GetStored( "cw_mp5" )
        wep.Slot = 0
        wep.Damage = 22
        wep.FireDelay = 0.07
        wep.Recoil = 0.73
        wep.HipSpread = 0.035
        wep.AimSpread = 0.015
        wep.VelocitySensitivity = 1.2
        wep.MaxSpreadInc = 0.03
        wep.SpreadPerShot = 0.004
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 20
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.13
        wep.SpeedDec = 30
    end

    if weapons.Get( "cw_vss" ) then
        local wep = weapons.GetStored( "cw_vss" )
        wep.Slot = 0
        wep.Damage = 31
        wep.FireDelay = 0.09
        wep.Recoil = 1.1
        wep.HipSpread = 0.045
        wep.AimSpread = 0.015
        wep.VelocitySensitivity = 1.6
        wep.MaxSpreadInc = 0.045
        wep.SpreadPerShot = 0.003
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 15
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.13
        wep.SpeedDec = 30
    end

    if weapons.Get( "cw_mac11" ) then
        local wep = weapons.GetStored( "cw_mac11" )
        wep.Slot = 0
        wep.Damage = 25
        wep.FireDelay = 0.075
        wep.Recoil = 0.8
        wep.HipSpread = 0.06
        wep.AimSpread = 0.015
        wep.VelocitySensitivity = 1.4
        wep.MaxSpreadInc = 0.04
        wep.SpreadPerShot = 0.003
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 40
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.23
        wep.SpeedDec = 30
    end

    --// LMGs //--

    if weapons.Get( "cw_official_m249" ) then
        local wep = weapons.GetStored( "cw_official_m249" )
        wep.Slot = 0
        wep.Damage = 28
        wep.FireDelay = 0.075
        wep.Recoil = 1.1
        wep.HipSpread = 0.1
        wep.AimSpread = 0.003
        wep.VelocitySensitivity = 0.8
        wep.MaxSpreadInc = 0.04
        wep.SpreadPerShot = 0.004
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 100
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.35
        wep.SpeedDec = 70
    end

    --// Shotguns //--

    if weapons.Get( "cw_m3super90" ) then
        local wep = weapons.GetStored( "cw_m3super90" )
        wep.Slot = 0
        wep.Damage = 8
        wep.FireDelay = 0.7
        wep.Recoil = 3
        wep.HipSpread = 0.04
        wep.AimSpread = 0.005
        wep.VelocitySensitivity = 1.1
        wep.MaxSpreadInc = 0.06
        wep.SpreadPerShot = 0.01
        wep.ClumpSpread = 0.025
        wep.Shots = 16
        wep.Primary.ClipSize = 8
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.8
        wep.SpeedDec = 40
    end

    if weapons.Get( "" ) then --spas12
        local wep = weapons.GetStored( "" )
        wep.Slot = 0
        wep.Damage = 9
        wep.FireDelay = 0.9
        wep.Recoil = 3
        wep.HipSpread = 0.04
        wep.AimSpread = 0.005
        wep.VelocitySensitivity = 1.6
        wep.MaxSpreadInc = 0.06
        wep.SpreadPerShot = 0.01
        wep.ClumpSpread = 0.035
        wep.Shots = 16
        wep.Primary.ClipSize = 6
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.8
        wep.SpeedDec = 40
    end

    if weapons.Get( "cw_shorty" ) then
        local wep = weapons.GetStored( "cw_shorty" )
        wep.Slot = 1
        wep.Damage = 7
        wep.FireDelay = 0.8
        wep.Recoil = 2
        wep.HipSpread = 0.04
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.4
        wep.MaxSpreadInc = 0.02
        wep.SpreadPerShot = 0.007
        wep.ClumpSpread = 0.3
        wep.Shots = 16
        wep.Primary.ClipSize = 2
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.85
        wep.SpeedDec = 20
    end

    --// Pistols & Mini-SMGs //--

    if weapons.Get( "cw_p99" ) then
        local wep = weapons.GetStored( "cw_p99" )
        wep.Slot = 1
        wep.Damage = 21
        wep.FireDelay = 0.135
        wep.Recoil = 0.77
        wep.HipSpread = 0.034
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.2
        wep.MaxSpreadInc = 0.04
        wep.SpreadPerShot = 0.005
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 15
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.17
        wep.SpeedDec = 20
    end

    if weapons.Get( "cw_m1911" ) then
        local wep = weapons.GetStored( "cw_m1911" )
        wep.Slot = 1
        wep.Damage = 32
        wep.FireDelay = 0.15
        wep.Recoil = 1
        wep.HipSpread = 0.04
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.25
        wep.MaxSpreadInc = 0.036
        wep.SpreadPerShot = 0.005
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 7
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.18
        wep.SpeedDec = 20
    end

    if weapons.Get( "cw_mr96" ) then
        local wep = weapons.GetStored( "cw_mr96" )
        wep.Slot = 1
        wep.Damage = 50
        wep.FireDelay = 0.2
        wep.Recoil = 2.6
        wep.HipSpread = 0.039
        wep.AimSpread = 0.005
        wep.VelocitySensitivity = 1.35
        wep.MaxSpreadInc = 0.06
        wep.SpreadPerShot = 0.003
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 6
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.25
        wep.SpeedDec = 20
    end

    if weapons.Get( "cw_fiveseven" ) then
        local wep = weapons.GetStored( "cw_fiveseven" )
        wep.Slot = 1
        wep.Damage = 20
        wep.FireDelay = 0.11
        wep.Recoil = 0.77
        wep.HipSpread = 0.034
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.2
        wep.MaxSpreadInc = 0.04
        wep.SpreadPerShot = 0.005
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 20
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.17
        wep.SpeedDec = 20
    end

    if weapons.Get( "cw_mac11" ) then
        local wep = weapons.GetStored( "cw_mac11" )
        wep.Slot = 1
        wep.Damage = 17
        wep.FireDelay = 0.05
        wep.Recoil = 0.65
        wep.HipSpread = 0.034
        wep.AimSpread = 0.015
        wep.VelocitySensitivity = 1.2
        wep.MaxSpreadInc = 0.05
        wep.SpreadPerShot = 0.01
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 30
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.09
        wep.SpeedDec = 20
    end

    if weapons.Get( "cw_makarov" ) then
        local wep = weapons.GetStored( "cw_makarov" )
        wep.Slot = 1
        wep.Damage = 35
        wep.FireDelay = 0.115
        wep.Recoil = 0.7
        wep.HipSpread = 0.038
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1
        wep.MaxSpreadInc = 0.03
        wep.SpreadPerShot = 0.005
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 6 --is this the original clip size?
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.15
        wep.SpeedDec = 20
    end

    if weapons.Get( "cw_deagle" ) then
        local wep = weapons.GetStored( "cw_deagle" )
        wep.Slot = 1
        wep.Damage = 56
        wep.FireDelay = 0.25
        wep.Recoil = 2.8
        wep.HipSpread = 0.045
        wep.AimSpread = 0.005
        wep.VelocitySensitivity = 1.35
        wep.MaxSpreadInc = 0.06
        wep.SpreadPerShot = 0.003
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 8
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.32
        wep.SpeedDec = 25
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