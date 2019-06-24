util.AddNetworkString( "RequestLockedWeapons" )
util.AddNetworkString( "RequestLockedWeaponsCallback" )

net.Receive( "RequestLockedWeapons", function( len, ply )
    local fil = util.JSONToTable( file.Read( "tdm/users/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) )
    local unlockedweps = fil[ 2 ]
    local throwaway, lockedweps = {}, {}

    for k, v in pairs( unlockedweps ) do
        throwaway[ v ] = true
    end

    for k, v in pairs( GAMEMODE.WeaponsList ) do
        if !throwaway[ v[ 2 ] ] then
            lockedweps[ #lockedweps + 1 ] = k
        end
    end

    net.Start( "RequestLockedWeaponsCallback" )
        net.WriteTable( lockedweps )
    net.Send( ply )
end )

--//Ripped from sv_money.lua
net.Receive( "BuyShit", function( len, ply )
	local wep = net.ReadString()
	local num = tonumber( net.ReadString() )
	num = -num
	AddMoney( ply, num )
	local fil = util.JSONToTable( file.Read( "tdm/users/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) )
	local ttab = fil[ 2 ]
	table.insert( ttab, wep )
	local new = util.TableToJSON( { fil[ 1 ], ttab } )
	file.Write( "tdm/users/" .. id( ply:SteamID() ) .. ".txt", new )
	timer.Simple( 0.1, function()
		local cur = GetMoney( ply )
		net.Start( "BuyShitCallback" )
			net.WriteString( tostring( cur ) )
		net.Send( ply )
	end )
end )