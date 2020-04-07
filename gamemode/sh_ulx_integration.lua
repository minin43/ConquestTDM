--if !ulx or !ULib then return end

--//Force swap the given player's teams

function ulx.changeTeam(calling_ply, target_plys)
    for k, v in pairs(target_plys) do
        --//Don't switch anyone out of spectator
        if v:Team() == 1 then
            v:ConCommand( "tdm_setteam " ..  2 )
        elseif v:Team() == 2 then
            v:ConCommand( "tdm_setteam " ..  1 )
        end
    end
end
local changeTeam = ulx.command("CTDM Commands", "ulx changeteam", ulx.changeTeam, "!changeteam")
changeTeam:addParam{ type = ULib.cmds.PlayersArg }
changeTeam:defaultAccess( ULib.ACCESS_SUPERADMIN )

--//Force the given players to the specified team (ignores auto-balance)

function ulx.setTeam(calling_ply, target_plys, target_team)
    target_team = tonumber(target_team)
    if target_team != 1 and target_team != 2 then return end --//Don't switch to invalid teams

    for k, v in pairs(target_plys) do
        if v:Team() != target_team and (v:Team() == 1 or v:Team() == 2) then
            v:ConCommand( "tdm_setteam " ..  target_team )
        end
    end
end
local setTeam = ulx.command("CTDM Commands", "ulx forceteam", ulx.setTeam, "!forceteam")
setTeam:addParam{ type = ULib.cmds.PlayersArg }
setTeam:addParam{ type=ULib.cmds.StringArg, hint = "Set Team (1 for red, 2 for blue)" }
setTeam:defaultAccess( ULib.ACCESS_SUPERADMIN )

--//Manually set given player's levels

function ulx.setLevel(calling_ply, target_plys, target_lvl)
    for k, v in pairs(target_plys) do
        lvl.SetLevel(v, tonumber(target_lvl))
        lvl.SendUpdate(v)
    end

    ulx.fancyLogAdmin(calling_ply, "#A Set the following players to level " .. target_lvl .. ": #T", target_plys)
end
local setLevel = ulx.command("CTDM Commands", "ulx setlevel", ulx.setLevel, "!setlevel")
setLevel:addParam{ type = ULib.cmds.PlayersArg }
setLevel:addParam{ type=ULib.cmds.StringArg, hint = "Desired Level" }
setLevel:defaultAccess( ULib.ACCESS_SUPERADMIN )

--//Manually set given player's cash

function ulx.setMoney(calling_ply, target_plys, target_money)
    for k, v in pairs(target_plys) do
        SetMoney(v, tonumber(target_money))
        SendUpdate(v)
    end

    ulx.fancyLogAdmin(calling_ply, "#A Set the following player's money count to " .. target_money .. ": #T", target_plys)
end
local setMoney = ulx.command("CTDM Commands", "ulx setmoney", ulx.setMoney, "!setmoney")
setMoney:addParam{type = ULib.cmds.PlayersArg}
setMoney:addParam{type = ULib.cmds.StringArg, hint = "Desired Money Count"}
setMoney:defaultAccess(ULib.ACCESS_SUPERADMIN)

--//ADD TO given player's cash

function ulx.addMoney(calling_ply, target_plys, target_money)
    for k, v in pairs(target_plys) do
        SetMoney(v, tonumber(target_money))
        SendUpdate(v)
    end

    ulx.fancyLogAdmin(calling_ply, "#A Added " .. target_money .. " money to the following players: #T", target_plys)
end
local addMoney = ulx.command("CTDM Commands", "ulx addmoney", ulx.addMoney, "!addmoney")
addMoney:addParam{type = ULib.cmds.PlayersArg}
addMoney:addParam{type = ULib.cmds.StringArg, hint = "Money To Add"}
addMoney:defaultAccess(ULib.ACCESS_SUPERADMIN)

--//Credits is donator cash, used to buy cosmetics

function ulx.setCredits(calling_ply, target_plys, target_credits)
    for k, v in pairs(target_plys) do
        donations.SetCredits(v, tonumber(target_credits) or donations.GetCredits(v))
        donations.UpdateCredits(v)
    end

    ulx.fancyLogAdmin(calling_ply, "#A Set the following player's DONATOR'S CREDITS to " .. target_credits .. ": #T", target_plys)
end
local setCredits = ulx.command("CTDM Commands", "ulx setcredits", ulx.setCredits, "!setcredits")
setCredits:addParam{type = ULib.cmds.PlayersArg}
setCredits:addParam{type = ULib.cmds.StringArg, hint = "Desired Donator Credits"}
setCredits:defaultAccess(ULib.ACCESS_SUPERADMIN)

--//ADD TO given player's donator credits

function ulx.addCredits(calling_ply, target_plys, target_credits)
    for k, v in pairs(target_plys) do
        donations.AddCredits(v, tonumber(target_credits) or 0)
        donations.UpdateCredits(v)
    end

    ulx.fancyLogAdmin(calling_ply, "#A Added " .. target_credits .. " DONATOR'S CREDITS to the following players: #T", target_plys)
end
local addCredits = ulx.command("CTDM Commands", "ulx addcredits", ulx.addCredits, "!addcredits")
addCredits:addParam{type = ULib.cmds.PlayersArg}
addCredits:addParam{type = ULib.cmds.StringArg, hint = "Donator Credits To Add"}
addCredits:defaultAccess(ULib.ACCESS_SUPERADMIN)

--//Tokens are the prestige tokens, used to buy cosmetics

function ulx.setTokens(calling_ply, target_plys, target_tokens)
    for k, v in pairs(target_plys) do
        prestige.SetTokens(v, tonumber(target_tokens) or prestige.GetTokens(v))
        prestige.UpdateTokens(v)
    end

    ulx.fancyLogAdmin(calling_ply, "#A Set the following player's PRESTIGE TOKENS to " .. target_tokens .. ": #T", target_plys)
end
local setTokens = ulx.command("CTDM Commands", "ulx settokens", ulx.setTokens, "!settokens")
setTokens:addParam{type = ULib.cmds.PlayersArg}
setTokens:addParam{type = ULib.cmds.StringArg, hint = "Desired Prestige Tokens"}
setTokens:defaultAccess(ULib.ACCESS_SUPERADMIN)

--//ADD TO given player's prestige tokens

function ulx.addTokens(calling_ply, target_plys, target_tokens)
    for k, v in pairs(target_plys) do
        prestige.AddTokens(v, tonumber(target_tokens) or 0)
        prestige.UpdateTokens(v)
    end

    ulx.fancyLogAdmin(calling_ply, "#A Added " .. target_tokens .. " PRESTIGE TOKENS to the following players: #T", target_plys)
end
local addTokens = ulx.command("CTDM Commands", "ulx addtokens", ulx.addTokens, "!addtokens")
addTokens:addParam{type = ULib.cmds.PlayersArg}
addTokens:addParam{type = ULib.cmds.StringArg, hint = "Prestige Tokens To Add"}
addTokens:defaultAccess(ULib.ACCESS_SUPERADMIN)