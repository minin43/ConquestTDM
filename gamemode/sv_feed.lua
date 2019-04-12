util.AddNetworkString( "KillFeed" )
util.AddNetworkString( "Announcer" )

SetGlobalInt("ctdm_global_xp_multiplier", 1)
NOTICETYPES = {
    KILL = 1,
    FLAG = 2,
    EXTRA = 4,
    ROUND = 8,
    SPECIAL = 16
}

SCORECOUNTS = {
    KILL = 100,
    HEADSHOT = 50,
    LONGSHOT = 25,
    FIRSTBLOOD = 50,
    DENIED = 100,
    VENDETTA = 50,
    VENDETTA_HUMILIATION = 200,
    
    DOUBLE_KILL = 50,
    MULTI_KILL = 100,
    MEGA_KILL = 150,
    ULTRA_KILL = 200,
    UNREAL_KILL_MULTIPLIER = 50,
	
	KILLSTREAK5 = 100,
    KILLSTREAK6 = 200,
    KILLSTREAK7 = 300,
    KILLSTREAK8 = 400,
    KILLSTREAK9 = 500,
    KILLSTREAK10 = 1000,
    KILLSTREAK15 = 1500,
    KILLSTREAK20 = 2000,
    KILLSTREAK30 = 3000,
    
    LOW_HEALTH = 50,
    FLAG_ATT_DEF = 50,
    AFTERLIFE = 200,
    END_GAME = 100,
    
    FLAG_CAPTURED = 300,
    FLAG_NEUTRALIZED = 200,
    FLAG_SAVED = 50,
    
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

--//All point distribution is done in this hook
hook.Add("PlayerDeath", "AddNotices", function(vic, inf, att)
    --Include checks for bots
    if vic:IsWorld() or inf:IsWorld() or att:IsWorld() then return end
    if att == "entityflame" or att:GetClass() == "entityflame" then
        att = GAMEMODE.PyroChecks[ id( vic:SteamID() ) ]
    end
    
    local vicID = id( vic:SteamID() )
    local attID = id( att:SteamID() )

    --//Make sure the relevant tables and values are set up
    GAMEMODE.FirstBloodCheck = GAMEMODE.FirstBloodCheck or false
    GAMEMODE.KillInfoTracking = GAMEMODE.KillInfoTracking or { }
    GAMEMODE.KillInfoTracking[ vicID ] = GAMEMODE.KillInfoTracking[ vicID ] or { }
    GAMEMODE.KillInfoTracking[ attID ] = GAMEMODE.KillInfoTracking[ attID ] or { }

    GAMEMODE.KillInfoTracking[ vicID ].KillsThisLife = GAMEMODE.KillInfoTracking[ vicID ].KillsThisLife or 0
    GAMEMODE.KillInfoTracking[ attID ].KillsThisLife = GAMEMODE.KillInfoTracking[ attID ].KillsThisLife or 0

    GAMEMODE.KillInfoTracking[ vicID ].KillSpree = GAMEMODE.KillInfoTracking[ vicID ].KillSpree or 0
    GAMEMODE.KillInfoTracking[ attID ].KillSpree = GAMEMODE.KillInfoTracking[ attID ].KillSpree or 0

    if vicID == attID then GAMEMODE.KillInfoTracking[ attID ].KillsThisLife = 0 return end
    GAMEMODE.KillInfoTracking[ vicID ].KillsThisLife = 0

    if !att:IsPlayer() or !att:IsValid() or !vic:IsValid() or att == vic or att:GetActiveWeapon() == NULL or att:GetActiveWeapon() == NULL then
        return
    end
    
    --Standard Kill Notice
    AddNotice( att, vic:Name(), SCORECOUNTS.KILL, NOTICETYPES.KILL, Color(255, 0, 83) )
    GAMEMODE.KillInfoTracking[ attID ].KillsThisLife = GAMEMODE.KillInfoTracking[ attID ].KillsThisLife + 1
    GAMEMODE.KillInfoTracking[ attID ].KillSpree = GAMEMODE.KillInfoTracking[ attID ].KillSpree + 1
    local SoundToSend

    --//First Blood Check
    if not GAMEMODE.FirstBloodCheck then
        AddNotice( att, "FIRST BLOOD", SCORECOUNTS.FIRSTBLOOD, NOTICETYPES.EXTRA )
        GAMEMODE.FirstBloodCheck = true
        SoundToSend = "firstblood"
    end

    --//Payback Check
    GAMEMODE.KillInfoTracking[ vicID ].LastKiller = attID
    if vicID == GAMEMODE.KillInfoTracking[ attID ].LastKiller then
        AddNotice( att, "PAYBACK", SCORECOUNTS.HEADSHOT, NOTICETYPES.EXTRA )
        GAMEMODE.KillInfoTracking[ attID ].LastKiller = ""
        SoundToSend = "payback"
    end

    print("vendettaList being checked...")
    --//Vendetta Checks
    if GAMEMODE.VendettaList[ vicID ][ attID ] > 3 then --//When you're their vendetta, and kill them anyway
        AddNotice( att, "ERADICATION", SCORECOUNTS.VENDETTA_HUMILIATION, NOTICETYPES.EXTRA )
        SoundToSend = "eradication"
    elseif GAMEMODE.VendettaList[ attID ][ vicID ] > 2 then --//When they're your vendetta
        AddNotice( att, "RETRIBUTION", SCORECOUNTS.VENDETTA, NOTICETYPES.EXTRA )
        SoundToSend = "retribution"
    end

    --//Marksman Bonus Check
    shotDistance = math.Round(att:GetPos():Distance(vic:GetPos()) / 39) -- Converts to meters
    if vic:LastHitGroup() == HITGROUP_HEAD and shotDistance < 50 then
        AddNotice(att, "HEADSHOT", SCORECOUNTS.HEADSHOT, NOTICETYPES.EXTRA)
        SoundToSend = "headshot"
    elseif shotDistance >= 50 and shotDistance < 100 and vic:LastHitGroup() == HITGROUP_HEAD then
        AddNotice(att, "BULLSYE", shotDistance, NOTICETYPES.EXTRA)
        AddNotice(att, "HEADSHOT", SCORECOUNTS.HEADSHOT, NOTICETYPES.EXTRA)
        SoundToSend = "bullseye"
        local data = att:GetPData("g_headshot")
        if not data then
            att:SetPData("g_headshot", shotDistance)
        else
            if shotDistance > tonumber(data) then
                att:SetPData("g_headshot", shotDistance)
            end
        end
    elseif shotDistance >= 50 and vic:LastHitGroup() ~= HITGROUP_HEAD then
        AddNotice(att, "EAGLE EYE", SCORECOUNTS.LONGSHOT, NOTICETYPES.EXTRA)
        SoundToSend = "eagleeye"
    elseif shotDistance >= 100 and vic:LastHitGroup() == HITGROUP_HEAD then
        AddNotice(att, "HEAD HUNTER", SCORECOUNTS.LONGSHOT, NOTICETYPES.EXTRA)
        AddNotice(att, "HEADSHOT", SCORECOUNTS.HEADSHOT, NOTICETYPES.EXTRA)
        SoundToSend = "headhunter"
    end

    --//Low Health Check
    if att:Health() <= 20 then
        AddNotice(att, "LOW HEALTH", SCORECOUNTS.LOW_HEALTH, NOTICETYPES.EXTRA)
    end
    
    --//Flags Offense/Defense Check
    if tab[vic] ~= 0 then
        AddNotice(att, "FLAG ATTACK", SCORECOUNTS.FLAG_ATT_DEF, NOTICETYPES.EXTRA)
    end
    if tab[att] ~= 0 then
        AddNotice(att, "FLAG DEFENSE", SCORECOUNTS.FLAG_ATT_DEF, NOTICETYPES.EXTRA)
    end
    
    --//Afterlife Check
    if not att:Alive() then
        AddNotice(att, "AFTERLIFE", SCORECOUNTS.AFTERLIFE, NOTICETYPES.EXTRA)
    end
    
    --//End Game Kill Check
    if GetGlobalBool("RoundFinished") then
        AddNotice(att, "END GAME KILL", SCORECOUNTS.END_GAME, NOTICETYPES.EXTRA)
    end
    
    --//Assist Shit - I'm not touching this with a 10 foot pole, no thanks, it can stay unoptimized
    if vic.PotentialAssist then
        local assist = vic.PotentialAssist
        if IsValid(assist[1]) and assist[1] ~= NULL then
            if assist[1] ~= att then
                AddNotice(assist[1], "ASSIST", assist[2], NOTICETYPES.KILL)
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
                
                ply.AttFromAssist = ( ply.AttFromAssist or 0 ) + assist[2]
                if ply.AttFromAssist >= 200 then UpdateAttKillTracking( ply, ply:GetActiveWeapon() ) end
                ply.AttFromAssist = ply.AttFromAssist - 200
            end
        end
    end
    vic.PotentialAssist = nil
    vic.dmg = nil

    --//Killspree & Killstreak End Check
    if GAMEMODE.KillInfoTracking[ vicID ].KillSpree >= 2 then --If the victim has reached a double kill, but hasn't timed the spree out yet
        AddNotice(att, "DENIED KILLSPREE", SCORECOUNTS.DENIED, NOTICETYPES.EXTRA)
        SoundToSend = "denied"
    elseif GAMEMODE.KillInfoTracking[ vicID ].KillsThisLife >= 5 then --If the victim has hit a DOMINATING killstreak
        AddNotice(att, "DENIED KILLSTREAK", SCORECOUNTS.DENIED, NOTICETYPES.EXTRA)
        SoundToSend = "rejected"
    end

    --//Killspree Timer Check
    if timer.Exists( "Killcount" .. attID ) then 
        timer.Destroy( "Killcount" .. attID )
    end
    timer.Create("Killcount" .. attID, 7, 1, function()
        GAMEMODE.KillInfoTracking[ attID ].KillSpree = 0
        timer.Destroy( "Killcount" .. attID )
    end)
    timer.Start( "Killcount" .. att:SteamID() )

    --//Killspree Check
    if GAMEMODE.KillInfoTracking[ attID ].KillSpree > 1 then
        if GAMEMODE.KillInfoTracking[ attID ].KillSpree == 2 then
            AddNotice(att, "DOUBLE KILL", SCORECOUNTS.DOUBLE_KILL, NOTICETYPES.SPECIAL, Color( 200, 0, 0 ))
            SoundToSend = "doublekill"
        elseif GAMEMODE.KillInfoTracking[ attID ].KillSpree == 3 then
            AddNotice(att, "MULTI KILL", SCORECOUNTS.MULTI_KILL, NOTICETYPES.SPECIAL, Color( 200, 0, 0 ))
            SoundToSend = "multikill"
        elseif GAMEMODE.KillInfoTracking[ attID ].KillSpree == 4 then
            AddNotice(att, "MEGA KILL", SCORECOUNTS.MEGA_KILL, NOTICETYPES.SPECIAL, Color( 200, 0, 0 ))
            SoundToSend = "megakill"
		elseif GAMEMODE.KillInfoTracking[ attID ].KillSpree == 5 then
            AddNotice(att, "ULTRA KILL", SCORECOUNTS.ULTRA_KILL, NOTICETYPES.SPECIAL, Color( 200, 0, 0 ))
            SoundToSend = "ultrakill"
        elseif GAMEMODE.KillInfoTracking[ attID ].KillSpree >= 6 then
            sc = SCORECOUNTS.UNREAL_KILL_MULTIPLIER * (GAMEMODE.KillInfoTracking[ attID ].KillSpree - 6) + SCORECOUNTS.MULTI_KILL
            AddNotice(att, "UNREAL", sc, NOTICETYPES.SPECIAL, Color( 200, 0, 0 ))
			SoundToSend = "unreal"
        end
        timer.Simple(0.1, function() 
            net.Start("tdm_killcountnotice")
                net.WriteEntity(att)
                net.WriteString(GAMEMODE.KillInfoTracking[ attID ].KillSpree)
            net.Broadcast() --Maybe not broadcast Killingspree information?
        end)
    end

    --//Killstreak & Killspree tracking shit
    local KillstreakNotices = {
        [5] = "DOMINATING",
        [6] = "RAMPAGE",
        [7] = "IMPRESSIVE",
        [8] = "GUNSLINGER",
        [9] = "BLOODBATH",
        [10] = "BLAZE OF GLORY",
        [15] = "OUTSTANDING",
        [20] = "TOP GUN",
        [30] = "SHAFT-MASTER"
    }

    local throwaway = GAMEMODE.KillInfoTracking[ attID ].KillsThisLife
    if KillstreakNotices[ throwaway ] then
        AddNotice( att, KillstreakNotices[ throwaway ], SCORECOUNTS["KILLSTREAK".. throwaway ], NOTICETYPES.SPECIAL, Color( 200, 0, 0 ) )
        SoundToSend = KillstreakNotices[ throwaway ]
        for k, v in pairs( player.GetAll() ) do
            v:ChatPrint( att:Nick() .. " is on a " .. throwaway .. " killstreak!" )
        end
    end

    if SoundToSend then
        net.Start( "Announcer" )
            net.WriteString( SoundToSend )
        net.Send( att )
    end

    --Drone Road Kill
    --[[if inf:GetClass() == "prop_physics" then
        AddNotice( att, "VEHICLE KILL", SCORECOUNTS.KILL, NOTICETYPES.EXTRA)
    end]]
end)

--[[hook.Add("PlayerHurt", "CalculateAssists", function(victim, attacker, x, dmg)
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
			if victim.dmg[attacker] >= 1 then
				victim.PotentialAssist = { attacker, math.Round(victim.dmg[attacker]) }
			end
		end
	end
end)]]

hook.Add("PlayerHurt", "CalculateAssists", function(victim, attacker, x, dmg)
	if victim and attacker and victim:IsPlayer() and attacker:IsPlayer() and victim ~= NULL and attacker ~= NULL then
		if not victim.dmg then
			victim.dmg = {}
        end
        
        victim.dmg[attacker] = ( victim.dmg[attacker] or 0 ) + dmg

		if not victim.PotentialAssist then
			if victim.dmg[attacker] >= 1 then
				victim.PotentialAssist = { attacker, math.Round(victim.dmg[attacker]) }
			end
		end
	end
end)