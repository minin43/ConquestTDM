--//Start Whuppo's code
if not file.Exists( "tdm/spawns", "DATA" ) then
	file.CreateDir( "tdm/spawns" )
end

if not file.Exists( "tdm/spawns/" .. game.GetMap() .. ".txt", "DATA" ) then
	file.Write( "tdm/spawns/" .. game.GetMap() .. ".txt" )
end

CreateConVar( "tdm_showspawns", "1", FCVAR_ARCHIVE, "0 = off, 1 = everyone, 2 = admins only, 3 = superadmins only" )

util.AddNetworkString( "debug_showspawns" )

local curSpawns = {}
local nl = Vector( 0, 0, 0 )	

--Made some minor adjustments to this function to get it to work with id-based spawns
function refreshspawns()
	local toApply = {}
	local fi = file.Read( "tdm/spawns/" .. game.GetMap() .. ".txt", "DATA" )
    local exp = string.Explode( "\n", fi )
    local num = GetConVar( "tdm_showspawns" ):GetInt()
    
    if GetGlobalInt( "ConquestResupply", 0 ) != 0 then
        for k, v in next, exp do
            local toAdd = util.JSONToTable( v )
            if toAdd[4] == tostring(GetGlobalInt( "ConquestResupply" )) then
                table.insert( toApply, toAdd )
            end
        end
    end
    if table.IsEmpty( toApply ) then
        for k, v in next, exp do
            local toAdd = util.JSONToTable( v )
            table.insert( toApply, toAdd )
        end
    end
    
    curSpawns = toApply
    
	if num == 1 then
		net.Start( "debug_showspawns" )
			net.WriteTable( curSpawns )
		net.Broadcast()	
	elseif num == 2 then
		for k, v in next, player.GetAll() do
			if ply:IsAdmin() then
				net.Start( "debug_showspawns" )
					net.WriteTable( curSpawns )
				net.Send( ply )
			end
		end
	elseif num == 3 then
		for k, v in next, player.GetAll() do
			if ply:IsSuperAdmin() then
				net.Start( "debug_showspawns" )
					net.WriteTable( curSpawns )
				net.Send( ply )
			end
		end
	end
end

hook.Add( "PlayerSpawn", "OverrideSpawnLocations", function( ply )	
	local availablespawns = false	
	for k, v in next, curSpawns do
		if v[ 1 ] == ply:Team() then
			availablespawns = true
			break
		end
	end		
	if availablespawns == true then		
		local tabspawns = {}			
		for k, v in next, curSpawns do
			if v[ 1 ] == ply:Team() then
				table.insert( tabspawns, v )
			end
		end			
		local tospawn = table.Random( tabspawns )
		local bound1 = tospawn[ 2 ]
		local bound2 = tospawn[ 3 ]
		local locationx = math.random( bound1.x, bound2.x )
		local locationy = math.random( bound1.y, bound2.y )
		local z = bound1.z + 5
		local vec = Vector( locationx, locationy, z )		
		while true do
			local en = ents.FindInSphere( vec, 40 )
			local safe = true
			for k, v in next, en do
				if IsValid( v ) and v:IsPlayer() then
					safe = false
					locationx = math.random( bound1.x, bound2.x )
					locationy = math.random( bound1.y, bound2.y )
					vec = Vector( locationx, locationy, z )
					break
				end
			end
			if safe then
				ply:SetPos( vec )
				ply.SpawnPos = vec
				break
			end
		end			
	end
end )

concommand.Add( "debug_showspawns", function( ply )
	local num = GetConVar( "tdm_showspawns" ):GetInt()
	if num == 1 then
		net.Start( "debug_showspawns" )
			net.WriteTable( curSpawns )
		net.Send( ply )		
	elseif num == 2 then
		if ply:IsAdmin() then
			net.Start( "debug_showspawns" )
				net.WriteTable( curSpawns )
			net.Send( ply )
		end
	elseif num == 3 then
		if ply:IsSuperAdmin() then
			net.Start( "debug_showspawns" )
				net.WriteTable( curSpawns )
			net.Send( ply )		
		end		
	end
end )

hook.Add( "PlayerSpawn", "SendSpawns", function( ply )
	local num = GetConVar( "tdm_showspawns" ):GetInt()
	if num == 1 then
		net.Start( "debug_showspawns" )
			net.WriteTable( curSpawns )
		net.Send( ply )		
	elseif num == 2 then
		if ply:IsAdmin() then
			net.Start( "debug_showspawns" )
				net.WriteTable( curSpawns )
			net.Send( ply )
		end
	elseif num == 3 then
		if ply:IsSuperAdmin() then
			net.Start( "debug_showspawns" )
				net.WriteTable( curSpawns )
			net.Send( ply )		
		end		
	end
end )

refreshspawns()
--//End Whuppo's code

util.AddNetworkString( "StartSpawnOverlay" )
util.AddNetworkString( "StopSpawnOverlay" )
util.AddNetworkString( "SpawnProtectionIcon" )
util.AddNetworkString( "ReducedDamage" )

--//Spawn protection crap
local PlayerClass = FindMetaTable( "Player" )

function PlayerClass:StartSpawnProtection( length )
	if GetGlobalBool( "RoundFinished" ) then return end

	length = length or 5

	self:SetColor( Color( 255, 255, 255, 155 ) )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.SpawnProtected = true

	net.Start( "StartSpawnOverlay" )
	net.Send( self )
	
	timer.Simple( length, function()
		self:StopSpawnProtection()
	end )

end

function PlayerClass:StopSpawnProtection()
	if self and self:IsValid() then
		self:SetMaterial( "" )
		self:SetColor( Color( 255, 255, 255, 255 ) )
		self.SpawnProtected = false

		net.Start( "StopSpawnOverlay" )
		net.Send( self )
	end
end

hook.Add( "EntityTakeDamage", "SpawnProtection", function( ply, dmginfo )
	if( ply.SpawnProtected ) then
		if dmginfo:GetAttacker():IsValid() and dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker():Team() != ply:Team() then
			dmginfo:GetAttacker():ChatPrint( "Don't shoot people in spawn protection!" )
			net.Start( "SpawnProtectionIcon" )
			net.Send( dmginfo:GetAttacker() )
		end

		net.Start( "ReducedDamage" )
		net.Send( ply )
		dmginfo:ScaleDamage( 0.1 ) --// 90% damage reduced

        GAMEMODE:QueueIcon( dmginfo:GetAttacker(), "spawn", 0.5 )
		--return dmginfo
	end
	
	--//This eliminated spawn protection when the player began shooting, but the player was never notified of this; I'm eliminating the mechanic entirely
	--[[if( dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker().spawning ) then
		dmginfo:GetAttacker().spawning = false
		--dmginfo:ScaleDamage( 0 )
		return dmginfo
	end]]
	
	if( GetConVarNumber( "tdm_ffa" ) == 1 ) then
		if( not dmginfo:IsExplosionDamage() ) then
			dmginfo:ScaleDamage( 1 )
		end
	end
	
    --return dmginfo
end )

hook.Add( "Think", "DisableProtectionByDistance", function()
	local distance = 600 --//Edit this value to change the distance needed to travel before losing protection
	for k, v in pairs( player.GetAll() ) do
		if v.SpawnProtected and v.SpawnPos then
			--//Note: wiki says vector:Distance( vector ) is expensive due to square root call, & since this is being called in a think function, we can bypass it and use DistToSqr
			--//(the un-rooted distance) and just compare the square of the distance, increasing server performance
			if v:GetPos():DistToSqr( v.SpawnPos ) > ( distance * distance ) then
				v:StopSpawnProtection()
			end
		end
	end
end )