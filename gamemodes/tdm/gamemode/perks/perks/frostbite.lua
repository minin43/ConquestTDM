util.AddNetworkString( "IceScreen" )
util.AddNetworkString( "EndIceScreen" )
GM.MovementBackups = GM.MovementBackups or {} --Some dependencies exist for this in sh_weaponbalancing
GM.ChilledPlayers = {}

function SlowDown( ply, damage )

    damage = math.Clamp( damage, 0, 100 )
    local scale = damage / 100

    local MovementSlow = math.Round( math.Clamp( 20 + ( scale * 20 ), 20, 40 ) )
    local JumpSlow = MovementSlow--math.Round( math.Clamp( 40 + ( scale * 20 ), 40, 60 ) )
    local Timer = math.Round( math.Clamp( 1 + scale, 1, 2 ), 1 )

    GAMEMODE.ChilledPlayers[ ply ] = true

    if not timer.Exists( "frostbite_" .. ply:SteamID() ) then

        GAMEMODE.MovementBackups[ id( ply:SteamID() ) ] = {}
        GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].walk = ply:GetWalkSpeed()
        GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].run = ply:GetRunSpeed()
        GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].jump = ply:GetJumpPower()

        ply:SetWalkSpeed( ply:GetWalkSpeed() * ( 1 - MovementSlow / 100 ) )
        ply:SetRunSpeed( ply:GetRunSpeed() * ( 1 - MovementSlow / 100 ) )
        ply:SetJumpPower( ply:GetJumpPower() * ( 1 - JumpSlow / 100 ) )

        net.Start( "IceScreen" )
        net.Send( ply )

        timer.Create( "frostbite_" .. ply:SteamID(), Timer, 1, function()
            if !ply:Alive() then return end
            ply:SetWalkSpeed( GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].walk )
            ply:SetRunSpeed( GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].run )
            ply:SetJumpPower( GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].jump )

            GAMEMODE.ChilledPlayers[ ply ] = false

            net.Start( "EndIceScreen" )
            net.Send( ply )
        end )
    else
        timer.Adjust( "frostbite_" .. ply:SteamID(), Timer, 1, function()
            if !ply:Alive() then return end
            ply:SetWalkSpeed( GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].walk )
            ply:SetRunSpeed( GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].run )
            ply:SetJumpPower( GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].jump )

            GAMEMODE.ChilledPlayers[ ply ] = false

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

RegisterPerk( "Frostbite", "frostbite", 0, "Enemies you shoot are chilled, slowing down movement & jump power 20-40% for 1-2 seconds, scaling with damage done." )