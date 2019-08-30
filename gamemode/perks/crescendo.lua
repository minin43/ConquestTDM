GM.CrescendoTable = {}

hook.Add( "EntityTakeDamage", "CrescendoBuildup", function( ply, dmginfo )
    local att = dmginfo:GetAttacker()
    if not IsValid( ply ) or not IsValid( att ) then return end

    if CheckPerk( att ) == "crescendo" then
        if att:IsPlayer() and ply:IsPlayer() and dmginfo:IsBulletDamage() and att:Team() != ply:Team() and not ply.SpawnProtected and not timer.Exists( id( att:SteamID() ) .. "CrescendoShotgunFix" ) then
            GAMEMODE.CrescendoTable[ att ] = GAMEMODE.CrescendoTable[ att ] or {}
            GAMEMODE.CrescendoTable[ att ][ ply ] = ( GAMEMODE.CrescendoTable[ att ][ ply ] or 0 ) + 1
            
            dmginfo:AddDamage( GAMEMODE.CrescendoTable[ att ][ ply ] )
            --//If the timer already exists, it deletes the old one and recreates it with the new args
            timer.Create( id( att:SteamID() ) .. "CrescendoOn" .. id( ply:SteamID() ), 3, 1, function() GAMEMODE.CrescendoTable[ att ][ ply ] = 0 end )
            timer.Create( id( att:SteamID() ) .. "CrescendoShotgunFix", 0.1, 1, function() timer.Remove( id( att:SteamID() ) .. "CrescendoShotgunFix" ) end )
        end
    end
end)

RegisterPerk( "Crescendo", "crescendo", 5, "Consecutive shots against an enemy slowly builds up additional damage per shot, lost after leaving combat." )