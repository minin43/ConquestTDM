--sv_playercards

util.AddNetworkString( "GetPlayerInfo" )
util.AddNetworkString( "GetPlayerInfoCallback" )
util.AddNetworkString( "GetCountry" )
util.AddNetworkString( "GetCountryCallback" )

net.Receive( "GetPlayerInfo", function( len, ply )
	local pl = net.ReadEntity()
	local id = pl:SteamID()
	local data = {}
	data.kills 		= util.GetPData( id, "g_kills" ) or 0
	data.deaths 	= util.GetPData( id, "g_deaths" ) or 0
	data.flags 		= util.GetPData( id, "g_flags" ) or 0
	data.time 		= util.GetPData( id, "g_time" ) or 0
	data.money		= util.GetPData( id, "tdm_money" ) or 0
	data.level		= util.GetPData( id, "level" ) or 0
	data.assists	= util.GetPData( id, "g_assists" ) or 0
	data.headshot	= util.GetPData( id, "g_headshot" ) or 0
	net.Start( "GetCountry" )
	net.Send( pl )
	net.Receive( "GetCountryCallback", function()
		data.country = net.ReadString()
		data.os = net.ReadString()
		net.Start( "GetPlayerInfoCallback" )
			net.WriteTable( data )
		net.Send( ply )
	end )
end )