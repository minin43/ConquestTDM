if engine.ActiveGamemode != nil and engine.ActiveGamemode != "sandbox" then return end

if not file.Exists( "tdm/tool", "DATA" ) then
	file.CreateDir( "tdm/tool" )
end

if not file.Exists( "tdm/tool/" .. game.GetMap() .. ".txt", "DATA" ) then
	file.Write( "tdm/tool/" .. game.GetMap() .. ".txt", "[]" )
end