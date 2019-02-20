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

--==
--== WEAPON FORMATING
--==

--== { <weapon name>, <class>, <unlock level>, <world model>, <cost>, { <damage>, <accuracy>, <rate of fire> } }
--== 
--        these values should be a rating out of 100 -- UnluckyWoof!	                                                       
--[[primaries = {
	{ "M16A2", 			"cw_m16_bo", 				0, 	"models/cw2/weapons/w_cod_bo_m16.mdl", 		    0, { 60, 60, 71.4 } },
	{ "M40A1",			"luke_m40a1", 				0,	"models/weapons/w_luke_m40a1.mdl",		0, { 85, 80, 30 } },
	{ "Daewoo K7",			"luke_gu7", 				0,	"models/weapons/w_ma85_wf_gu7.mdl",		0, { 20, 50, 80 } },
	{ "Remington 870",			"luke_rem_870", 				0,	"models/weapons/w_luke_870.mdl",		0, { 70, 50, 30 } },
	{ "AK-12",			"luke_ak12",				7,	"models/weapons/w_luke_ak12.mdl",		15000, { 46, 100, 40 } },
  	{ "Model 1887",			"luke_mw3_model_1887",			10,	"models/weapons/w_luke_model1887.mdl",		10000, { 80, 20, 20 } },
 	{ "STG-44",			"luke_stg",			10,	"models/weapons/w_cyber_stg.mdl",		10000, { 60, 70, 40 } },
	{ "MX4 Storm",			"luke_mx4_storm",			12,	"models/weapons/w_luke_mx4storm.mdl",		10000, { 30, 50, 80 } },
	{ "Bushmaster ACR",			"luke_bushmaster_acr",				18,	"models/weapons/w_luke_bushmasteracr.mdl",		14000, { 35, 80, 60 } },
	{ "CBJ-MS",			"luke_cbjms",				22,	"models/weapons/w_luke_cbjms.mdl",		10000, { 33, 77, 60 } },
	{ "KSG-12",			"luke_multi_ksg",			29,	"models/weapons/w_luke_ksg.mdl",		17500, { 80, 30, 30 } },
	{ "AWS",			"luke_aws",				34,	"models/weapons/w_luke_aws.mdl",		20000, { 40, 70, 65 } },
	{ "Mcmillan CS5",			"luke_cs5",				36,	"models/weapons/w_luke_cs5.mdl",		17000, { 85, 96, 45 } },
	{ "SCAR-H",			"luke_scarh",				37,	"models/weapons/w_luke_scarh.mdl",		15000, { 60, 70, 50 } },
	{ "M4 Carbine",			"luke_m4_carbine",			38,	"models/weapons/w_luke_m4_carbine.mdl",		14000, { 38, 70, 67 } },
	{ "MK14-EBR",			"luke_mw3_m14_ebr",			45,	"models/weapons/w_luke_mw3m14ebr.mdl",		14000, { 70, 80, 45 } },
	{ "CZ Skorpion EVO",			"luke_skorpion_evo",			48,	"models/weapons/w_luke_skorpionevo.mdl",		10000, { 20, 40, 100 } },
	{ "FN Ballista",			"luke_fnballista",			50,	"models/weapons/w_luke_fnballista.mdl",		17000, { 90, 100, 35 } },
	{ "Scar-L PDW",			"luke_scarl_pdw",			50,	"models/weapons/w_cyber_scarlpdw.mdl",		10000, { 40, 75, 60 } },
	{ "FAD",			"luke_fad",			54,	"models/weapons/w_luke_fad.mdl",		10000, { 38, 50, 70 } },
	{ "AUG-A3 9mmXS",		"luke_auga3_9mmxs",			57,	"models/weapons/w_wf_a39mmxs.mdl",		10000, { 33, 67, 72 } },
	{ "Scar-H SV",			"luke_scarhsv",				65,	"models/weapons/w_dber_scarm.mdl",		14000, { 70, 80, 45 } },
	{ "MK-48",			"luke_mk48",				71,	"models/weapons/w_cyber_mk48.mdl",		20000, { 60, 50, 50 } },
	{ "AS-VAL",			"luke_asval",				73,	"models/weapons/w_luke_asval.mdl",		10000, { 34, 60, 75 } },
	{ "DSR-50",			"luke_dsr50",				76,	"models/weapons/w_luke_dsr50.mdl",		17000, { 100, 95, 32 } },
	{ "AEK-971",			"luke_aek971",				80,	"models/weapons/w_luke_aek971.mdl",		15000, { 34, 60, 76 } },
	{ "AN-94",			"luke_an94",				90,	"models/weapons/w_luke_an94.mdl",		15000, { 36, 78, 56 } },
	{ "Cam's Galil-Chan",			"luke_galilchan",				201,	"models/weapons/w_luke_galilchan.mdl",		0, { 38, 67, 56 } }
}


secondaries = {
	{ "P226",			"luke_p226",				0,	"models/weapons/w_luke_p226.mdl",		0,    { 46, 60, 50 } },
	{ "M1911",			"luke_bo2_m1911",			5,	"models/weapons/w_cyber_1911.mdl",			2500, { 58, 50, 60 } },
	{ "PMM Makarov",		"pmm",					7,	"models/cw2/weapons/w_came_maka.mdl",		2500, { 30, 60, 50 } },
	{ "M9 Beretta",			"luke_main_m9",				10,	"models/weapons/w_luke_m9.mdl",			2500, { 40, 70, 60 } },
	{ "FN Five-SeveN",		"luke_mw3_57",				15,	"models/weapons/w_cyber_mw357.mdl",		2500, { 30, 70, 70 } },
	{ "B23R",			"luke_b23r",				17,	"models/weapons/w_luke_b23r.mdl",		3000, { 40, 60, 80 } },
	{ "Unica-6",			"luke_unica6",				20,	"models/weapons/w_luke_unica6.mdl",		3000, { 70, 80, 40 } },
	{ "MP9",			"luke_mp9",				27,	"models/weapons/w_luke_mp9.mdl",		5000, { 300, 50, 80 } },
	{ "FN-FNP 45",			"luke_fnp45",				30,	"models/weapons/w_luke_fnp45.mdl",		2500, { 50, 60, 50 } },
	{ "CZ-75",			"luke_cz75",				40,	"models/weapons/w_luke_cz75.mdl",		2500, { 40, 50, 60 } },
	{ "Desert Eagle",		"luke_deagle",				50,	"models/weapons/w_luke_cooldeagle.mdl",		5000, { 80, 50, 30 } },
	{ "KAP-40",			"luke_kap40",				70,	"models/weapons/w_luke_kap40.mdl",		5000, { 40, 60, 80 } },
	{ "Majestic-6",			"Crysis2Majestic",			80,	"models/cw2/weapons/w_came_ma2est.mdl",		5000, { 80, 70, 50 } },
	{ "Lusa Silvia's Glock",		"luke_hothellsglock",				201,	"models/weapons/w_luke_hothellglock.mdl",		0, { 30, 50, 80 } }
		
}

extras = {

	{ "Cam's Neko Equipment", "attachment", 205, "models/Items/BoxMRounds.mdl", 0 },
	{ "Cardboard Box", "weapon_cbox", 201, "models/gmod_tower/stealth box/box.mdl", 0 },
	{ "Fists", "weapon_fists", 0, "models/weapons/c_arms_citizen.mdl", 0 },
	{ "Frag Grenade x2", "grenades", 5, "models/weapons/w_cw_fraggrenade_thrown.mdl", 1000 },
	{ "Flash Grenade x2", "cw_flash_grenade", 10, "models/weapons/w_eq_flashbang.mdl", 1000 },
	{ "Smoke Grenade x2", "cw_smoke_grenade", 15, "models/weapons/w_eq_smokegrenade.mdl", 1000 },
	{ "Medkit", "weapon_medkit", 40, "models/weapons/w_medkit.mdl", 1000 },
	{ "Medic Bag", "sg_medkit", 65, "models/pg_props/pg_weapons/pg_healthkit_w.mdl", 1000 },
}]]

primaries = {
	{ "AK-74", 		"cw_ak74", 		0, 	"models/weapons/w_rif_ak47.mdl", 		0, 	{ 0, 0, 0} },
	{ "AR-15", 		"cw_ar15", 		1, 	"models/weapons/w_rif_m4a1.mdl", 		100, 	{ 0, 0, 0} },
	{ "G3A3", 		"cw_g3a3", 		2, 	"models/weapons/w_snip_g3sg1.mdl", 		100, 	{ 0, 0, 0} },
	{ "L115", 		"cw_l115", 		3, 	"models/weapons/w_cstm_l96.mdl", 		100, 	{ 0, 0, 0} },
	{ "MP5", 		"cw_mp5", 		4, 	"models/weapons/w_smg_mp5.mdl", 		100, 	{ 0, 0, 0} },
	{ "G36C", 		"cw_g36c", 		5, 	"models/weapons/cw20_g36c.mdl", 		100, 	{ 0, 0, 0} },
	{ "M3 Super 90","cw_m3super90", 6, 	"models/weapons/w_cstm_m3super90.mdl", 	100, 	{ 0, 0, 0} },
	{ "M14", 		"cw_m14", 		7, 	"models/weapons/w_cstm_m14.mdl", 		100, 	{ 0, 0, 0} },
	{ "SCAR-H", 	"cw_scarh", 	8, 	"models/cw2/rifles/w_scarh.mdl", 		100, 	{ 0, 0, 0} },
	{ "UMP .45", 	"cw_ump45", 	9, "models/weapons/w_smg_ump45.mdl", 		100, 	{ 0, 0, 0} },
	{ "VSS", 		"cw_vss", 		10, "models/cw2/rifles/w_vss.mdl", 			100, 	{ 0, 0, 0} }
}


secondaries = {
	{ "M1911",			"cw_m1911",		0,	"models/weapons/cw_pist_m1911.mdl",		0,   	{ 0, 0, 0 } },
	{ "Deagle",			"cw_deagle",	1,	"models/weapons/w_pist_deagle.mdl",		100,   { 0, 0, 0 } },
	{ "MR96",			"cw_mr96",		2,	"models/weapons/w_357.mdl",				100,   { 0, 0, 0 } },
	{ "Five Seven",		"cw_fiveseven",	3,	"models/weapons/w_pist_fiveseven.mdl",	100,   { 0, 0, 0 } },
	{ "MAC-11",			"cw_mac11",		4,	"models/weapons/w_cst_mac11.mdl",		100,   { 0, 0, 0 } },
	{ "Makarov",		"cw_makarov",	5,	"models/cw2/pistols/w_makarov.mdl",		100,   { 0, 0, 0 } },
	{ "P99",			"cw_p99",		6,	"models/weapons/w_pist_p228.mdl",		100,   { 0, 0, 0 } }
}

extras = {
	{ "Fists", "weapon_fists", 1, "models/weapons/c_arms_citizen.mdl", 0 },
	{ "Frag Grenade x2", "grenades", 0, "models/weapons/w_cw_fraggrenade_thrown.mdl", 0 },
	{ "Flash Grenades", "cw_flash_grenade", 0, "models/weapons/w_eq_flashbang.mdl", 0 },
	{ "Smoke Grenades", "cw_smoke_grenade", 0, "models/weapons/w_eq_smokegrenade.mdl", 0 },
	{ "Medkit", "weapon_medkit", 0, "models/weapons/w_medkit.mdl", 0 }
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

function FixExploit( ply, wep )
	ply:StripWeapon( wep )
	local ent = ents.Create( wep )
	ent:SetPos( ply:GetPos() )
	ent:Spawn()
end

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
                        if toSpawn == nil || toSpawn:GetOwner() == nil then 
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

function GM:WeaponEquip( wep )
	timer.Simple( 0, function() -- this will call the following on the next frame
        if wep == nil || wep:GetOwner() == nil then
            return;
        end -- fixed by cobalt 1/30/16
		if not IsValid( wep:GetOwner() ) then
			return
		end
		local ply = wep:GetOwner()
		if not ply or ply == NULL or ( not ply:IsValid() ) then
			return
		end
		if not ply.spawning then
			ply:RemoveAmmo( wep:Clip1(), wep:GetPrimaryAmmoType() )
		end
	end )
end

hook.Add( "PlayerCanPickupWeapon", "CheckPickups", function( ply, wep )
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

hook.Add( "PlayerDeath", "clearthings", function( ply )
	if ply.LastUsedWep then	
		if not isExtra( ply.LastUsedWep ) then
			local ent = ents.Create( ply.LastUsedWep )
			ent:SetPos( ply:GetPos() )
			ent:Spawn()
			timer.Simple( 15, function()
                if ent == nil || ent:GetOwner() == nil then return end -- fixed by cobalt 1/30/16
				if ent:GetOwner():IsValid() and ent:GetOwner():IsPlayer() then 
				else
					ent:Remove()
				end
			end )
		end
	end
	ply.curprimary = nil
	ply.cursecondary = nil
	ply.curextra = nil
end )