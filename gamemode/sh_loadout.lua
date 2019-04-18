--// WEAPON FORMATING:
--// { "name", "class", level unlock, "world model", price, { leave this alone, this is set automatically }
GM.PrimariesList = {
	{ "AR-15", 				"cw_ar15", 				0, 	"models/weapons/w_rif_m4a1.mdl", 		0, { 0, 0, 0 } },
	{ "UMP .45", 			"cw_ump45", 			2, "models/weapons/w_smg_ump45.mdl", 		5000, { 0, 0, 0 } },
	{ "M3 Super 90", 		"cw_m3super90", 		5, "models/weapons/w_cstm_m3super90.mdl", 	5000, { 0, 0, 0 } },
	{ "G36C", 				"cw_g36c", 				7, "models/weapons/cw20_g36c.mdl", 			10000, { 0, 0, 0 } },
	{ "L96A1", 				"cw_b196", 				10, "models/weapons/w_cstm_l96.mdl", 		10000, { 0, 0, 0 } },
	{ "CZ Scorpion EVO", 	"cw_scorpin_evo3", 		13, "models/weapons/scorpion/w_ev03.mdl", 	15000, { 0, 0, 0 } },
	{ "G3A3", 				"cw_g3a3", 				15, "models/weapons/w_snip_g3sg1.mdl", 		15000, { 0, 0, 0 } },
	{ "SPAS-12", 			"cw_ber_spas12", 		17, "models/weapons/w_dber_franchi12.mdl", 	15000, { 0, 0, 0 } },
	{ "P90", 				"cw_ber_p90", 			20, "models/weapons/w_dber_p9.mdl", 		15000, { 0, 0, 0 } },
	{ "M249", 				"cw_m249_official", 	22, "models/weapons/cw2_0_mach_para.mdl", 	15000, { 0, 0, 0 } },
	{ "FAMAS FELIN", 		"cw_ber_famas_felin", 	25, "models/weapons/w_rif_galil.mdl", 		20000, { 0, 0, 0 } },
	{ "M14", 				"cw_m14", 				28, "models/weapons/w_cstm_m14.mdl", 		20000, { 0, 0, 0 } },
	{ "MP5", 				"cw_mp5", 				30, "models/weapons/w_smg_mp5.mdl", 		20000, { 0, 0, 0 } },
	{ "AK-74", 				"cw_ak74", 				33, "models/weapons/w_rif_ak47.mdl", 		20000, { 0, 0, 0 } },
	{ "VSS", 				"cw_vss", 				35, "models/cw2/rifles/w_vss.mdl", 			20000, { 0, 0, 0 } },
	{ "L115", 				"cw_l115", 				38, "models/weapons/w_cstm_l96.mdl", 		20000, { 0, 0, 0 } },
	{ "L85A2", 				"cw_l85a2", 			40, "models/weapons/w_cw20_l85a2.mdl", 		30000, { 0, 0, 0 } },
	{ "MP7", 				"cw_ber_hkmp7", 		42, "models/weapons/w_dber_p7.mdl", 		30000, { 0, 0, 0 } },
	{ "SCAR-H", 			"cw_scarh", 			45, "models/cw2/rifles/w_scarh.mdl", 		30000, { 0, 0, 0 } }
	--{ "RPK", "", 0, "", 0, { 0, 0, 0 } },
	--{ "", "", 0, "", 0, { 0, 0, 0 } },
}

GM.SecondariesList = {
	{ "P99",			"cw_p99",		0,	"models/weapons/w_pist_p228.mdl",		0, { 0, 0, 0 } },
	{ "M1911",			"cw_m1911",		5,	"models/weapons/cw_pist_m1911.mdl",		3000, { 0, 0, 0 } },
	{ "MR96",			"cw_mr96",		13,	"models/weapons/w_357.mdl",				3000, { 0, 0, 0 } },
	{ "Five Seven",		"cw_fiveseven",	21,	"models/weapons/w_pist_fiveseven.mdl",	5000, { 0, 0, 0 } },
	{ "MAC-11",			"cw_mac11",		29,	"models/weapons/w_cst_mac11.mdl",		10000, { 0, 0, 0 } },
	{ "Super Shorty",	"cw_shorty",	37,	"models/weapons/cw2_super_shorty.mdl",	15000, { 0, 0, 0 } },
	{ "Makarov",		"cw_makarov",	45,	"models/cw2/pistols/w_makarov.mdl",		15000, { 0, 0, 0 } },
	{ "Deagle",			"cw_deagle",	50,	"models/weapons/w_pist_deagle.mdl",		15000, { 0, 0, 0 } }
}

GM.EquipmentList = {
	{ "Fists", 				"weapon_fists", 	1, "models/weapons/c_arms_citizen.mdl", 			0 },
	{ "Flash Grenades", 	"cw_flash_grenade",	6, "models/weapons/w_eq_flashbang.mdl", 			2000 },
	{ "Smoke Grenades", 	"cw_smoke_grenade", 11, "models/weapons/w_eq_smokegrenade.mdl", 		5000 },
	{ "Frag Grenade x2",	"grenades", 		17, "models/weapons/w_cw_fraggrenade_thrown.mdl",	5000 },
	{ "Medkit", 			"weapon_medkit", 	26, "models/weapons/w_medkit.mdl", 					10000 }
}

--[[	Perk table - used for your reference only
	Packrat -Ammo			- 1
	Hunter -Movement		- 5
	Vengeance -Misc			- 10
	Regeneration -Life		- 14
	Slaw					- 19
	Headpopper -Sniper		- 23
	Thornmail -Misc			- 28
	Excited -Movement		- 32
	Leech -Life				- 37
	Pyromancer -Misc		- 41
	Vulture -Sniper			- 46
	Lifeline -Life/Movement	- 50
]]