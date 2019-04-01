function GM:ChangeTeam( _, args, _ ) --This is a wonky return as the function is a part of the gamemode table
	local ply = self
	local t = tonumber( args[1] )
	
	if( t ~= 0 and t ~= 1 and t ~= 2 ) then
		ply:ChatPrint( "Error: no valid team selected." )
		return
	end
		
	if( t == ply:Team() ) then
		if t != 0 then
			ply:ChatPrint( "You are already on that team!" )
		end
		return
	end

	if #team.GetPlayers( 1 ) - #team.GetPlayers( 2 ) > 1 and t == 1 then
		ply:ChatPrint( "Due to player count imbalance, you can't join this team!" )
		return
	elseif #team.GetPlayers( 2 ) - #team.GetPlayers( 1 ) > 1 and t == 2 then
		ply:ChatPrint( "Due to player count imbalance, you can't join this team!" )
		return
	end
	
	hook.Run( "PlayerSwitchedTeams", ply, ply:Team(), t )
	ply:Spectate( OBS_MODE_NONE )
	ply:SetTeam( t )
	ply:Spawn()
	if ply:Team() == 0 then
		--NewFunction( Color( 255, 255, 255 ), "Player ", team.GetColor( ply:Team() ), ply:Nick(), Color( 255, 255, 255 ), " is joining the spectators" )
	elseif ply:Team() == 1 then
		--NewFunction( Color( 255, 255, 255 ), "Player ", team.GetColor( ply:Team() ), ply:Nick(), Color( 255, 255, 255 ), " is joining the ", team.GetColor( ply:Team() ), "red team" )
	elseif ply:Team() == 2 then
		--NewFunction( Color( 255, 255, 255 ), "Player ", team.GetColor( ply:Team() ), ply:Nick(), Color( 255, 255, 255 ), " is joining the ", team.GetColor( ply:Team() ), "blue team" )
	end
end

concommand.Add( "tdm_setteam", GM.ChangeTeam )

--[[ If we ever change the table back from being a part of the GAMEMODE table:
function GM:ChangeTeam( ply, cmd, args )
	local t = tonumber( args[1] )
]]