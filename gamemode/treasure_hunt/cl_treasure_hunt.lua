net.Receive( "SaidMagicPhrase", function()
    print("client received SaidMagicPhrase")
    GAMEMODE.HelpMenuObjects[ #GAMEMODE.HelpMenuObjects + 1 ] = { type = "text", display = "https://i.imgur.com/JJaqBLU.png" }
end )