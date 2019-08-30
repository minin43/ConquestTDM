--// WEAPON FORMATING:
--// { "name", "class", level unlock, "world model", price, { leave this alone, this is set automatically }, "type", slot
GM.WeaponsList = {
	--//Primaries
	{ "AR-15", 				"cw_ar15", 				0, 	"models/weapons/w_rif_m4a1.mdl", 			        0, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "L96A1", 				"cw_b196", 				0, "models/weapons/w_cstm_l96.mdl", 			        0, { 0, 0, 0 }, type = "sr", slot = 1 },
    { "UMP .45", 			"cw_ump45", 			4, "models/weapons/w_smg_ump45.mdl", 			        5000, { 0, 0, 0 }, type = "smg", slot = 1 },
    { "QBZ-97", 			"cw_tr09_qbz97", 		8, "models/weapons/therambotnic09/w_cw2_qbz97.mdl", 	10000, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "M3 Super 90", 		"cw_m3super90", 		12, "models/weapons/w_cstm_m3super90.mdl", 		        10000, { 0, 0, 0 }, type = "sg", slot = 1 },
    { "G3A3", 				"cw_g3a3", 				16, "models/weapons/w_snip_g3sg1.mdl", 			        15000, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "MP9", 			    "cw_tr09_mp9", 		    20, "models/weapons/therambotnic09/w_cw2_mp9.mdl", 	    20000, { 0, 0, 0 }, type = "smg", slot = 1 },
	{ "G36C", 				"cw_g36c", 				24, "models/weapons/cw20_g36c.mdl", 			        30000, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "CZ Scorpion EVO", 	"cw_scorpin_evo3", 		28, "models/weapons/scorpion/w_ev03.mdl", 		        30000, { 0, 0, 0 }, type = "smg", slot = 1 },
    { "TAC .338", 			"cw_tac338", 			32, "models/weapons/w_snip_TAC338.mdl", 		        30000, { 0, 0, 0 }, type = "sr", slot = 1 },
	{ "P90", 				"cw_ber_p90", 			36, "models/weapons/w_dber_p9.mdl", 			        30000, { 0, 0, 0 }, type = "smg", slot = 1 },
    { "Remington R5", 		"r5", --[[really?]]	    40, "models/cw2/weapons/w_r5.mdl", 			            30000, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "SPAS-12", 			"cw_ber_spas12", 		44, "models/weapons/w_dber_franchi12.mdl", 		        30000, { 0, 0, 0 }, type = "sg", slot = 1 },
    { "M14", 				"cw_m14", 				48, "models/weapons/w_cstm_m14.mdl", 			        50000, { 0, 0, 0 }, type = "sr", slot = 1 },
	{ "MP5", 				"cw_mp5", 				52, "models/weapons/w_smg_mp5.mdl", 			        50000, { 0, 0, 0 }, type = "smg", slot = 1 },
	{ "AK-74", 				"cw_ak74", 				56, "models/weapons/w_rif_ak47.mdl", 			        50000, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "VSS", 				"cw_vss", 				60, "models/cw2/rifles/w_vss.mdl", 				        50000, { 0, 0, 0 }, type = "smg", slot = 1 },
    { "AUG-A3", 			"cw_tr09_auga3", 		64, "models/weapons/therambotnic09/w_cw2_auga3.mdl", 	50000, { 0, 0, 0 }, type = "ar", slot = 1 },
	{ "Cheytac M200", 		"cw_wf_m200", 			68, "models/weapons/w_snip_m200.mdl", 			        50000, { 0, 0, 0 }, type = "sr", slot = 1 },
	{ "L85A2", 				"cw_l85a2", 			72, "models/weapons/w_cw20_l85a2.mdl", 			        75000, { 0, 0, 0 }, type = "ar", slot = 1 },
	{ "MP7", 				"cw_ber_hkmp7", 		76, "models/weapons/w_dber_p7.mdl", 			        75000, { 0, 0, 0 }, type = "smg", slot = 1 },
    { "AAC Honeybadger", 	"cw_aacgsm", 		    80, "models/cw2/gsm/w_gsm_aac.mdl",                     75000, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "M1014", 			    "cw_m1014", 		    84, "models/weapons/w_4hot_xm1014.mdl", 	            75000, { 0, 0, 0 }, type = "sg", slot = 1 },
    { "SCAR-H", 			"cw_scarh", 			88, "models/cw2/rifles/w_scarh.mdl", 			        75000, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "RFB", 			    "cw_weapon_rfb", 		92, "models/weapons/w_snip_rfb.mdl", 	                90000, { 0, 0, 0 }, type = "sr", slot = 1 },
    { "TAR-21", 			"cw_tr09_tar21", 		96, "models/weapons/therambotnic09/w_cw2_tar21.mdl", 	90000, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "M249", 				"cw_m249_official", 	100, "models/weapons/cw2_0_mach_para.mdl", 		        100000, { 0, 0, 0 }, type = "lmg", slot = 1 }, --//For funzies
	--//Secondaries
	{ "P99",			"cw_p99",		    0,	"models/weapons/w_pist_p228.mdl",		0, { 0, 0, 0 }, type = "pt", slot = 2 },
	{ "M1911",			"cw_m1911",		    9,	"models/weapons/cw_pist_m1911.mdl",		6000, { 0, 0, 0 }, type = "pt", slot = 2 },
	{ "MR96",			"cw_mr96",		    19,	"models/weapons/w_357.mdl",				6000, { 0, 0, 0 }, type = "mn", slot = 2 },
	{ "Five Seven",		"cw_fiveseven",	    30,	"models/weapons/w_pist_fiveseven.mdl",	10000, { 0, 0, 0 }, type = "pt", slot = 2 },
	{ "MAC-11",			"cw_mac11",		    42,	"models/weapons/w_cst_mac11.mdl",		20000, { 0, 0, 0 }, type = "smg", slot = 2 },
	{ "Super Shorty",	"cw_shorty",	    55,	"models/weapons/cw2_super_shorty.mdl",	30000, { 0, 0, 0 }, type = "sg", slot = 2 },
    { "Makarov",		"cw_makarov",	    69,	"models/cw2/pistols/w_makarov.mdl",		40000, { 0, 0, 0 }, type = "pt", slot = 2 },
    { "TEC-9", 			"cw_weapon_tec9", 	84, "models/weapons/w_bfh_tec9.mdl", 	    60000, { 0, 0, 0 }, type = "smg", slot = 2 },
    { "Deagle",			"cw_deagle",	    100,"models/weapons/w_pist_deagle.mdl",		60000, { 0, 0, 0 }, type = "mn", slot = 2 },
	--//Equipment
	{ "Fists", 				"weapon_fists", 	1, "models/weapons/c_arms_citizen.mdl", 			0, type = "eq", slot = 3 },
	{ "Flash Grenades", 	"cw_flash_grenade",	6, "models/weapons/w_eq_flashbang.mdl", 			4000, type = "eq", slot = 3 },
	{ "Slow Medkit", 		"medkit_slow",		12, "models/weapons/w_medkit.mdl",					10000, type = "eq", slot = 3 },
	{ "Smoke Grenades", 	"cw_smoke_grenade", 19, "models/weapons/w_eq_smokegrenade.mdl", 		10000, type = "eq", slot = 3 },
	{ "Fast Medkit", 		"medkit_fast", 		27, "models/weapons/w_medkit.mdl", 					20000, type = "eq", slot = 3 },
	{ "Frag Grenade x2",	"grenades", 		36, "models/weapons/w_cw_fraggrenade_thrown.mdl",	20000, type = "eq", slot = 3 },
    { "Large Medkit", 		"medkit_full", 		46, "models/weapons/w_medkit.mdl", 					30000, type = "eq", slot = 3 }
    --//Find new slots for: Ammo equipment, tripwire mine
}

--[[	Perk table - used for your reference only
    Packrat -Ammo			- 1
    Crescendo -Combat       - 5
	Hunter -Movement		- 10
    Rebound -Life			- 15
    Frostbite -Combat		- 20
    Headpopper -Sniper		- 25
    Bleedout -Life          - 30
    Martyrdom Combat        - 35
    Double Jump	-Movement	- 40
    Regeneration -Life		- 45
	Thornmail -Combat		- 50
    Vulture -Sniper			- 55
	Excited -Movement		- 60
    Pyromancer -Combat		- 65
    Leech -Life				- 70
    Lifeline -Combat        - 75

    Possible new perk mechanics:
    "The Bonus" - double mags received on flag capture
    "The Grind" - All point generation gets a 5% boost (or some %)
    "The Grind Part 2" - All kills earn double towards attachment progression
    Titan - Every 5th kill earned counts double towards ticket drain & TDM killcount, flag capturing pressure is also doubled
]]

if SERVER then
	function RetrieveWeaponName( wepclass )
		for k, v in pairs( GAMEMODE.WeaponsList ) do
			if v[ 2 ] == wepclass then
				return v[ 1 ]
			end
		end
		return nil
	end
end