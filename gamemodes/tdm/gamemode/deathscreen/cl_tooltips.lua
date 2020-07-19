Tooltips = {}
GM.Tooltips = Tooltips

Tooltips.TipCounting = {}
Tooltips.TipQueue = {}
Tooltips.MasterTable = {
    movement = { tip = "Enemies moving too quickly, jump-strafing, or bunny-hopping? Try out the Frostbite perk to slow their movement down." },
    sniper = { tip = "Dying frequently to sniper rifles? Try damage-reducing perks, such as rebound or thornmail, or damage-reducing equipment like the Hyperweave vest." },
    explosive = { tip = "Dying to explosives too often? Try explosive-damage-reducing equipment, or the perk martyrdom." },
    health = { tip = "You spend a lot of time low on health, consider trying a life-giving perk such as regeneration or leech, or bring a medkit.", amount = 1 },
    damage = { tip = "Enemies barely scraping by with life after you shoot them? Try a damage-amplifying perk such as crescendo or vulture." },
    ammo = { tip = "Running out of ammo? Pick up enemy weapons with 'e' after dropping yours with 'q', or use packrat.", amount = 60 }
}

Tooltips.MovementPerks = {
    double_jump = true,
    excited = true,
    hunter = true,
    lifeline = true
}

function GM:TipDebug( tip )
    table.insert( Tooltips.TipQueue, 1, Tooltips.MasterTable[ tip ].tip )
end

function Tooltips.IncrementTip( tip )
    local tab = Tooltips.MasterTable[tip]

    if tab then
        Tooltips.TipCounting[tip] = (Tooltips.TipCounting[tip] or 0) + 1

        if Tooltips.TipCounting[tip] >= (tab.amount or 6) then
            table.insert( Tooltips.TipQueue, 1, tab.tip )
            Tooltips.TipCounting[tip] = 0
        end
    end
end

GM.SecondsLowHP = 0
timer.Create( "TipCounting", 1, 0, function()
    local ply = LocalPlayer()
    if ply and ply:IsValid() and ply:Alive() then
        if ply:Health() < 31 then
            GAMEMODE.SecondsLowHP = GAMEMODE.SecondsLowHP + 1

            if GAMEMODE.SecondsLowHP > 80 then
                Tooltips.IncrementTip( "health" )
                GAMEMODE.SecondsLowHP = 0
            end
        end

        local heldwep = ply:GetActiveWeapon()
        if heldwep and heldwep:IsValid() then
            if GAMEMODE.AmmoTipWeapon and GAMEMODE.AmmoTipWeapon == heldwep:GetClass() then
                if ply:GetAmmoCount( heldwep:GetPrimaryAmmoType() ) < 10 then
                    Tooltips.IncrementTip( "ammo" )
                end
            elseif !GAMEMODE.AmmoTipBlacklist or GAMEMODE.AmmoTipBlacklist != heldwep:GetClass() then
                local tab = RetrieveWeaponTable( heldwep:GetClass() )
                if tab and (tab.slot == 0 or tab.slot == 1) then
                    if ply:GetAmmoCount( heldwep:GetPrimaryAmmoType() ) < 10 then
                        Tooltips.IncrementTip( "ammo" )
                    end
                    GAMEMODE.AmmoTipWeapon = heldwep:GetClass()
                    GAMEMODE.AmmoTipBlacklist = nil
                else
                    GAMEMODE.AmmoTipBlacklist = heldwep:GetClass()
                end
            end
        end
    end
end )