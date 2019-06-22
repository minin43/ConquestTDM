--// WEAPON FORMATING:
--// { "name", "class", level unlock, "world model", price, { leave this alone, this is set automatically }
GM.WeaponsList = {
	--//Primaries
	{ "AR-15", 				"cw_ar15", 				0, 	"models/weapons/w_rif_m4a1.mdl", 			0, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "L96A1", 				"cw_b196", 				0, "models/weapons/w_cstm_l96.mdl", 			0, { 0, 0, 0 }, type = "sr", slot = 1 },
	{ "UMP .45", 			"cw_ump45", 			2, "models/weapons/w_smg_ump45.mdl", 			5000, { 0, 0, 0 }, type = "smg", slot = 1 },
    { "M3 Super 90", 		"cw_m3super90", 		5, "models/weapons/w_cstm_m3super90.mdl", 		5000, { 0, 0, 0 }, type = "sg", slot = 1 },
	{ "G3A3", 				"cw_g3a3", 				7, "models/weapons/w_snip_g3sg1.mdl", 			5000, { 0, 0, 0 }, type = "ar", slot = 1 },
	{ "G36C", 				"cw_g36c", 				10, "models/weapons/cw20_g36c.mdl", 			15000, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "CZ Scorpion EVO", 	"cw_scorpin_evo3", 		12, "models/weapons/scorpion/w_ev03.mdl", 		15000, { 0, 0, 0 }, type = "smg", slot = 1 },
	{ "M249", 				"cw_m249_official", 	15, "models/weapons/cw2_0_mach_para.mdl", 		15000, { 0, 0, 0 }, type = "lmg", slot = 1 },
    { "TAC .338", 			"cw_tac338", 			17, "models/weapons/w_snip_TAC338.mdl", 		20000, { 0, 0, 0 }, type = "sr", slot = 1 },
	{ "P90", 				"cw_ber_p90", 			20, "models/weapons/w_dber_p9.mdl", 			20000, { 0, 0, 0 }, type = "smg", slot = 1 },
    { "FAMAS FELIN", 		"cw_ber_famas_felin", 	22, "models/weapons/w_rif_galil.mdl", 			20000, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "SPAS-12", 			"cw_ber_spas12", 		25, "models/weapons/w_dber_franchi12.mdl", 		20000, { 0, 0, 0 }, type = "sg", slot = 1 },
    { "M14", 				"cw_m14", 				27, "models/weapons/w_cstm_m14.mdl", 			30000, { 0, 0, 0 }, type = "sr", slot = 1 },
	{ "RPK-74", 			"cw_amr2_rpk74", 		30, "models/weapons/AMR2/RPK/w_amr2_rpk.mdl", 	30000, { 0, 0, 0 }, type = "lmg", slot = 1 },
	{ "MP5", 				"cw_mp5", 				32, "models/weapons/w_smg_mp5.mdl", 			30000, { 0, 0, 0 }, type = "smg", slot = 1 },
	{ "AK-74", 				"cw_ak74", 				35, "models/weapons/w_rif_ak47.mdl", 			40000, { 0, 0, 0 }, type = "ar", slot = 1 },
	{ "VSS", 				"cw_vss", 				37, "models/cw2/rifles/w_vss.mdl", 				40000, { 0, 0, 0 }, type = "smg", slot = 1 },
	{ "Cheytac M200", 		"cw_wf_m200", 			40, "models/weapons/w_snip_m200.mdl", 			50000, { 0, 0, 0 }, type = "sr", slot = 1 },
	{ "L85A2", 				"cw_l85a2", 			42, "models/weapons/w_cw20_l85a2.mdl", 			50000, { 0, 0, 0 }, type = "ar", slot = 1 },
	{ "MP7", 				"cw_ber_hkmp7", 		45, "models/weapons/w_dber_p7.mdl", 			50000, { 0, 0, 0 }, type = "smg", slot = 1 },
	{ "MK46 Mod 1", 		"cw_amr2_mk46", 		47, "models/weapons/AMR2/MK46/w_amr2_mk46.mdl", 50000, { 0, 0, 0 }, type = "lmg", slot = 1 },
	{ "SCAR-H", 			"cw_scarh", 			50, "models/cw2/rifles/w_scarh.mdl", 			50000, { 0, 0, 0 }, type = "ar", slot = 1 },
	--//Secondaries
	{ "P99",			"cw_p99",		0,	"models/weapons/w_pist_p228.mdl",		0, { 0, 0, 0 }, type = "pt", slot = 2 },
	{ "M1911",			"cw_m1911",		5,	"models/weapons/cw_pist_m1911.mdl",		3000, { 0, 0, 0 }, type = "pt", slot = 2 },
	{ "MR96",			"cw_mr96",		13,	"models/weapons/w_357.mdl",				3000, { 0, 0, 0 }, type = "mn", slot = 2 },
	{ "Five Seven",		"cw_fiveseven",	21,	"models/weapons/w_pist_fiveseven.mdl",	5000, { 0, 0, 0 }, type = "pt", slot = 2 },
	{ "MAC-11",			"cw_mac11",		29,	"models/weapons/w_cst_mac11.mdl",		10000, { 0, 0, 0 }, type = "smg", slot = 2 },
	{ "Super Shorty",	"cw_shorty",	37,	"models/weapons/cw2_super_shorty.mdl",	15000, { 0, 0, 0 }, type = "sg", slot = 2 },
	{ "Makarov",		"cw_makarov",	45,	"models/cw2/pistols/w_makarov.mdl",		20000, { 0, 0, 0 }, type = "pt", slot = 2 },
	{ "Deagle",			"cw_deagle",	50,	"models/weapons/w_pist_deagle.mdl",		30000, { 0, 0, 0 }, type = "mn", slot = 2 },
	--//Equipment
	{ "Fists", 				"weapon_fists", 	1, "models/weapons/c_arms_citizen.mdl", 			0, type = "eq", slot = 3 },
	{ "Flash Grenades", 	"cw_flash_grenade",	6, "models/weapons/w_eq_flashbang.mdl", 			2000, type = "eq", slot = 3 },
	{ "Slow Medkit", 		"medkit_slow",		11, "models/weapons/w_medkit.mdl",					5000, type = "eq", slot = 3 },
	{ "Smoke Grenades", 	"cw_smoke_grenade", 18, "models/weapons/w_eq_smokegrenade.mdl", 		5000, type = "eq", slot = 3 },
	{ "Fast Medkit", 		"medkit_fast", 		26, "models/weapons/w_medkit.mdl", 					10000, type = "eq", slot = 3 },
	{ "Frag Grenade x2",	"grenades", 		35, "models/weapons/w_cw_fraggrenade_thrown.mdl",	10000, type = "eq", slot = 3 },
	{ "Large Medkit", 		"medkit_full", 		45, "models/weapons/w_medkit.mdl", 					15000, type = "eq", slot = 3 }
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