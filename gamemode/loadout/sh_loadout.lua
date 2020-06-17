--// WEAPON FORMATING:
--// { "Print name", "Class_name", level unlock, "world/model", price, { leave this alone, this is set automatically }, "type", slot }
GM.WeaponsList = {
	--//Primaries
	{ "AR-15", 				"cw_ar15", 				0, 	"models/weapons/w_rif_m4a1.mdl", 			        0, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "L96A1", 				"cw_b196", 				0, "models/weapons/w_cstm_l96.mdl", 			        0, { 0, 0, 0 }, type = "sr", slot = 1 },
    { "UMP .45", 			"cw_ump45", 			3, "models/weapons/w_smg_ump45.mdl", 			        5000, { 0, 0, 0 }, type = "smg", slot = 1 },
    { "QBZ-97", 			"cw_tr09_qbz97", 		6, "models/weapons/therambotnic09/w_cw2_qbz97.mdl", 	5000, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "M3 Super 90", 		"cw_m3super90", 		9, "models/weapons/w_cstm_m3super90.mdl", 		        5000, { 0, 0, 0 }, type = "sg", slot = 1 },
    { "G3A3", 				"cw_g3a3", 				12, "models/weapons/w_snip_g3sg1.mdl", 			        10000, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "MP9", 			    "cw_tr09_mp9", 		    16, "models/weapons/therambotnic09/w_cw2_mp9.mdl", 	    10000, { 0, 0, 0 }, type = "smg", slot = 1 },
    { "Dragunov SVD", 		"bo2r_svu", 		    19, "models/weapons/w_bo2_svu.mdl", 	                15000, { 0, 0, 0 }, type = "sr", slot = 1 },
	{ "G36C", 				"cw_g36c", 				22, "models/weapons/cw20_g36c.mdl", 			        20000, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "Scorpion EVO", 	    "cw_scorpin_evo3", 		25, "models/weapons/scorpion/w_ev03.mdl", 		        20000, { 0, 0, 0 }, type = "smg", slot = 1 },
    { "TAC .338", 			"cw_tac338", 			28, "models/weapons/w_snip_TAC338.mdl", 		        25000, { 0, 0, 0 }, type = "sr", slot = 1 },
    { "M27", 				"bo2r_m27", 			32, "models/weapons/w_bo2_m27.mdl", 			        30000, { 0, 0, 0 }, type = "ar", slot = 1 },
	{ "P90", 				"cw_ber_p90", 			35, "models/weapons/w_dber_p9.mdl", 			        30000, { 0, 0, 0 }, type = "smg", slot = 1 },
    { "Remington R5", 		"r5", --[[really?]]	    38, "models/cw2/weapons/w_r5.mdl", 			            35000, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "SPAS-12", 			"cw_ber_spas12", 		41, "models/weapons/w_dber_franchi12.mdl", 		        40000, { 0, 0, 0 }, type = "sg", slot = 1 },
    { "ACR-E", 		        "cw_killdrix_acre",	    44, "models/weapons/killdrix/w_acre.mdl", 			    40000, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "M14", 				"cw_m14", 				48, "models/weapons/w_cstm_m14.mdl", 			        45000, { 0, 0, 0 }, type = "sr", slot = 1 },
	{ "MP5", 				"cw_mp5", 				51, "models/weapons/w_smg_mp5.mdl", 			        50000, { 0, 0, 0 }, type = "smg", slot = 1 },
	{ "AK-74", 				"cw_ak74", 				54, "models/weapons/w_rif_ak47.mdl", 			        50000, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "VSS", 				"cw_vss", 				57, "models/cw2/rifles/w_vss.mdl", 				        55000, { 0, 0, 0 }, type = "smg", slot = 1 },
    { "AUG-A3", 			"cw_tr09_auga3", 		60, "models/weapons/therambotnic09/w_cw2_auga3.mdl", 	60000, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "Icarus-37",          "cwc_icarus37",         64, "models/weapons/cwc_icarus37/w_cturix_icarus37.mdl",60000, { 0, 0, 0 }, type = "sg", slot = 1 },
    { "Peacekeeper", 		"bo2r_peacekeeper", 	67, "models/weapons/w_bo2_peacekeeper.mdl", 	        65000, { 0, 0, 0 }, type = "ar", slot = 1 },
	{ "Cheytac M200", 		"cw_wf_m200", 			70, "models/weapons/w_snip_m200.mdl", 			        70000, { 0, 0, 0 }, type = "sr", slot = 1 },
	{ "L85A2", 				"cw_l85a2", 			73, "models/weapons/w_cw20_l85a2.mdl", 			        70000, { 0, 0, 0 }, type = "ar", slot = 1 },
	{ "MP7", 				"cw_ber_hkmp7", 		76, "models/weapons/w_dber_p7.mdl", 			        75000, { 0, 0, 0 }, type = "smg", slot = 1 },
    { "AAC Honeybadger", 	"cw_aacgsm", 		    80, "models/cw2/gsm/w_gsm_aac.mdl",                     80000, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "M1014", 			    "cw_m1014", 		    83, "models/weapons/w_4hot_xm1014.mdl", 	            80000, { 0, 0, 0 }, type = "sg", slot = 1 },
    { "SCAR-H", 			"cw_scarh", 			86, "models/cw2/rifles/w_scarh.mdl", 			        80000, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "HK-416", 			"cw_kk_hk416", 			89, "models/weapons/w_cwkk_hk416.mdl", 			        85000, { 0, 0, 0 }, type = "ar", slot = 1 },
    { "R870 MCS", 		    "bo2r_870mcs", 		    92, "models/weapons/w_bo2_870mcs.mdl", 		            90000, { 0, 0, 0 }, type = "sg", slot = 1 },
    { "RFB", 			    "cw_weapon_rfb", 		96, "models/weapons/w_snip_rfb.mdl", 	                90000, { 0, 0, 0 }, type = "sr", slot = 1 },
    { "TAR-21", 			"cw_tr09_tar21", 		99, "models/weapons/therambotnic09/w_cw2_tar21.mdl", 	95000, { 0, 0, 0 }, type = "ar", slot = 1 },
    --//For funzies
    { "M249", 				"cw_m249_official", 	100, "models/weapons/cw2_0_mach_para.mdl", 		        100000, { 0, 0, 0 }, type = "lmg", slot = 1 },
    { "HAMR", 				"bo2r_hamr", 	        100, "models/weapons/w_bo2_hamr.mdl", 		            100000, { 0, 0, 0 }, type = "lmg", slot = 1 },
    { "MP7 Alt",			"bo2r_mp7", 		    100, "models/weapons/w_bo2_mp7.mdl", 			        100000, { 0, 0, 0 }, type = "smg", slot = 1 },
	--//Secondaries
	{ "P99",			"cw_p99",		    0,	"models/weapons/w_pist_p228.mdl",		0,      { 0, 0, 0 }, type = "pt", slot = 2 },
	{ "M1911",			"cw_m1911",		    11,	"models/weapons/cw_pist_m1911.mdl",		5000,   { 0, 0, 0 }, type = "pt", slot = 2 },
	{ "MR96",			"cw_mr96",		    22,	"models/weapons/w_357.mdl",				10000,  { 0, 0, 0 }, type = "mn", slot = 2 },
	{ "Five Seven",		"cw_fiveseven",	    33,	"models/weapons/w_pist_fiveseven.mdl",	15000,  { 0, 0, 0 }, type = "pt", slot = 2 },
	{ "MAC-11",			"cw_mac11",		    44,	"models/weapons/w_cst_mac11.mdl",		20000,  { 0, 0, 0 }, type = "smg", slot = 2 },
	{ "Super Shorty",	"cw_shorty",	    55,	"models/weapons/cw2_super_shorty.mdl",	25000,  { 0, 0, 0 }, type = "sg", slot = 2 },
    { "Makarov",		"cw_makarov",	    66,	"models/cw2/pistols/w_makarov.mdl",		30000,  { 0, 0, 0 }, type = "pt", slot = 2 },
    { "TEC-9", 			"cw_weapon_tec9", 	77, "models/weapons/w_bfh_tec9.mdl", 	    35000,  { 0, 0, 0 }, type = "smg", slot = 2 },
    { "Deagle",			"cw_deagle",	    88, "models/weapons/w_pist_deagle.mdl",		40000,  { 0, 0, 0 }, type = "mn", slot = 2 },
    { "B23R",		    "bo2r_b23r",	    99,	"models/weapons/w_bo2_b23r.mdl",	    45000,  { 0, 0, 0 }, type = "pt", slot = 2 },
	--//Equipment
    --[[{ "Fists", 				"weapon_fists", 	1, "models/weapons/c_arms_citizen.mdl", 			0, type = "eq", slot = 3,
        desc = "Give 'em the 'ol 1-2" },]]
	{ "Flash Grenades", 	"cw_flash_grenade",	8, "models/weapons/w_eq_flashbang.mdl", 			5000,   type = "eq",    slot = 3,
        desc = "2x flashbangs which blind all players near the grenade when detonated." },
	{ "Slow Medkit", 		"medkit_slow",		16, "models/weapons/w_medkit.mdl",					5000,   type = "eq",    slot = 3,
        desc = "Heal friendlies 10 HP with the primary attack, or yourself with the secondary attack. Slowly regenerates ammo." },
    { "Flak Jacket",        "flak",             24, "models/dayz/vest_police.mdl",                  10000,  type = "eq",    slot = 3,
        desc = "Reduces damage from explosions by 75%." },
	{ "Smoke Grenades", 	"cw_smoke_grenade", 32, "models/weapons/w_eq_smokegrenade.mdl",         15000,  type = "eq",    slot = 3,
        desc = "3x smoke grenades to block sightlines." },
    { "Adrenaline Shot",    "sg_adrenaline",    40, "models/pg_props/pg_stargate/pg_shot.mdl",      20000,  type = "eq",    slot = 3,   --Outside addon/SWEP
        desc = "Heals the user slightly, and grants a temporary movement boost." },
    { "Impulse Grenade",    "impulse_grenade",  48, "models/impulse_grenade/impulse_grenade.mdl",   20000,  type = "eq",    slot = 3,   --Outside addon/SWEP
        desc = "2x impulse grenades, launches yourself and enemies into the air." },
	{ "Fast Medkit", 		"medkit_fast", 		56, "models/weapons/w_medkit.mdl", 					25000,  type = "eq",    slot = 3,
        desc = "Heal friendlies 20 HP with the primary attack, or yourself with the secondary attack. Limited ammo capacity. Slowly regenerates ammo." },
	{ "Frag Grenade x2",	"grenades", 		64, "models/weapons/w_cw_fraggrenade_thrown.mdl",	30000,  type = "eq",    slot = 3,
        desc = "2x frag grenades. Kills stuff. Does not damage yourself or friendlies." },
    { "Hyperweave Vest",    "hyperweave",       72, "models/danguyenvest/militaryvest.mdl",         35000,  type = "eq",    slot = 3,
        desc = "Reduces damage from high-caliber weapons by 10% and damage from explosions by 50%." },
    { "Large Medkit", 		"medkit_full", 		80, "models/weapons/w_medkit.mdl", 					40000,  type = "eq",    slot = 3,
        desc = "Heal yourself 1/2 your missing HP with the secondary attack. Cannot heal friendlies. Large ammo capacity. Extremely slowly regenerates ammo." },
    { "Hexshield Grenade",  "weapon_hexshield", 88, "models/weapons/w_hexshield_grenade.mdl",       40000,  type = "eq",    slot = 3,  --Outside addon/SWEP
        desc = "Generates a temporary force field anyone can enter and exit." },
    --//VIP Weapons
    --{ "CODOL FATE",         "cwc_fate",         0, "models/weapons/cwc_fate/w_rif_m4a1.mdl",        0, type = "ar", slot = 1, vip = true },
    { "The Box",            "weapon_cbox",      0, "models/gmod_tower/stealth box/box.mdl",         0, type = "eq", slot = 3, vip = true,
        desc = "Crouching with this equipped renders you nearly-invisible, perfect for surprise attacks. Left-click to taunt other players." },
    { "LR300",              "cw_tr09_lr300",    0, "models/weapons/therambotnic09/w_cw2_lr300.mdl", 0, type = "ar", slot = 1, vip = true },
    { "PP19 Bizon",         "cw_bizongsm",      0, "models/cw2/gsm/w_gsm_bizon.mdl",                0, type = "smg", slot = 1, vip = true },
    { "G2 Contender",       "cw_contender",     0, "models/cw2/pistols/w_contender.mdl",            0, type = "sr", slot = 2, vip = true },
    { "Silverballer",       "cw_silverballer",  0, "models/weapons/w_silverballer.mdl",             0, type = "pt", slot = 2, vip = true },
}

function RetrieveWeaponName( wepclass )
    for k, v in pairs( GAMEMODE.WeaponsList ) do
        if v[ 2 ] == wepclass then
            return v[ 1 ]
        end
    end
    return nil
end

function RetrieveWeaponTable( wepclass )
    for k, v in pairs( GAMEMODE.WeaponsList ) do
        if v[ 2 ] == wepclass then
            return v
        end
    end
    return nil
end

function IsDefaultWeapon( wepclass )
    if !GAMEMODE.CachedDefaultWeapons then
        GAMEMODE.CachedDefaultWeapons = {}
        for k, v in pairs( GAMEMODE.WeaponsList ) do
            if v[2] == wepclass then
                if (v[ 3 ] == 1 or v[ 3 ] == 0) and (v[ 5 ] == 0) then
                    GAMEMODE.CachedDefaultWeapons[wepclass] = true
                end
            end
        end
    end
    return GAMEMODE.CachedDefaultWeapons[wepclass] or false
end

function isPrimary( class )
	for k, v in next, GAMEMODE.WeaponsList do
        if class == v[ 2 ] then
			return v.slot == 1
		end
	end
	
	return false
end

function isSecondary( class )
	for k, v in next, GAMEMODE.WeaponsList do
        if class == v[ 2 ] then
			return v.slot == 2
		end
	end
	
	return false
end

function isExtra( class )
	for k, v in next, GAMEMODE.WeaponsList do
        if class == v[ 2 ] then
			return v.slot == 3
		end
	end
	
	return false
end

function isUnique( class )
    for k, v in pairs( GAMEMODE.WeaponsList ) do
        if class == v[ 2 ] then
            return true
        end
    end
    return false
end

function IsNonSwepEquipment( class )
    for k, v in pairs( GAMEMODE.WeaponsList ) do
        if class == v[ 2 ] then
            return !weapons.Get( class )
        end
    end
    return false
end