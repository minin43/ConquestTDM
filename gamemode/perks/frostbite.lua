util.AddNetworkString( "IceScreen" )
util.AddNetworkString( "EndIceScreen" )
GM.SlawBackups = GM.SlawBackups or {}

function SlowDown( ply, damage )
    if not timer.Exists( "frostbite_" .. ply:SteamID() ) then

        damage = math.Clamp( damage, 0, 100 )
        local scale = damage / 100

        local MovementSlow = math.Clamp( 20 + ( scale * 20 ), 20, 40 )
        local JumpSlow = math.Clamp( 40 + ( scale * 20 ), 40, 60 )
        local Timer = math.Clamp( 1 + scale, 1, 2 )

        GAMEMODE.SlawBackups[ id( ply:SteamID() ) ] = {}
        GAMEMODE.SlawBackups[ id( ply:SteamID() ) ].walk = ply:GetWalkSpeed()
        GAMEMODE.SlawBackups[ id( ply:SteamID() ) ].run = ply:GetRunSpeed()
        GAMEMODE.SlawBackups[ id( ply:SteamID() ) ].jump = ply:GetJumpPower()

        ply:SetWalkSpeed( ply:GetWalkSpeed() * ( 1 - MovementSlow ) )
        ply:SetRunSpeed( ply:GetRunSpeed() * ( 1 - MovementSlow ) )
        ply:SetJumpPower( ply:GetJumpPower() * ( 1 - JumpSlow ) )

        net.Start( "IceScreen" )
        net.Send( ply )

        timer.Create( "frostbite_" .. ply:SteamID(), Timer, 1, function()
            if !ply:Alive() then return end
            ply:SetWalkSpeed( GAMEMODE.SlawBackups[ id( ply:SteamID() ) ].walk )
            ply:SetRunSpeed( GAMEMODE.SlawBackups[ id( ply:SteamID() ) ].run )
            ply:SetJumpPower( GAMEMODE.SlawBackups[ id( ply:SteamID() ) ].jump )

            net.Start( "EndIceScreen" )
            net.Send( ply )
        end )
    else
        timer.Adjust( "frostbite_" .. ply:SteamID(), Timer, 1, function()
            if !ply:Alive() then return end
            ply:SetWalkSpeed( GAMEMODE.SlawBackups[ id( ply:SteamID() ) ].walk )
            ply:SetRunSpeed( GAMEMODE.SlawBackups[ id( ply:SteamID() ) ].run )
            ply:SetJumpPower( GAMEMODE.SlawBackups[ id( ply:SteamID() ) ].jump )

            net.Start( "EndIceScreen" )
            net.Send( ply )
        end )
    end
end

hook.Add( "EntityTakeDamage", "SlawChecks", function( ply, dmginfo )
    local att = dmginfo:GetAttacker()

    if att:IsPlayer() and ply:IsPlayer() and att:Team() != ply:Team() then
        if CheckPerk( att ) == "frostbite" then
            SlowDown( ply, dmginfo:GetDamage() )
        end
    end
end )

hook.Add( "DoPlayerDeath", "TurnOffIceOverlay", function( ply, att, dmginfo )
    net.Start( "EndIceScreen" )
    net.Send( ply )
end )

RegisterPerk( "Frostbite", "frostbite", 20, "Enemies you shoot are chilled, slowing down movement 20-40% and jump power 40-60% for 1-2 seconds, scaling with damage done." )