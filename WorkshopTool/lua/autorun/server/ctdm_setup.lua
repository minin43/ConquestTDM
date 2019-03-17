if engine.ActiveGamemode != nil and engine.ActiveGamemode != "sandbox" then return end

if not file.Exists( "tdm/spawns", "DATA" ) then
	file.CreateDir( "tdm/spawns" )
end

if not file.Exists( "tdm/spawns/" .. game.GetMap() .. ".txt", "DATA" ) then
	file.Write( "tdm/spawns/" .. game.GetMap() .. ".txt" )
end