util.AddNetworkString( "KillFeed" )
util.AddNetworkString( "Announcer" )

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
    VENDETTA_HUMILIATION_SPECIAL = 250,
    MIDAIR = 50,
    SKEET = 100,
    
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

function AddNotice(ply, text, score, type, color)
    if GAMEMODE.pointGainDisabled then return end

    color = color or Color(255, 255, 255, 255)

    net.Start("KillFeed")
        net.WriteString(text)
        net.WriteInt(score, 16) -- short type
        net.WriteInt(type, 16)
        net.WriteColor(color)
    net.Send(ply)
    
    AddRewards(ply, score)
end

function AddRewards(ply, score)
    lvl.AddEXP(ply, score)
    AddMoney(ply, score)
    ply:AddScore(score)
end

--//All point distribution related to combat is done in this hook
hook.Add( "PlayerDeath", "AddNotices", function( vic, wep, att )

    if vic:IsWorld() or att:IsWorld() then return end
    
    if att == "entityflame" or att:GetClass() == "entityflame" then
        att = GAMEMODE.PyroChecks[ id( vic:SteamID() ) ]
        if not att then return end
    elseif att == "cw_40mm_explosive" or att:GetClass() == "cw_40mm_explosive" or att == "cw_40mm_smoke" or att:GetClass() == "cw_40mm_smoke" then
        att = att:GetOwner()
    end

    if not IsValid( att ) or not att:IsPlayer() then return end
    
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
    if !att:IsPlayer() or !att:IsValid() or !vic:IsValid() or att == vic or att:GetActiveWeapon() == NULL or !vic:IsPlayer() then
        return
    end

    local totalpointcount = 0
    
    --Standard Kill Notice
    AddNotice( att, vic:Name(), SCORECOUNTS.KILL, NOTICETYPES.KILL, Color(255, 0, 83) )
    totalpointcount = totalpointcount + SCORECOUNTS.KILL
    GAMEMODE.KillInfoTracking[ attID ].KillsThisLife = GAMEMODE.KillInfoTracking[ attID ].KillsThisLife + 1
    GAMEMODE.KillInfoTracking[ attID ].KillSpree = GAMEMODE.KillInfoTracking[ attID ].KillSpree + 1
    local SoundToSend
    hook.Call( "KillFeedStandard", GAMEMODE, att, vic )
    
    --//First Blood Check
    if not GAMEMODE.FirstBloodCheck then
        hook.Call( "KillfeedFirstBlood", GAMEMODE, att )
        AddNotice( att, "FIRST BLOOD", SCORECOUNTS.FIRSTBLOOD, NOTICETYPES.EXTRA )
        totalpointcount = totalpointcount + SCORECOUNTS.FIRSTBLOOD
        GAMEMODE.FirstBloodCheck = true
        SoundToSend = "firstblood"
    end

    --//Payback Check
    GAMEMODE.KillInfoTracking[ vicID ].LastKiller = attID
    if vicID == GAMEMODE.KillInfoTracking[ attID ].LastKiller then
        hook.Call( "KillFeedPayback", GAMEMODE, att )
        AddNotice( att, "PAYBACK", SCORECOUNTS.HEADSHOT, NOTICETYPES.EXTRA )
        totalpointcount = totalpointcount + SCORECOUNTS.HEADSHOT
        GAMEMODE.KillInfoTracking[ attID ].LastKiller = ""
        SoundToSend = "payback"

        if vic:LastHitGroup() == HITGROUP_HEAD then
            IncrementTitleCounting( att, GAMEMODE:GetTitleTable( "bloodmoney" ) )
        end
    end

    --//Vendetta Checks
    GAMEMODE.VendettaList[ vicID ].ActiveSaves = GAMEMODE.VendettaList[ vicID ].ActiveSaves or { }
    GAMEMODE.VendettaList[ attID ].ActiveSaves = GAMEMODE.VendettaList[ attID ].ActiveSaves or { }
    --//When you're their vendetta, and kill them anyway
    if GAMEMODE.VendettaList[ vicID ].ActiveSaves[ attID ] then --and GAMEMODE.VendettaList[ vicID ][ attID ] > self:GetVendettaRequirement( vic ) then
        hook.Call( "KillFeedHumiliated", GAMEMODE, vic )

        local numenemies = #team.GetPlayers( vic:Team() )
        if numenemies > 2 and GetBestPlayerByTeam(vic:Team()) == vic then
            hook.Call( "KillFeedBGH", GAMEMODE, att )
            AddNotice( att, "BIG GAME HUNTER", SCORECOUNTS.VENDETTA_HUMILIATION_SPECIAL, NOTICETYPES.EXTRA )
            totalpointcount = totalpointcount + SCORECOUNTS.VENDETTA_HUMILIATION_SPECIAL
            SoundToSend = "biggamehunter"
        elseif numenemies > 2 and GetWorstPlayerByTeam(vic:Team()) == vic then
            hook.Call( "KillFeedBottomFeeder", GAMEMODE, att )
            AddNotice( att, "BOTTOM FEEDER", SCORECOUNTS.VENDETTA_HUMILIATION, NOTICETYPES.EXTRA )
            totalpointcount = totalpointcount + SCORECOUNTS.VENDETTA_HUMILIATION
            SoundToSend = "bottomfeeder"
        else
            hook.Call( "KillFeedHumiliator", GAMEMODE, att )
            AddNotice( att, "ERADICATION", SCORECOUNTS.VENDETTA_HUMILIATION, NOTICETYPES.EXTRA )
            totalpointcount = totalpointcount + SCORECOUNTS.VENDETTA_HUMILIATION
            SoundToSend = "eradication"
        end
    --//When they're your vendetta
    elseif GAMEMODE.VendettaList[ attID ].ActiveSaves[ vicID ] then
        hook.Call( "KillFeedRevenger", GAMEMODE, att )
        AddNotice( att, "RETRIBUTION", SCORECOUNTS.VENDETTA, NOTICETYPES.EXTRA )
        totalpointcount = totalpointcount + SCORECOUNTS.VENDETTA
        SoundToSend = "retribution"
    end

    --//Marksman Bonus Check
    shotDistance = math.Round(att:GetPos():Distance(vic:GetPos()) / 39) -- Converts to meters
    if vic:LastHitGroup() == HITGROUP_HEAD and shotDistance < 50 then
        hook.Call( "KillFeedHeadshot", GAMEMODE, att )
        AddNotice(att, "HEADSHOT", SCORECOUNTS.HEADSHOT, NOTICETYPES.EXTRA)
        totalpointcount = totalpointcount + SCORECOUNTS.HEADSHOT
        SoundToSend = "headshot"
    elseif shotDistance >= 50 and shotDistance < 100 and vic:LastHitGroup() == HITGROUP_HEAD then
        hook.Call( "KillFeedHeadshot", GAMEMODE, att )
        AddNotice(att, "BULLSYE", shotDistance, NOTICETYPES.EXTRA)
        totalpointcount = totalpointcount + shotDistance
        AddNotice(att, "HEADSHOT", SCORECOUNTS.HEADSHOT, NOTICETYPES.EXTRA)
        totalpointcount = totalpointcount + SCORECOUNTS.HEADSHOT
        SoundToSend = "bullseye"
        --//Longest Distance Headshot
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
        totalpointcount = totalpointcount + SCORECOUNTS.LONGSHOT
        SoundToSend = "eagleeye"
    elseif shotDistance >= 100 and vic:LastHitGroup() == HITGROUP_HEAD then
        hook.Call( "KillFeedHeadhunter", GAMEMODE, att )
        AddNotice(att, "HEAD HUNTER", SCORECOUNTS.LONGSHOT, NOTICETYPES.EXTRA)
        totalpointcount = totalpointcount + SCORECOUNTS.LONGSHOT
        AddNotice(att, "HEADSHOT", SCORECOUNTS.HEADSHOT, NOTICETYPES.EXTRA)
        totalpointcount = totalpointcount + SCORECOUNTS.HEADSHOT
        SoundToSend = "headhunter"
    end

    --//Low Health Check
    if att:Health() <= 20 then
        hook.Call( "KillFeedLowHealth", GAMEMODE, att )
        AddNotice(att, "LOW HEALTH", SCORECOUNTS.LOW_HEALTH, NOTICETYPES.EXTRA)
        totalpointcount = totalpointcount + SCORECOUNTS.LOW_HEALTH
    end
    
    --//Flags Offense/Defense Check
    if GAMEMODE.FlagFeedCheck then
        if GAMEMODE.FlagFeedCheck[ vic ] then
            hook.Call( "KillFeedFlagAttack", GAMEMODE, att )
            AddNotice(att, "FLAG ATTACK", SCORECOUNTS.FLAG_ATT_DEF, NOTICETYPES.EXTRA)
            totalpointcount = totalpointcount + SCORECOUNTS.FLAG_ATT_DEF

            local remainingplayers, shouldrun
            if att:Team() == 1 then
                remainingplayers = GAMEMODE.FlagTable[ GAMEMODE.FlagFeedCheck[ vic ] ].bluecount
                shouldrun = GAMEMODE.FlagTable[ GAMEMODE.FlagFeedCheck[ vic ] ].count > 17
            else
                remainingplayers = GAMEMODE.FlagTable[ GAMEMODE.FlagFeedCheck[ vic ] ].redcount
                shouldrun = GAMEMODE.FlagTable[ GAMEMODE.FlagFeedCheck[ vic ] ].count < 3
            end

            if shouldrun and remainingplayers == 0 then
                AddNotice(att, "LAST SECOND SAVE", SCORECOUNTS.FLAG_ATT_DEF, NOTICETYPES.EXTRA)
                totalpointcount = totalpointcount + SCORECOUNTS.FLAG_ATT_DEF
                SoundToSend = "lastsecondsave"
            end
        end
        if GAMEMODE.FlagFeedCheck[ att ] then
            hook.Call( "KillFeedFlagDefend", GAMEMODE, att )
            AddNotice(att, "FLAG DEFENSE", SCORECOUNTS.FLAG_ATT_DEF, NOTICETYPES.EXTRA)
            totalpointcount = totalpointcount + SCORECOUNTS.FLAG_ATT_DEF
        end
    end
    
    --//Afterlife Check
    --print("Afterlife Check", att:Alive(), not att:Alive() )
    if not att:Alive() or att:Health() == 0 then
        hook.Call( "KillFeedAfterlife", GAMEMODE, att )
        AddNotice(att, "AFTERLIFE", SCORECOUNTS.AFTERLIFE, NOTICETYPES.EXTRA)
        totalpointcount = totalpointcount + SCORECOUNTS.AFTERLIFE
    end
    
    --//End Game Kill Check
    if GetGlobalBool("RoundFinished") then
        hook.Call( "KillFeedEGK", GAMEMODE, att )
        AddNotice(att, "END GAME KILL", SCORECOUNTS.END_GAME, NOTICETYPES.EXTRA)
        totalpointcount = totalpointcount + SCORECOUNTS.END_GAME
    end

    --//Mid-air check
    if not vic:OnGround() then
        AddNotice( att, "SKEET SHOOTING", SCORECOUNTS.SKEET, NOTICETYPES.EXTRA )
    end
    if not att:OnGround() then
        AddNotice( att, "MID-AIR", SCORECOUNTS.MIDAIR, NOTICETYPES.EXTRA )
    end
    
    --//Assist Shit
    if GAMEMODE.AssistTable[ vicID ] then
        for attacker, damageDone in pairs( GAMEMODE.AssistTable[ vicID ] ) do
            if IsValid( attacker ) then
                if damageDone > 0 and attacker != att then
                    hook.Call( "KillFeedAssist", GAMEMODE, attacker )
                    AddNotice( attacker, "ASSIST", math.Round( damageDone ), NOTICETYPES.KILL )
                    VampirismAssist( attacker, damageDone )

                    if attacker:GetPData( "g_assists" ) then
                        attacker:SetPData("g_assists", tostring( attacker:GetPData( "g_assists" ) + 1 ) )
                    else
                        attacker:SetPData("g_assists", "1" )
                    end

                    if attacker:GetNWString( "assists" ) == "" or !attacker:GetNWString( "assists" ) then
                        attacker:SetNWString( "assists", "1" )
                    else
                        attacker:SetNWString( "assists", tostring( tonumber( attacker:GetNWString( "assists" ) ) + 1) )
                    end

                    attacker.AttFromAssist = ( attacker.AttFromAssist or 0 ) + damageDone
                    if attacker.AttFromAssist >= 400 then 
                        attacker:ChatPrintColor( Color( 255, 255, 255 ), "You earned a ", Color( 0, 255, 0 ), "free kill ", Color( 255, 255, 255 ), "towards your current attachment due to assists!" )
                        local wep = attacker:GetActiveWeapon()
                        if IsValid( wep ) and wep:GetClass() then UpdateAttKillTracking( attacker, wep:GetClass() ) end
                        attacker.AttFromAssist = attacker.AttFromAssist - 400
                    end
                end
            --[[else
                GAMEMODE.AssistTable[ vicID ][ attacker ] = nil]]
            end
        end
    end
    table.Empty( GAMEMODE.AssistTable[ vicID ] )

    --//Killspree & Killstreak End Check
    if GAMEMODE.KillInfoTracking[ vicID ].KillSpree >= 2 then --If the victim has reached a double kill, but hasn't timed the spree out yet
        hook.Call( "KillFeedEndKillspree", GAMEMODE, att )
        AddNotice(att, "DENIED KILLSPREE", SCORECOUNTS.DENIED, NOTICETYPES.EXTRA)
        totalpointcount = totalpointcount + SCORECOUNTS.DENIED
        SoundToSend = "denied"
    elseif GAMEMODE.KillInfoTracking[ vicID ].KillsThisLife >= 5 then --If the victim has hit a DOMINATING killstreak or better
        hook.Call( "KillFeedEndKillstreak", GAMEMODE, att )
        AddNotice(att, "REJECTED KILLSTREAK", SCORECOUNTS.DENIED, NOTICETYPES.EXTRA)
        totalpointcount = totalpointcount + SCORECOUNTS.DENIED
        SoundToSend = "rejected"
    end
    GAMEMODE.KillInfoTracking[ vicID ].KillsThisLife = 0

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
        hook.Call( "KillFeedKillspree", GAMEMODE, att, SoundToSend )
        if GAMEMODE.KillInfoTracking[ attID ].KillSpree == 2 then
            AddNotice(att, "DOUBLE KILL", SCORECOUNTS.DOUBLE_KILL, NOTICETYPES.SPECIAL, Color( 200, 0, 0 ))
            totalpointcount = totalpointcount + SCORECOUNTS.DOUBLE_KILL
            SoundToSend = "doublekill"
        elseif GAMEMODE.KillInfoTracking[ attID ].KillSpree == 3 then
            AddNotice(att, "MULTI KILL", SCORECOUNTS.MULTI_KILL, NOTICETYPES.SPECIAL, Color( 200, 0, 0 ))
            totalpointcount = totalpointcount + SCORECOUNTS.MULTI_KILL
            SoundToSend = "multikill"
        elseif GAMEMODE.KillInfoTracking[ attID ].KillSpree == 4 then
            AddNotice(att, "MEGA KILL", SCORECOUNTS.MEGA_KILL, NOTICETYPES.SPECIAL, Color( 200, 0, 0 ))
            totalpointcount = totalpointcount + SCORECOUNTS.MEGA_KILL
            SoundToSend = "megakill"
		elseif GAMEMODE.KillInfoTracking[ attID ].KillSpree == 5 then
            AddNotice(att, "ULTRA KILL", SCORECOUNTS.ULTRA_KILL, NOTICETYPES.SPECIAL, Color( 200, 0, 0 ))
            totalpointcount = totalpointcount + SCORECOUNTS.ULTRA_KILL
            SoundToSend = "ultrakill"
        elseif GAMEMODE.KillInfoTracking[ attID ].KillSpree >= 6 then
            sc = SCORECOUNTS.UNREAL_KILL_MULTIPLIER * (GAMEMODE.KillInfoTracking[ attID ].KillSpree - 6) + SCORECOUNTS.MULTI_KILL
            AddNotice(att, "UNREAL", sc, NOTICETYPES.SPECIAL, Color( 200, 0, 0 ))
            totalpointcount = totalpointcount + sc
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
        hook.Call( "KillFeedKillstreak", GAMEMODE, att, SoundToSend )
        AddNotice( att, KillstreakNotices[ throwaway ], SCORECOUNTS[ "KILLSTREAK".. throwaway ], NOTICETYPES.SPECIAL, Color( 200, 0, 0 ) )
        totalpointcount = totalpointcount + SCORECOUNTS[ "KILLSTREAK" .. throwaway ]
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
    
    if vip.GetVip( att ) then
        AddNotice( att, "VIP BONUS", math.Round( totalpointcount * vip.Groups[ vip.GetVip( att ) ] ), NOTICETYPES.EXTRA )
    end

    local eventpointmultiplier = 1
    for k, v in pairs( GAMEMODE.ActiveEvents ) do
        local tab = RetrieveEventTable( k )

        if tab.bonus then
            eventpointmultiplier = eventpointmultiplier * tab.bonus
        end
    end
    if eventpointmultiplier > 1 then
        AddNotice( att, "EVENT BONUS", totalpointcount * eventpointmultiplier, NOTICETYPES.EXTRA )
    end

    GAMEMODE:UpdateVendetta( vic, att )
end )

GM.AssistTable = { }
hook.Add( "PlayerHurt", "CalculateAssists", function( victim, attacker, healthRemaining, damageTaken )
    if victim:IsValid() and attacker:IsValid() and attacker:IsPlayer() then

        local vicID = id( victim:SteamID() )
		GAMEMODE.AssistTable[ vicID ] = GAMEMODE.AssistTable[ vicID ] or { }
        
        --//This assist calculation doesn't track victim health regen, but w/e, I'm assuming the gameplay choices the victim makes as a result of having low HP
        --//will be enough to warrant giving the attacker assist points anyway
        GAMEMODE.AssistTable[ vicID ][ attacker ] = ( GAMEMODE.AssistTable[ vicID ][ attacker ] or 0 ) + damageTaken
    end
end )