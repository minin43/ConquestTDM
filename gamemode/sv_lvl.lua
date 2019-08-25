util.AddNetworkString( "SendUpdate" )

local color_red = Color( 255, 0, 0 )
local color_blue = Color( 0, 0, 255 )
local color_green = Color( 102, 255, 51 )
local color_white = Color( 255, 255, 255 )

lvl = {}

lvl.levels = {}
	
lvl.expmul = 300
	
for i = 1, 50 do
	lvl.levels[ i ] = i * lvl.expmul
end

for i = 51, 100 do
    lvl.levels[ i ] = ( 50 * lvl.expmul ) + ( ( i - 50 ) * expmul )
end

lvl.maxlevel = #lvl.levels
lvl.maxlevelexp = lvl.levels[ lvl.maxlevel ]

function lvl.GetLevel( ply )
    if ply and ply:IsValid() then
        return tonumber( ply:GetPData( "level" ) )
    else
        error( "Bad entity in argument for lvl.GetLevel", 1 )
    end
end
	
function lvl.GetEXP( ply )
    if ply and ply:IsValid() then
        return tonumber( ply:GetPData( "exp" ) )
    end
end
	
function lvl.GetAmountForLevel( num )
	return lvl.levels[ num ]
end
	
function lvl.GetNeededEXP( ply )
	local l = lvl.GetLevel( ply )
	local num = lvl.GetAmountForLevel( l )
	local cur = lvl.GetEXP( ply )
	return num - cur
end
	
function lvl.SendUpdate( ply )
	local curlvl = lvl.GetLevel( ply )
	local curexp = lvl.GetEXP( ply )
	local nextexp = lvl.GetAmountForLevel( curlvl )
	net.Start( "SendUpdate" )
		net.WriteString( tostring( curlvl ) )
		net.WriteString( tostring( curexp ) )
		net.WriteString( tostring( nextexp ) )
	net.Send( ply )
end

function lvl.SetLevel( ply, num )
	ply:SetPData( "level", tostring( num ) )
	ply:SetPData( "exp", "0" )
	ply:SetNWString( "level", tostring( num ) )
end

function lvl.SetEXP( ply, num )
	ply:SetPData( "exp", tostring( num ) )
end
	
function lvl.LevelUp( ply, diff )
	if lvl.GetLevel( ply ) + 1 > lvl.maxlevel then
		if lvl.GetEXP( ply ) ~= lvl.maxlevelexp then
			lvl.SetEXP( ply, lvl.maxlevelexp )
			lvl.SendUpdate( ply )
		end
		
		return
	end
	
	if diff then
		local cur = lvl.GetLevel( ply )
		local d = diff + lvl.GetEXP( ply )
		
		for i = cur, lvl.maxlevel do
			if lvl.levels[ i ] - d <= 0 then
				if d - lvl.levels[ i ] - lvl.levels[ i + 1 ] >= 0 then
					hook.Run( "lvl.OnLevelUp", ply, lvl.GetLevel( ply ) + 1 )
				end
				d = ( d - lvl.levels[ i ] )
				lvl.SetLevel( ply, lvl.GetLevel( ply ) + 1 )
			else
				hook.Run( "lvl.OnLevelUp", ply, i )
				lvl.SetLevel( ply, i )
				lvl.SetEXP( ply, d )
				break
			end
		end
		
		lvl.SendUpdate( ply )
	else
		hook.Run( "lvl.OnLevelUp", ply, lvl.GetLevel( ply ) + 1 )
		lvl.SetLevel( ply, lvl.GetLevel( ply ) + 1 )
		lvl.SendUpdate( ply )
	end
	ply:SetNWString( "level", lvl.GetLevel( ply ) )
end
	
function lvl.AddEXP( ply, num )
	local n = lvl.GetNeededEXP( ply )
	local c = lvl.GetEXP( ply )
	if n > num then
		lvl.SetEXP( ply, ( num + c ) )
		lvl.SendUpdate( ply )
	elseif num > n then
		local diff = num
		lvl.LevelUp( ply, diff )		
	elseif num == n then
		lvl.LevelUp( ply )		
	end
end

function lvl.ResetPlayer( ply )
	ply:SetPData( "level", 0 )
	ply:SetPData( "exp", 0 )
	lvl.SetLevel( ply, 1 )
	lvl.SetEXP( ply, 0 )
	lvl.SendUpdate( ply )	
end
	
hook.Add( "PlayerInitialSpawn", "lvl.SendInitialLevel", function( ply )
	timer.Simple( 5, function()
		if not ply:GetPData( "level" ) then
			lvl.SetLevel( ply, 1 )
			lvl.SetEXP( ply, 0 )
		end
		
		lvl.SendUpdate( ply )
		ply:SetNWString( "level", lvl.GetLevel( ply ) )
	end )
end )
	
hook.Add( "lvl.OnLevelUp", "lvl.OnLevelUp", function( ply, newlv )
	ply:ChatPrintColor( "You have leveled up to ", color_green, "level " .. tostring( newlv ), color_white )--, ". You unlocked: ", color_green )
	ply:SendLua([[surface.PlaySound( "ui/UI_Awards_Basic_wav.mp3" )]])
end )

concommand.Add( "lvl_refresh", function( ply )
	lvl.SendUpdate( ply )
end )
	
concommand.Add( "lvl_debug_reset", function( ply )
	if ply:IsValid() and not ply:IsSuperAdmin() then 
		return 
	end
	
	for k, v in next, player.GetAll() do
		v:RemovePData( "level" )
		v:RemovePData( "exp" )
		lvl.SetLevel( v, 1 )
		lvl.SetEXP( v, 0 )
		lvl.SendUpdate( v )		
	end
end )

util.AddNetworkString( "GetLevel" )
util.AddNetworkString( "GetLevelCallback" )