--[[Some notes about balancing:
    MaxSpreadInc is ideally Hip Spread / 4 + 0.02?
    SpreadPerShot feels bad any value > 0 on automatic weapons, as uncontrollable inaccuracy takes effect. Values of 0.001 - 0.003 are recommended for 
        particularly inaccurate-feeling weapons, otherwise values of 0 work well (recoil is already heavily randomized, randomized^2 just feels plain bad)
    Dunno how VelocitySensitivity plays into accuracy penalties, only that it does.
]]

function RebalanceWeapons()
    print("Balancing the weapons...")

    --//Primary Weapons

    --// ARs //--

    if weapons.Get( "cw_ar15" ) then
        local wep = weapons.GetStored( "cw_ar15" )
        wep.Slot = 0
        wep.Damage = 27
        wep.FireDelay = 0.078
        wep.Recoil = 0.92
        wep.HipSpread = 0.12
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.7
        wep.MaxSpreadInc = 0.05
        wep.SpreadPerShot = 0.0
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 30
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.13
        wep.SpeedDec = 50

        wep.ReloadSpeed = 1.1
    end

    if weapons.Get( "cw_tr09_qbz97" ) then
        local wep = weapons.GetStored( "cw_tr09_qbz97" )
        wep.Slot = 0
        wep.Damage = 31
        wep.FireDelay = 0.084
        wep.Recoil = 1.08
        wep.HipSpread = 0.12
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

    if weapons.Get( "cw_g36c" ) then
        local wep = weapons.GetStored( "cw_g36c" )
        wep.Slot = 0
        wep.Damage = 28
        wep.FireDelay = 0.08
        wep.Recoil = 0.95
        wep.HipSpread = 0.12
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.4
        wep.MaxSpreadInc = 0.05
        wep.SpreadPerShot = 0.0
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
        wep.SpreadPerShot = 0.0
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 20
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.17
        wep.SpeedDec = 50
    end

    if weapons.Get( "r5" ) then
        local wep = weapons.GetStored( "r5" )
        wep.Slot = 0
        wep.Damage = 26
        wep.FireDelay = 0.072
        wep.Recoil = 0.9
        wep.HipSpread = 0.12
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.6
        wep.MaxSpreadInc = 0.05
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
        wep.Recoil = 1.2
        wep.HipSpread = 0.12
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.6
        wep.MaxSpreadInc = 0.05
        wep.SpreadPerShot = 0.001
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 30
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.13
        wep.SpeedDec = 50
    end

    if weapons.Get( "cw_tr09_auga3" ) then
        local wep = weapons.GetStored( "cw_tr09_auga3" )
        wep.Slot = 0
        wep.Damage = 28
        wep.FireDelay = 0.08
        wep.Recoil = 0.97
        wep.HipSpread = 0.12
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.9
        wep.MaxSpreadInc = 0.05
        wep.SpreadPerShot = 0.0
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 30
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.15
        wep.SpeedDec = 50
    end

    if weapons.Get( "cw_l85a2" ) then
        local wep = weapons.GetStored( "cw_l85a2" )
        wep.Slot = 0
        wep.Damage = 30
        wep.FireDelay = 0.092
        wep.Recoil = 1.05
        wep.HipSpread = 0.12
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.8
        wep.MaxSpreadInc = 0.05
        wep.SpreadPerShot = 0.001
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 30
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.16
        wep.SpeedDec = 50
    end

    if weapons.Get( "cw_aacgsm" ) then
        local wep = weapons.GetStored( "cw_aacgsm" )
        wep.Slot = 0
        wep.Damage = 24
        wep.FireDelay = 0.063
        wep.Recoil = 0.87
        wep.HipSpread = 0.12
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.5
        wep.MaxSpreadInc = 0.05
        wep.SpreadPerShot = 0.001
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 30
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.15
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
        wep.SpreadPerShot = 0.0
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 20
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.15
        wep.SpeedDec = 50
    end

    if weapons.Get( "cw_tr09_tar21" ) then
        local wep = weapons.GetStored( "cw_tr09_tar21" )
        wep.Slot = 0
        wep.Damage = 37
        wep.FireDelay = 0.086
        wep.Recoil = 1.35
        wep.HipSpread = 0.12
        wep.AimSpread = 0.001
        wep.VelocitySensitivity = 1.5
        wep.MaxSpreadInc = 0.05
        wep.SpreadPerShot = 0.002
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 30
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.15
        wep.SpeedDec = 50
    end

    if weapons.Get( "bo2r_m27" ) then
        local wep = weapons.GetStored( "bo2r_m27" )
        wep.Slot = 0
        wep.Damage = 28
        wep.FireDelay = 0.08
        wep.Recoil = 0.95
        wep.HipSpread = 0.12
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.4
        wep.MaxSpreadInc = 0.05
        wep.SpreadPerShot = 0.0
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 30
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.15
        wep.SpeedDec = 50
    end

    if weapons.Get( "cw_killdrix_acre" ) then
        local wep = weapons.GetStored( "cw_killdrix_acre" )
        wep.Slot = 0
        wep.Damage = 26
        wep.FireDelay = 0.072
        wep.Recoil = 0.9
        wep.HipSpread = 0.12
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.6
        wep.MaxSpreadInc = 0.05
        wep.SpreadPerShot = 0.001
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 30
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.15
        wep.SpeedDec = 50

        wep.ReloadSpeed = 1.5

        --Adjusts what scopes are seen by the player (I've removed a few extra attachments I didn't want/like), attachments are still manually set in sv_stattrak
        wep.Attachments[1] = {header = "Sight", offset = {850, -100},  atts = {"md_microt1","md_eotech","md_aimpoint"}}
        wep.Attachments[4] = nil
        wep.Attachments[5] = nil
    end

    if weapons.Get( "bo2r_peacekeeper" ) then
        local wep = weapons.GetStored( "bo2r_peacekeeper" )
        wep.Slot = 0
        wep.Damage = 28
        wep.FireDelay = 0.08
        wep.Recoil = 0.97
        wep.HipSpread = 0.12
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.9
        wep.MaxSpreadInc = 0.05
        wep.SpreadPerShot = 0.0
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 30
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.15
        wep.SpeedDec = 50
    end

    if weapons.Get( "cw_kk_hk416" ) then
        local wep = weapons.GetStored( "cw_kk_hk416" )
        wep.Slot = 0
        wep.Damage = 27
        wep.FireDelay = 0.078
        wep.Recoil = 0.92
        wep.HipSpread = 0.12
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.7
        wep.MaxSpreadInc = 0.05
        wep.SpreadPerShot = 0.0
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 30
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.13
        wep.SpeedDec = 50

        --Adjusts what scopes are seen by the player (I've removed a bunch of extra scopes I didn't want/like), attachments are still manually set in sv_stattrak
        wep.Attachments[1] = {header = "Sight", offset = {550, -475}, atts = {"bg_hk416_foldsight","md_fas2_eotech","md_fas2_holo","md_cod4_aimpoint_v2","md_cod4_acog_v2","md_fas2_leupold"}}
    end

    --// Snipers //--

    if weapons.Get( "cw_b196" ) then
        local wep = weapons.GetStored( "cw_b196" )
        wep.Slot = 0
        wep.Damage = 100
        wep.FireDelay = 1.5
        wep.Recoil = 2.5
        wep.HipSpread = 0.35
        wep.AimSpread = 0.001
        wep.VelocitySensitivity = 3.0
        wep.MaxSpreadInc = 0.4
        wep.SpreadPerShot = 0.1
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 5
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = wep.FireDelay + 0.01
        wep.SpeedDec = 60

        wep.Attachments[5] = nil
    end

    if weapons.Get( "cw_tac338" ) then
        local wep = weapons.GetStored( "cw_tac338" )
        wep.Slot = 0
        wep.Damage = 110
        wep.FireDelay = 1.9
        wep.Recoil = 2.5
        wep.HipSpread = 0.35
        wep.AimSpread = 0.001
        wep.VelocitySensitivity = 3.1
        wep.MaxSpreadInc = 0.4
        wep.SpreadPerShot = 0.1
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 5
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = wep.FireDelay + 0.01
        wep.SpeedDec = 60

        wep.Attachments[1] = {header = "Sight", offset = {500, -600}, atts = {"md_rmr", "md_microt1", "md_aimpoint", "md_eotech", "md_schmidt_shortdot", "md_acog", "md_nightforce_nxs"}}
    end

    if weapons.Get( "cw_wf_m200" ) then
        local wep = weapons.GetStored( "cw_wf_m200" )
        wep.Slot = 0
        wep.Damage = 115
        wep.FireDelay = 1.62
        wep.Recoil = 3.5
        wep.HipSpread = 0.35
        wep.AimSpread = 0.001
        wep.VelocitySensitivity = 3.2
        wep.MaxSpreadInc = 0.4
        wep.SpreadPerShot = 0.1
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 5
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = wep.FireDelay + 0.01
        wep.SpeedDec = 60

        wep.Attachments[1] = {header = "Sight", offset = {400, -600}, atts = {"md_rmr", "md_microt1", "md_aimpoint", "md_eotech", "md_schmidt_shortdot", "md_acog", "md_nightforce_nxs"}}
    end

    if weapons.Get( "cw_l115" ) then
        local wep = weapons.GetStored( "cw_l115" )
        wep.Slot = 3
        wep.Damage = 300
        wep.FireDelay = 1.5
        wep.Recoil = 3.5
        wep.HipSpread = 0.35
        wep.AimSpread = 0.001
        wep.VelocitySensitivity = 2.5
        wep.MaxSpreadInc = 0.4
        wep.SpreadPerShot = 0.1
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 1
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
        wep.HipSpread = 0.35
        wep.AimSpread = 0.002
        wep.VelocitySensitivity = 2.4
        wep.MaxSpreadInc = 0.45
        wep.SpreadPerShot = 0.0
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 15
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.12
        wep.SpeedDec = 60
    end

    if weapons.Get( "cw_weapon_rfb" ) then
        local wep = weapons.GetStored( "cw_weapon_rfb" )
        wep.Slot = 0
        wep.Damage = 52
        wep.FireDelay = 0.13
        wep.Recoil = 1.75
        wep.HipSpread = 0.35
        wep.AimSpread = 0.002
        wep.VelocitySensitivity = 2.1
        wep.MaxSpreadInc = 0.45
        wep.SpreadPerShot = 0.0
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 10
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.19
        wep.SpeedDec = 60
    end

    if weapons.Get( "bo2r_svu" ) then
        local wep = weapons.GetStored( "bo2r_svu" )
        wep.PrintName = "Dragunov SVU"
        wep.Slot = 0
        wep.Damage = 52
        wep.FireDelay = 0.11
        wep.Recoil = 1.6
        wep.HipSpread = 0.35
        wep.AimSpread = 0.002
        wep.VelocitySensitivity = 2.4
        wep.MaxSpreadInc = 0.45
        wep.SpreadPerShot = 0.0
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 20
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.22
        wep.SpeedDec = 60
    end

    --// SMGs //--

    if weapons.Get( "cw_ump45" ) then
        local wep = weapons.GetStored( "cw_ump45" )
        wep.Slot = 0
        wep.Damage = 29
        wep.FireDelay = 0.093
        wep.Recoil = 1.1
        wep.HipSpread = 0.05
        wep.AimSpread = 0.025
        wep.VelocitySensitivity = 1.4
        wep.MaxSpreadInc = 0.035
        wep.SpreadPerShot = 0.001
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 25
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.15
        wep.SpeedDec = 30

        wep.ReloadSpeed = 1.1
    end

    if weapons.Get( "cw_tr09_mp9" ) then
        local wep = weapons.GetStored( "cw_tr09_mp9" )
        wep.Slot = 0
        wep.Damage = 23
        wep.FireDelay = 0.067
        wep.Recoil = 0.82
        wep.HipSpread = 0.047
        wep.AimSpread = 0.025
        wep.VelocitySensitivity = 1.3
        wep.MaxSpreadInc = 0.035
        wep.SpreadPerShot = 0.004
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 20
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.13
        wep.SpeedDec = 30
    end

    if weapons.Get( "cw_scorpin_evo3" ) then
        local wep = weapons.GetStored( "cw_scorpin_evo3" )
        wep.Slot = 0
        wep.Damage = 20
        wep.FireDelay = 0.054
        wep.Recoil = 0.8
        wep.HipSpread = 0.04
        wep.AimSpread = 0.025
        wep.VelocitySensitivity = 1.1
        wep.MaxSpreadInc = 0.03
        wep.SpreadPerShot = 0.003
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 30
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.13
        wep.SpeedDec = 30
    end

    if weapons.Get( "cw_ber_p90" ) then
        local wep = weapons.GetStored( "cw_ber_p90" )
        wep.Slot = 0
        wep.Damage = 26
        wep.FireDelay = 0.08
        wep.Recoil = 0.9
        wep.HipSpread = 0.05
        wep.AimSpread = 0.025
        wep.VelocitySensitivity = 1.5
        wep.MaxSpreadInc = 0.06
        wep.SpreadPerShot = 0.002
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 50
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.07
        wep.SpeedDec = 30

        wep.Chamberable = false
    end

    if weapons.Get( "cw_mp5" ) then
        local wep = weapons.GetStored( "cw_mp5" )
        wep.Slot = 0
        wep.Damage = 24
        wep.FireDelay = 0.07
        wep.Recoil = 0.73
        wep.HipSpread = 0.045
        wep.AimSpread = 0.025
        wep.VelocitySensitivity = 1.2
        wep.MaxSpreadInc = 0.03
        wep.SpreadPerShot = 0.003
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
        wep.HipSpread = 0.055
        wep.AimSpread = 0.025
        wep.VelocitySensitivity = 1.6
        wep.MaxSpreadInc = 0.045
        wep.SpreadPerShot = 0.002
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 15
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.13
        wep.SpeedDec = 30
    end

    if weapons.Get( "cw_ber_hkmp7" ) then
        local wep = weapons.GetStored( "cw_ber_hkmp7" )
        wep.Slot = 0
        wep.Damage = 25
        wep.FireDelay = 0.075
        wep.Recoil = 0.9
        wep.HipSpread = 0.06
        wep.AimSpread = 0.025
        wep.VelocitySensitivity = 1.4
        wep.MaxSpreadInc = 0.04
        wep.SpreadPerShot = 0.002
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 40
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.23
        wep.SpeedDec = 30
    end

    if weapons.Get( "bo2r_mp7" ) then
        local wep = weapons.GetStored( "bo2r_mp7" )
        wep.Slot = 0
        wep.Damage = 25
        wep.FireDelay = 0.075
        wep.Recoil = 0.9
        wep.HipSpread = 0.06
        wep.AimSpread = 0.025
        wep.VelocitySensitivity = 1.4
        wep.MaxSpreadInc = 0.04
        wep.SpreadPerShot = 0.002
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
        wep.Damage = 32
        wep.FireDelay = 0.085
        wep.Recoil = 1.8
        wep.HipSpread = 0.18
        wep.AimSpread = 0.006
        wep.VelocitySensitivity = 1.0
        wep.MaxSpreadInc = 0.22
        wep.SpreadPerShot = 0.004
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 100
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.35
        wep.SpeedDec = 70
        wep.Trivia = { } --//Removes the line "Accurate aimed fire is not possible without the use of a bipod", as all LMGs will utilize that mechanic

        wep.RecoilToSpread = 0.8
    end

    if weapons.Get( "bo2r_hamr" ) then
        local wep = weapons.GetStored( "bo2r_hamr" )
        wep.Slot = 0
        wep.Damage = 32
        wep.FireDelay = 0.085
        wep.Recoil = 1.8
        wep.HipSpread = 0.18
        wep.AimSpread = 0.006
        wep.VelocitySensitivity = 1.0
        wep.MaxSpreadInc = 0.22
        wep.SpreadPerShot = 0.004
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 100
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.35
        wep.SpeedDec = 70
        wep.Trivia = { } --//Removes the line "Accurate aimed fire is not possible without the use of a bipod", as all LMGs will utilize that mechanic

        wep.RecoilToSpread = 0.8
    end

    --[[if weapons.Get( "cw_amr2_mk46" ) then
        local wep = weapons.GetStored( "cw_amr2_mk46" )
        wep.Slot = 0
        wep.Damage = 36
        wep.FireDelay = 0.09
        wep.Recoil = 1.75
        wep.HipSpread = 0.18
        wep.AimSpread = 0.008
        wep.VelocitySensitivity = 1.0
        wep.MaxSpreadInc = 0.22
        wep.SpreadPerShot = 0.002
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 100
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.37
        wep.SpeedDec = 70

        wep.RecoilToSpread = 0.8

        wep.badAccuracyModifier = 3
        function wep:hasBadAccuracy()
            return self.dt.State == CW_AIMING and not self.dt.BipodDeployed
        end
        function wep:getBaseCone()
            local baseCone, maxSpreadMod = self.BaseClass.getBaseCone(self)
            
            if self:hasBadAccuracy() then
                return baseCone * self.badAccuracyModifier, maxSpreadMod
            end
            
            return baseCone, maxSpreadMod
        end
        function wep:getMaxSpreadIncrease(maxSpreadMod)
            if self:hasBadAccuracy() then
                return self.BaseClass.getMaxSpreadIncrease(self, maxSpreadMod) * self.badAccuracyModifier
            end
            
            return self.BaseClass.getMaxSpreadIncrease(self, maxSpreadMod)
        end
    end

    if weapons.Get( "cw_amr2_rpk74" ) then
        local wep = weapons.GetStored( "cw_amr2_rpk74" )
        wep.Slot = 0
        wep.Damage = 30
        wep.FireDelay = 0.093
        wep.Recoil = 1.7
        wep.HipSpread = 0.18
        wep.AimSpread = 0.003
        wep.VelocitySensitivity = 1.1
        wep.MaxSpreadInc = 0.21
        wep.SpreadPerShot = 0.002
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 75
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.32
        wep.SpeedDec = 70

        wep.RecoilToSpread = 0.8

        wep.badAccuracyModifier = 5
        function wep:hasBadAccuracy()
            return self.dt.State == CW_AIMING and not self.dt.BipodDeployed
        end
        function wep:getBaseCone()
            local baseCone, maxSpreadMod = self.BaseClass.getBaseCone(self)
            
            if self:hasBadAccuracy() then
                return baseCone * self.badAccuracyModifier, maxSpreadMod
            end
            
            return baseCone, maxSpreadMod
        end
        function wep:getMaxSpreadIncrease(maxSpreadMod)
            if self:hasBadAccuracy() then
                return self.BaseClass.getMaxSpreadIncrease(self, maxSpreadMod) * self.badAccuracyModifier
            end
            
            return self.BaseClass.getMaxSpreadIncrease(self, maxSpreadMod)
        end
    end]]

    --// Shotguns //--

    if weapons.Get( "cw_m3super90" ) then
        local wep = weapons.GetStored( "cw_m3super90" )
        wep.Slot = 0
        wep.Damage = 9
        wep.FireDelay = 0.75
        wep.Recoil = 3
        wep.HipSpread = 0.04
        wep.AimSpread = 0.005
        wep.VelocitySensitivity = 1.1
        wep.MaxSpreadInc = 0.06
        wep.SpreadPerShot = 0.01
        wep.ClumpSpread = 0.0325
        wep.Shots = 16
        wep.Primary.ClipSize = 8
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.8
        wep.SpeedDec = 40
    end

    if weapons.Get( "cw_ber_spas12" ) then
        local wep = weapons.GetStored( "cw_ber_spas12" )
        wep.Slot = 0
        wep.Damage = 10
        wep.FireDelay = 0.85
        wep.Recoil = 3
        wep.HipSpread = 0.04
        wep.AimSpread = 0.005
        wep.VelocitySensitivity = 1.4
        wep.MaxSpreadInc = 0.06
        wep.SpreadPerShot = 0.01
        wep.ClumpSpread = 0.040
        wep.Shots = 16
        wep.Primary.ClipSize = 6
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.8
        wep.SpeedDec = 40
    end

    if weapons.Get( "cw_m1014" ) then
        local wep = weapons.GetStored( "cw_m1014" )
        wep.Slot = 0
        wep.Damage = 7
        wep.FireDelay = 0.22
        wep.Recoil = 4
        wep.HipSpread = 0.04
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.5
        wep.MaxSpreadInc = 0.06
        wep.SpreadPerShot = 0.01
        wep.ClumpSpread = 0.045
        wep.Shots = 16
        wep.Primary.ClipSize = 6
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.27
        wep.SpeedDec = 40

        wep.Chamberable = false
    end

    if weapons.Get( "cw_shorty" ) then
        local wep = weapons.GetStored( "cw_shorty" )
        wep.Slot = 1
        wep.Damage = 7
        wep.FireDelay = 0.8
        wep.Recoil = 2
        wep.HipSpread = 0.04
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.6
        wep.MaxSpreadInc = 0.02
        wep.SpreadPerShot = 0.007
        wep.ClumpSpread = 0.0325
        wep.Shots = 16
        wep.Primary.ClipSize = 2
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.85
        wep.SpeedDec = 20
    end

    if weapons.Get( "bo2r_870mcs" ) then
        local wep = weapons.GetStored( "bo2r_870mcs" )
        wep.Slot = 0
        wep.Damage = 9
        wep.FireDelay = 0.75
        wep.Recoil = 3
        wep.HipSpread = 0.04
        wep.AimSpread = 0.005
        wep.VelocitySensitivity = 1.1
        wep.MaxSpreadInc = 0.06
        wep.SpreadPerShot = 0.01
        wep.ClumpSpread = 0.0325
        wep.Shots = 16
        wep.Primary.ClipSize = 6
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.8
        wep.SpeedDec = 40
    end

    if weapons.Get( "cwc_icarus37" ) then
        local wep = weapons.GetStored( "cwc_icarus37" )
        wep.Slot = 0
        wep.Damage = 6
        wep.FireDelay = 0.65
        wep.Recoil = 2.5
        wep.HipSpread = 0.04
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.1
        wep.MaxSpreadInc = 0.06
        wep.SpreadPerShot = 0.01
        wep.ClumpSpread = 0.035
        wep.Shots = 16
        wep.Primary.ClipSize = 6
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.31
        wep.SpeedDec = 40
    end

    --// Pistols & Mini-SMGs //--

    if weapons.Get( "cw_p99" ) then
        local wep = weapons.GetStored( "cw_p99" )
        wep.Slot = 1
        wep.Damage = 23
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
        wep.Damage = 33
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
        wep.HipSpread = 0.12
        wep.AimSpread = 0.005
        wep.VelocitySensitivity = 1.35
        wep.MaxSpreadInc = 0.09
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
        wep.Damage = 22
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

    if weapons.Get( "cw_weapon_tec9" ) then
        local wep = weapons.GetStored( "cw_weapon_tec9" )
        wep.Slot = 1
        wep.Damage = 19
        wep.FireDelay = 0.07
        wep.Recoil = 0.72
        wep.HipSpread = 0.037
        wep.AimSpread = 0.015
        wep.VelocitySensitivity = 1.0
        wep.MaxSpreadInc = 0.06
        wep.SpreadPerShot = 0.012
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 32
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.09
        wep.SpeedDec = 20

        wep.ReloadTime = 3.6
        wep.ReloadTime_Empty = 3.6
        wep.ReloadHalt = 3.6
        wep.ReloadHalt_Empty = 3.6
        wep.SnapToIdlePostReload = false
        wep.Chamberable = false
    end

    if weapons.Get( "cw_deagle" ) then
        local wep = weapons.GetStored( "cw_deagle" )
        wep.Slot = 1
        wep.Damage = 56
        wep.FireDelay = 0.25
        wep.Recoil = 2.8
        wep.HipSpread = 0.13
        wep.AimSpread = 0.005
        wep.VelocitySensitivity = 1.35
        wep.MaxSpreadInc = 0.09
        wep.SpreadPerShot = 0.003
        wep.ClumpSpread = 0
        wep.Shots = 1
        wep.Primary.ClipSize = 8
        wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.32
        wep.SpeedDec = 25
    end

    if weapons.Get( "bo2r_b23r" ) then
        local wep = weapons.GetStored( "bo2r_b23r" )
        wep.Slot = 1
        wep.Damage = 22
        wep.FireDelay = 0.085
        wep.Recoil = 0.95
        wep.HipSpread = 0.03
        wep.AimSpread = 0.01
        wep.VelocitySensitivity = 1.0
        wep.MaxSpreadInc = 0.09
        wep.SpreadPerShot = 0.005
        wep.ClumpSpread = 0
        wep.Shots = 1
        --wep.Primary.ClipSize = 8
        --wep.Primary.DefaultClip	= wep.Primary.ClipSize
        wep.SpreadCooldown = 0.12
        wep.SpeedDec = 25
    end

    --//Tertiary Weapons
    if weapons.Get( "weapon_fists" ) then
        local wep = weapons.GetStored( "weapon_fists" )
        wep.Slot = 2
        wep.HitDistance = 48 + 15 --48 is the original distance
        --//Damage is calculated with RNG, will need to re-create the fists weapon and add damage modification
    end

    if weapons.Get( "cw_flash_grenade" ) then
        local wep = weapons.GetStored( "cw_flash_grenade" )
        wep.Slot = 2
    end

    if weapons.Get( "cw_smoke_grenade" ) then
        local wep = weapons.GetStored( "cw_smoke_grenade" )
        wep.Slot = 2
    end

    local medkits = { "weapon_medkit", "medkit_slow", "medkit_fast", "medkit_full" }
    for k, v in pairs( medkits ) do 
        if weapons.Get( v ) then
            local wep = weapons.GetStored( v )
            wep.Slot = 2
        end
    end

end

hook.Add( "InitPostEntity", "WeaponBaseFixes", function()
    RebalanceWeapons()

	local wepbase = weapons.GetStored( "cw_base" )
    function wepbase:unloadWeapon()
        return
    end

    --Fixes the error when spectating someone first-person and they open their attachments
    function CustomizableWeaponry:hasAttachment(ply, att, lookIn)
        if not self.useAttachmentPossessionSystem then
            return true
        end
        
        lookIn = lookIn or ply.CWAttachments
        
        local has = hook.Call("CW20HasAttachment", nil, ply, att, lookIn)
        
        if (lookIn and lookIn[att]) or has then
            return true
        end
        
        return false
    end
	
    --[[function CustomizableWeaponry:decodeAttachmentString(str)
        self.CWAttachments = self.CWAttachments or {}
        
        local result = string.Explode(" ", str)
        print("dicks - decodeAttachmentString", str)
        if self.CWAttachments and self.CWAttachments != nil then
            for k, v in pairs(result) do
                self.CWAttachments[v] = true
            end
        end
    end]]
end )

hook.Add( "OnEntityCreated", "BalanceTheM203", function( ent )
    if ent:GetClass() == "cw_40mm_explosive" then
        ent.BlastDamage = 80 --100 is the default value
        ent.BlastRadius = 384 --384 is the default value
    end
end )