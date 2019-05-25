util.AddNetworkString( "UpdateVendetta" )

GM.VendettaList = { } --Listed as victims, then by attackers

function GM:GetVendettaRequirement( ply )
    local otherTeam
    if ply:Team() == 1 then
        otherTeam = 2
    else
        otherTeam = 1
    end

    if #team.GetPlayers( otherTeam ) < 4 then
        return 4
    elseif #team.GetPlayers( otherTeam ) < 6 then
        return 3
    else
        return 2
    end
end

function GM:UpdateVendetta( vic, att )
    if !att:IsPlayer() or !vic:IsPlayer() or att:IsWorld() then return end
    local vicID = id( vic:SteamID() )
    local attID = id( att:SteamID() )
    if vicID == attID then return end --Shouldn't ever run into this, but JIC

    self.VendettaList[ vicID ][ attID ] = ( self.VendettaList[ vicID ][ attID ] or 0 ) + 1

    self.VendettaList[ vicID ].ActiveSaves = self.VendettaList[ vicID ].ActiveSaves or { }
    self.VendettaList[ attID ].ActiveSaves = self.VendettaList[ attID ].ActiveSaves or { }

    if self.VendettaList[ vicID ][ attID ] >= self:GetVendettaRequirement( vic ) --[[and !self.VendettaList[ vicID ].ActiveSaves[ attID ]] then
        self.VendettaList[ vicID ].ActiveSaves[ attID ] = true
        net.Start( "UpdateVendetta" )
            net.WriteString( attID )
            net.WriteBool( true )
        net.Send( vic )
    end
    
    if self.VendettaList[ attID ][ vicID ] then
        if self.VendettaList[ attID ].ActiveSaves[ vicID ] then
            net.Start( "UpdateVendetta" )
                net.WriteString( vicID )
                net.WriteBool( false )
            net.Send( att )
        end
        self.VendettaList[ attID ].ActiveSaves[ vicID ] = false
        self.VendettaList[ attID ][ vicID ] = 0
    end
end

hook.Add( "PlayerSwitchedTeams", "RemoveVendetta", function( ply, oldTeamNum, newTeamNum )
    GAMEMODE.VendettaList[ id( ply:SteamID() ) ] = { }
end )

hook.Add( "PlayerInitialSpawn", "VendettaSetup", function( ply )
    local plyID = id( ply:SteamID() )
    GAMEMODE.VendettaList[ plyID ] = { }
    GAMEMODE.VendettaList[ plyID ].ActiveSaves = { }

    for k, v in pairs( player.GetAll() ) do --this doesn't check v != ply, but that's okay, saves on performance
        GAMEMODE.VendettaList[ plyID ][ id( v:SteamID() ) ] = 0
        GAMEMODE.VendettaList[ id( v:SteamID() ) ][ plyID ] = 0
    end
end )