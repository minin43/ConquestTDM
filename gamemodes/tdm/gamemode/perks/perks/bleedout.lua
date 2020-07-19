util.AddNetworkString( "BleedOverlay" )
util.AddNetworkString( "EndBleedOverlay" )

GM.BleedoutTable = {}
GM.BleedoutDuration = 3 --//In seconds
GM.BleedoutTicksPerSecond = 4 --//How many damage "hits" or "ticks" we want the player to take per second the bleedout is occuring
GM.BleedoutBulletDamageReduction = 0.05 --//How much bullet damage is entirely nullified
GM.BleedoutBleedDamagePercent = 0.25 --//How much damage, post-nullification, is applied as a DoT

hook.Add( "EntityTakeDamage", "BleedoutShit", function( ply, dmginfo )
    local att = dmginfo:GetAttacker()
    
    if not IsValid( ply ) or not IsValid( att ) then return end

    if CheckPerk( ply ) == "bleedout" then
        if att:IsPlayer() and dmginfo:IsBulletDamage() and att:Team() != ply:Team() then
            local bleedDamage = dmginfo:GetDamage() * GAMEMODE.BleedoutBleedDamagePercent
            
            if GAMEMODE.BleedoutTable[ ply ] then
                GAMEMODE.BleedoutTable[ ply ].lastattacker = att
                GAMEMODE.BleedoutTable[ ply ].damagetodo = ( GAMEMODE.BleedoutTable[ ply ].damagetodo - GAMEMODE.BleedoutTable[ ply ].damagedone ) + bleedDamage
                GAMEMODE.BleedoutTable[ ply ].damagedone = 0
                GAMEMODE.BleedoutTable[ ply ].wep = dmginfo:GetInflictor()
            else
                GAMEMODE.BleedoutTable[ ply ] = { lastattacker = att, damagetodo = bleedDamage, damagedone = 0, wep = dmginfo:GetInflictor() }
            end
            
            dmginfo:SetDamage( dmginfo:GetDamage() * (1 - GAMEMODE.BleedoutBleedDamagePercent - GAMEMODE.BleedoutBleedDamagePercent) )
            
            timer.Create( "BleedingOn" .. id( ply:SteamID() ), 1 / GAMEMODE.BleedoutTicksPerSecond, GAMEMODE.BleedoutDuration * GAMEMODE.BleedoutTicksPerSecond, function()
                if GAMEMODE.BleedoutTable[ ply ] and ply:Alive() then
                    local tab = GAMEMODE.BleedoutTable[ ply ]
                    local bleeddamage = tab.damagetodo / ( GAMEMODE.BleedoutDuration * GAMEMODE.BleedoutTicksPerSecond )
                    
                    local damageToDo = DamageInfo()
                    damageToDo:SetDamage( bleeddamage )
                    damageToDo:SetDamageType( DMG_DIRECT )
                    damageToDo:SetAttacker( tab.lastattacker )
                    damageToDo:SetInflictor( tab.wep )

                    ply:TakeDamageInfo( damageToDo )
                    tab.damagedone = tab.damagedone + bleeddamage

                    net.Start( "BleedOverlay" )
                    net.Send( ply )

                    timer.Simple( 0.1, function()
                        net.Start( "EndBleedOverlay" )
                        net.Send( ply )
                    end )

                    if tab.damagedone >= tab.damagetodo then
                        timer.Remove( "BleedingOn" .. id( ply:SteamID() ) )
                        tab.damagetodo = 0
                    end
                end
            end )
        end
    end
end )

hook.Add("DoPlayerDeath", "DisplayBleedoutIconOnDeath", function( ply, att, dmginfo )
    if CheckPerk( att ) == "bleedout" and dmginfo:GetDamageType() == DMG_DIRECT then
        GAMEMODE:QueueIcon( att, "bleedout" )
    end
end)

RegisterPerk( "Bleedout", "bleedout", 0, "Provides 5% damage reduction against bullets, with an extra 25% reduction applied as a 3 second long, damage-over-time bleeding effect." )