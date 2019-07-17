--//This file primarily used to share the weapon skin and player model tables between client & server - saving time in net messages
--//Tokens = Prestige Tokens, earned via prestiging - Cash = regular shop currency, earned by playing the game - Credits = donator currency, earned by donating to the server

GM.WeaponSkins = {
	{ name = "", directory = "", texture = Material( "" ), tokens = 1, cash = 0, credits = 0 },
}

--//Any playermodels we add have the option for voiceovers, though I doubt any will get them - see cl_ and sv_character_interaction for specifics
GM.PlayerModels = {
	{ name = "", model = "", price = 1, cash = 0, credits = 0, voiceovers = false },
}