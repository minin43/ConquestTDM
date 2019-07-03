util.AddNetworkString( "RequestLockedWeapons" )
util.AddNetworkString( "RequestLockedWeaponsCallback" )
util.AddNetworkString( "RequestLockedSkins" )
util.AddNetworkString( "RequestLockedSkinsCallback" )
util.AddNetworkString( "RequestLockedModels" )
util.AddNetworkString( "RequestLockedModelsCallback" )

util.AddNetworkString( "BuyWeapon" )
util.AddNetworkString( "BuyWeaponCallback" )
util.AddNetworkString( "BuySkin" )
util.AddNetworkString( "BuySkinCallback")
util.AddNetworkString( "BuyModel" )
util.AddNetworkString( "BuyModelCallback" )

--[[GM.WeaponSkins = {
	{ name = "", texture = Material( "" ), price = 1 },
}

GM.PlayerModels = {
	{ name = "", model = "", price = 1, voiceovers = false },
}]]

--//Request locked crap
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
net.Receive( "RequestLockedSkins", function( len, ply )
	local fil = util.JSONToTable( file.Read( "tdm/users/skins/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) )
	local unlockedskins = fil[ 2 ]
	local throwaway, lockedskins = {}, {}

    for k, v in pairs( unlockedskins ) do
        throwaway[ v ] = true
    end

    for k, v in pairs( GAMEMODE.WeaponSkins ) do
        if !throwaway[ v.name ] then
            lockedskins[ #lockedskins + 1 ] = k
        end
    end

    net.Start( "RequestLockedSkinsCallback" )
        net.WriteTable( lockedskins )
    net.Send( ply )
end )
net.Receive( "RequestLockedModels", function( len, ply )
	local fil = util.JSONToTable( file.Read( "tdm/users/models/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) )
	local unlockedmodels = fil[ 2 ]
	local throwaway, lockedmodels = {}, {}

    for k, v in pairs( unlockedmodels ) do
        throwaway[ v ] = true
    end

    for k, v in pairs( GAMEMODE.PlayerModels ) do
        if !throwaway[ v.name ] then
            lockedmodels[ #lockedmodels + 1 ] = k
        end
    end

    net.Start( "RequestLockedSkinsCallback" )
        net.WriteTable( lockedmodels )
    net.Send( ply )
end )

--//Legacy code ripped from sv_money.lua, written exploitably. SHAME, WHUPPO. SHAME.
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

--//Buy locked crap
net.Receive( "BuyWeapon", function( len, ply )
	local num = net.ReadInt( 16 )
	local wep = GAMEMODE.WeaponsList[ num ]
	--//If we're being gamed and the player is trying to buy something he shouldn't, either because low $ or low level, don't let it go through
	--//The button that sends this message doesn't work on the client if they're too low level or don't have the $, so any that come in will be
	--//from a source trying to cheat.
	local price = wep[ 5 ]
	if price > GetMoney( ply ) then CaughtCheater( ply, "Sent net message BuyWeapon for a weapon they don't have the money for" ) return end
	local levelunlock = wep[ 3 ]
	if levelunlock > lvl.GetLevel( ply ) then CaughtCheater( ply, "Sent net message BuyWeapon for a weapon that unlocks at a higher level" ) return end

	SubtractMoney( ply, price )

	local fil = util.JSONToTable( file.Read( "tdm/users/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) )
	local ttab = fil[ 2 ]
	table.insert( ttab, wep )
	local new = util.TableToJSON( { fil[ 1 ], ttab } )
	file.Write( "tdm/users/" .. id( ply:SteamID() ) .. ".txt", new )

	net.Start( "BuyWeaponCallback" )
	net.Send( ply )
end )

net.Receive( "BuySkin", function( len, ply )

	net.Start( "BuySkinCallback" )
		net.Write
	net.Send( ply )
end )


net.Receive( "BuyModel", function( len, ply )

	net.Start( "BuyModelCallback" )
		net.Write
	net.Send( ply )
end )