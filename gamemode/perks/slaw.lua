util.AddNetworkString( "IceScreen" )
util.AddNetworkString( "EndIceScreen" )
GM.SlawBackups = GM.SlawBackups or {}

function SlowDown( ply, percent )
    if not timer.Exists( "slaw_" .. ply:SteamID() ) then
        print("SlawDEBUG - SlowDownCalled", ply, percent )
        GAMEMODE.SlawBackups[ id( ply:SteamID() ) ] = {}
        GAMEMODE.SlawBackups[ id( ply:SteamID() ) ].walk = ply:GetWalkSpeed()
        GAMEMODE.SlawBackups[ id( ply:SteamID() ) ].run = ply:GetRunSpeed()
        GAMEMODE.SlawBackups[ id( ply:SteamID() ) ].jump = ply:GetJumpPower()

        ply:SetWalkSpeed( ply:GetWalkSpeed() * ( 1 - percent ) )
        ply:SetRunSpeed( ply:GetRunSpeed() * ( 1 - percent ) )
        ply:SetJumpPower( ply:GetJumpPower() * ( 1 - percent ) )

        net.Start( "IceScreen" )
        net.Send( ply )

        timer.Create( "slaw_" .. ply:SteamID(), 1, 1, function()
            if !ply:Alive() then return end
            ply:SetWalkSpeed( GAMEMODE.SlawBackups[ id( ply:SteamID() ) ].walk )
            ply:SetRunSpeed( GAMEMODE.SlawBackups[ id( ply:SteamID() ) ].run )
            ply:SetJumpPower( GAMEMODE.SlawBackups[ id( ply:SteamID() ) ].jump )

            net.Start( "EndIceScreen" )
            net.Send( ply )
        end )
    else
        timer.Adjust( "slaw_" .. ply:SteamID(), 1, 1, function()
            if !ply:Alive() then return end
            ply:SetWalkSpeed( GAMEMODE.SlawBackups[ id( ply:SteamID() ) ].walk )
            ply:SetRunSpeed( GAMEMODE.SlawBackups[ id( ply:SteamID() ) ].run )
            ply:SetJumpPower( GAMEMODE.SlawBackups[ id( ply:SteamID() ) ].jump )

            net.Start( "EndIceScreen" )
            net.Send( ply )
        end )
    end
end

hook.Add( "EntityTakeDamage", "SlawChecks", function( ent, dmginfo )
    local att = dmginfo:GetAttacker()
    local ply = ent
    local dmg = dmginfo:GetDamage()

    if att:IsPlayer() and ply:IsPlayer() and att:Team() != ply:Team() then
        if CheckPerk( att ) == "slaw" then
            SlowDown( ply, math.Clamp( math.Clamp( dmg, 0, 100 ) / 333, 0.1, 0.3 ) )
        end
    end
end )

hook.Add( "DoPlayerDeath", "TurnOffIceOverlay", function( ply, att, dmginfo )
    net.Start( "EndIceScreen" )
    net.Send( ply )
end )

RegisterPerk( "Slaw", "slaw", 19, "Enemies you shoot are slowed down 10-30% for 1 second, depending on damage done" )