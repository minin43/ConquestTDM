hook.Add("PlayerDeath", "countKillstreaks", function(vic, inf, att)
    
    --[[if att.killsThisLife == 5 then
        att:Give( "5killstreak" )
    elseif att.killsThisLife == 10 then
        att:Give( "10killstreak" )
    elseif att.killsThisLife == 15 then
        att:Give( "15killstreak" )
    end]]
    
end)