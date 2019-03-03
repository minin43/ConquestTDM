util.AddNetworkString( "RequestWeapons" )
util.AddNetworkString( "RequestWeaponsCallback" )
util.AddNetworkString( "RequestWeaponsList" )
util.AddNetworkString( "RequestWeaponsListCallback" )
util.AddNetworkString( "GetRank" )
util.AddNetworkString( "GetRankCallback" )
util.AddNetworkString( "GetCurWeapons" )
util.AddNetworkString( "GetCurWeaponsCallback" )
util.AddNetworkString( "GetULXRank" )
util.AddNetworkString( "GetULXRankCallback" )

function id( steamid )
	local x = string.gsub( steamid, ":", "x" )
	return x
end

function unid( steamid )
	local x = string.gsub( steamid, "x", ":" )
	return string.upper( x )
end

function SetStats( wepTable )
	for k, v in pairs( wepTable ) do
		local damage, accuracy, firerate

		local wep = weapons.GetStored( v[2] )
		damage = math.Clamp( wep.Damage * wep.Shots, 0, 100 )
		accuracy = math.Clamp( 0.01 - (wep.AimSpread - 0.001) / 0.0001, 0, 100 )
		firerate = math.Clamp( 6 / wep.FireDelay, 0, 100)

		v[6][1] = damage
		v[6][2] = accuracy
		v[6][3] = firerate
	end
end

--// WEAPON FORMATING:
--// { "name", "class", level unlock, "world model", price, { damage, accuracy, firerate }
primaries = {
	{ "AR-15", 		"cw_ar15", 			0, 	"models/weapons/w_rif_m4a1.mdl", 		0, 		{ 0, 0, 0 } },
	{ "MP5", 		"cw_mp5", 			3, 	"models/weapons/w_smg_mp5.mdl", 		5000, 	{ 0, 0, 0 } },
	{ "M3 Super 90","cw_m3super90", 	4, 	"models/weapons/w_cstm_m3super90.mdl", 	5000, 	{ 0, 0, 0 } },
	{ "G36C", 		"cw_g36c", 			8, "models/weapons/cw20_g36c.mdl", 			15000, 	{ 0, 0, 0 } },
	{ "L115", 		"cw_l115", 			13, "models/weapons/w_cstm_l96.mdl", 		15000, 	{ 0, 0, 0 } },
	{ "G3A3", 		"cw_g3a3", 			17, "models/weapons/w_snip_g3sg1.mdl", 		15000, 	{ 0, 0, 0 } },
	{ "UMP .45", 	"cw_ump45", 		22, "models/weapons/w_smg_ump45.mdl", 		15000, 	{ 0, 0, 0 } },
	{ "M249", 		"cw_m249_official", 26, "models/weapons/cw2_0_mach_para.mdl",	20000, 	{ 0, 0, 0 } },
	{ "AK-74", 		"cw_ak74", 			31, "models/weapons/w_rif_ak47.mdl", 		20000, 	{ 0, 0, 0 } },
	{ "M14", 		"cw_m14", 			35, "models/weapons/w_cstm_m14.mdl", 		20000, 	{ 0, 0, 0 } },
	{ "VSS", 		"cw_vss", 			40, "models/cw2/rifles/w_vss.mdl", 			25000, 	{ 0, 0, 0 } },
	{ "L85A2", 		"cw_l85a2",			44, "models/weapons/w_cw20_l85a2.mdl", 		25000, 	{ 0, 0, 0 } },
	{ "SCAR-H", 	"cw_scarh", 		50, "models/cw2/rifles/w_scarh.mdl", 		25000, 	{ 0, 0, 0 } }
}
SetStats( primaries )

secondaries = {
	{ "P99",			"cw_p99",		0,	"models/weapons/w_pist_p228.mdl",		0,   	{ 0, 0, 0 } },
	{ "M1911",			"cw_m1911",		5,	"models/weapons/cw_pist_m1911.mdl",		3000,  	{ 0, 0, 0 } },
	{ "MR96",			"cw_mr96",		13,	"models/weapons/w_357.mdl",				3000, 	{ 0, 0, 0 } },
	{ "Five Seven",		"cw_fiveseven",	21,	"models/weapons/w_pist_fiveseven.mdl",	5000, 	{ 0, 0, 0 } },
	{ "MAC-11",			"cw_mac11",		29,	"models/weapons/w_cst_mac11.mdl",		10000, 	{ 0, 0, 0 } },
	{ "Super Shorty",	"cw_shorty",	37,	"models/weapons/cw2_super_shorty.mdl",	15000, 	{ 0, 0, 0 } },
	{ "Makarov",		"cw_makarov",	45,	"models/cw2/pistols/w_makarov.mdl",		15000, 	{ 0, 0, 0 } },
	{ "Deagle",			"cw_deagle",	50,	"models/weapons/w_pist_deagle.mdl",		15000, 	{ 0, 0, 0 } },
}
SetStats( secondaries )

extras = {
	{ "Fists", 				"weapon_fists", 	1, "models/weapons/c_arms_citizen.mdl", 			0	 },
	{ "Flash Grenades", 	"cw_flash_grenade",	6, "models/weapons/w_eq_flashbang.mdl", 			2000 },
	{ "Smoke Grenades", 	"cw_smoke_grenade", 11, "models/weapons/w_eq_smokegrenade.mdl", 		5000 },
	{ "Frag Grenade x2",	"grenades", 		17, "models/weapons/w_cw_fraggrenade_thrown.mdl",	5000 },
	{ "Medkit", 			"weapon_medkit", 	26, "models/weapons/w_medkit.mdl", 					10000 }
}

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

net.Receive( "GetULXRank", function( len, ply )
	local rank = 0
	for k, v in next, vip do
		if ply:IsUserGroup( v[ 1 ] ) then
			rank = v[ 2 ]
		end
	end
	net.Start( "GetULXRankCallback" )
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

--[[function FixExploit( ply, wep )
	ply:StripWeapon( wep )
	local ent = ents.Create( wep )
	ent:SetPos( ply:GetPos() )
	ent:Spawn()
end]]

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
			wep:GetOwner():RemoveAmmo( wep:Clip1(), wep:GetPrimaryAmmoType() )
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