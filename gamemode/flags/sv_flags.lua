util.AddNetworkString( "SendFlags" )
util.AddNetworkString( "FlagCapped" )
util.AddNetworkString( "FullFlagReset" )
	
flags = flags or {}

flags[ "gm_construct" ] = {
	{ "L", Vector( -2402, -1560, -143 ), 300, 0 },
	{ "O", Vector( -2250, -2786, 256 ), 400, 0 },
	{ "G", Vector( -845, 564, -160 ), 200, 0 },
	{ "A", Vector( -4531, 5393, -95 ), 400, 0 },
	{ "N", Vector( 1399, -1659, -143 ), 300, 0 }
}
flags[ "sh_lockdown" ] = {
	{ "A", Vector( -1498, -275, -1551 ), 400, 0 },
	{ "B", Vector( -1309, -1662, -1551 ), 100, 0 },
	{ "C", Vector( 818, -1675, -1039 ), 300, 0 },
	{ "D", Vector( 1722, 85, -527 ), 400, 0 },
	{ "E", Vector( 404, 286, -1564 ), 400, 0 }
}
flags[ "sh_lockdown_v2" ] = {
	{ "A", Vector( -1498, -275, -1551 ), 300, 0 },
	{ "B", Vector( -1309, -1662, -1551 ), 100, 0 },
	{ "C", Vector( 818, -1675, -1039 ), 300, 0 },
	{ "D", Vector( 1722, 85, -527 ), 400, 0 },
	{ "E", Vector( 404, 286, -1564 ), 400, 0 }
}
flags[ "gm_freespace_13" ] = {
	{ "A", Vector( -2105, -2126, -14192 ), 400, 0 },
	{ "B", Vector( -2038, 2202, -14440 ), 300, 0 },
	{ "C", Vector( -795, -1037, -14064 ), 500, 0 },
	{ "D", Vector( -6643, -16, -15350 ), 700, 0 },
	{ "E", Vector( -7482, -7422, -15196 ), 800, 0 },
	{ "F", Vector( -2457, -7477, -13312 ), 200, 0 },
	{ "G", Vector( -429, 9688, -15296 ), 600, 0 },
	{ "H", Vector( -12654, -13998, -14865 ), 1000, 0 },
	{ "I", Vector( -14605, 4352, -14832 ), 800, 0 }
}	
flags[ "de_dust2" ] = {
	{ "A", Vector( 1132, 2456, 96 ), 400, 0 },
	{ "B", Vector( -1543, 2650, 1 ), 400, 0 },
	{ "C", Vector( -1973, 1160, 32 ), 400, 0 },
	{ "D", Vector( 577, -213, 4 ), 400, 0 },
	{ "E", Vector( -207, 1147, 0 ), 400, 0 }
}
flags[ "de_train" ] = {
	{ "A", Vector( 408, 367, -230 ), 400, 0 },
	{ "B", Vector( -174, -1283, -288 ), 400, 0 },
	{ "C", Vector( 1404, 1603, -222 ), 400, 0 },
	{ "D", Vector( -987, -998, -151 ), 400, 0 },
	{ "E", Vector( 839, -622, -221 ), 400, 0 }
}

flags[ "de_port" ] = {
	{ "A", Vector( 626, -2529, 776 ), 500, 0 },
	{ "B", Vector( -1073, 45, 512 ), 500, 0 },
	{ "C", Vector( 1116, 195, 645 ), 500, 0 },
	{ "D", Vector( 242, 3714, 496 ), 500, 0 },
	{ "E", Vector( -215, -160, 512 ), 500, 0 }
}

flags[ "cs_office" ] = {
	{ "A", Vector( 1123, -1515, -312 ), 400, 0 },
	{ "B", Vector( -1267, 805, -322 ), 300, 0 },
	{ "C", Vector( 676, -178, -160 ), 200, 0 },
	{ "D", Vector( -517, 171, -160 ), 400, 0 },
	{ "E", Vector( -681, -792, -334 ), 300, 0 }
}
flags[ "de_nuke" ] = {
	{ "A", Vector( 647, -1684, -301 ), 200, 0 },
	{ "B", Vector( 83, -1660, -33 ), 200, 0 },
	{ "C", Vector( 654, -665, -403 ), 200, 0 },
	{ "D", Vector( 601, -954, -753 ), 200, 0 },
	{ "E", Vector( 1570, -2267, -625 ), 200, 0 },
	{ "F", Vector( 666, 669, -465 ), 200, 0 },
	{ "G", Vector( 27, -869, -81 ), 200, 0 }
}

flags[ "gm_valley" ] = {
	{ "A", Vector( -4895, -3804, 99 ), 700, 0 },
	{ "B", Vector( -8028, 7876, -1179 ), 700, 0 },
	{ "C", Vector( 151, 7422, -1308 ), 700, 0 },
	{ "D", Vector( -4991, 295, -1072 ), 700, 0 },
	{ "E", Vector( 5381, -4329, 0 ), 700, 0 },
	{ "F", Vector( -1260, -13467, 0 ), 700, 0 },
	{ "G", Vector( -8710, -13325, 5 ), 700, 0 },
	{ "H", Vector( -12054, -4670, -16 ), 700, 0 },
	{ "I", Vector( -12351, 2196, -1240 ), 700, 0 }
}

flags[ "dm_nuketown" ] = {
	{ "A", Vector( 568, 354, -68 ), 300, 0 },
	{ "B", Vector( 1401, 616, -64 ), 200, 0 },
	{ "C", Vector( -307, 238, -64 ), 200, 0 },
	{ "D", Vector( 1208, -2, -68 ), 100, 0 },
	{ "E", Vector( -8, 1001, -68 ), 100, 0 }
}

flags[ "gm_forestforts" ] = {
	{ "A", Vector( 1172, -3306, 49 ), 400, 0 },
	{ "B", Vector( -84, -359, 27 ), 400, 0 },
	{ "C", Vector( -1175, 3328, 49 ), 300, 0 }
}

flags[ "dm_operationdeaglestorm_alpha2" ] = {
	{ "A", Vector( 2081, -65, 179 ), 400, 0 },
	{ "B", Vector( 3, 8, 495 ), 200, 0 },
	{ "C", Vector( -2102, 145, 179 ), 200, 0 }
}

flags[ "dm_island17" ] ={
	{ "A", Vector( -2, 165, 928 ), 300, 0 },
	{ "B", Vector( -250, 2014, 24 ), 300, 0 },
	{ "C", Vector( -1354, -694, -184 ), 200, 0 }
}

flags[ "sh_map_finala15" ] ={
	{ "A", Vector( -930, 314, -502 ), 133, 0 },
	{ "B", Vector( -657, -1043, -504 ), 400, 0 },
	{ "C", Vector( -1199, -2047, -504 ), 300, 0 },
	{ "D", Vector( -2345, -1040, 200 ), 400, 0 }
}

flags[ "gm_bay" ] ={
	{ "A", Vector( -3464, 1536, 264 ), 200, 0 },
	{ "B", Vector( 37, 4724, 160 ), 400, 0 },
	{ "C", Vector( 841, -1639, 156 ), 200, 0 }
}

flags[ "gm_toysoldiers" ] ={
	{ "A", Vector( 180, 357, -400 ), 400, 0 },
	{ "B", Vector( 1648, 5655, -88 ), 400, 0 },
	{ "C", Vector( 263, -4112, -228 ), 400, 0 },
	{ "D", Vector( -3525, 1586, -382 ), 400, 0 },
	{ "E", Vector( -4671, -5355, -438 ), 400, 0 }
}

flags[ "de_asia" ] ={
	{ "A", Vector( -828, 133, -64 ), 400, 0 },
	{ "B", Vector( -831, -834, 139 ), 450, 0 },
	{ "C", Vector( -1597, 2145, 76 ), 450, 0 }
}

flags[ "de_nightfever" ] ={
	{ "A", Vector( 1816, 3168, 224 ), 300, 0 },
	{ "B", Vector( -438, 3074, 118 ), 400, 0 },
	{ "C", Vector( 799, 2168, 32 ), 400, 0 }
}

flags[ "cs_east_borough" ] ={
	{ "A", Vector( -1411, -2045, -16 ), 400, 0 },
	{ "B", Vector( 878, -1951, -16 ), 400, 0 },
	{ "C", Vector( 2302, -1951, -16 ), 400, 0 }
}

flags[ "de_vegas_css" ] ={
	{ "A", Vector( 193, 15, 16 ), 200, 0 },
	{ "B", Vector( -831, -2791, 32 ), 200, 0 },
	{ "C", Vector( 592, -1671, 356 ), 290, 0 }
}
flags[ "sh_bloodniron_c1" ] ={
	{ "A", Vector( 325, -14, 64 ), 266, 0 },
	{ "B", Vector( -3070, -521, 384 ), 200, 0 },
	{ "C", Vector( 3327, -448, 784 ), 200, 0 },
	{ "D", Vector( -219, 1042, 640 ), 200, 0 }
}

flags[ "sh_strongdale_2dark" ] ={
	{ "A", Vector( -257, 0, 272 ), 200, 0 },
	{ "B", Vector( 899, -2172, 496 ), 200, 0 },
	{ "C", Vector( -1145, 1921, 272 ), 166, 0 },
	{ "D", Vector( -2176, -1546, 272 ), 200, 0 },
	{ "E", Vector( 2110, 258, 496 ), 200, 0 }
}

flags[ "sh_vespene_c1" ] ={
	{ "A", Vector( 0, 0, 448 ), 200, 0 },
	{ "B", Vector( -2752, 0, 304 ), 200, 0 },
	{ "C", Vector( 2752, 0, 304 ), 200, 0 }
}

flags[ "sh_voxelgrounds_c1" ] ={
	{ "A", Vector( -35, -24, 455 ), 466, 0 },
	{ "B", Vector( 0, 2192, 168 ), 200, 0 },
	{ "C", Vector( 39, -2869, 368 ), 300, 0 }
}

flags[ "dm_autoroute" ] ={
	{ "A", Vector( 1093, 1625, 12 ), 300, 0 },
	{ "B", Vector( 0, 0, 266 ), 200, 0 },
	{ "C", Vector( 0, 0, 0 ), 200, 0 },
	{ "D", Vector( -1341, -1627, 16 ), 175, 0 }
}

flags[ "de_contra" ] ={
	{ "A", Vector( -1884, -475, -280 ), 200, 0 },
	{ "B", Vector( -67, 83, -208 ), 200, 0 },
	{ "C", Vector( 1531, 766, -256 ), 200, 0 }
}

flags[ "de_cpl_fire" ] ={
	{ "A", Vector( 2271, 719, -32 ), 200, 0 },
	{ "B", Vector( 1411, 1151, -224 ), 250, 0 }
}

flags[ "de_cpl_mill" ] ={
	{ "A", Vector( 16, 1216, -112 ), 200, 0 },
	{ "B", Vector( 1872, 2592, 208 ), 277, 0 },
	{ "C", Vector( -896, 1024, -112 ), 200, 0 }
}

flags[ "de_cpl_strike" ] ={
	{ "A", Vector( -457, -2224, -168 ), 200, 0 },
	{ "B", Vector( -2043, 231, -168 ), 200, 0 },
	{ "C", Vector( -273, -660, -264 ), 277, 0 },
	{ "D", Vector( 488, -2043, -40 ), 200, 0 }
}

flags[ "de_crane" ] ={
	{ "A", Vector( 2007, -1760, 8 ), 200, 0 },
	{ "B", Vector( 2437, -580, 64 ), 188, 0 },
	{ "C", Vector( 2688, 960, -96 ), 200, 0 }
}

flags[ "de_losttemple" ] ={
	{ "A", Vector( 388, -481, 238 ), 177, 0 },
	{ "B", Vector( 1880, -443, 232 ), 300, 0 },
	{ "C", Vector( -692, -1640, 218 ), 200, 0 }
}

flags[ "de_russka" ] ={
	{ "A", Vector( 1151, -1640, -360 ), 200, 0 },
	{ "B", Vector( -1477, 480, -48 ), 200, 0 },
	{ "C", Vector( -232, 26, -160 ), 288, 0 }
}

flags[ "ctf_canals" ] ={
	{ "A", Vector( -1792, 960, 64 ), 250, 0 },
	{ "B", Vector( 601, -548, 67 ), 200, 0 },
	{ "C", Vector( 2817, -2151, 64 ), 250, 0 }
}

flags[ "de_bulguksa" ] ={
	{ "A", Vector( 1002, 2251, -328 ), 333, 0 },
	{ "B", Vector( 34, 104, -111 ), 200, 0 }
}

flags[ "de_canal" ] ={
	{ "A", Vector( -953, -1031, -250 ), 200, 0 },
	{ "B", Vector( -442, -200, -124 ), 300, 0 },
	{ "C", Vector( 550, 680, -379 ), 210, 0 }
}

flags[ "de_dust_mj" ] ={
	{ "A", Vector( -1405, 712, 32 ), 300, 0 },
	{ "B", Vector( -2, 175, 0 ), 277, 0 },
	{ "C", Vector( 680, -1161, -227 ), 350, 0 },
	{ "D", Vector( -771, 722, 288 ), 200, 0 },
	{ "E", Vector( 478, -249, 32 ), 200, 0 }
}

flags[ "de_junitown" ] ={
	{ "A", Vector( 2208, -2541, -535 ), 300, 0 },
	{ "B", Vector( 3757, -1067, -508 ), 300, 0 },
	{ "C", Vector( 2658, 12, -520 ), 200, 0 },
	{ "D", Vector( 4410, -1847, -384 ), 200, 0 },
	{ "E", Vector( 1995, -934, -512 ), 200, 0 }
}

flags[ "de_loup2" ] ={
	{ "?", Vector( 170, 546, -512 ), 200, 0 },
	{ "A", Vector( -969, 729, 176 ), 225, 0 },
	{ "B", Vector( 1407, 385, 160 ), 250, 0 },
	{ "C", Vector( -62, 374, 280 ), 200, 0 },
	{ "D", Vector( 7, -98, 30 ), 200, 0 },
	{ "E", Vector( -671, 234, 84 ), 188, 0 },
	{ "F", Vector( 174, 625, -176 ), 175, 0 },
	{ "G", Vector( 112, -757, 140 ), 125, 0 }
}

flags[ "dm_bridge_b2" ] ={
	{ "A", Vector( -6111, 0, 431 ), 200, 0 },
	{ "B", Vector( -4065, 1, 431 ), 200, 0 },
	{ "C", Vector( -2017, 1, 431 ), 200, 0 },
	{ "D", Vector( 32, 0, 431 ), 200, 0 }
}

flags[ "dm_damage_inc" ] ={
	{ "A", Vector( -361, -198, 0 ), 200, 0 },
	{ "B", Vector( -352, 806, 0 ), 333, 0 },
	{ "C", Vector( -446, -1046, 0 ), 333, 0 }
}

flags[ "dm_dgc_finca_v2" ] ={
	{ "A", Vector( 1862, -519, -188 ), 288, 0 },
	{ "B", Vector( 861, -276, -100 ), 200, 0 },
	{ "C", Vector( 1120, -544, -4 ), 175, 0 },
	{ "D", Vector( 30, -886, -148 ), 200, 0 },
	{ "E", Vector( -597, -443, -252 ), 250, 0 }
}

flags[ "dm_neon" ] ={
	{ "A", Vector( 1430, 770, -16 ), 300, 0 },
	{ "B", Vector( 1430, 770, -416 ), 300, 0 },
	{ "C", Vector( -702, 769, -416 ), 300, 0 },
	{ "D", Vector( -702, 769, -64 ), 300, 0 },
	{ "E", Vector( 591, 1728, 0 ), 200, 0 },
	{ "F", Vector( 588, -191, 0 ), 200, 0 }
}

flags[ "dm_streetwar_b1" ] ={
	{ "A", Vector( 1280, 1089, 16 ), 200, 0 },
	{ "B", Vector( 2432, -62, 16 ), 200, 0 },
	{ "C", Vector( 1281, -1215, 16 ), 200, 0 },
	{ "D", Vector( 128, -64, 16 ), 200, 0 },
	{ "E", Vector( 1159, 0, 134 ), 166, 0 }
}

flags[ "dm_titanic" ] ={
	{ "A", Vector( 3130, 2, -136 ), 200, 0 },
	{ "B", Vector( 2232, -14, 40 ), 200, 0 },
	{ "C", Vector( 1345, -2, 96 ), 200, 0 },
	{ "D", Vector( -176, -1, 226 ), 200, 0 },
	{ "E", Vector( -1728, -1, 150 ), 200, 0 },
	{ "F", Vector( -2813, 2, -8 ), 200, 0 }
}

flags[ "dm_zavod_yantar" ] ={
	{ "A", Vector( -514, 1747, 694 ), 300, 0 },
	{ "B", Vector( 2, -373, 681 ), 200, 0 },
	{ "C", Vector( -350, -1771, 683 ), 200, 0 }
}

flags[ "de_dust2__2z" ] ={
	{ "A", Vector( 1132, 2456, 96 ), 400, 0 },
	{ "B", Vector( -1543, 2650, 1 ), 400, 0 },
	{ "C", Vector( -1973, 1160, 32 ), 400, 0 },
	{ "D", Vector( 577, -213, 4 ), 400, 0 },
	{ "E", Vector( -190, 1147, 0 ), 66, 0 },
	{ "F", Vector( -2, 2137, 110 ), 166, 0 },
	{ "G", Vector( 247, 1241, 229 ), 75, 0 },
	{ "H", Vector( -544, 800, 418 ), 88, 0 }
}

flags[ "de_dust_pro" ] ={
	{ "A", Vector( -864, 2274, 96 ), 250, 0 },
	{ "B", Vector( 821, 1090, 64 ), 200, 0 },
	{ "C", Vector( -113, 1720, 40 ), 200, 0 }
}

flags[ "de_kyoto" ] ={
	{ "A", Vector( -1996, 0, 172 ), 333, 0 },
	{ "B", Vector( -3497, 0, 24 ), 200, 0 },
	{ "C", Vector( -897, 0, 24 ), 200, 0 },
	{ "D", Vector( 134, 0, -80 ), 200, 0 }
}

flags[ "de_dust2_confused" ] = {
	{ "A", Vector( 1132, 2456, -150 ), 200, 0 },
	{ "B", Vector( -1543, 2650, -130 ), 300, 0 },
	{ "C", Vector( -1973, 1160, -100 ), 300, 0 },
	{ "D", Vector( 577, -213, 4 ), 300, 0 },
	{ "E", Vector( -190, 1147, -30 ), 75, 0 }
}

flags[ "mw2_highrise_ly" ] ={
	{ "A", Vector( -311, -1738, -304 ), 300, 0 },
	{ "B", Vector( -681, -2406, -90 ), 190, 0 },
	{ "C", Vector( -1656, -3054, -96 ), 300, 0 }
}

flags[ "de_thematrix" ] ={
	{ "A", Vector( -1849, 18, 0 ), 200, 0 },
	{ "B", Vector( 370, -683, 416 ), 200, 0 },
	{ "C", Vector( -136, -621, 0 ), 125, 0 },
	{ "D", Vector( 338, -897, -69 ), 125, 0 },
	{ "E", Vector( -959, 32, -132 ), 175, 0 }
}

flags[ "dm_datacore" ] ={
	{ "A", Vector( 2220, 223, 0 ), 300, 0 },
	{ "B", Vector( 1248, -338, 400 ), 400, 0 },
	{ "C", Vector( -105, -576, -112 ), 200, 0 }
}
flags[ "ttt_forest_final" ] ={
	{ "A", Vector( -1446, 1342, 11 ), 100, 0 },
	{ "B", Vector( 1920, 1044, 0 ), 333, 0 },
	{ "C", Vector( -780, 464, 35 ), 50, 0 },
	{ "D", Vector( 467, 2156, 62 ), 125, 0 }
}

flags[ "ttt_magma_v2a" ] ={
	{ "A", Vector( -361, 0, 0 ), 200, 0 },
	{ "B", Vector( -361, 0, -256 ), 200, 0 },
	{ "C", Vector( -563, 1971, 0 ), 100, 0 },
	{ "D", Vector( 1070, 326, 0 ), 200, 0 },
	{ "E", Vector( -355, -1479, 0 ), 100, 0 },
	{ "?", Vector( 508, 321, 0 ), 1, 0 }
}

flags[ "zs_lockup_v2" ] ={
	{ "A", Vector( 497, -1046, 136 ), 100, 0 },
	{ "B", Vector( -458, -2266, 8 ), 350, 0 },
	{ "C", Vector( -1290, -819, 0 ), 133, 0 },
	{ "D", Vector( -336, -2926, 8 ), 200, 0 }
}
flags[ "zs_pathogen" ] ={
	{ "A", Vector( -616, -1835, 410 ), 200, 0 },
	{ "B", Vector( 1016, 312, 6 ), 222, 0 },
	{ "C", Vector( 1202, 100, 272 ), 200, 0 }
}

flags[ "gm_flatgrass" ] = {
	{ "A", Vector( 35, -190, -12800 ), 200, 0 },
	{ "B", Vector( 989, -198, -12288 ), 200, 0 },
	{ "C", Vector( -1769, 25, -12800 ), 300, 0 }
}
--Flags for CTDM2 maps
flags[ "gm_lasertag" ] = {
	{ "A", Vector( -485, 495.5, 192 ), 250, 0 }
}
flags[ "ttt_gunkanjima_v2" ] = {
	{ "A", Vector( 1201.3413, -429.3165, 144.0313 ), 200, 0 },
	{ "B", Vector( 1281.5133, -2040.4832, 256.0313 ), 200, 0 },
	{ "C", Vector( 2068.9688, -1162.7659, 0.0313 ), 200, 0 },
	{ "D", Vector( 510.4102, -546.4933, 64.0313 ), 200, 0 },
	{ "E", Vector( -792.4333, -1300.7861, 397.8168 ), 200, 0 }
}
flags[ "de_boston" ] = {
	{ "A", Vector( -704.2567, 415.8456, 316.0313 ), 200, 0 },
	{ "B", Vector( 1405.6569, 113.5675, 0.0313 ), 200, 0 },
	{ "C", Vector( 1183.7201, -1951.7478, 272.0313 ), 200, 0 },
	{ "D", Vector( 43.319, -1671.5, 56.0313 ), 200, 0 },
	{ "E", Vector( -1173.9105, -276.1628, 64.0313 ), 200, 0 },
	{ "F", Vector( -1775.3285, -1484.9709, 64.0312 ), 200, 0 }
}
flags[ "de_dust2_nightfall" ] = {
	{ "A", Vector( -1659.7954, 193.4194, 3.0742 ), 200, 0 },
	{ "B", Vector( -1924.54, 2527.8589, 42.0313 ), 200, 0 },
	{ "C", Vector( 286.8236, 2414.751, -125.6516 ), 200, 0 },
	{ "D", Vector( 626.0691, 499.537, 2.2789 ), 200, 0 },
	{ "E", Vector( -832.0617, 1424.496, -111.9687 ), 200, 0 }
}
flags[ "gm_wintertown" ] = {
	{ "A", Vector( 3347.5703, -1770.3727, 96.0313 ), 200, 0 },
	{ "B", Vector( 5055.8862, -2641.4661, 128.0313 ), 200, 0 },
	{ "C", Vector( 5104.0488, -1633.9333, 128.0313 ), 200, 0 },
	{ "D", Vector( 5039.105, -2608.198, 288.0313 ), 200, 0 },
	{ "E", Vector( 1935.9137, -3584.0771, -143.9687 ), 200, 0 },
	{ "F", Vector( 5888.0874, -3583.4883, -143.9688 ), 200, 0 },
	{ "G", Vector( 5887.9561, 192.7638, -143.9688 ), 200, 0 },
	{ "H", Vector( 3903.2891, 766.5276, 80.0312 ), 200, 0 },
}
flags[ "gm_floatingworlds_3" ] = {
	{ "A", Vector( -2994, -6657, 512 ), 200, 0 },
	{ "B", Vector( -2791, -2303, 98 ), 120, 0 },
	{ "C", Vector( 251, -1583, 256 ), 150, 0 },
	{ "D", Vector( 3583, -3867, 0 ), 200, 0 },
	{ "E", Vector( 2368, -8077, 20 ), 200, 0 }
}
flags[ "ttt_riverside_b3" ] = {
	{ "A", Vector( -2015, 237, -1 ), 200, 0 },
	{ "B", Vector( -1047, -606, 42 ), 200, 0 },
	{ "C", Vector( -298.5, -1448, -52 ), 200, 0 }
}
flags[ "cs_compound" ] = {
	{ "A", Vector( 693, 754, 0 ), 300, 0 },
	{ "B", Vector( 1923, 95, 256 ), 200, 0 },
	{ "C", Vector( 4012.5, 1413, 8 ), 300, 0 }
}
flags[ "cs_italy" ] = {
	{ "A", Vector( 534, -389, -160 ), 200, 0 },
	{ "B", Vector( -813.5, 1000, -156 ), 200, 0 },
	{ "C", Vector( -382, 688.5, 8 ), 200, 0 }
}
flags[ "de_cbble" ] = {
	{ "A", Vector( -2290, 2270, 0 ), 250, 0 },
	{ "B", Vector( 295, -675, -114 ), 300, 0 }
}
flags[ "de_dust" ] = {
	{ "A", Vector( 2001, 652, 1 ), 300, 0 },
	{ "B", Vector( 16, 1408.5, 32 ), 350, 0 },
	{ "C", Vector( -1067.5, 1888.5, -191.5 ), 350, 0 }
}
flags[ "dm_powerstation" ] = {
	{ "A", Vector( -953.6875, 601.1875, -107.9688 ), 125.0, 0 },
	{ "B", Vector( 249.5938, 1649.75, -452.5 ), 101, 0 },
	{ "C", Vector( 268, 1494.6563, -167.9688 ), 128, 0 }
}

flags[ "dm_basebunker" ] = {
	{ "A", Vector( 2024.0625, -1919.8125, -67.9688 ), 165, 0 },
	{ "B", Vector( 3136.0938, -1663.625, -63.9688 ), 276, 0 },
	{ "C", Vector( 2879.6563, -48.125, -63.9688 ), 97, 0 }
	
}

--[[flags[ "dm_aftermath" ] = {
--none yet
}]]

flags[ "dm_laststop" ] = {
	{ "A", Vector( -821.25, -259.8438, 216.0313 ), 178, 0 },
	{ "B", Vector( 767.875, 226.7, -319.9688 ), 218, 0 },
	{ "C", Vector( -58.5938, 912.4063, 216.0313 ), 162, 0 }
}

flags[ "de_corse" ] = {
	{ "A", Vector( 2580.6563, -613.5, -32.0625 ), 276, 0 },
	{ "B", Vector( -449.1563, -1729.9688, -4.6875 ), 181, 0 },
	{ "C", Vector( 1350, -1632, 64.0313 ), 120, 0 }
}

flags[ "de_joint" ] = {
	{ "A", Vector( 2629.0313, -3648, 175 ), 197, 0 },
	{ "B", Vector( 856.7813, -2632.4688, 64.0313 ), 200, 0 },
	{ "C", Vector( 2366.0625, -2236.9375, 192.0313 ), 159, 0 },
	{ "D", Vector( 2430.5625, -866.4688, 113.4375 ), 302, 0 },
	{ "E", Vector( 4552.3125, -2945, 64.0313 ), 198, 0 }
}

flags[ "dm_plaza17" ] = {
	{ "A", Vector( 3903.3438, 1855.7813, -715 ), 190, 0 },
	{ "B", Vector( 3863.625, 689.4688, -763.9688 ), 110, 0 },
	{ "C", Vector( 3721.0625, 984.0313, -515.9688 ), 168, 0 }
}

flags[ "de_star" ] ={
	{ "A", Vector( 1274.75, -446.5938, 96.0313 ), 187, 0 },
	{ "B", Vector( 695.75, -941.0313, 96.2813 ), 192, 0 },
	{ "C", Vector( -9.25, -896.375, 96.0313 ), 186, 0 }
}

flags[ "sh_smalltown_c" ] ={
	{ "A", Vector( 2227.9375, -523.1563, -65.9688 ), 93, 0 },
	{ "B", Vector( -389.8125, -1118.25, -61.9688 ), 95, 0 },
	{ "C", Vector( -2229.5625, -1839.4688, -58.9688 ), 138, 0 }	
}

flags[ "ttt_mw2_terminal" ] = {
	{ "A", Vector( 749.2188, 1999.5, 130.125 ), 135, 0 },
	{ "B", Vector( -372.5313, 919.8438, 130.0938 ), 288, 0 },
	{ "C", Vector( -1055.6563, -247.125, 124.125 ), 106, 0 }
}

flags[ "ttt_lazertag" ] = {
	{ "A", Vector( 1184.75, 38.5938, 64.0313 ), 287, 0 },
	{ "B", Vector( -9.4375, 32.75, 400.0313 ), 78, 0 },
	{ "C", Vector( -1346.0938, -258.1875, 64.0313 ), 125, 0 },
	{ "D", Vector( 420.5938, 1379.4063, 64.0313 ), 147, 0 },
	{ "E", Vector( 130.2188, -1291.5, 64.0313 ), 180, 0 }	
}

flags[ "dm_avalon" ] = {
	{ "A", Vector( -153, 400, 79.2188 ), 384, 0 },
	{ "B", Vector( -125.7813, -249.9063, 472.0313 ), 126, 0 },
	{ "C", Vector( 651.4688, 78.75, 1056 ), 321, 0 }
}

flags[ "dm_bounce" ] = {
	{ "A", Vector( 571.4375, -763.5625, -236.0313 ), 451, 0 },
	{ "B", Vector( 648.6875, 188.6875, -250.8438 ), 456, 0 }
}	

flags[ "dm_resident" ] = {
	{ "A", Vector( -159.2813, -256.3125, 640.0313 ), 224, 0 },
	{ "B", Vector( 164.6563, -858.5625, -127.9688 ), 193, 0 },
	{ "C", Vector( 736.75, 211.875, 257.0313 ), 160, 0 }
}

flags[ "ttt_mw2_highrise" ] = {
	{ "A", Vector( 160.125, -2150.6875, -95.875 ), 169, 0 },
	{ "B", Vector( -830.875, -2038.875, -95.9688 ), 208, 0 },
	{ "C", Vector( -1895.3125, -2376.75, -95.9688 ), 212, 0 }
}

flags[ "ttt_mw2_scrapyard" ] = {
	{ "A", Vector( 953.5938, 779.5625, 64 ), 164, 0 },
	{ "B", Vector( 76.0313, 1579.5313, 113.4375 ), 205, 0 },
	{ "C", Vector( -1037.2188, 943.4063, 128.0313 ), 188, 0 }
}

flags[ "de_crash" ] = {
	{ "A", Vector( -1459.75, -725.9063, -258.8438 ), 215, 0 },
	{ "B", Vector( -2640, 1279.8125, -80.0625 ), 150, 0 }
}

flags[ "ttt_cwoffice2019" ] = {
	{ "A", Vector( 2570.9063, -1243.5625, -327.9688 ),324, 0 },
	{ "B", Vector( 1544.8125, 498.25, -495.9688 ), 253, 0 },
	{ "C", Vector( 889.9063, 853.6563, -151.9688 ), 200, 0 }
}

flags[ "ba_stadium" ] = {
	{ "A", Vector( 0, 512, 64 ), 510.0, 0 }
}

flags[ "de_westwood" ] = {
	{ "A", Vector( 1447.375, -814.9375, -111.9688 ), 85.0, 0 },
	{ "B", Vector( 255.8438, -257.4688, -63.9688 ), 111.0, 0 },
	{ "C", Vector( 866.7188, 440.6563, -127.9688 ), 135.0, 0 }
}

flags[ "gm_devruins" ] = {
	{ "A", Vector( 1168.1563, -1728.1563, 0.0313 ), 127.0, 0 },
	{ "B", Vector( 1728.75, -1152.4688, -120 ), 95.0, 0 },
	{ "C", Vector( 3328.0313, -640.1563, -55.9688 ), 127.0, 0 }
}

flags[ "ttt_bf3_scrapmetal" ] = {
	{ "A", Vector( 678.7813, -187.375, 1180.0313 ), 141.0, 0 },
	{ "B", Vector( -113.1563, 893.6875, 832.3125 ), 98.0, 0 },
	{ "C", Vector( -1.375, 2435.9688, 1191.0313 ), 159.0, 0 }
}

flags[ "dm_octagon" ] = {
	{ "A", Vector( -1906.6875, 1352.4375, -395.9688 ), 313.0, 0 },
	{ "B", Vector( -2681.5938, 1876.4688, 116.0313 ), 222.0, 0 },
	{ "C", Vector( -1064.6563, 1035.9375, -264.9375 ), 200.0, 0 }
}

flags[ "de_keystone_beta" ] = {
	{ "A", Vector( 1537.0938, -2046.8125, -127.4688 ), 360.0, 0 },
	{ "B", Vector( -1052.625, 194.8438, -98.875 ), 358.0, 0 },
	{ "C", Vector( -1921.5313, 708.625, -127.9688 ), 234.0, 0 }
}

flags[ "dm_canals" ] = {
	{ "A", Vector( -2697.5938, -945.5625, 144.0313 ), 194.0, 0 },
	{ "B", Vector( -1406.3125, -1115.4375, 392.0313 ), 254.0, 0 },
	{ "C", Vector( -979.375, -2437.625, 16.0313 ), 115.0, 0 }
}

flags[ "ba_halo_crypt" ] = {
	{ "A", Vector( 716.4375, 0.4063, 0.0313 ), 30.0, 0 },
	{ "B", Vector( -716.0313, 33.5938, 0.0313 ), 30.0, 0 }
}

flags[ "de_stad" ] = {
    { "A", Vector( 1620.25, -1404.2813, 0.5625 ), 200.0, 0.0 },
    { "B", Vector( 4.875, 194.75, 424.0313 ), 175.0, 0.0 },
    { "C", Vector( -2034.625, 1962.3125, -0.5938 ), 420.0, 0.0 }
}

--//Update 1.10

flags[ "de_wellness" ] = {
    { "A", Vector( -1548.3438, 1718.5625, -292.9688 ), 222.0, 0.0 },
    { "B", Vector( -1131.8438, 770.2813, -653.5625 ), 212.0, 0.0 },
    { "C", Vector( 72, 1535.7188, -807.9688 ), 256.0, 0.0 }
}

flags[ "de_ruins" ] = {
    { "A", Vector( -716.375, -48.375, 46.2188 ), 229.0, 0.0 },
    { "B", Vector( 1115.5625, -633.2813, 33.375 ), 140.0, 0.0 },
    { "C", Vector( 2261.3438, -1464.1563, -63.2188 ), 361.0, 0.0 }
}

flags[ "dm_torrent" ] = {
    { "B", Vector( 1412.375, 1150.9375, -13.375 ), 142.0, 0.0 },
    { "A", Vector( -155.625, -1261.1563, 8.0313 ), 132.0, 0.0 },
    { "C", Vector( 152.5313, 1440.8438, 136.031 ), 98.0, 0.0 }
}

flags[ "zs_abstractum_v1" ] = {
    { "A", Vector( -1041.5313, 1258.4375, 0.0313 ), 179.0, 0.0 },
    { "B", Vector( -506.6875, 295.2188, -9.9688 ), 251.0, 0.0 },
    { "C", Vector( 769.9063, 1553.2813, 0.0313 ), 183.0, 0.0 }
}

flags[ "ttt_trinity_church" ] = {
    { "A", Vector( 1516.125, -1492.75, 443 ), 117.0, 0.0 },
    { "B", Vector( 1489.875, -1968.3438, 991.0313 ), 100.0, 0.0 },
    { "C", Vector( 1109.7188, -2074.5625, 215.0313 ), 119.0, 0.0 }
}

flags[ "de_donya" ] = {
    { "A", Vector( -4604.4375, 1841.75, 302.0313 ), 121.0, 0.0 },
    { "B", Vector( -3712.875, 1844.125, 47.031 ), 95.0, 0.0 },
    { "C", Vector( -2680.5625, 2455.2813, 237.0313 ), 190.0, 0.0 }
}

flags[ "cs_siege_csgo" ] = {
    { "A", Vector( 719.7188, 326.9688, -77 ), 197.0, 0.0 },
    { "B", Vector( 3465.875, -1425.75, -143.9375 ), 622.0, 0.0 },
    { "C", Vector( 1776.5313, -315.8438, -415.9688 ), 105.0, 0.0 }
}

flags[ "dm_crossfire" ] = {
    { "A", Vector( -2056.8438, 32.3125, -6.937 ), 93.0, 0.0 },
    { "B", Vector( -478.0313, 20.4688, 2.0313 ), 127.0, 0.0 },
    { "C", Vector( 1660.0313, 123.625, -390.9688 ), 187.0, 0.0 }
}

flags[ "dm_torque" ] = {
    { "A", Vector( -151.1875, 402.1875, 432.0313 ), 189.0, 0.0 },
    { "B", Vector( -314.5625, -13.5625, 0.0313 ), 138.0, 0.0 },
    { "C", Vector( 17.0313, -744.5313, 144.0313 ), 158.0, 0.0 },
    { "D", Vector( 323.625, 863.3125, -7.9688 ), 104.0, 0.0 }
}

flags[ "dm_necessity" ] = {
    { "A", Vector( -272.2813, -527.875, -95.9688 ), 141.0, 0.0 },
    { "B", Vector( 564.8125, -590.125, 192.0313 ), 170.0, 0.0 }
}

flags[ "dm_corrugated" ] = {
    { "A", Vector( 191.8125, 510.5, -63.9688 ), 262.0, 0.0 },
    { "B", Vector( -965.6563, -832.4063, -175.9375 ), 194.0, 0.0 },
    { "C", Vector( 1582.625, 1855.0938, -95.9688 ), 143.0, 0.0 }
}

flags[ "gm_thepit" ] = {
    { "A", Vector( 24.75, 838.375, 160.0313 ), 210.0, 0.0 },
    { "B", Vector( 5, -924.0313, 240.0313 ), 119.0, 0.0 },
    { "C", Vector( 34.7813, -1679.4375, 240.0313 ), 182.0, 0.0 }
}

flags[ "dm_drift" ] = {
    { "A", Vector(-88.7813, -369.8438, 80.0313), 271.0, 0.0 },
    { "B", Vector(1779.8438, 665.7188, 180.0313), 152.0, 0.0 }
}

flags[ "de_paris_subway" ] = {
    { "A", Vector(-2274.5, -14.125, -31.9688), 509.0, 0.0 },
    { "B", Vector(559.75, 562.5313, -75.9688), 489.0, 0.0 },
    { "C", Vector(503.125, 1236.4688, 325.0313), 219.0, 0.0 }

}

flags[ "dm_winterchill_r3" ] = {
    { "A", Vector(-1406.8125, 351.9375, -63.9688), 273.0, 0.0 },
    { "B", Vector(-34.4375, -98.9375, 160.0313), 219.0, 0.0 },
    { "C", Vector(915.9063, -768.0313, -191.9688), 191.0, 0.0 }
}

flags[ "gm_battleground_nodes" ] = {
    { "A", Vector(514.25, 33.8125, 128.0313), 261.0, 0.0 },
    { "B", Vector(-1350.7813, -922.9375, 128.0313), 330.0, 0.0 },
    { "C", Vector(-2751.8438, -639.125, -127.9375), 181.0, 0.0 },
    { "D", Vector(-2092.9688, -1738.3125, 32.0313), 188.0, 0.0 },
    { "E", Vector(-4142.4688, -1423.6875, -63.9688), 289.0, 0.0 }
}

flags[ "cs_east_borough" ] = {
    { "A", Vector(-1486.5938, -2128.7188, -15.9688), 204.0, 0.0 },
    { "B", Vector(767.75, -1951.8125, -16), 276.0, 0.0 },
    { "C", Vector(2303.625, -1650.4688, -16), 198.0, 0.0 }
}

flags[ "gm_boreas" ] = {
    { "A", Vector(-8102.625, -14276.0313, -10495.9375), 451.0, 0.0, "1" },
    { "B", Vector(-9353.2188, -11183.125, -10463.9688), 231.0, 0.0, "1" },
    { "C", Vector(-10137.0938, -8473.5313, -10319.9688), 88.0, 0.0, "1" },

    { "A", Vector(-255.8438, 3455.9375, -6399.9688), 402.0, 0.0, "2" },
    --{ "B", Vector(65.5313, 4802.625, -6399.9688), 278.0, 0.0, "2" },
    { "B", Vector(748.75, 4423.8125, -6271.9688), 90.0, 0.0, "2" },
    { "C", Vector(1748.2813, 3855.5, -6319.9688), 290.0, 0.0, "2" },

    { "A", Vector(2335.2188, 2508.1875, -6399.9688), 317.0, 0.0, "3" },
    { "B", Vector(1425.5625, 3080.2813, -6271.9688), 134.0, 0.0, "3" },
    { "C", Vector(2528.2813, 4095.3438, -6319.9688), 165.0, 0.0, "3" }
}

flags[ "npc_galleria_mess" ] = {
    { "B", Vector( 487.25, 2530.8438, -463.9688 ), 160.0, 0.0, },
    { "A", Vector( 486.0625, 1787.6875, -703.9688 ), 282.0, 0.0, },
    { "C", Vector( -847.125, 2495.8438, -703.9688 ), 204.0, 0.0, }
}

flags[ "rp_limanskhospital" ] = {
    { "A", Vector( 529.7813, 6785, 159 ), 240.0, 0.0, },
    { "B", Vector( 514.75, 5631.4688, 160.0313 ), 265.0, 0.0, },
    { "C", Vector( 510.4375, 3986.6563, -63.9375 ), 146.0, 0.0, }
}

flags[ "gm_explore_tunnels" ] = {
    { "A", Vector( -888.5, -3039.0625, 16.0313 ), 247.0, 0.0, },
    { "B", Vector( 259.9063, -2239.6875, 16.0313 ), 282.0, 0.0, },
    { "C", Vector( 1012.7813, -1204.75, 16.0313 ), 269.0, 0.0, },
    { "D", Vector( 47.5625, -324.375, 16.0313 ), 166.0, 0.0, }
}

--[[flags[ "" ] = {
	{ "", Vector( 0, 0, 0 ), 0, 0 }
}]]

--//Leaving this hanging around since it's functionality that can be added in later if desired
--[[timer.Create( "FlagRewards", 10, 0, function()
	local numFlags = #flags[ game.GetMap() ]
	if numFlags == 0 then
		return
	end
	local redFlags = 0
	local blueFlags = 0
	local neutralFlags = 0
	for k, v in next, flags[ game.GetMap() ] do
		if status[ v[ 1 ] ] == 1 then
			redFlags = redFlags + 1
		elseif status[ v[ 1 ] ] == -1 then
			blueFlags = blueFlags + 1
		elseif status[ v[ 1 ] ] == 0 then
			neutralFlags = neutralFlags + 1
		end
	end
	if redFlags > blueFlags and redFlags > numFlags / 2 then
		SetGlobalInt( "control", 1 )
	elseif blueFlags > redFlags and blueFlags > numFlags / 2 then
		SetGlobalInt( "control", 2 )
	else
		SetGlobalInt( "control", 0 )
	end
	if redFlags == numFlags then
		SetGlobalInt( "allcontrol", 1 )
	elseif blueFlags == numFlags then
		SetGlobalInt( "allcontrol", 2 )
	else
		SetGlobalInt( "allcontrol", 0 )
	end
	
	if GetGlobalInt( "control" ) == 1 then
		if GetGlobalInt( "allcontrol" ) == 1 then
			for k, v in next, player.GetAll() do
				if v:Team() == 1 then
					AddMoney( v, 20 )
					lvl.AddEXP( v, 20 )
					v:AddScore( 20 )
				end
			end
		else
			for k, v in next, player.GetAll() do
				if v:Team() == 1 then
					AddMoney( v, 10 )
					lvl.AddEXP( v, 10 )
					v:AddScore( 10 )
				end
			end
		end
	elseif GetGlobalInt( "control" ) == 2 then
		if GetGlobalInt( "allcontrol" ) == 2 then
			for k, v in next, player.GetAll() do
				if v:Team() == 2 then
					AddMoney( v, 20 )
					lvl.AddEXP( v, 20 )
					v:AddScore( 20 )
				end
			end
		else
			for k, v in next, player.GetAll() do
				if v:Team() == 2 then
					AddMoney( v, 10 )
					lvl.AddEXP( v, 10 )
					v:AddScore( 10 )
				end
			end
		end
	end
	
end )]]

util.AddNetworkString( "DoesMapHaveFlags" )
util.AddNetworkString( "DoesMapHaveFlagsCallback" )
net.Receive( "DoesMapHaveFlags", function( len, ply )
    if flags[ game.GetMap() ] then
        net.Start( "DoesMapHaveFlagsCallback" )
        net.Send( ply )
    end
end )

if not flags[ game.GetMap() ] then return end

function GM:SetupFlags()
    self.FlagTable = {}
    self.FlagFeedCheck = {}
    self.RedDrain, self.BlueDrain = 0, 0
    --//Keys in this table are the flag "name" - duplicates do not exist this way
    --[[ Table format:
        pos = flag position
        size = size of the area the player must be in
        players = table of all players inside the area, key = player object, value = player's team
        redcount = number of red team players on the point (this was originally a local value, but let's save it anywhore)
        bluecount = same as red but for blue team
        currentcontrol = team currently in control of the flag
        lastcontrol = team that last controlled the flag before it neutralized - used for "SAVED FLAG"
        count = where the flag sits in terms of control, 0 = red control, 20 = blue control, 10 = neutral]]

    net.Start( "FullFlagReset" )
    net.Broadcast()

    if GetGlobalInt( "ConquestResupply", 0 ) != 0 then
        for k, v in pairs( flags[ game.GetMap() ] ) do
            if tostring(GetGlobalInt( "ConquestResupply" )) == v[5] then
                self.FlagTable[ v[ 1 ] ] = { pos = v[ 2 ], size = v[ 3 ], players = {}, redcount = 0, bluecount = 0, currentcontrol = 0, lastcontrol = 0, count = 10 }
            end
        end

        for k, v in pairs( player.GetAll() ) do
            SendFlagOrder( v )
        end
    end
    if table.IsEmpty( self.FlagTable ) then
        for k, v in pairs( flags[ game.GetMap() ] ) do
            self.FlagTable[ v[ 1 ] ] = { pos = v[ 2 ], size = v[ 3 ], players = {}, redcount = 0, bluecount = 0, currentcontrol = 0, lastcontrol = 0, count = 10 }
        end
    end
end
GM:SetupFlags()

--//Moved from init.lua - calculates ticket drain every 5 seconds
timer.Create( "TicketFlagCheck", 5, 0, function()
    if GetGlobalBool( "RoundFinished" ) then timer.Remove( "TicketFlagCheck" ) return end
    
    if not firstcheck then
        firstcheck = true

        if GAMEMODE.FlagTable then
            if !table.IsEmpty( GAMEMODE.FlagTable ) then
                SetGlobalBool( "ticketmode", true )
            else
                SetGlobalBool( "ticketmode", false )
                timer.Remove( "TicketFlagCheck" )
            end
        else
            SetGlobalBool( "ticketmode", false )
            timer.Remove( "TicketFlagCheck" )
        end
    end

	SetGlobalInt( "RedTickets", math.Clamp( GetGlobalInt( "RedTickets" ) - GAMEMODE.RedDrain, 0, GAMEMODE.Tickets ) )
	SetGlobalInt( "BlueTickets", math.Clamp( GetGlobalInt( "BlueTickets" ) - GAMEMODE.BlueDrain, 0, GAMEMODE.Tickets ) )
    
	if GetGlobalInt( "RedTickets" ) == 0 and GetGlobalInt( "BlueTickets" ) == 0 then
		if GAMEMODE.RedDrain > GAMEMODE.BlueDrain then
			GAMEMODE:EndRound( 2 )
		elseif GAMEMODE.BlueDrain > GAMEMODE.RedDrain then
            GAMEMODE:EndRound( 1 )
        else
            GAMEMODE:EndRound( 0 )
		end
	elseif GetGlobalInt( "RedTickets" ) == 0 then
		GAMEMODE:EndRound( 2 )
	elseif GetGlobalInt( "BlueTickets" ) == 0 then
		GAMEMODE:EndRound( 1 )
	end
end )

util.AddNetworkString( "UpdateFlagInfo" )
function UpdateFlagCount( flag, pos, count, control, lastcontrol, ply )
	net.Start( "UpdateFlagInfo" )
		net.WriteString( flag )
		net.WriteVector( pos )
		net.WriteInt( math.Clamp( count, 0, 20 ), 6 )
		net.WriteInt( math.Clamp( control, 0, 2 ), 3 )
		net.WriteInt( math.Clamp( lastcontrol, 0, 2 ), 3 )
	if ply then
		net.Send( ply )
	else
		net.Broadcast()
	end

	GAMEMODE:UpdateFlagDrain()
end

GM.RedDrain, GM.BlueDrain = 0, 0
function GM:UpdateFlagDrain()
	local redcount, bluecount = 0, 0
	for flagname, flagtable in pairs( self.FlagTable ) do
		if flagtable.currentcontrol == 1 then
			redcount = redcount + 1
		elseif flagtable.currentcontrol == 2 then
			bluecount = bluecount + 1
		end
    end
    
	if redcount > bluecount then
		self.RedDrain = 0
		self.BlueDrain = redcount - bluecount
	elseif bluecount > redcount then
		self.RedDrain = bluecount - redcount
		self.BlueDrain = 0
	elseif bluecount == redcount and bluecount != 0 then
		self.RedDrain = 1
		self.BlueDrain = 1
	end
end

function SendCurrentFlagStatuses( ply )
	for flagname, flagtable in pairs( GAMEMODE.FlagTable ) do
		UpdateFlagCount( flagname, flagtable.pos, flagtable.count, flagtable.currentcontrol, flagtable.lastcontrol, ply )
	end
end

function SendFlagOrder( ply )
    --if !GAMEMODE.FlagsOrdered then
        GAMEMODE.FlagsOrdered = {}
        for _, flagtable in pairs( flags[ game.GetMap() ] ) do
            if GetGlobalInt( "ConquestResupply", 0 ) != 0 then
                if tostring(GetGlobalInt( "ConquestResupply" )) == flagtable[5] then
                    GAMEMODE.FlagsOrdered[ #GAMEMODE.FlagsOrdered + 1 ] = flagtable[ 1 ]
                end
            else
                GAMEMODE.FlagsOrdered[ #GAMEMODE.FlagsOrdered + 1 ] = flagtable[ 1 ]
            end
        end
    --end

	net.Start( "RequestFlagOrderCallback" )
		net.WriteTable( GAMEMODE.FlagsOrdered )
	net.Send( ply )
end

--//The core of the flag checking - hopefully written much better than Whuppo's was
timer.Create( "FlagCheck", 1, 0, function()
	--//First thing, check where all of the players are - if they're inside a flag zone, mark them down
	for _, ply in pairs( player.GetAll() ) do
        --if ply:IsValid() and ply:Team() != 0 and ply:Alive() then 
            for _, flagtable in pairs( GAMEMODE.FlagTable ) do
                if ply:IsValid() and ply:Team() != 0 and ply:Alive() and ply:GetPos():Distance( flagtable.pos ) <= flagtable.size then
                    flagtable.players[ ply ] = ply:Team()
                else
                    flagtable.players[ ply ] = nil
                end
            end
        --end
	end

    --//We'll need to count how many players are on the zone, and what the team majority is
	for flagname, flagtable in pairs( GAMEMODE.FlagTable ) do
		--//These were intially local vars, but fuckit let's save them to the table in case we need them for some odd reason in the future
		flagtable.redcount = 0
		flagtable.players.redTeam = {}
		flagtable.bluecount = 0
        flagtable.players.blueTeam = {}
		for ply, teamid in pairs( flagtable.players ) do
			if teamid == 1 then
				flagtable.redcount = flagtable.redcount + 1
				flagtable.players.redTeam[ #flagtable.players.redTeam + 1 ] = ply
			elseif teamid == 2 then
				flagtable.bluecount = flagtable.bluecount + 1
				flagtable.players.blueTeam[ #flagtable.players.blueTeam + 1 ] = ply
            end
		end
		
		--//If there's a difference by team, give the team with the most players the difference in count towards capturing - none if none
		local difference = 0
		if flagtable.redcount > flagtable.bluecount then
		--//Red team first
			difference = flagtable.redcount - flagtable.bluecount
			--//If we're climbing from blue control (from count 20 - 11), neutralize the flag first
			if flagtable.count > 10 and ( flagtable.count - difference ) <= 10 then
				--//Neutralize the flag
				if flagtable.currentcontrol != 0 then
                    hook.Run( "FlagNeutralized", flagname, flagtable.lastcontrol, flagtable.players.redTeam )
                    flagtable.currentcontrol = 0
                end
			end
			--//If red hasn't yet captured the flag, give them count towards it, if the count given hits 0, capture the flag
			if flagtable.count > 0 then
				flagtable.count = math.Clamp( flagtable.count - difference, 0, 20 )

				if flagtable.count == 0 then --//If we capture the flag with this newest count
					flagtable.currentcontrol = 1

					if flagtable.lastcontrol == 1 then --//If we held the flag last, we've saved it, not captured it
						hook.Run( "FlagSaved", flagname, flagtable.currentcontrol, flagtable.players.redTeam )
					else --//We captured the flag back
						hook.Run( "FlagCaptured", flagname, flagtable.currentcontrol, flagtable.players.redTeam )
					end

					flagtable.lastcontrol = 1
				end
				
				UpdateFlagCount( flagname, flagtable.pos, flagtable.count, flagtable.currentcontrol, flagtable.lastcontrol )
			end
		elseif flagtable.redcount < flagtable.bluecount then
		--//This half mirrors above, but for blue team
			difference = flagtable.bluecount - flagtable.redcount
			if flagtable.count < 10 and ( flagtable.count + difference ) >= 10 then
				if flagtable.currentcontrol != 0 then
                    hook.Run( "FlagNeutralized", flagname, flagtable.lastcontrol, flagtable.players.blueTeam )
                    flagtable.currentcontrol = 0
                end
			end

			if flagtable.count < 20 then
				flagtable.count = math.Clamp( flagtable.count + difference, 0, 20 )

				if flagtable.count == 20 then
					flagtable.currentcontrol = 2

					if flagtable.lastcontrol == 2 then
						hook.Run( "FlagSaved", flagname, flagtable.currentcontrol, flagtable.players.blueTeam )
					else
						hook.Run( "FlagCaptured", flagname, flagtable.currentcontrol, flagtable.players.blueTeam )
					end

					flagtable.lastcontrol = 2
				end

				UpdateFlagCount( flagname, flagtable.pos, flagtable.count, flagtable.currentcontrol, flagtable.lastcontrol )
			end
		end

	end
end )

util.AddNetworkString( "IsOnFlag" )
util.AddNetworkString( "IsOffFlag" )
hook.Add( "Think", "CheckIfOnFlag", function()
	for _, ply in pairs( player.GetAll() ) do
		for flagname, flagtable in pairs( GAMEMODE.FlagTable ) do
			if ply:IsValid() and ply:Team() != 0 and ply:Alive() and ply:GetPos():Distance( flagtable.pos ) <= flagtable.size then
				net.Start( "IsOnFlag" )
					net.WriteString( flagname )
                net.Send( ply )
                GAMEMODE.FlagFeedCheck[ ply ] = flagname
			else
				net.Start( "IsOffFlag" )
					net.WriteString( flagname )
                net.Send( ply )
                GAMEMODE.FlagFeedCheck[ ply ] = nil
			end
		end
	end
end )

hook.Add( "PlayerSpawn", "SendCurrentFlagInfo", function( ply )
	SendCurrentFlagStatuses( ply )
end )

hook.Add( "PlayerInitialSpawn", "SendFlagOrderOnJoin", function( ply )
    SendFlagOrder( ply )
end )

hook.Add( "FlagCaptured", "GiveAmmoCapture", function( _, _, plytable )
    for _, ply in pairs( plytable ) do
        for _, wep in pairs( ply:GetWeapons() ) do
			if weapons.Get(wep:GetClass()) and weapons.Get(wep:GetClass()).Slot < 3 then
            	ply:GiveAmmo( wep:GetMaxClip1(), wep:GetPrimaryAmmoType(), true )
			end
        end
    end
end )

hook.Add( "FlagCaptured", "CapturePointDistribution", function( flagname, controllingTeam, controllingTeamPlayers )
	for _, ply in next, controllingTeamPlayers do --//I just noticed doing this rewrite, friendly's capturing a point isn't announced...
		AddNotice( ply, "FLAG CAPTURED", SCORECOUNTS.FLAG_CAPTURED, NOTICETYPES.FLAG )
		AddRewards( ply, SCORECOUNTS.FLAG_CAPTURED )
		umsg.Start( "friendlyflagcaptured", ply )
			umsg.String( flagname )
		umsg.End()
	end
	for _, ply in next, player.GetAll() do
		if ply:Team() != controllingTeam and ply:Team() != 0 then
			umsg.Start( "enemyflagcaptured", ply )
				umsg.String( flagname )
			umsg.End()		
		end		
	end
end )

hook.Add( "FlagNeutralized", "NeutralizePointDistribution", function( flagname, previousTeam, controllingTeamPlayers )
	for _, ply in pairs( controllingTeamPlayers ) do
        AddNotice( ply, "FLAG NEUTRALIZED", SCORECOUNTS.FLAG_NEUTRALIZED, NOTICETYPES.FLAG )
		AddRewards( ply, SCORECOUNTS.FLAG_NEUTRALIZED )
		hook.Run( "MatchHistory_Neutral", ply )
	end
end )

hook.Add( "FlagSaved", "SavePointDistribution", function( flagname, controllingTeam, controllingTeamPlayers )
	for _, ply in pairs( controllingTeamPlayers ) do
        AddNotice( ply, "FLAG SAVED", SCORECOUNTS.FLAG_SAVED, NOTICETYPES.FLAG )
		AddRewards( ply, SCORECOUNTS.FLAG_SAVED )
	end		
end )

util.AddNetworkString( "RequestInitialFlagStatus" )
net.Receive( "RequestInitialFlagStatus", function( len, ply )
	SendCurrentFlagStatuses( ply )
end )

util.AddNetworkString( "RequestFlagOrder" )
util.AddNetworkString( "RequestFlagOrderCallback" )
net.Receive( "RequestFlagOrder", function( len, ply )
	SendFlagOrder( ply )
end )