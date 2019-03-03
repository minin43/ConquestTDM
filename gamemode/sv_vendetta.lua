util.AddNetworkString( "UpdateVendetta" )

GM.VendettaList = { } --Listed as victims, then by attackers

function GM:UpdateVendetta( vic, att )
    local vicID = id( vic:SteamID() )
    local attID = id( att:SteamID() )
    if vicID == attID then return end --Shouldn't ever run into this, but JIC

    self.VendettaList[ vicID ] = self.VendettaList[ vicID ] or { }
    self.VendettaList[ vicID ][ attID ] = self.VendettaList[ vicID ][ attID ] or 0
    self.VendettaList[ vicID ][ attID ] = self.VendettaList[ vicID ][ attID ] + 1

    if self.VendettaList[ vicID ][ attID ] > 3 then
        net.Start( "UpdateVendetta" )
            net.WriteString( attID )
            net.WriteBool( true )
        net.Send( vic )
    end

    if self.VendettaList[ attID ][ vicID ] then
        if self.VendettaList[ attID ][ vicID ] > 2 then
            net.Start( "UpdateVendetta" )
                net.WriteString( vicID )
                net.WriteBool( false )
            net.Send( att )
        end
        self.VendettaList[ attID ][ vicID ] = 0
    end
end