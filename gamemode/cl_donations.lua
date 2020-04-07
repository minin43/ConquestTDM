GM.MyCredits = 0

net.Start( "GetDonatorCredits")
net.SendToServer()

net.Receive( "GetDonatorCreditsCallback", function()
    local credits = net.ReadInt( 16 )
    GAMEMODE.MyCredits = credits
end)