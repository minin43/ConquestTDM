GM.MyLevel = 0
GM.NotifyUnlocks = 0
currentlvl = -1
currentexp = -1
nextlvlexp = -1

net.Receive( "SendUpdate", function()
	local lv = tonumber( net.ReadString() )
	local exp = tonumber( net.ReadString() )
	local nextlvl = tonumber( net.ReadString() )
    currentlvl = lv
    GAMEMODE.MyLevel = lv
	currentexp = exp
	nextlvlexp = nextlvl
end )

net.Receive( "NewLevel", function()
    local newunlocks = net.ReadInt( 8 )
    if newunlocks > 0 then
        GAMEMODE.NotifyUnlocks = GAMEMODE.NotifyUnlocks + newunlocks
    end

    surface.PlaySound( "ui/UI_Awards_Basic_wav.mp3" )
end )

timer.Create( "Refresh", 5, 0, function()
	if currentlvl == -1 and currentexp == -1 and nextlvlexp == -1 then
		RunConsoleCommand( "lvl_refresh" )
	end
end )