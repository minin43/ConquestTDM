local hax = {}

local whitelist = {}
local tounban = {}

util.AddNetworkString( "SendBan" )
util.AddNetworkString( "SendClientFile" )

function hax.Init()
	if not file.Exists( "hax", "DATA" ) then
		file.CreateDir( "hax" )
	end
	if not file.Exists( "hax/logs", "DATA" ) then
		file.CreateDir( "hax/logs" )
	end
	if not file.Exists( "hax/logs/logs.txt", "DATA" ) then
		file.Write( "hax/logs/logs.txt" )
	end
end

function hax.Add( ply )
	if not table.HasValue( whitelist, ply ) then
		table.insert( whitelist, ply )
	end
end

concommand.Add( "hax_whitelist", function( ply, cmd, args )
	local pl = args[ 1 ]
	if ply:IsValid() and not ply:IsSuperAdmin() then
		if ply:IsValid() then
			ply:ChatPrint( "Invalid permissions." )
		else
			MsgN( "Invalid permissions." )
		end
		for k, v in next, player.GetAll() do
			if v:IsAdmin() then
				v:ChatPrint( "User " .. ply:Nick() .. " attempted to whitelist " .. pl )
			end
		end
		return
	end
	local user
	for k, v in next, player.GetAll() do
		if string.find( v:Nick():lower(), pl:lower() ) then
			user = v
		end
	end
	if user then
		hax.Add( user )
		if ply:IsValid() then
			ply:ChatPrint( user:Nick() .. " has been added to the whitelist" )
		else
			MsgN( user:Nick() .. " has been added to the whitelist" )
		end
	else
		if ply:IsValid() then
			ply:ChatPrint( "No users found" )
		else
			MsgN( "No users found" )
		end
	end
end )

concommand.Add( "hax_unban", function( ply, cmd, args )
	local steamid = args[ 1 ]
	if ply:IsValid() and not ply:IsSuperAdmin() then
		if ply:IsValid() then
			ply:ChatPrint( "Invalid permissions." )
		else
			MsgN( "Invalid permissions." )
		end
		for k, v in next, player.GetAll() do
			if v:IsAdmin() then
				v:ChatPrint( "User " .. ply:Nick() .. " attempted to unban " .. steamid )
			end
		end
		return
	end
	if not ULib.isValidSteamID( steamid ) then
		if ply:IsValid() then
			ply:ChatPrint( "Invalid steamid" )
		else
			MsgN( steamid )
			MsgN( "Invalid steamid" )
		end
		return
	end
	ULib.unban( steamid )
	if not table.HasValue( tounban, steamid ) then
		table.insert( tounban, steamid )
		if ply:IsValid() then
			file.Append( "hax/logs/logs.txt", ply:Nick() .. " unbanned steamid " .. steamid ..  "\n" )
		else
			file.Append( "hax/logs/logs.txt", "Console unbanned steamid " .. steamid ..  "\n" )
		end
		if ply:IsValid() then
			ply:ChatPrint( "SteamID " .. steamid .. " has been unbanned. Tell them to join so their data can be wiped, otherwise they will be banned again upon the next mapchange." )
		else
			MsgN( "SteamID " .. steamid .. " has been unbanned. Tell them to join so their data can be wiped, otherwise they will be banned again upon the next mapchange." )
		end
	end
end )

function hax.Ban( ply, logmsg )

	local name = ply:Name()
	local id = ply:SteamID()
	local ip = ply:IPAddress()
	local time = os.date()
	
	ply:SendLua( [[ cookie.Set( "tdm_banned", "true" ) ]] )
	
	timer.Simple( 0.5, function()
		file.Append( "hax/logs/logs.txt", name .. " ( " .. id .. " | " .. ip .. " ) banned on " .. time .. " for " .. logmsg .. "\n" )
		--ply:Kick( "#VAC_ConnectionRefusedByServer" ) 	-- don't let them know exactly what they were banned for
		ply:Kick( logmsg )								-- unless you really want to
		
		ULib.addBan( id, 0, logmsg )
		
		ULib.tsayColor( nil, false, Color( 255, 0, 0 ), name .. " (" .. id .. ") has been banned for " .. logmsg )
	end )
	
end

/*
CW2.0 WEAPON SCOPES MAKE THIS USELESS
AHHHHHHHHHHHHHHH

local v_banned = false
_R[ "CUserCmd" ][ "SetViewAngles" ] = function( ... ) 
	if v_banned then
		return
	end
	v_banned = true
	local fi = debug.getinfo( 2 ).short_src
	if isvalidfile( fi ) then
		SendBan( "Forbidden function call [SetViewAngles]" )
	end
	return _G[ "CUserCmd" ][ "SetViewAngles" ]( ... )
end	
*/

-- #cantbypassthis
function SendClientFile( ply )
	ply:SendLua([[
		net.Receive( "SendClientFile", function()
			local str = net.ReadString()
			RunString( str )
		end )
	]])
	local str = [[
	
		local _R = debug.getregistry()
		local _N = table.Copy( _G )
		
		function hook.Exists( type, value )
			local tab = hook.GetTable()		
			for k, v in next, tab[ type ] do
				if k == value then
					return true
				end
			end		
			return false
		end
		function concommand.Exists( type, value )
			local tab = concommand.GetTable()
			for k, v in next, tab do
				if k == value then
					return true
				end
			end
			return false
		end		
		local function SendBan( message )
			net.Start( "SendBan" )
				net.WriteString( message )
			net.SendToServer()
		end		
		local a_cheating = false
		local c_cheating = false
		local f_cheating = false
		hook.Add( "Think", "CheckConVars", function()
		
			local gcv_banned = false
			if debug.getinfo( GetConVar ).short_src ~= "[C]" then
				if gcv_banned then
					return
				end
				gcv_banned = true
				SendBan( "Overwriting GetConVar" )
			end
			
			local ggb_banned = false
			if debug.getinfo( GetGlobalBool ).short_src ~= "[C]" then
				if ggb_banned then
					return
				end
				ggb_banned = true
				SendBan( "Overwriting GetGlobalBool" )
			end
			
			local ascl = GetConVar( "sv_allowcslua" ):GetInt()
			if ascl and ascl ~= 0 then
				if a_cheating then
					return
				end
				if GetGlobalBool( "allowcslua" ) == false then
					a_cheating = true
					timer.Simple( 0.5, function()
						if GetGlobalBool( "allowcslua" ) == false then
							SendBan( "Forcing sv_allowcslua" )
						else
							a_cheating = false
						end
					end )
				end
			end
			
			local cheats = GetConVar( "sv_cheats" ):GetInt()
			if cheats and cheats ~= 0 then
				if c_cheating then
					return
				end
				if GetGlobalBool( "cheats" ) == false then
					c_cheating = true
					timer.Simple( 0.5, function()
						if GetGlobalBool( "cheats" ) == false then
							SendBan( "Forcing sv_cheats" )
						else
							c_cheating = false
						end
					end )
				end
			end
			
			local fr = GetConVar( "host_framerate" ):GetInt()
			if fr and fr ~= 0 then
				if f_cheating then
					return
				end
				f_cheating = true
				SendBan( "Forcing host_framerate" )				
			end
			
		end )
		
		usermessage.Hook( "CheckHooks", function()
			if not hook.Exists( "Think", "CheckConVars" ) then
				SendBan( "Removing Clientside Hooks" )
			end
		end )
		usermessage.Hook( "CheckCookies", function()
			local c = cookie.GetString( "tdm_banned", "" )
			if c == "true" then
				SendBan( "Ban Evasion" )
			end
		end )	
		
		local function isvalidfile( str )
			if string.find( str, "mad" ) or string.find( str, "fas2" ) or string.find( str, "wac" ) then
				return false
			end
			return true
		end
		
		local sfm_banned = false
		_R[ "CUserCmd" ][ "SetForwardMove" ] = function( speed )
			if sfm_banned then
				return
			end
			sfm_banned = true
			local fi = debug.getinfo( 2 ).short_src
			if isvalidfile( fi ) then
				SendBan( "Forbidden function call [SetForwardMove]" )
			end
			return _G[ "CUserCmd" ][ "SetForwardMove" ]( speed )
		end
		
		local ssm_banned = false
		_R[ "CUserCmd" ][ "SetSideMove" ] = function( speed )
			if ssm_banned then
				return
			end
			ssm_banned = true
			local fi = debug.getinfo( 2 ).short_src
			if isvalidfile( fi ) then
				SendBan( "Forbidden function call [SetSideMove]" )
			end
			return _G[ "CUserCmd" ][ "SetSideMove" ]( speed )
		end
		
		local sum_banned = false
		_R[ "CUserCmd" ][ "SetUpMove" ] = function( speed )
			if sum_banned then
				return
			end
			sum_banned = true
			local fi = debug.getinfo( 2 ).short_src
			if isvalidfile( fi ) then
				SendBan( "Forbidden function call [SetUpMove]" )
			end
			return _G[ "CUserCmd" ][ "SetUpMove" ]( speed )
		end		
		
		_G[ "RunString" ] = function( str )
			local fi = debug.getinfo( 2 ).short_src
			if isvalidfile( fi ) then
				SendBan( "Forbidden function call [RunString]" )
			end
			return _N.RunString( str )
		end
		
		_G[ "RunStringEx" ] = function( str, val )
			local fi = debug.getinfo( 2 ).short_src
			if isvalidfile( fi ) then
				SendBan( "Forbidden function call [RunStringEx]" )
			end
			return _N.RunStringEx( str, val )
		end
		
		_G[ "CompileString" ] = function( code, id, err )
			local fi = debug.getinfo( 2 ).short_src
			if isvalidfile( fi ) then
				SendBan( "Forbidden function call [CompileString]" )
			end		
			SendBan( "Forbidden function call [CompileString]" )
			return _N.CompileString( code, id, err )
		end	
	]]
	net.Start( "SendClientFile" )
		net.WriteString( str )
	net.Send( ply )
end

timer.Create( "SendFunctions", 10, 0, function( ply )
	umsg.Start( "CheckHooks", ply )
	umsg.End()
end )

hook.Add( "PlayerAuthed", "CheckCookies", function( ply )
	local xtab = {
	}
	if table.HasValue( xtab, ply:SteamID() ) then
		table.insert( tounban, ply:SteamID() )
	end

	SendClientFile( ply )
	if table.HasValue( tounban, ply:SteamID() ) then
		ply:SendLua( [[ cookie.Delete( "tdm_banned" ) ]] )
		local key = table.KeyFromValue( tounban, ply:SteamID() )
		table.remove( tounban, key )
	else
		umsg.Start( "CheckCookies", ply )
		umsg.End()
	end
end )

-- you can turn on cheats and allowcslua serverside if you want to i guess
-- hook.Add( "Think", "SetGlobalBools", function()
	-- local cheats = GetConVar( "sv_cheats" ):GetBool()
	-- if cheats then
		-- if not GetGlobalBool( "cheats" ) == true then
			-- SetGlobalBool( "cheats", true )				Don't even need this since Cake will do this for you
		-- end
	-- else
		-- if not GetGlobalBool( "cheats" ) == false then
			-- SetGlobalBool( "cheats", false )
		-- end
	-- end
	-- local acl = GetConVar( "sv_allowcslua" ):GetBool()
	-- if acl then
		-- if not GetGlobalBool( "allowcslua" ) == true then
			-- SetGlobalBool( "allowcslua", true )
		-- end
	-- else
		-- if not GetGlobalBool( "allowcslua" ) == false then
			-- SetGlobalBool( "allowcslua", false )
		-- end
	-- end
-- end )

hook.Add( "Initialize", "StartUp", function()
	hax.Init()
end )

net.Receive( "SendBan", function( len, ply )
	local str = net.ReadString()
	if not table.HasValue( whitelist, ply ) then
		hax.Ban( ply, str )
	else
		ULib.tsayColor( ply, false, Color( 255, 255, 255 ), "Whitelisted for ban value: " .. str )
	end
end )