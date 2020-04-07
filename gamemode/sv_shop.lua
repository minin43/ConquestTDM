util.AddNetworkString( "RequestLockedWeapons" )
util.AddNetworkString( "RequestLockedWeaponsCallback" )
util.AddNetworkString( "RequestLockedSkins" )
util.AddNetworkString( "RequestLockedSkinsCallback" )
util.AddNetworkString( "RequestLockedModels" )
util.AddNetworkString( "RequestLockedModelsCallback" )

util.AddNetworkString( "BuyWeapon" )
util.AddNetworkString( "BuyWeaponCallback" )
util.AddNetworkString( "BuySkin" )
util.AddNetworkString( "BuySkinCallback" )
util.AddNetworkString( "BuyModel" )
util.AddNetworkString( "BuyModelCallback" )

util.AddNetworkString( "StartPMPrecache" )

--[[ Found in sh_shop, this is just how the tables are structured - WeaponsList found in sh_loadout
GM.WeaponSkins = {
	{ name = "", directory = "", texture = Material( "" ), tokens = 1, cash = 0, credits = 0 },
}

GM.PlayerModels = {
	{ name = "", model = "", price = 1, cash = 0, credits = 0, voiceovers = false },
}]]

hook.Add( "PlayerLoadedIn", "PlayerPrecachePMs", function( ply )
    net.Start( "StartPMPrecache" )
    net.Send( ply )
end )

function GM:RefreshCurrencies( ply )
    SendUpdate( ply ) --Cash
    prestige.UpdateTokens( ply ) --Prestige Tokens
    donations.UpdateCredits( ply ) --Donator Credits
end

--//Request locked crap
net.Receive( "RequestLockedWeapons", function( len, ply )
    local fil = util.JSONToTable( file.Read( "tdm/users/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) )
    local unlockedweps = fil[ 2 ]
    local throwaway, lockedweps = {}, {}

    for k, v in pairs( unlockedweps ) do
        throwaway[ v ] = true
    end

    for k, v in pairs( GAMEMODE.WeaponsList ) do
        if !throwaway[ v[ 2 ] ] and v[ 5 ] != 0 then
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
        if !throwaway[ v.directory ] then --//Have to save by texture, since name can be changed
            lockedskins[ #lockedskins + 1 ] = k --//Instead of sending a table of strings, send an int corresponding to the subtable in GAMEMODE.WeaponSkins to save space
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
        if !throwaway[ v.model ] then --//Have to save by model, since naming can be changed
            lockedmodels[ #lockedmodels + 1 ] = k
        end
    end

    net.Start( "RequestLockedModelsCallback" )
        net.WriteTable( lockedmodels )
    net.Send( ply )
end )

--//Legacy code ripped from sv_money.lua, written exploitably. SHAME, WHUPPO. SHAME.    -    To be removed later
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
	table.insert( ttab, wep[ 2 ] )
	local new = util.TableToJSON( { fil[ 1 ], ttab } )
	file.Write( "tdm/users/" .. id( ply:SteamID() ) .. ".txt", new )

	net.Start( "BuyWeaponCallback" )
	net.Send( ply )
end )

net.Receive( "BuySkin", function( len, ply )
	local num = net.ReadInt( 8 )
	local currency = net.ReadString()
	local skin = GAMEMODE.WeaponSkins[ num ]
	
	local price = skin[ currency ]
	if currency == "tokens" then --Prestige Tokens
		if price > prestige.GetTokens( ply ) then CaughtCheater( ply, "Sent net message BuySkin for a skin they don't have the " .. currency .. " for" ) return end
        prestige.SubtractTokens( ply, price )
	elseif currency == "credits" then --Donator Credits
		if price > donations.GetCredits( ply ) then CaughtCheater( ply, "Sent net message BuySkin for a skin they don't have the " .. currency .. " for" ) return end
        donations.SubtractCredits( ply, price )
	elseif currency == "cash" then --Standard cash
		if price > GetMoney( ply ) then CaughtCheater( ply, "Sent net message BuySkin for a skin they don't have the " .. currency .. " for" ) return end
        SubtractMoney( ply, price )
	else Error( "Function for net message BuySkin ran with bad currency type" ) return end

	local fil = util.JSONToTable( file.Read( "tdm/users/skins/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) )
	local ttab = fil[ 2 ]
	table.insert( ttab, skin.directory )
	local new = util.TableToJSON( { id( ply:SteamID() ), ttab } )
    file.Write( "tdm/users/skins/" .. id( ply:SteamID() ) .. ".txt", new )
    
    net.Start( "BuySkinCallback" )
    net.Send( ply )

    GAMEMODE:RefreshCurrencies( ply )
end )

net.Receive( "BuyModel", function( len, ply )
	local num = net.ReadInt( 8 )
	local currency = net.ReadString()
	local pmodel = GAMEMODE.PlayerModels[ num ]
	--print(num, GAMEMODE.PlayerModels[ num ], currency)
	local price = GAMEMODE.PlayerModels[ num ][ currency ]
	if currency == "tokens" then --Prestige Tokens
		if price > prestige.GetTokens( ply ) then CaughtCheater( ply, "Sent net message BuyModel for a skin they don't have the " .. currency .. " for" ) return end
		prestige.SubtractTokens( ply, price )
	elseif currency == "credits" then --Donator Credits
		if price > donations.GetCredits( ply ) then CaughtCheater( ply, "Sent net message BuyModel for a skin they don't have the " .. currency .. " for" ) return end
		donations.SubtractCredits( ply, price )
	elseif currency == "cash" then --Standard cash
		if price > GetMoney( ply ) then CaughtCheater( ply, "Sent net message BuyModel for a skin they don't have the " .. currency .. " for" ) return end
		SubtractMoney( ply, price )
	else Error( "Function for net message BuyModel ran with bad currency type" ) return end

	local fil = util.JSONToTable( file.Read( "tdm/users/models/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) )
	local ttab = fil[ 2 ]
	table.insert( ttab, pmodel.model )
	local new = util.TableToJSON( { id( ply:SteamID() ), ttab } )
	file.Write( "tdm/users/models/" .. id( ply:SteamID() ) .. ".txt", new )

	net.Start( "BuyModelCallback" )
    net.Send( ply )
    
    GAMEMODE:RefreshCurrencies( ply )
end )