util.AddNetworkString("DeadlyWeaponAttacker")
util.AddNetworkString("DeadlyWeaponVictim")

GM.WeaponCounter = {}

hook.Add("PlayerDeath", "DeadlyWeapon", function(vic, inf, att)
	if !GetGlobalBool( "RoundFinished" ) and CheckPerk(att) == "deadlyweapon" then
        if att:Alive() and att != vic then
            GAMEMODE.WeaponCounter[att] = GAMEMODE.WeaponCounter[att] + 1

            if GAMEMODE.WeaponCounter[att] == 4 then
                --Give weapon
                att:Give("cw_l115")
                att:SelectWeapon("cw_l115")
                --att:GetWeapon("cw_l115"):SendWeaponAnim(ACT_VM_DRAW)

                net.Start("DeadlyWeaponAttacker")
                    net.WriteInt(GAMEMODE.WeaponCounter[att], 8)
                net.Send(att)

                for k, v in pairs(team.GetPlayers(att:Team() % 2 + 1)) do
                    net.Start("DeadlyWeaponVictim")
                    if att:GetAimVector():Dot( ( v:GetPos() - att:EyePos() ):GetNormalized() ) > 0 and att:Visible( v ) then
                        net.WriteInt(2, 4)
                    else
                        net.WriteInt(1, 4)
                    end
                    net.Send(v)
                end
            elseif GAMEMODE.WeaponCounter[att] == 5 then
                if inf:GetActiveWeapon():GetClass() == "cw_l115" then
                    --Reset health & ammo
                    --att:RemoveAllAmmo()
                    --[[for k, v in pairs(att:GetWeapons()) do
                        if v:GetClass() == "cw_l115" then
                            v:Remove()
                        end
                    end]]
                    local dontgive = {"fas2_ammobox", "fast2_ifak", "fas2_m67", "seal6-claymore"}
                    timer.Simple( 1, function()
                        for k, v in pairs( att:GetWeapons() ) do
                            local x = v:GetPrimaryAmmoType()
                            local y = v:GetMaxClip1()
                            local give = true
                            
                            for k2, v2 in next, dontgive do
                                if v2 == v then
                                    give = false
                                    break
                                end
                            end
                            if give == true then
                                att:GiveAmmo( ( y * 4 ), x, true )
                            end
                        end
                        att:GiveAmmo( 2, "40MM", true )
                    end )
                    att:SetHealth(att:GetMaxHealth())

                    net.Start("DeadlyWeaponAttacker")
                        net.WriteInt(GAMEMODE.WeaponCounter[att], 8)
                    net.Send(att)

                    GAMEMODE.WeaponCounter[att] = 0
                else
                    GAMEMODE.WeaponCounter[att] = GAMEMODE.WeaponCounter[att] - 1
                end
            else
                net.Start("DeadlyWeaponAttacker")
                    net.WriteInt(GAMEMODE.WeaponCounter[att], 8)
                net.Send(att)
            end
		end
	end
end )

hook.Add("PlayerSpawn", "DeadlyWeaponSetup", function(ply)
    GAMEMODE.WeaponCounter[ply] = 0
end)

hook.Add("EntityFireBullets", "FiredL115", function(ply, bulletdata)
    if ply:GetActiveWeapon():GetClass() == "cw_l115" then
        timer.Simple(0.4, function()
            for k, v in pairs(ply:GetWeapons()) do
                if v:GetClass() == "cw_l115" then
                    v:Remove()
                end
            end
            GAMEMODE.WeaponCounter[ply] = 0
            timer.Simple(0.1, function()
                ply:SelectWeapon(ply:GetWeapons()[1]:GetClass())
            end)
        end)
    end
end)

hook.Add( "PlayerButtonDown", "PreventL115Drop", function( ply, bind )
    if bind == KEY_Q and IsValid( ply ) and ply:Team() != 0 and !ply.spawning then
        local wep = ply:GetActiveWeapon()
        if wep and wep:IsValid() and wep:GetClass() == "cw_l115" then
            ply:StripWeapon( wep )
            GAMEMODE.WeaponCounter[ply] = 0
        end
    end
end )

RegisterPerk("Deadly Weapon", "deadlyweapon", 80, "After reaching 4 kills in one life, equip a 1-shot-kill sniper with 1 bullet loaded. Earning a kill with it refreshes all weapon ammo and player heatlh.")

--[[Issues to consider now
    - Dropping the gun on death]]