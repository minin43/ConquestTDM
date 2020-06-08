--//TO NOTE: THE SETSUBMATERIALS TABLE STARTS AT KEY 0, THE VALUES RETRIEVED IN THIS FILE STARTED AT KEY 1
--//Additionally, it looks like some submaterials are retuning as errors, such as in the mp5 - check for validity
GM.WeaponSubmaterialExclusions = {
    [ "cw_ar15" ] = { 2 },
    [ "cw_ak74" ] = { 1, 2 },
    [ "cw_g3a3" ] = { 3, 4 },
    [ "cw_scarh" ] = { 3 },
    [ "cw_g36c" ] = { 1 },
    [ "cw_mp5" ] = { 2 },
    [ "cw_ump45" ] = { 2 },
    [ "cw_deagle" ] = { 2 },
    [ "cw_l85a2" ] = { 5 },
    [ "cw_m14" ] = { 5 },
    [ "cw_m1911" ] = { 1 },
    [ "cw_m249_official" ] = { 2 },
    [ "cw_m3super90" ] = { 2, 3, 4, 5, 6 },
    [ "cw_mac11" ] = { 4 },
    [ "cw_mr96" ] = { 3 },
    [ "cw_p99" ] = { 1 },
    [ "cw_makarov" ] = { 1 },
    [ "cw_shorty" ] = { 3 },
    [ "cw_vss" ] = { 2 },
    [ "cw_b196" ] = {  },
    [ "cw_scorpin_evo3" ] = {  },
    [ "cw_tac338" ] = {  },
    [ "cw_ber_p90" ] = {  },
    [ "cw_ber_famas_felin" ] = {  },
    [ "cw_ber_spas12" ] = {  },
    [ "cw_amr2_rpk74" ] = {  },
    [ "cw_wf_m200" ] = {  },
    [ "cw_ber_hkmp7" ] = {  },
    [ "cw_amr2_mk46" ] = {  },
    [ "cw_fiveseven" ] = { 1, 2 },
    [ "cw_m1014" ] = { 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 }
    --[ "cw_" ] = {  },
}

net.Receive( "ApplyWeaponSkin", function()
    local wepclass = net.ReadString()
    local skindir = net.ReadString()
    GAMEMODE.WeaponSubmaterialExclusions[wepclass] = GAMEMODE.WeaponSubmaterialExclusions[wepclass] or {}

    if LocalPlayer():GetWeapon( wepclass ) then
        local model = LocalPlayer():GetWeapon( wepclass ).CW_VM
        if !model then return end
        
        local exclusiontable = {}
        for k, v in pairs( GAMEMODE.WeaponSubmaterialExclusions[wepclass] ) do
            exclusiontable[ v ] = true
        end

        for k, v in pairs( model:GetMaterials() ) do
            if !exclusiontable[k] and v != "models/weapons/v_models/hands/v_hands" then
                model:SetSubMaterial( k - 1, skindir )
            end
        end
    end
end )