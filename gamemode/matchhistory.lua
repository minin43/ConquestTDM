--side project by whuppo
require( "mysqloo" )

DATABASE = DATABASE or {
	HOST = "amrcommunity.com",
	PORT = 3306,
	NAME = "amrcommunity_tdmhistory",
	USERNAME = "amrcommunity",
	PASSWORD = "PSJcxV6NKg",
	PREFIX = "[Match History]"
}

function DATABASE:Create( ip, username, password, name, port )
	if ( self.DATABASE ) then return self.DATABASE end
	
	local db = mysqloo.connect( ip, username, password, name, port )
	db.querys = {}

	function db:addQuery( sql, callback )
		table.insert( self.querys, { sql = sql, callback = callback } )

		if !timer.Exists( name .. "_reconnect" ) then
			timer.Create( name .. "_reconnect", 5, 0, function()
				self:connect()
				print( DATABASE.PREFIX, " Attempting to connect ", self )
			end )
		end
	end

	function db:onConnected()
		for k, v in pairs( self. querys ) do
			DATABASE:query( v.sql, v.callback )
		end

		self.querys = {}

		print( DATABASE.PREFIX, " Connected to ", name, " successfully." )

		timer.Destroy( name .. " _reconnect" )

		timer.Create( name .. "_tick", 20, 0, function()
			if ( DATABASE.DATABASE ) then
				local q = DATABASE.DATABASE:query( "SELECT 1" )
 
				if ( !q ) then
					return
				end

				q:start()
			end
		end )
	end

	function db:onConnectionFailure( err )
		print( DATABASE.PREFIX, " Connection to database failed!" )
		print( DATABASE.PREFIX, " Error: ", err )
	end

	db:connect()
	db:wait()

	return db
end

function DATABASE:query( sql, callback )
	local q = self.DATABASE:query( sql )

	if ( !q ) then
		self.DATABASE:addQuery( sql, callback )
		return
	end

	if ( callback ) then
		q.onSuccess = callback
	end

	function q:onError( err )
		if ( err == "MySQL server has gone away" ) then
			self.DATABASE:addQuery( sql, callback )
			return
		end

		print( DATABASE.PREFIX, " Query Error: ", err )
		print( DATABASE.PREFIX, " Query: ", sql )
	end

	q:start()
end

DATABASE.DATABASE = DATABASE:Create( DATABASE.HOST, DATABASE.USERNAME, DATABASE.PASSWORD, DATABASE.NAME, DATABASE.PORT )

local query_string
-- create tables if they don't exist
query_string =
[[CREATE TABLE IF NOT EXISTS `matches`
(
	matchid INT AUTO_INCREMENT,
	starttime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	endtime TIMESTAMP NULL,
	mapname VARCHAR(32) NOT NULL,
	PRIMARY KEY(matchid)
);]]
DATABASE:query( query_string )

query_string =
[[CREATE TABLE IF NOT EXISTS `players`
(
	steamid VARCHAR(32),
	matchid INT,
	jointime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	leavetime TIMESTAMP NULL,
	kills INT(3) DEFAULT 0,
	deaths INT(3) DEFAULT 0,
	assists INT(3) DEFAULT 0,
	headshots INT(3) DEFAULT 0,
	distance INT(4) DEFAULT 0,
	killspree INT(2) DEFAULT 0,
	multikill INT(1) DEFAULT 0,
	bulletdmg INT(7) DEFAULT 0,
	explosivedmg INT(7) DEFAULT 0,
	otherdmg INT(7) DEFAULT 0,
	heal INT(7) DEFAULT 0,
	flagcapture INT(2) DEFAULT 0,
	flagneutral INT(2) DEFAULT 0,
	flagoffense INT(3) DEFAULT 0,
	flagdefense INT(3) DEFAULT 0
);]]
DATABASE:query( query_string )

-- create match ID and grab it
if ( GetGlobalInt( "CurrentMatchID" ) == 0 ) then
	SetGlobalInt( "CurrentMatchID", -1 ) -- unknown matchid
	query_string =
	[[INSERT INTO `matches` (mapname) VALUES (']] .. game.GetMap() .. [[');]]
	DATABASE:query( query_string )

	query_string =
	[[SELECT matchid FROM `matches` ORDER BY matchid DESC LIMIT 1;]]
	DATABASE:query( query_string, function( data )
		data = data:getData()
		SetGlobalInt( "CurrentMatchID", data[1].matchid )
	end )
	DATABASE:query( query_string )
end

-- hook to complete endtime match
function MatchComplete()
	if GetGlobalInt( "CurrentMatchID" ) == -1 then return end --unable to track due to unknown matchid

	local query_string =
	[[UPDATE `matches` SET endtime=CURRENT_TIMESTAMP WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND endtime IS NULL;]]
	DATABASE:query( query_string )

	query_string =
	[[UPDATE `players` SET leavetime=CURRENT_TIMESTAMP WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND leavetime IS NULL;]]
	DATABASE:query( query_string )
end
hook.Add( "MatchHistory_MatchComplete", "MatchHistory_MatchCompleteHook", MatchComplete )
hook.Add( "ShutDown", "MatchHistory_MatchCompleteShutDown", MatchComplete )

-- create players as they join a team
hook.Add( "MatchHistory_JoinTeam", "MatchHistory_JoinTeam", function( ply, team )
	if GetGlobalInt( "CurrentMatchID" ) == -1 then return end --unable to track due to unknown matchid
	if team == 0 then return end --don't add spectators

	local query_string =
	[[SELECT matchid FROM `players` WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. ply:SteamID() .. [[' AND leavetime IS NULL;]]
	DATABASE:query( query_string, function( data )
		local function isempty( var )
			return s == nil or s == ''
		end
		
		data = data:getData()
		if isempty( data[1] ) then 
			local query_string =
			[[INSERT INTO `players` (steamid,matchid) VALUES (']] .. ply:SteamID() .. [[',]] .. GetGlobalInt( "CurrentMatchID" ) .. [[);]]
			DATABASE:query( query_string )
		end
	end )
end )

-- leavetime for players
hook.Add( "PlayerDisconnected", "MatchHistory_DC", function( ply )
	if GetGlobalInt( "CurrentMatchID" ) == -1 then return end --unable to track due to unknown matchid

	local query_string =
	[[UPDATE `players` SET leavetime=CURRENT_TIMESTAMP WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. ply:SteamID() .. [[' AND leavetime IS NULL;]]
	DATABASE:query( query_string )
end )

-- hooks for stats 

--Combat 
--Kills/Deaths
hook.Add( "PlayerDeath", "MatchHistory_KD", function( ply, inf, att )
	if GetGlobalInt( "CurrentMatchID" ) == -1 then return end --unable to track due to unknown matchid

	local query_string
	if ( ply:IsPlayer() ) then
		query_string =
		[[SELECT deaths FROM `players` WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. ply:SteamID() .. [[';]]
		DATABASE:query( query_string, function( data )
			data = data:getData()
			local deaths = data[1].deaths + 1
			local query_string =
			[[UPDATE `players` SET deaths=]] .. deaths .. [[ WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. ply:SteamID() .. [[';]]
			DATABASE:query( query_string )
		end )
	end

	if ( att:IsPlayer() ) then
		query_string =
		[[SELECT kills FROM `players` WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. att:SteamID() .. [[';]]
		DATABASE:query( query_string, function( data )
			data = data:getData()
			local kills
			if ( ply ~= att ) then
				kills = data[1].kills + 1
			else
				kills = data[1].kills - 1
			end
			local query_string =
			[[UPDATE `players` SET kills=]] .. kills .. [[ WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. att:SteamID() .. [[';]]
			DATABASE:query( query_string )
		end )
	end
end )
--Assists
hook.Add( "MatchHistory_Assist", "MatchHistory_Assist", function( ply )
	if GetGlobalInt( "CurrentMatchID" ) == -1 then return end --unable to track due to unknown matchid

	local query_string
	if ( ply:IsPlayer() ) then
		query_string =
		[[SELECT assists FROM `players` WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. ply:SteamID() .. [[';]]
		DATABASE:query( query_string, function( data )
			data = data:getData()
			local assists = data[1].assists + 1
			local query_string =
			[[UPDATE `players` SET assists=]] .. assists .. [[ WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. ply:SteamID() .. [[';]]
			DATABASE:query( query_string )
		end )
	end
end )
--Headshots
hook.Add( "MatchHistory_HS", "MatchHistory_HS", function( ply )
	if GetGlobalInt( "CurrentMatchID" ) == -1 then return end --unable to track due to unknown matchid

	local query_string
	if ( ply:IsPlayer() ) then
		query_string =
		[[SELECT headshots FROM `players` WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. ply:SteamID() .. [[';]]
		DATABASE:query( query_string, function( data )
			data = data:getData()
			local headshots = data[1].headshots + 1
			local query_string =
			[[UPDATE `players` SET headshots=]] .. headshots .. [[ WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. ply:SteamID() .. [[';]]
			DATABASE:query( query_string )
		end )
	end
end )
--Longest Shot (Marksman)
hook.Add( "MatchHistory_Distance", "MatchHistory_Distance", function( ply, amt )
	if GetGlobalInt( "CurrentMatchID" ) == -1 then return end --unable to track due to unknown matchid

	local query_string
	if ( ply:IsPlayer() ) then
		query_string =
		[[SELECT distance FROM `players` WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. ply:SteamID() .. [[';]]
		DATABASE:query( query_string, function( data )
			data = data:getData()
			local distance = data[1].distance
			if ( amt > distance ) then
				local query_string =
				[[UPDATE `players` SET distance=]] .. distance .. [[ WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. ply:SteamID() .. [[';]]
				DATABASE:query( query_string )
			end
		end )
	end
end )
--Largest Killing Spree
hook.Add( "PlayerDeath", "MatchHistory_KS", function( vic, inf, att )
	--sv_killstreaks.lua is godsend

	if GetGlobalInt( "CurrentMatchID" ) == -1 then return end --unable to track due to unknown matchid
	if !att.killsThisLife then return end --killstreak doesn't exist... for some reason

	local query_string
	if ( att:IsPlayer() ) then
		query_string =
		[[SELECT killspree FROM `players` WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. att:SteamID() .. [[';]]
		DATABASE:query( query_string, function( data )
			data = data:getData()
			local killspree = data[1].killspree
			if ( att.killsThisLife > killspree ) then
				local query_string =
				[[UPDATE `players` SET killspree=]] .. killspree .. [[ WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. att:SteamID() .. [[';]]
				DATABASE:query( query_string )
			end
		end )
	end
end )
--Largest Multi Kill
hook.Add( "MatchHistory_Multi", "MatchHistory_Multi", function( ply, amt )
	if GetGlobalInt( "CurrentMatchID" ) == -1 then return end --unable to track due to unknown matchid

	local query_string
	if ( ply:IsPlayer() ) then
		query_string =
		[[SELECT multikill FROM `players` WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. ply:SteamID() .. [[';]]
		DATABASE:query( query_string, function( data )
			data = data:getData()
			local multikill = data[1].multikill
			if ( amt > multikill ) then
				local query_string =
				[[UPDATE `players` SET multikill=]] .. multikill .. [[ WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. ply:SteamID() .. [[';]]
				DATABASE:query( query_string )
			end
		end )
	end
end )

/*
--Damage
--Bullet/Explosive/Other Damage
hook.Add( "EntityTakeDamage", "MatchHistory_Damage", function( ply, dmg )

end )
--Damage Healed
hook.Add( "MatchHistory_Heal", "MatchHistory_Heal", function( ply, amt )

end )
*/

--Objectives
--Flags Captures
hook.Add( "MatchHistory_Capture", "MatchHistory_Capture", function( ply )
	if GetGlobalInt( "CurrentMatchID" ) == -1 then return end --unable to track due to unknown matchid
	if GetGlobalBool( "ticketmode" ) == false then return end --how the fk

	local query_string
	if ( ply:IsPlayer() ) then
		query_string =
		[[SELECT flagcapture FROM `players` WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. ply:SteamID() .. [[';]]
		DATABASE:query( query_string, function( data )
			data = data:getData()
			local flagcapture = data[1].flagcapture + 1
			local query_string =
			[[UPDATE `players` SET flagcapture=]] .. flagcapture .. [[ WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. ply:SteamID() .. [[';]]
			DATABASE:query( query_string )
		end )
	end
end )
--Flags Neutralized
hook.Add( "MatchHistory_Neutral", "MatchHistory_Neutral", function( ply )
	if GetGlobalInt( "CurrentMatchID" ) == -1 then return end --unable to track due to unknown matchid
	if GetGlobalBool( "ticketmode" ) == false then return end --how the fk

	local query_string
	if ( ply:IsPlayer() ) then
		query_string =
		[[SELECT flagneutral FROM `players` WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. ply:SteamID() .. [[';]]
		DATABASE:query( query_string, function( data )
			data = data:getData()
			local flagneutral = data[1].flagneutral + 1
			local query_string =
			[[UPDATE `players` SET flagneutral=]] .. flagneutral .. [[ WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. ply:SteamID() .. [[';]]
			DATABASE:query( query_string )
		end )
	end
end )
--Flag Offense Kills
hook.Add( "MatchHistory_FlagOffense", "MatchHistory_FlagOffense", function( ply )
	if GetGlobalInt( "CurrentMatchID" ) == -1 then return end --unable to track due to unknown matchid
	if GetGlobalBool( "ticketmode" ) == false then return end --how the fk

	local query_string
	if ( ply:IsPlayer() ) then
		query_string =
		[[SELECT flagoffense FROM `players` WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. ply:SteamID() .. [[';]]
		DATABASE:query( query_string, function( data )
			data = data:getData()
			local flagoffense = data[1].flagoffense + 1
			local query_string =
			[[UPDATE `players` SET flagoffense=]] .. flagoffense .. [[ WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. ply:SteamID() .. [[';]]
			DATABASE:query( query_string )
		end )
	end
end )
--Flag Defense Kills
hook.Add( "MatchHistory_FlagDefense", "MatchHistory_FlagDefense", function( ply )
	if GetGlobalInt( "CurrentMatchID" ) == -1 then return end --unable to track due to unknown matchid
	if GetGlobalBool( "ticketmode" ) == false then return end --how the fk

	local query_string
	if ( ply:IsPlayer() ) then
		query_string =
		[[SELECT flagdefense FROM `players` WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. ply:SteamID() .. [[';]]
		DATABASE:query( query_string, function( data )
			data = data:getData()
			local flagdefense = data[1].flagdefense + 1
			local query_string =
			[[UPDATE `players` SET flagdefense=]] .. flagdefense .. [[ WHERE matchid=]] .. GetGlobalInt( "CurrentMatchID" ) .. [[ AND steamid=']] .. ply:SteamID() .. [[';]]
			DATABASE:query( query_string )
		end )
	end
end )
