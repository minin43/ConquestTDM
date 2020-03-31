--//This file primarily used to share the weapon skin and player model tables between client & server - saving time in net messages
--//Tokens = Prestige Tokens, earned via prestiging - Cash = regular shop currency, earned by playing the game - Credits = donator currency, earned by donating to the server

GM.WeaponSkins = {
	--{ name = "", directory = "", texture = Material( "" ), tokens = 1, cash = 0, credits = 0 },
}
for k, v in pairs(GM.SkinsMasterTable) do
	if v.quality == 0 then
		GM.WeaponSkins[#GM.WeaponSkins + 1] = {name = v.name, directory = v.dir, texture = Material(v.dir), tokens = 1, cash = 50000, credits = 1, rarity = v.quality}
	elseif v.quality == 1 then
		GM.WeaponSkins[#GM.WeaponSkins + 1] = {name = v.name, directory = v.dir, texture = Material(v.dir), tokens = 3, cash = 100000, credits = 1, rarity = v.quality}
	elseif v.quality == 2 then
		GM.WeaponSkins[#GM.WeaponSkins + 1] = {name = v.name, directory = v.dir, texture = Material(v.dir), tokens = 5, cash = 0, credits = 1, rarity = v.quality}
	elseif v.quality == 3 then
		GM.WeaponSkins[#GM.WeaponSkins + 1] = {name = v.name, directory = v.dir, texture = Material(v.dir), tokens = 10, cash = 0, credits = 1, rarity = v.quality}
	elseif v.quality == 4 then
		GM.WeaponSkins[#GM.WeaponSkins + 1] = {name = v.name, directory = v.dir, texture = Material(v.dir), tokens = 20, cash = 0, credits = 2, rarity = v.quality}
	else--if v.quality == 5 then
		GM.WeaponSkins[#GM.WeaponSkins + 1] = {name = v.name, directory = v.dir, texture = Material(v.dir), tokens = 0, cash = 0, credits = 2, rarity = v.quality}
	end
end

--//Any playermodels we add have the option for voiceovers, though I doubt any will get them - see cl_ and sv_character_interaction for specifics
GM.PlayerModels = {
	--{ name = "", model = "", tokens = 1, cash = 0, credits = 0, voiceovers = false },
}
for k, v in pairs(GM.BuyableModels) do
	GM.PlayerModels[#GM.PlayerModels + 1] = {name = v.name, model = v.model, tokens = 1, cash = 0, credits = 0, voiceovers = v.voiceovers}
end