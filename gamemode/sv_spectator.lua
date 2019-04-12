--//The gamemode's spectator team functionality
local function GetValid()
	local validEnts = {}
	for k, v in next, player.GetAll() do
		if IsValid( v ) and v:Team() and v:Team() ~= 0 then
			table.insert( validEnts, v )
		end
	end
	return validEnts
end

function SetupSpectator( ply )
	ply:StripWeapons()
	local ent = GetValid()
	if #ent == 0 then
		ply:Spectate( OBS_MODE_ROAMING )
		return
	end
	ply:SpectateEntity( table.Random( ent ) )
	ply:Spectate( OBS_MODE_IN_EYE )
end

local function NextSpec( ply )
	if ply:Team() == 0 then
		local specs = GetValid()
		if not ply:GetObserverTarget() or ply:GetObserverTarget() == NULL then
			return
		end
		local pos = table.KeyFromValue( specs, ply:GetObserverTarget() )
		if not pos then
			return
		end
		local newpos
		if pos + 1 > #specs then
			newpos = table.GetFirstKey( specs )
		else
			newpos = pos + 1
		end
		return specs[ newpos ]
	end
end

local function PrevSpec( ply )
	if ply:Team() == 0 then
		local specs = GetValid()
		if not ply:GetObserverTarget() or ply:GetObserverTarget() == NULL then
			return
		end
		local pos = table.KeyFromValue( specs, ply:GetObserverTarget() )
		if not pos then
			return
		end
		local newpos
		if pos - 1 < 1 then
			newpos = table.GetLastKey( specs )
		else
			newpos = pos - 1
		end
		return specs[ newpos ]
	end
end

hook.Add( "PlayerButtonDown", "SpectatorControls", function( ply, key )
	if ply:Team() == 0 then
		if key == KEY_R then
			if ply:GetObserverMode() == OBS_MODE_IN_EYE then
				ply:Spectate( OBS_MODE_CHASE )
			elseif ply:GetObserverMode() == OBS_MODE_CHASE then
				ply:Spectate( OBS_MODE_ROAMING )
			elseif ply:GetObserverMode() == OBS_MODE_ROAMING then
				ply:Spectate( OBS_MODE_IN_EYE )
			end
		elseif key == MOUSE_LEFT and ply:GetObserverMode() ~= OBS_MODE_ROAMING then
			if not ply:GetObserverTarget() or ply:GetObserverTarget() == ply then
				ply:SpectateEntity( GetValid()[ 1 ] )
			else
				ply:SpectateEntity( PrevSpec( ply ) )
			end
		elseif key == MOUSE_RIGHT and ply:GetObserverMode() ~= OBS_MODE_ROAMING then
			if not ply:GetObserverTarget() or ply:GetObserverTarget() == ply then
				ply:SpectateEntity( GetValid()[ 1 ] )
			else
				ply:SpectateEntity( NextSpec( ply ) )
			end
		end		
	end
end )

hook.Add( "PlayerDisconnected", "Spec_DC", function( ply )
	for k, v in next, player.GetAll() do
		if v:Team() == 0 then
			if v:GetObserverTarget() == ply then
				v:SpectateEntity( NextSpec( v ) )
				if v:GetObserverTarget() == v or v:GetObserverTarget() == nil then
					v:Spectate( OBS_MODE_ROAMING )
				end
			end
		end
	end
end )