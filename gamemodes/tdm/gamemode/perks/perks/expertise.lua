GM.ExpertiseReloadBuff = 0.40 --As a percent
GM.ExpertiseHandlingBuff = 0.20 --As a percent
GM.ExpertiseRecoilBuff = 0.15 --As a percent

util.AddNetworkString( "ExpertiseStats" )

hook.Add( "WeaponEquip", "ExpertiseSettingPickup", function( wep, ply )
    if CheckPerk( ply ) == "expertise" then
        if wep and wep:IsValid() and wep.Base == "cw_base" then
            wep.ReloadSpeed = wep.ReloadSpeed * (1 + GAMEMODE.ExpertiseReloadBuff)
            wep.ReloadSpeed_Orig = wep.ReloadSpeed_Orig * (1 + GAMEMODE.ExpertiseReloadBuff)
            --wep.SpeedDec = wep.SpeedDec * (1 - GAMEMODE.ExpertiseHandlingBuff)
            wep.Recoil = wep.Recoil * (1 - GAMEMODE.ExpertiseRecoilBuff)
            wep.Recoil_Orig = wep.Recoil_Orig * (1 - GAMEMODE.ExpertiseRecoilBuff)

            timer.Simple( 0, function()
                net.Start( "ExpertiseStats" )
                    net.WriteString( wep:GetClass() )
                    net.WriteFloat( GAMEMODE.ExpertiseReloadBuff )
                    net.WriteFloat( GAMEMODE.ExpertiseHandlingBuff )
                    net.WriteFloat( GAMEMODE.ExpertiseRecoilBuff )
                net.Send( ply )
            end )
        end
    end
end )

--With the current iteration of weapon dropping, this is unecessary
--[[hook.Add( "PlayerDroppedWeapon", "ExpertiseSettingDrop", function( ply, wep )
    if CheckPerk( ply ) == "expertise" then
end )]]

RegisterPerk( "Expertise", "expertise", 0, "Your proficiency with weapons enables you to perform certain actions, such as reloading, better than normal." )