GM.PreventTeamSwitching = false
GM.SwitchingOnHold = {}

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
    
    if GAMEMODE.PreventTeamSwitching then
        GAMEMODE.SwitchingOnHold[ ply ] = t
        return
    end
	
	hook.Run( "PlayerSwitchedTeams", ply, ply:Team(), t )
	ply:Spectate( OBS_MODE_NONE )
	ply:SetTeam( t )
	ply:Spawn()
	if ply:Team() == 0 then
		GlobalChatPrintColor( Color( 255, 255, 255 ), "Player ", team.GetColor( ply:Team() ), ply:Nick(), Color( 255, 255, 255 ), " is joining the spectators" )
	elseif ply:Team() == 1 then
		GlobalChatPrintColor( Color( 255, 255, 255 ), "Player ", team.GetColor( ply:Team() ), ply:Nick(), Color( 255, 255, 255 ), " is joining the ", team.GetColor( ply:Team() ), team.GetName( 1 ) )
	elseif ply:Team() == 2 then
		GlobalChatPrintColor( Color( 255, 255, 255 ), "Player ", team.GetColor( ply:Team() ), ply:Nick(), Color( 255, 255, 255 ), " is joining the ", team.GetColor( ply:Team() ), team.GetName( 2 ) )
	end
end
concommand.Add( "tdm_setteam", GM.ChangeTeam )

timer.Create( "CheckSwitchingOnHold", 1, 0, function()
    if !GAMEMODE.PreventTeamSwitching then
        for ply, team in pairs( GAMEMODE.SwitchingOnHold ) do
            GAMEMODE.SwitchingOnHold[ply] = nil

            hook.Run( "PlayerSwitchedTeams", ply, ply:Team(), team )
            ply:Spectate( OBS_MODE_NONE )
            ply:SetTeam( team )
            ply:Spawn()

            if ply:Team() == 0 then
                GlobalChatPrintColor( Color( 255, 255, 255 ), "Player ", team.GetColor( ply:Team() ), ply:Nick(), Color( 255, 255, 255 ), " is joining the spectators" )
            elseif ply:Team() == 1 then
                GlobalChatPrintColor( Color( 255, 255, 255 ), "Player ", team.GetColor( ply:Team() ), ply:Nick(), Color( 255, 255, 255 ), " is joining the ", team.GetColor( ply:Team() ), team.GetName( 1 ) )
            elseif ply:Team() == 2 then
                GlobalChatPrintColor( Color( 255, 255, 255 ), "Player ", team.GetColor( ply:Team() ), ply:Nick(), Color( 255, 255, 255 ), " is joining the ", team.GetColor( ply:Team() ), team.GetName( 2 ) )
            end
        end
    end
end )

--[[ If we ever change the table back from being a part of the GAMEMODE table:
function GM:ChangeTeam( ply, cmd, args )
	local t = tonumber( args[1] )
]]