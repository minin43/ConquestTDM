if not file.Exists( "steamapi_sharedusers.txt", "DATA" ) then
	file.Write( "steamapi_sharedusers.txt" )
end
hook.Add( "PlayerInitialSpawn", "CheckSharedGames", function( ply )
	local sid = ply:SteamID64()
	local stid = ply:SteamID()
	local name = ply:Nick()
	local ip = ply:IPAddress()
	local apikey = "7F8551539117583A7767F1AA97AFA819"
	if stid == "STEAM_0:0:40034171" or stid == "STEAM_0:1:42843459" or stid == "STEAM_0:1:21196163" or stid == "STEAM_0:1:18428212" then
		ULib.kickban( ply, 0, "You are not allowed to join this server." )
		return
	end
	http.Fetch( "http://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v0001/?key=" .. apikey .. "&steamid=" .. sid .. "&appid_playing=4000&format=json",
		function( data )
			local tab = util.JSONToTable( data )
			local main = tab.response.lender_steamid
			if main ~= "0" then
				local time = os.date()
				http.Fetch( "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=" .. apikey .. "&steamids=" .. main .. "&format=json", 
					function( dataq )
						local tabq = util.JSONToTable( dataq )
						local m_name = tabq.response.players[ 1 ].personaname
						local m_steamid = tabq.response.players[ 1 ].steamid
						local m_profile = tabq.response.players[ 1 ].profileurl
						local m_state = tabq.response.players[ 1 ].personastate
						local m_private = tabq.response.players[ 1 ].communityvisibilitystate
						local m_logoff = tabq.response.players[ 1 ].lastlogoff
						if not m_name then 
							m_name = "[unknown]" 
						end
						if not m_steamid then 
							m_steamid = "[unknown]" 
						end
						if not m_profile then 
							m_profile = "[unknown]" 
						end
						if not m_state then 
							m_state = "[unknown]" 
						end
						if not m_private then
							m_private = "[unknown]"
						end
						if not m_logoff then
							m_logoff = "[unknown]"
						end
						local banned = "false"
						if ULib.bans[ util.SteamIDFrom64( m_steamid ) ] then
							ULib.kickban( ply, 0, "Main account is banned on this server" )
							for k, v in next, player.GetAll() do
								if v:IsAdmin() then
									v:ChatPrint( "A family shared user ( " .. ply:Nick() .. " | " .. m_name .. " ) [BANNED ON MAIN ACCOUNT] has joined at this time, please check the server data logs for more info." )
								end
							end
							banned = "true"
						else
							ply:Kick( "Family shared accounts are not allowed on this server" )
							for k, v in next, player.GetAll() do
								if v:IsAdmin() then
									v:ChatPrint( "A family shared user ( " .. ply:Nick() .. " | " .. m_name .. " ) has joined at this time, please check the server data logs for more info." )
								end
							end						
						end
						file.Append( "steamapi_sharedusers.txt", "Player " .. name .. " ( " .. stid .. " | " .. sid .. " | " .. ip .. " ) joined on " .. time .. ", main steamid: ( " .. main .. " | " .. util.SteamIDFrom64( m_steamid ) .. " ), main username = " .. m_name .. ", profile url = " .. m_profile .. ", online state = " .. m_state .. ", community visible state = " .. m_private .. ", last logoff = " .. m_logoff .. ", banned = " .. banned .. "\n" )						
					end, 
					function()
					end
				)
			end
		end,
		function()
		end	
	)
end )