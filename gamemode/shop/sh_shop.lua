--//This file is used to set up back end for the shop, including tables for weapon skins & player models
--//Tokens = Prestige Tokens, earned via prestiging - Cash = regular shop currency, earned by playing the game - Credits = donator currency, earned by donating to the server

--//    Weapon Skins    //--

--//Quality goes from 0 (shit) to 5 (amazing) - I think I'll reserve 5 for special skins, 4 will be the default "really good" quality marker
GM.SkinsMasterTable = {
    { name = "Stone Blue", dir = "models/XQM/BoxFull_diffuse", quality = 1 },
    { name = "Artic Breeze", dir = "models/XQM/CellShadedCamo_diffuse", quality = 1 },
    { name = "Packed", dir = "models/XQM/LightLinesRed", quality = 4 },
    { name = "Packed a Punch", dir = "models/XQM/LightLinesRed_tool", quality = 4 },
    { name = "Polex", dir = "models/XQM/PoleX1_diffuse", quality = 1 },
    { name = "Arctic Block", dir = "models/XQM/SquaredMatInverted", quality = 2 },
    { name = "Grassy Knoll", dir = "models/XQM/WoodTexture_1", quality = 0 },
    { name = "Black Hole", dir = "models/onfire", quality = 2 },
    { name = "Viscera", dir = "models/zombie_fast/fast_zombie_sheet", quality = 2 },
    { name = "Wisp", dir = "models/Airboat/airboat_blur02", quality = 3 },
    { name = "Striped Slate", dir = "phoenix_storms/black_brushes", quality = 2 },
    { name = "Vent", dir = "phoenix_storms/future_vents", quality = 1 },
    --{ name = "Plasmid", dir = "plastic", quality = 2 }, --Doesn't seem to work in the menu M4
    --{ name = "True Ice", dir = "ice_tool/ice_texture", quality = 3 }, --Also doesn't seem to work in the menu M4
    { name = "Wireframed", dir = "models/wireframe", quality = 3 },
    { name = "Chrome", dir = "debug/env_cubemap_model", quality = 4 },
    { name = "Flow", dir = "models/shadertest/shader3", quality = 4 },
    { name = "Red Flow", dir = "models/shadertest/shader4", quality = 4 },
    { name = "Mosaic", dir = "models/shadertest/shader5", quality = 3 },
    { name = "Stasis", dir = "models/props_combine/stasisshield_sheet", quality = 4 },
    { name = "Juice", dir = "models/props_lab/Tank_Glass001", quality = 4 },
    { name = "Mirror", dir = "models/screenspace", quality = 3 },
    { name = "Flesh", dir = "models/flesh", quality = 2 },
    { name = "ATTENTION!!!", dir = "phoenix_storms/stripes", quality = 1 },
    { name = "Green Wire", dir = "phoenix_storms/wire/pcb_green", quality = 3 },
    { name = "Red Wire", dir = "phoenix_storms/wire/pcb_red", quality = 3 },
    { name = "Blue Wire", dir = "phoenix_storms/wire/pcb_blue", quality = 3 },
    --
    { name = "Flat Gray", dir = "phoenix_storms/gear", quality = 0 },
    { name = "Energy Arc", dir = "Models/effects/splodearc_sheet", quality = 3 },
    { name = "Orb Stasis", dir = "models/props_combine/portalball001_sheet", quality = 4 },
    { name = "Shield", dir = "models/props_combine/com_shield001a", quality = 4 },
    { name = "Glass", dir = "models/props_c17/frostedglass_01a", quality = 0 },
    { name = "Cherry", dir = "models/props_combine/tprings_globe", quality = 4 },
    { name = "Vantablack", dir = "models/rendertarget", quality = 3 },
    { name = "Brick", dir = "brick/brick_model", quality = 1 },
    { name = "Gutter", dir = "models/props_pipes/GutterMetal01a", quality = 0 },
    { name = "Flannel", dir = "models/props_c17/FurnitureFabric003a", quality = 0 },
    { name = "Space Junk", dir = "phoenix_storms/metalset_1-2", quality = 2 }--[[,
    { name = "", dir = "", quality = 0 },
    { name = "", dir = "", quality = 0 },
    { name = "", dir = "", quality = 0 },
    { name = "", dir = "", quality = 0 },
    { name = "", dir = "", quality = 0 }]]
}

--//    Player models   //--

GM.BuyableModels = {
    { name = "Alphatzech", model = "models/player/aphaztech.mdl", collection = "Gmod Tower", voiceovers = false, quality = 0 },
    { name = "Charple", model = "models/player/charple.mdl", collection = "HL2 Defaults", voiceovers = false, quality = 0 },
    { name = "Hunter", model = "models/player/hunter.mdl", collection = "Gmod Tower", voiceovers = false, quality = 0 },
    { name = "Jack Sparrow", model = "models/player/jack_sparrow.mdl", collection = "Gmod Tower", voiceovers = false, quality = 0 },
    { name = "Knight", model = "models/player/knight.mdl", collection = "Gmod Tower", voiceovers = false, quality = 0 },
    { name = "Liberty Prime", model = "models/player/sam.mdl", collection = "Gmod Tower", voiceovers = false, quality = 0 },
    { name = "Undead Combine", model = "models/player/clopsy.mdl", collection = "Gmod Tower", voiceovers = false, quality = 0 },
    { name = "Alice", model = "models/player/alice.mdl", collection = "Gmod Tower", voiceovers = false, quality = 1 },
    { name = "Altair", model = "models/player/altair.mdl", collection = "Gmod Tower", voiceovers = false, quality = 1 },
    { name = "Boxman", model = "models/player/nuggets.mdl", collection = "Gmod Tower", voiceovers = false, quality = 1 },
    { name = "Deadpool", model = "models/player/deadpool.mdl", collection = "Gmod Tower", voiceovers = false, quality = 1 },
    { name = "Doomguy", model = "models/ex-mo/quake3/players/doom.mdl", collection = "Gmod Tower", voiceovers = false, quality = 1 },
    { name = "Postal Dude", model = "models/player/dude.mdl", collection = "Gmod Tower", voiceovers = false, quality = 1 },
    { name = "Faith", model = "models/player/faith.mdl", collection = "Gmod Tower", voiceovers = false, quality = 1 },
    { name = "Green Arrow", model = "models/player/greenarrow.mdl", collection = "Gmod Tower", voiceovers = false, quality = 1 },
    { name = "Jack Skellington", model = "models/vinrax/player/Jack_player.mdl", collection = "Gmod Tower", voiceovers = false, quality = 1 },
    { name = "Joker", model = "models/player/joker.mdl", collection = "Gmod Tower", voiceovers = false, quality = 1 },
    { name = "Master Chief", model = "models/player/lordvipes/haloce/spartan_classic.mdl", collection = "Gmod Tower", voiceovers = false, quality = 1 },
    { name = "Megaman", model = "models/vinrax/player/megaman64_no_gun_player.mdl", collection = "Gmod Tower", voiceovers = false, quality = 1 },
    { name = "Niko", model = "models/player/niko.mdl", collection = "Gmod Tower", voiceovers = false, quality = 1 },
    { name = "Scorpion", model = "models/player/scorpion.mdl", collection = "Gmod Tower", voiceovers = false, quality = 1 },
    { name = "Sub-Zero", model = "models/player/subzero.mdl", collection = "Gmod Tower", voiceovers = false, quality = 1 },
    { name = "Walter White", model = "models/Agent_47/agent_47.mdl", collection = "Gmod Tower", voiceovers = false, quality = 1 },
    { name = "Boba Fett", model = "models/player/bobafett.mdl", collection = "Gmod Tower", voiceovers = false, quality = 2, bodygroups = true },
    { name = "Chewbacca", model = "models/player/chewbacca.mdl", collection = "Gmod Tower", voiceovers = false, quality = 2 },
    { name = "Chris", model = "models/player/chris.mdl", collection = "Gmod Tower", voiceovers = false, quality = 2 },
    { name = "Crimson Lance Soldier", model = "models/player/lordvipes/bl_clance/crimsonlanceplayer.mdl", collection = "Gmod Tower", voiceovers = false, quality = 2 },
    { name = "Deathstroke", model = "models/norpo/ArkhamOrigins/Assassins/Deathstroke_ValveBiped.mdl", collection = "Gmod Tower", voiceovers = false, quality = 2 },
    { name = "Grayfox", model = "models/player/lordvipes/Metal_Gear_Rising/gray_fox_playermodel_cvp.mdl", collection = "Gmod Tower", voiceovers = false, quality = 2 },
    { name = "Ironman", model = "models/Avengers/Iron Man/mark7_player.mdl", collection = "Gmod Tower", voiceovers = false, quality = 2 },
    { name = "Isaac", model = "models/player/security_suit.mdl", collection = "Gmod Tower", voiceovers = false, quality = 2 },
    { name = "Leon Kennedy", model = "models/player/leon.mdl", collection = "Gmod Tower", voiceovers = false, quality = 2 },
    { name = "Scarecrow", model = "models/player/scarecrow.mdl", collection = "Gmod Tower", voiceovers = false, quality = 2 },
    { name = "Agent Smith", model = "models/player/smith.mdl", collection = "Gmod Tower", voiceovers = false, quality = 2 },
    { name = "Solid Snake", model = "models/player/big_boss.mdl", collection = "Gmod Tower", voiceovers = false, quality = 2 },
    { name = "Stormtrooper", model = "models/player/stormtrooper.mdl", collection = "Gmod Tower", voiceovers = false, quality = 2 },
    { name = "Kapkan", model = "models/player/r6s_kapkan.mdl", collection = "R6 Siege", voiceovers = false, quality = 3, bodygroups = true },
    { name = "Alyx", model = "models/player/alyx.mdl", collection = "HL2 Defaults", voiceovers = false, quality = 3 },
    { name = "Pokemon Trainer", model = "models/player/red.mdl", collection = "Gmod Tower", voiceovers = false, quality = 3, bodygroups = true },
    { name = "Rorschach", model = "models/player/rorschach.mdl", collection = "Gmod Tower", voiceovers = false, quality = 3 },
    { name = "Info_player_start", model = "models/player/infoplayerstart.mdl", collection = "NULL", voiceovers = false, quality = 4 },
    { name = "Teslapower", model = "models/player/teslapower.mdl", collection = "Gmod Tower", voiceovers = false, quality = 4 },
    { name = "Tron Guy", model = "models/player/anon/anon.mdl", collection = "Gmod Tower", voiceovers = false, quality = 4, bodygroups = true },
    { name = "Necris Male", model = "models/mark2580/ut4/necris_m_player.mdl", collection = "Necris", voiceovers = false, quality = 5, bodygroups = true },
    { name = "Necris Female", model = "models/mark2580/ut4/necris_f_player.mdl", collection = "Necris", voiceovers = false, quality = 5, bodygroups = true },
    { name = "Thanos", model = "models/kryptonite/inf_thanos/inf_thanos.mdl", collection = "Avengers", voiceovers = false, quality = 3 },
    { name = "John Wick", model = "models/wick_chapter2", collection = "John Wick", voiceovers = false, quality = 4, bodygroups = true },
    { name = "Franklin", model = "models/grandtheftauto5/franklin.mdl", collection = "GTA V", voiceovers = false, quality = 4, bodygroups = true },
    { name = "Michael", model = "models/grandtheftauto5/michael.mdl", collection = "GTA V", voiceovers = false, quality = 4, bodygroups = true },
    { name = "Trevor", model = "models/grandtheftauto5/trevor.mdl", collection = "GTA V", voiceovers = false, quality = 4 }
    --{ name = "", model = "", collection = "", voiceovers = false, quality = 0 },
}

--//    Shared shop backend    //--

GM.WeaponSkins = {
	--{name = "", directory = "", texture = Material( "" ), tokens = 1, cash = 0, credits = 0},
}
for k, v in pairs(GM.SkinsMasterTable) do
	if v.quality == 0 then
		GM.WeaponSkins[#GM.WeaponSkins + 1] = {name = v.name, directory = v.dir, texture = Material(v.dir), tokens = 1, cash = 50000, credits = 1, rarity = v.quality}
	elseif v.quality == 1 then
		GM.WeaponSkins[#GM.WeaponSkins + 1] = {name = v.name, directory = v.dir, texture = Material(v.dir), tokens = 2, cash = 100000, credits = 1, rarity = v.quality}
	elseif v.quality == 2 then
		GM.WeaponSkins[#GM.WeaponSkins + 1] = {name = v.name, directory = v.dir, texture = Material(v.dir), tokens = 3, cash = 0, credits = 1, rarity = v.quality}
	elseif v.quality == 3 then
		GM.WeaponSkins[#GM.WeaponSkins + 1] = {name = v.name, directory = v.dir, texture = Material(v.dir), tokens = 5, cash = 0, credits = 2, rarity = v.quality}
	elseif v.quality == 4 then
		GM.WeaponSkins[#GM.WeaponSkins + 1] = {name = v.name, directory = v.dir, texture = Material(v.dir), tokens = 10, cash = 0, credits = 2, rarity = v.quality}
	else--if v.quality == 5 then
		GM.WeaponSkins[#GM.WeaponSkins + 1] = {name = v.name, directory = v.dir, texture = Material(v.dir), tokens = 0, cash = 0, credits = 3, rarity = v.quality}
	end
end

--//Any playermodels we add have the option for voiceovers, though I doubt any will get them - see cl_ and sv_character_interaction for specifics
GM.PlayerModels = {
	--{ name = "", model = "", tokens = 1, cash = 0, credits = 0, voiceovers = false },
}
for k, v in pairs(GM.BuyableModels) do
    if v.quality == 1 then
        GM.PlayerModels[#GM.PlayerModels + 1] = {name = v.name, model = v.model, tokens = 2, cash = 100000, credits = 1, voiceovers = v.voiceovers, collection = v.collection, quality = v.quality, bodygroups = v.bodygroups}
	elseif v.quality == 2 then
        GM.PlayerModels[#GM.PlayerModels + 1] = {name = v.name, model = v.model, tokens = 3, cash = 0, credits = 1, voiceovers = v.voiceovers, collection = v.collection, quality = v.quality, bodygroups = v.bodygroups}
	elseif v.quality == 3 then
        GM.PlayerModels[#GM.PlayerModels + 1] = {name = v.name, model = v.model, tokens = 5, cash = 0, credits = 2, voiceovers = v.voiceovers, collection = v.collection, quality = v.quality, bodygroups = v.bodygroups}
	elseif v.quality == 4 then
        GM.PlayerModels[#GM.PlayerModels + 1] = {name = v.name, model = v.model, tokens = 10, cash = 0, credits = 2, voiceovers = v.voiceovers, collection = v.collection, quality = v.quality, bodygroups = v.bodygroups}
	elseif v.quality == 5 then
        GM.PlayerModels[#GM.PlayerModels + 1] = {name = v.name, model = v.model, tokens = 0, cash = 0, credits = 3, voiceovers = v.voiceovers, collection = v.collection, quality = v.quality, bodygroups = v.bodygroups}
	else--if v.quality == 0 then
        GM.PlayerModels[#GM.PlayerModels + 1] = {name = v.name, model = v.model, tokens = 1, cash = 50000, credits = 1, voiceovers = v.voiceovers, collection = v.collection, quality = v.quality, bodygroups = v.bodygroups}
	end
end

function GetSkinTableByDirectory( dir )
    if !isstring(dir) then error("Function GetSkinTableByDirectory given non-string skin texture") end

    for k, v in pairs( GAMEMODE.WeaponSkins ) do
        if v.directory == dir then return v end
    end
    error( "Function GetSkinTableByDirectory given bad skin texture: " .. dir )
end

function GetModelTableByDirectory( dir )
    if !isstring(dir) then error("Function GetModelTableByDirectory given non-string skin texture") end

    for k, v in pairs( GAMEMODE.PlayerModels ) do
        if v.model == dir then return v end
    end

    if IsDefaultModel( dir ) then return false end

    error( "Function GetModelTableByDirectory given bad model directory: " .. dir )
end

if CLIENT then
    net.Receive( "StartPMPrecache", function()
        for k, v in pairs( GAMEMODE.PlayerModels ) do
            timer.Simple( 0.1 * k, function()
                util.PrecacheModel( v.model )
            end )
        end
    end )
end