GM.CannonDamageBoost = 0.15
GM.CannonDamageReduction = 0.10

function PlayerIsntMoving( ply )
    local vel = ply:GetVelocity()
    return math.abs(vel.x) < 50 and math.abs(vel.y) < 50 and math.abs(vel.z) < 50 --Velocity sensitivities
end

hook.Add( "EntityTakeDamage", "CannonOutgoing", function( vic, dmginfo )
    local attacker = dmginfo:GetAttacker()
    if attacker:IsPlayer() and vic:IsPlayer() and attacker:Team() != vic:Team() then
        if CheckPerk( attacker ) == "entrench" then
            dmginfo:SetDamage( dmginfo:GetDamage() * (1 + GAMEMODE.CannonDamageBoost) )
        end
    end
end )

hook.Add( "EntityTakeDamage", "CannonIncoming", function( vic, dmginfo )
    local attacker = dmginfo:GetAttacker()
    if vic:IsPlayer() and (attacker:IsPlayer() and attacker:Team() != vic:Team()) or !attacker:IsPlayer() then
        if CheckPerk( vic ) == "entrench" and PlayerIsntMoving(vic) then
            dmginfo:SetDamage( dmginfo:GetDamage() * (1 - GAMEMODE.CannonDamageReduction) )
            GAMEMODE:QueueIcon( att, "entrench" )
        end
    end
end )

--[[hook.Add( "Think", "VelocityChecking", function()
    for k, v in pairs( player.GetAll() ) do
        local vel = v:GetVelocity()
        if !PlayerIsntMoving(v) then
            print(v, vel)
        end
    end
end )]]

RegisterPerk( "Entrench", "entrench", 0, "Remaining still provides an outgoing 15% damage boost for, and an incoming 10% damage reduction buff against, all damage types." )