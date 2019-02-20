util.AddNetworkString("KillFeed")

SetGlobalInt("ctdm_global_xp_multiplier", 1)
NOTICETYPES = {
    KILL = 1,
    FLAG = 2,
    EXTRA = 4,
    ROUND = 8
}

SCORECOUNTS = {
    KILL = 100,
    HEADSHOT = 50,
    LONGSHOT = 25,
    
    DOUBLE_KILL = 50,
    TRIPLE_KILL = 100,
    QUAD_KILL = 150,
    MULTI_KILL = 200,
    MULTI_KILL_MULTIPLIER = 50,
    
    LOW_HEALTH = 50,
    FLAG_ATT_DEF = 50,
    AFTERLIFE = 200,
    END_GAME = 100,
    
    FLAG_CAPTURED = 400,
    FLAG_NEUTRALIZED = 200,
    FLAG_SAVED = 10,
    
    ROUND_WON = 500,
    ROUND_LOST = 100,
    ROUND_TIED = 250
}

function AddNotice(ply, text, score, type, color, suppressrewards)
    if !color then color = Color(255, 255, 255, 255) end
    if !suppressrewards then suppressrewards = false end
    score = score * GetGlobalInt("ctdm_global_xp_multiplier")
    net.Start("KillFeed")
        net.WriteString(text)
        net.WriteInt(score, 16) -- short type
        net.WriteInt(type, 16)
        net.WriteColor(color)
    net.Send(ply)
    if suppressrewards then return end
    AddRewards(ply, score)
end

function AddRewards(ply, score)
    lvl.AddEXP(ply, score)
    AddMoney(ply, score)
    ply:AddScore(score)
end


hook.Add("PlayerDeath", "AddNotices", function(vic, inf, att)
    if !att:IsValid() || !vic:IsValid() || att == vic || att:GetActiveWeapon() == NULL || att:GetActiveWeapon() == NULL then
        return
    end
    --local col = team.GetColor(vic:Team())
    local col = Color(255, 0, 83)
    AddNotice(att, vic:Name(), SCORECOUNTS.KILL, NOTICETYPES.KILL, col)
    
    -- Add extras
    
    -- Headshot
    if vic:LastHitGroup() == HITGROUP_HEAD then
        AddNotice(att, "HEADSHOT", SCORECOUNTS.HEADSHOT, NOTICETYPES.EXTRA)
        hook.Run( "MatchHistory_HS", att )
    end
    
    -- Marksman bonus
    shotDistance = math.Round(att:GetPos():Distance(vic:GetPos()) / 39) -- Converts to meters
    if shotDistance >= 50 and vic:LastHitGroup() == HITGROUP_HEAD then
        AddNotice(att, "MARKSMAN", shotDistance, NOTICETYPES.EXTRA)
        hook.Run( "MatchHistory_Distance", att, shotDistance )
        local data = att:GetPData("g_headshot")
        if not data then
            att:SetPData("g_headshot", shotDistance)
        else
            if shotDistance > tonumber(data) then
                att:SetPData("g_headshot", shotDistance)
            end
        end
    elseif shotDistance >= 100 and vic:LastHitGroup() ~= HITGROUP_HEAD then
        AddNotice(att, "LONGSHOT", SCORECOUNTS.LONGSHOT, NOTICETYPES.EXTRA)
    end
    
    -- Kill streaks
    if not att.killcount then
        att.killcount = 0
    end
    if att.killcount ~= 0 then
        if att.killcount == 1 then
            AddNotice(att, "DOUBLE KILL", SCORECOUNTS.DOUBLE_KILL, NOTICETYPES.EXTRA)
        elseif att.killcount == 2 then
            AddNotice(att, "TRIPLE KILL", SCORECOUNTS.TRIPLE_KILL, NOTICETYPES.EXTRA)
        elseif att.killcount == 3 then
            AddNotice(att, "QUAD KILL", SCORECOUNTS.QUAD_KILL, NOTICETYPES.EXTRA)
        elseif att.killcount >= 4 then
            sc = SCORECOUNTS.MULTI_KILL_MULTIPLIER * (att.killcount - 4) + SCORECOUNTS.MULTI_KILL
            AddNotice(att, "MULTI KILL", sc, NOTICETYPES.EXTRA)
        end
        hook.Run( "MatchHistory_Multi", att, att.killcount )
        timer.Simple(0.1, function() 
            net.Start("tdm_killcountnotice")
                net.WriteEntity(att)
                net.WriteString(att.killcount)
            net.Broadcast()
        end)
    end
    
    -- Low Health
    if att:Health() <= 10 then
        AddNotice(att, "LOW HEALTH", SCORECOUNTS.LOW_HEALTH, NOTICETYPES.EXTRA)
    end
    
    -- Flags
    if tab[vic] ~= 0 then
        AddNotice(att, "FLAG ATTACK", SCORECOUNTS.FLAG_ATT_DEF, NOTICETYPES.EXTRA)
        hook.Run( "MatchHistory_FlagOffense", att )
    end
    if tab[att] ~= 0 then
        AddNotice(att, "FLAG DEFENSE", SCORECOUNTS.FLAG_ATT_DEF, NOTICETYPES.EXTRA)
        hook.Run( "MatchHistory_FlagDefense", att )
    end
    
    -- Killed someone from the dead (grenade, etc)
    if not att:Alive() then
        AddNotice(att, "AFTERLIFE", SCORECOUNTS.AFTERLIFE, NOTICETYPES.EXTRA)
    end
    
    -- Implement this in the hud
    -- if (GetConVarNumber("tdm_xpmulti") > 1) then
    --     AddNotice(att, "GLOBAL XP MULTIPLIER x" .. tostring(GetConVarNumber("tdm_xpmulti")),(
    -- end
    if GetGlobalBool("RoundFinished") then
        AddNotice(att, "END GAME KILL", SCORECOUNTS.END_GAME, NOTICETYPES.EXTRA)
    end
    
    -- Assist stuff
    if vic.PotentialAssist then
        local assist = vic.PotentialAssist
        if IsValid(assist[1]) and assist[1] ~= NULL then
            if assist[1] ~= att then
                AddNotice(assist[1], "ASSIST", assist[2], NOTICETYPES.KILL)
                hook.Run( "MatchHistory_Assist", assist[1] )
                if assist[1]:GetNWString("assists") == "" or not assist[1]:GetNWString("assists") then
                    assist[1]:SetNWString("assists", "1")
                else
                    assist[1]:SetNWString("assists", tostring(tonumber(assist[1]:GetNWString("assists")) + 1))
                end
                local ply = assist[1]
                local data = ply:GetPData("g_assists")
                if !data then
                    ply:SetPData("g_assists", "1")
                else
                    local num = tonumber(data)
                    ply:SetPData("g_assists", tostring(num + 1))
                end
            end
        end
    end
    vic.PotentialAssist = nil
    vic.dmg = nil
    
    -- Kill streak stuff
    if att.killcount then
		att.killcount = att.killcount + 1
	else
		att.killcount = 1
	end
    if !timer.Exists("Killcount" .. att:SteamID()) then 
        timer.Create("Killcount" .. att:SteamID(), 7, 1, function()
            att.killcount = 0
            timer.Destroy("Killcount" .. att:SteamID())
        end)
    end
    timer.Start("Killcount" .. att:SteamID())
end)

hook.Add("PlayerHurt", "CalculateAssists", function(victim, attacker, x, dmg)
	if victim and attacker and victim:IsPlayer() and attacker:IsPlayer() and victim ~= NULL and attacker ~= NULL then
		if not victim.dmg then
			victim.dmg = {}
		end
		if not victim.dmg[attacker] then
			victim.dmg[attacker] = dmg
		else
			victim.dmg[attacker] = victim.dmg[attacker] + dmg
		end
		if not victim.PotentialAssist then
			if victim.dmg[attacker] >= 50 then
				victim.PotentialAssist = { attacker, math.Round(victim.dmg[attacker]) }
			end
		end
	end
end)
