GM.MyPrestigeTokens = 0

net.Start( "GetPrestigeTokens" )
net.SendToServer()

net.Receive( "GetPrestigeTokensCallback", function()
    local tokens = net.ReadInt( 16 )
    GAMEMODE.MyPrestigeTokens = tokens
end)