--//UNDER NO CIRCUMSTANCES ARE THE ID'S TO BE CHANGED EVER - THEY ARE UNIQUE TO THE TITLE AND USED INTERNALLY
--//ONCE THE GAMEMODE HAS GONE LIVE WITH NEW TITLES, A CHANGE IN ID CAUSES PLAYERS TO LOSE ALL PROGRESS
GM.TitleMasterTable = {
    { id = "freshmeat", title = "Fresh Meat", description = "Play on the server for 10 minutes", req = 10, pdata = "g_time" },
    { id = "commfriend", title = "Community Friend", description = "Play on the server for 10 hours", req = 600, pdata = "g_time" },
    { id = "veteran", title = "The Veteran", description = "Play on the server for 20 hours", req = 1200, pdata = "g_time" },
    { id = "nolife", title = "The No-Life", description = "Play on the server for 50 hours", req = 6000, pdata = "g_time" },
    { id = "2fer", title = "The Two-fer", description = "Achieve \"Double Kill\" (2 kill killspree) 30 times", req = 30 },
    { id = "3threat", title = "The Triple Threat", description = "Achieve \"Multi Kill\" (3 kill killlspree) 20 times", req = 20 },
    { id = "4killer", title = "The Quad Killer", description = "Achieve \"Mega Kill\" (4 kill killspree) 15 times", req = 15 },
    { id = "5up", title = "The Pent-Up", description = "Achieve \"Ultra Kill\" (5 kill killspree) 10 times", req = 10 },
    { id = "thegod", title = "The God", description = "Achieve \"Unreal\" (6 kill killspree) 10 times", req = 10 },
    { id = "thedominator", title = "The Dominator", description = "Achieve \"Dominating\" (5 kill killstreak) 10 times", req = 10 },
    { id = "bog", title = "Blaze of Glory", description = "Achieve \"Blaze Of Glory\" (10 kill killstreak) 5 times", req = 5 },
    { id = "topgun", title = "Top Gun", description = "Achieve \"Top Gun\" (20 kill killstreak) 2 times", req = 2 },
    { id = "shaftmaster", title = "The Shaft Master", description = "Achieve \"Shaft-Master\" (30 kill killstreak) 1 time", req = 1 },
    { id = "fastestdraw", title = "The Fastest Draw", description = "Achieve \"First Blood\" (first kill of the match) 20 times", req = 20 },
    { id = "bsc", title = "Best Served Cold", description = "Achieve \"Payback\" (kill your last killer) 20 times", req = 20 },
    { id = "humiliated", title = "The Humiliated", description = "Die to your vendetta 10 times", req = 10 },
    { id = "humiliator", title = "The Humiliator", description = "Achieve \"Eradication\" (kill someone vendetta'd against you) 20 times", req = 20 },
    { id = "revenger", title = "The Revenger", description = "Achieve \"Retribution\" (kill your vendetta) 30 times", req = 30 },
    { id = "headshot", title = "BOOM HEADSHOT!", description = "Achieve \"Headshot\" (kill an enemy with a bullet to the head) 40 times", req = 40 },
    { id = "headhunter", title = "Head Hunter", description = "Achieve \"Head Hunter\" (kill an enemy over 100 m away with a bullet to the head) 20 times", req = 20 },
    { id = "bulletproof", title = "Bullet Proof", description = "Achieve \"Low Life\" (getting a kill under 20 hp) 30 times", req = 30 },
    { id = "necromancer", title = "The Necromancer", description = "Achieve \"Afterlife\" (getting a kill while dead) 10 times", req = 10 },
    { id = "denier", title = "The Denier", description = "Achieve \"Denied\" (end a player's killspree) 5 times", req = 5 },
    { id = "rejector", title = "The Rejector", description = "Achieve \"Rejected\" (end a player's killstreak) 20 times", req = 20 }
    --{ id = "", title = "", description = "", req = 0 },
}
--//The PData is saved as id .. "count"

GM.MasteryRequirements = {
    ar = 500,
    smg = 500,
    sg = 500,
    lmg = 500,
    sr = 300,
    pt = 150,
    mn = 150
}

for k, v in pairs( GM.WeaponsList ) do
    if GM.MasteryRequirements[ v.type ] then
        local req = GM.MasteryRequirements[ v.type ]
        local newtitle = { id = v[ 2 ] .. "_mastery", title = v[ 1 ] .. " Mastery", description = "Achieve " .. req .. " kills with this weapon", req = req, pdata = v[ 2 ] }
        GM.TitleMasterTable[ #GM.TitleMasterTable + 1 ] = newtitle
    end
end

if SERVER then
    for k, v in pairs( GM.TitleMasterTable ) do
        util.AddNetworkString( v.id .. "Status" )
        util.AddNetworkString( v.id .. "StatusCallback" )

        net.Receive( v.id .. "Status", function ( len, ply )
            net.Start( v.id .. "StatusCallback" )
                if v.pdata and ply:GetPData( v.pdata ) then
                    net.WriteInt( ply:GetPData( v.pdata ), 16 )
                else
                    net.WriteInt( ply:GetPData( v.id .. "count" ), 16 )
                end
            net.Send( ply )
        end )
    end
end

function GM:GetTitleTable( str )
    for k, v in pairs( self.TitleMasterTable ) do
        if v.id == str then return v end
    end
    Error( "GetTitleTable called with invalid title ID: " .. str )
end