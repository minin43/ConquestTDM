util.AddNetworkString( "RequestWeapons" )
util.AddNetworkString( "RequestWeaponsCallback" )
util.AddNetworkString( "RequestWeaponsList" )
util.AddNetworkString( "RequestWeaponsListCallback" )
util.AddNetworkString( "GetRank" )
util.AddNetworkString( "GetRankCallback" )
util.AddNetworkString( "GetCurWeapons" )
util.AddNetworkString( "GetCurWeaponsCallback" )
util.AddNetworkString( "GetUserGroupRank" )
util.AddNetworkString( "GetUserGroupRankCallback" )

function SetStats( wepTable )
	for k, v in pairs( wepTable ) do
		local damage, accuracy, firerate

		local wep = weapons.GetStored( v[2] )
		if wep then
			damage = math.Clamp( wep.Damage * wep.Shots, 0, 100 )
			accuracy = math.Clamp( ( 0.01 - (wep.AimSpread - 0.001) ) / 0.0001, 0, 100 )
			firerate = math.Clamp( 6 / wep.FireDelay, 0, 100)

			v[6] = { }
			v[6][1] = damage
			v[6][2] = accuracy
			v[6][3] = firerate
		end
	end
end

--// WEAPON FORMATING:
--// { "name", "class", level unlock, "world model", price, { leave this alone, this is set automatically }
--//This should eventually be one table, with "slot" being used to differentiate prim/sec/equip
primaries = {
    { "AR-15", 				"cw_ar15", 				0, 	"models/weapons/w_rif_m4a1.mdl", 			0, { 0, 0, 0 }, type = "ar" },
    { "L96A1", 				"cw_b196", 				0, "models/weapons/w_cstm_l96.mdl", 			0, { 0, 0, 0 }, type = "sr" },
	{ "UMP .45", 			"cw_ump45", 			2, "models/weapons/w_smg_ump45.mdl", 			5000, { 0, 0, 0 }, type = "smg" },
    { "M3 Super 90", 		"cw_m3super90", 		5, "models/weapons/w_cstm_m3super90.mdl", 		5000, { 0, 0, 0 }, type = "sg" },
	{ "G3A3", 				"cw_g3a3", 				7, "models/weapons/w_snip_g3sg1.mdl", 			5000, { 0, 0, 0 }, type = "ar" },
	{ "G36C", 				"cw_g36c", 				10, "models/weapons/cw20_g36c.mdl", 			15000, { 0, 0, 0 }, type = "ar" },
    { "CZ Scorpion EVO", 	"cw_scorpin_evo3", 		12, "models/weapons/scorpion/w_ev03.mdl", 		15000, { 0, 0, 0 }, type = "smg" },
	{ "M249", 				"cw_m249_official", 	15, "models/weapons/cw2_0_mach_para.mdl", 		15000, { 0, 0, 0 }, type = "lmg" },
    { "TAC .338", 			"cw_tac338", 			17, "models/weapons/w_snip_TAC338.mdl", 		20000, { 0, 0, 0 }, type = "sr" },
	{ "P90", 				"cw_ber_p90", 			20, "models/weapons/w_dber_p9.mdl", 			20000, { 0, 0, 0 }, type = "smg" },
    { "FAMAS FELIN", 		"cw_ber_famas_felin", 	22, "models/weapons/w_rif_galil.mdl", 			20000, { 0, 0, 0 }, type = "ar" },
    { "SPAS-12", 			"cw_ber_spas12", 		25, "models/weapons/w_dber_franchi12.mdl", 		20000, { 0, 0, 0 }, type = "sg" },
    { "M14", 				"cw_m14", 				27, "models/weapons/w_cstm_m14.mdl", 			30000, { 0, 0, 0 }, type = "sr" },
	{ "RPK-74", 			"cw_amr2_rpk74", 		30, "models/weapons/AMR2/RPK/w_amr2_rpk.mdl", 	30000, { 0, 0, 0 }, type = "lmg" },
	{ "MP5", 				"cw_mp5", 				32, "models/weapons/w_smg_mp5.mdl", 			30000, { 0, 0, 0 }, type = "smg" },
	{ "AK-74", 				"cw_ak74", 				35, "models/weapons/w_rif_ak47.mdl", 			40000, { 0, 0, 0 }, type = "ar" },
	{ "VSS", 				"cw_vss", 				37, "models/cw2/rifles/w_vss.mdl", 				40000, { 0, 0, 0 }, type = "smg" },
	{ "Cheytac M200", 		"cw_wf_m200", 			40, "models/weapons/w_snip_m200.mdl", 			50000, { 0, 0, 0 }, type = "sr" },
	{ "L85A2", 				"cw_l85a2", 			42, "models/weapons/w_cw20_l85a2.mdl", 			50000, { 0, 0, 0 }, type = "ar" },
	{ "MP7", 				"cw_ber_hkmp7", 		45, "models/weapons/w_dber_p7.mdl", 			50000, { 0, 0, 0 }, type = "smg" },
	{ "MK46 Mod 1", 		"cw_amr2_mk46", 		47, "models/weapons/AMR2/MK46/w_amr2_mk46.mdl", 50000, { 0, 0, 0 }, type = "lmg" },
	{ "SCAR-H", 			"cw_scarh", 			50, "models/cw2/rifles/w_scarh.mdl", 			50000, { 0, 0, 0 }, type = "ar" }
}

secondaries = {
	{ "P99",			"cw_p99",		0,	"models/weapons/w_pist_p228.mdl",		0, { 0, 0, 0 }, type = "pt" },
	{ "M1911",			"cw_m1911",		5,	"models/weapons/cw_pist_m1911.mdl",		3000, { 0, 0, 0 }, type = "pt" },
	{ "MR96",			"cw_mr96",		13,	"models/weapons/w_357.mdl",				3000, { 0, 0, 0 }, type = "mn" },
	{ "Five Seven",		"cw_fiveseven",	21,	"models/weapons/w_pist_fiveseven.mdl",	5000, { 0, 0, 0 }, type = "pt" },
	{ "MAC-11",			"cw_mac11",		29,	"models/weapons/w_cst_mac11.mdl",		10000, { 0, 0, 0 }, type = "smg" },
	{ "Super Shorty",	"cw_shorty",	37,	"models/weapons/cw2_super_shorty.mdl",	15000, { 0, 0, 0 }, type = "sg" },
	{ "Makarov",		"cw_makarov",	45,	"models/cw2/pistols/w_makarov.mdl",		20000, { 0, 0, 0 }, type = "pt" },
	{ "Deagle",			"cw_deagle",	50,	"models/weapons/w_pist_deagle.mdl",		30000, { 0, 0, 0 }, type = "mn" }
}

extras = {
	{ "Fists", 				"weapon_fists", 	1, "models/weapons/c_arms_citizen.mdl", 			0, type = "eq" },
	{ "Flash Grenades", 	"cw_flash_grenade",	6, "models/weapons/w_eq_flashbang.mdl", 			2000, type = "eq" },
	{ "Slow Medkit", 		"medkit_slow",		11, "models/weapons/w_medkit.mdl",					5000, type = "eq" },
	{ "Smoke Grenades", 	"cw_smoke_grenade", 18, "models/weapons/w_eq_smokegrenade.mdl", 		5000, type = "eq" },
	{ "Fast Medkit", 		"medkit_fast", 		26, "models/weapons/w_medkit.mdl", 					10000, type = "eq" },
	{ "Frag Grenade x2",	"grenades", 		35, "models/weapons/w_cw_fraggrenade_thrown.mdl",	10000, type = "eq" },
	{ "Large Medkit", 		"medkit_full", 		45, "models/weapons/w_medkit.mdl", 					15000, type = "eq" }
}

--[[	Perk table - used for your reference only
	Packrat -Ammo			- 1
	Hunter -Movement		- 5
    Rebound -Life			- 9
    Frostbite	-Misc		- 13
    Headpopper -Sniper		- 18
    Double Jump	 -Movement	- 22
    Regeneration -Life		- 26
	Thornmail -Misc			- 30
    Vulture -Sniper			- 34
	Excited -Movement		- 38
    Leech -Life				- 42
    Pyromancer -Misc		- 46
    Lifeline -Misc	        - 50
]]

hook.Add( "InitPostEntity", "SetStats", function()
	SetStats( primaries )
	SetStats( secondaries )
end )

perks = {}

function RegisterPerk( name, value, lvl, hint )
	table.insert( perks, { name, value, lvl, hint } )
	table.sort( perks, function( a, b ) return a[ 3 ] < b[ 3 ] end )
end

function CheckPerk( ply )
	if ply:IsPlayer() and load[ ply ] ~= nil then
		if ply.perk and load[ ply ].perk then
			return load[ ply ].perk
		end
	end
end

////////////////////

net.Receive( "RequestWeapons", function( len, ply )
	net.Start( "RequestWeaponsCallback" )
		net.WriteTable( primaries )
		net.WriteTable( secondaries )
		net.WriteTable( extras )
		net.WriteTable( perks )
	net.Send( ply )
end )

net.Receive( "RequestWeaponsList", function( len, ply )
	net.Start( "RequestWeaponsListCallback" )
		net.WriteTable( primaries )
		net.WriteTable( secondaries )
		net.WriteTable( extras )
		net.WriteTable( perks )
	net.Send( ply )
end )

net.Receive( "GetRank", function( len, ply )
	net.Start( "GetRankCallback" )
		net.WriteString( tostring( lvl.GetLevel( ply ) ) )
	net.Send( ply )
end )

net.Receive( "GetCurWeapons", function( len, ply )
	local i = id( ply:SteamID() )
	local fil = util.JSONToTable( file.Read( "tdm/users/" .. i .. ".txt", "DATA" ) )
	local tab = fil[ 2 ]
	net.Start( "GetCurWeaponsCallback" )
		if not tab or #tab == 0 then
			tab = { "" }
		end
		net.WriteTable( tab )
	net.Send( ply )
end )

////////////////////////

vip = {
	{ "vip", 201 },
    { "operator", 201 },
	{ "vip+", 202 },
	{ "ultravip", 203 },
	{ "admin", 204 },
	{ "superadmin", 204 },
	{ "headadmin", 205 },
	{ "coowner", 206 },
	{ "owner", 206 },
	{ "creator", 206 },
	{ "Developer", 209 }
}

net.Receive( "GetUserGroupRank", function( len, ply )
	local rank = 0
	for k, v in next, vip do
		if ply:IsUserGroup( v[ 1 ] ) then
			rank = v[ 2 ]
		end
	end
	net.Start( "GetUserGroupRankCallback" )
		net.WriteString( rank )
	net.Send( ply )
end)

////////////////////////

function isPrimary( class )
	for k, v in next, primaries do
		if class == v[ 2 ] then
			return true
		end
	end
	
	return false
end

function isSecondary( class )
	for k, v in next, secondaries do
		if class == v[ 2 ] then
			return true
		end
	end
	
	return false
end

function isExtra( class )
	for k, v in next, extras do
		if class == v[ 2 ] then
			return true
		end
	end
	
	return false
end

function FixExploit( ply, wep )
	ply:StripWeapon( wep )
	local ent = ents.Create( wep )
	ent:SetPos( ply:GetPos() )
	ent:Spawn()
end

--//I fail to see the purpose of this, and it's being ran in a think hook, so disabling
--To remove when I rework weapon pickup
function CheckWeapons()
	for k, v in next, player.GetAll() do
		if v and v ~= NULL and IsValid( v ) and v:Alive() then
			if v:GetWeapons() then
				local foundp = false
				local founds = false
				local founde = false
				for q, w in next, v:GetWeapons() do
					if isPrimary( w:GetClass() ) then
						if foundp then
							FixExploit( v, w:GetClass() )
						else
							v.curprimary = w:GetClass()
							foundp = true
						end
					elseif isSecondary( w:GetClass() ) then
						if founds then
							FixExploit( v, w:GetClass() )
						else
							v.cursecondary = w:GetClass() 
							founds = true
						end
					elseif isExtra( w:GetClass() ) then
						if founde then
							FixExploit( v, w:GetClass() )
						else
							v.curextra = w:GetClass()
							founde = true
						end
					end
				end
				if foundp == false then
					v.curprimary = nil
				end
				if founds == false then
					v.cursecondary = nil
				end
				if founde == false then
					v.curextra = nil
				end
			end
		end
	end
end
hook.Add( "Think", "CheckPlayersWeapons", CheckWeapons )

--//Disabling because we only want players dropping their weapons when they pick up a different one
--To remove when I rework weapon pickup
hook.Add( "PlayerButtonDown", "DropWeapons", function( ply, bind ) 
	if bind == KEY_Q then
		if not ply.spawning then
			if ply and IsValid( ply ) and ply:IsPlayer() and ply:Team() ~= nil and ply:Team() ~= 0 then
				if ply:GetActiveWeapon() and ply:GetActiveWeapon() ~= NULL then
					if isExtra( ply:GetActiveWeapon():GetClass() ) then
						return
					end
					local wep = ply:GetActiveWeapon()
					local toSpawn = ents.Create( wep:GetClass() )
					toSpawn:SetClip1( wep:Clip1() )
					toSpawn:SetClip2( wep:Clip2() )
					ply:StripWeapon( wep:GetClass() )
					toSpawn:SetPos( ply:GetShootPos() + ( ply:GetAimVector() * 20 ) )
					toSpawn:Spawn()
					toSpawn.rspawn = true
					timer.Simple( 0.5, function()
						toSpawn.rspawn = nil
					end )
					timer.Simple( 15, function()
                        if toSpawn == nil or !toSpawn:IsValid() or toSpawn:GetOwner() == nil then 
                            return 
                        end -- fixed by cobalt 1/30/16
						if toSpawn:GetOwner():IsValid() and toSpawn:GetOwner():IsPlayer() then 
						else
							toSpawn:Remove()
						end
					end )
					local phys = toSpawn:GetPhysicsObject()
					if phys and IsValid( phys ) and phys ~= NULL then
						phys:SetVelocity( ply:EyeAngles():Forward() * 300 )
					end
				end
			end
		end
	end
end )

--//The point of this is to remove one magazine's worth of ammo from the player's ammo pool - WAS written extremely poorly
function GM:WeaponEquip( wep )
	timer.Simple( 0, function() -- this will call the following on the next frame
		if wep and wep:IsValid() and wep:GetOwner() then
			if wep.Base == "cw_base" then
				wep:GetOwner():RemoveAmmo( wep:Clip1(), wep:GetPrimaryAmmoType() )
			end
		end
	end )
end

--To remove when I rework weapon pickup
hook.Add( "PlayerCanPickupWeapon", "NoAutoPickup", function( ply, wep )
	--return --This will be done with a button prompt
	if isPrimary( wep:GetClass() ) then
		if ply.curprimary == nil then
			if wep.rspawn then
				return false
			else
				return true
			end
		else
			return false
		end
	elseif isSecondary( wep:GetClass() ) then
		if ply.cursecondary == nil then
			if wep.rspawn then
				return false
			else		
				return true
			end
		else
			return false
		end
	elseif isExtra( wep:GetClass() ) then
		if ply.curextra == nil then
			if wep.rspawn then
				return false
			else		
				return true
			end
		else
			return false
		end
	end
end )

--//Used to remove dropped weapons to prevent entity buildup
hook.Add( "PlayerDeath", "ClearDroppedWeapons", function( ply )
	if ply.LastUsedWep then	
		if not isExtra( ply.LastUsedWep ) then
			local ent = ents.Create( ply.LastUsedWep )
			ent:SetPos( ply:GetPos() )
			ent:Spawn()
			timer.Simple( 60, function()
				if ent and ent:IsValid() then
					ent:Remove()
				end
			end )
		end
	end
	--To remove when I rework weapon pickup
	ply.curprimary = nil
	ply.cursecondary = nil
	ply.curextra = nil
end )