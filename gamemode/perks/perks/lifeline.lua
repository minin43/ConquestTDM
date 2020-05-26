util.AddNetworkString( "Lifeline" )
util.AddNetworkString( "EndLifeline" )

local llwalkdiff = 40
local llrundiff = 60
local lljumpdiff = 30
local lldefaultwalk = GM.DefaultWalkSpeed - llwalkdiff
local lldefaultrun = GM.DefaultRunSpeed - llrundiff
local lldefaultjump = GM.DefaultJumpPower - lljumpdiff

local healthtracking = {}

local function UpdateMovement( ply )
	ply:SetWalkSpeed( math.Round( lldefaultwalk + ( ( llwalkdiff * 3 ) * ( 1 - ( ply:Health() / ply:GetMaxHealth() ) ) ) ) )
	ply:SetRunSpeed ( math.Round( lldefaultrun + ( ( llrundiff * 3 ) * ( 1 - ( ply:Health() / ply:GetMaxHealth() ) ) ) ) )
    ply:SetJumpPower( math.Round( lldefaultjump + ( ( lljumpdiff * 2 ) * ( 1 - ( ply:Health() / ply:GetMaxHealth() ) ) ) ) )
end

hook.Add( "PostGiveLoadout", "LifelineSpawn", function( ply )
	if CheckPerk( ply ) == "lifeline" then
		GAMEMODE.PerkTracking.LifelineList[ ply ] = true
		healthtracking[ ply ] = ply:GetMaxHealth()
	else
		if GAMEMODE.PerkTracking.LifelineList[ ply ] then
			GAMEMODE.PerkTracking.LifelineList[ ply ] = nil
		end
	end
end )

hook.Add( "Think", "LifelineMovementSetting", function()
	for k, v in pairs( GAMEMODE.PerkTracking.LifelineList ) do
		if v and k:IsValid() and healthtracking[ k ] != k:Health() then
			UpdateMovement( k )
			healthtracking[ k ] = k:Health()
		--[[else
			k = nil]]
		end
	end
end )
 
--[[hook.Add( "EntityTakeDamage", "LifelineDamageReduction", function( ply, dmginfo )
    if ply:IsValid() and ply:IsPlayer() then
		if CheckPerk( ply ) == "lifeline" then
			dmginfo:ScaleDamage( math.Clamp( 1 - ( ( ply:GetMaxHealth() - ply:Health() ) / 115 ), 0, 1 ) ) --//Not very complicated scaling, might make this mechanic too strong
		end
	end
end )]]

RegisterPerk( "Lifeline", "lifeline", 75, "Walk speed, sprint speed, & jump height all scale with missing health; the lower, the better, the higher the worse." )