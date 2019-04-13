--//This file is actually used for announcer sounds & music, but I figured I'd keep the naming moniker the same, just for consistency
--//These sound calls need to be done with Sound objects using CreateSound, so they can be stopped when necessary
GM.AnnouncerType = "default"
GM.AvailableTypes = {
    --//Default game music, ripped from BF4
    [ "default" ] = {
        [ "gameWin" ] = true,
        [ "announcerWin" ] = false,
        [ "gameLose" ] = true,
        [ "announcerLose" ] = false,
        [ "gameStart" ] = false,
        [ "announcerStart" ] = false,
        [ "gameTie" ] = false,
        [ "announcerTie" ] = false,
        [ "path" ] = "" --To organize
    },
    --//HL2 Sounds
    [ "rebels" ] = {
        [ "gameWin" ] = true,
        [ "announcerWin" ] = false,
        [ "gameLose" ] = true,
        [ "announcerLose" ] = false,
        [ "gameStart" ] = true,
        [ "announcerStart" ] = false,
        [ "gameTie" ] = false,
        [ "announcerTie" ] = false,
        [ "path" ] = "hl2/rebels/"
    },
    [ "combine" ] = {
        [ "gameWin" ] = true,
        [ "announcerWin" ] = false,
        [ "gameLose" ] = true,
        [ "announcerLose" ] = false,
        [ "gameStart" ] = true,
        [ "announcerStart" ] = true,
        [ "gameTie" ] = false,
        [ "announcerTie" ] = false,
        [ "path" ] = "hl2/combine/"
    },
    --//INS2 Sounds
    [ "security" ] = {
        [ "gameWin" ] = true,
        [ "announcerWin" ] = false,
        [ "gameLose" ] = true,
        [ "announcerLose" ] = false,
        [ "gameStart" ] = true,
        [ "announcerStart" ] = true,
        [ "gameTie" ] = false,
        [ "announcerTie" ] = false,
        [ "path" ] = "ins2/security/"
    },
    [ "insurgent" ] = {
        [ "gameWin" ] = true,
        [ "announcerWin" ] = false,
        [ "gameLose" ] = true,
        [ "announcerLose" ] = false,
        [ "gameStart" ] = true,
        [ "announcerStart" ] = true,
        [ "gameTie" ] = false,
        [ "announcerTie" ] = false,
        [ "path" ] = "ins2/insurgent/"
    },
    --//MW2 Sounds
    [ "opfor" ] = {
        [ "gameWin" ] = true,
        [ "announcerWin" ] = false,
        [ "gameLose" ] = true,
        [ "announcerLose" ] = false,
        [ "gameStart" ] = true,
        [ "announcerStart" ] = true,
        [ "gameTie" ] = true,
        [ "announcerTie" ] = true,
        [ "path" ] = "mw2/opfor/"
    },
    [ "spetsnaz" ] = {
        [ "gameWin" ] = true,
        [ "announcerWin" ] = true,
        [ "gameLose" ] = true,
        [ "announcerLose" ] = true,
        [ "gameStart" ] = true,
        [ "announcerStart" ] = true,
        [ "gameTie" ] = true,
        [ "announcerTie" ] = true,
        [ "path" ] = "mw2/spetsnaz/"
    },
    --[[[ "militia" ] = {
        [ "gameWin" ] = true,
        [ "announcerWin" ] = true,
        [ "gameLose" ] = true,
        [ "announcerLose" ] = true,
        [ "gameStart" ] = true,
        [ "announcerStart" ] = true,
        [ "gameTie" ] = true,
        [ "announcerTie" ] = true,
        [ "path" ] = "mw2/militia/"
    },]]
    [ "rangers" ] = {
        [ "gameWin" ] = true,
        [ "announcerWin" ] = true,
        [ "gameLose" ] = true,
        [ "announcerLose" ] = true,
        [ "gameStart" ] = true,
        [ "announcerStart" ] = true,
        [ "gameTie" ] = true,
        [ "announcerTie" ] = true,
        [ "path" ] = "mw2/rangers/"
    },
    [ "seals" ] = {
        [ "gameWin" ] = true,
        [ "announcerWin" ] = true,
        [ "gameLose" ] = true,
        [ "announcerLose" ] = true,
        [ "gameStart" ] = true,
        [ "announcerStart" ] = true,
        [ "gameTie" ] = true,
        [ "announcerTie" ] = true,
        [ "path" ] = "mw2/seals/"
    },
    [ "tf141" ] = {
        [ "gameWin" ] = true,
        [ "announcerWin" ] = true,
        [ "gameLose" ] = true,
        [ "announcerLose" ] = true,
        [ "gameStart" ] = true,
        [ "announcerStart" ] = true,
        [ "gameTie" ] = true,
        [ "announcerTie" ] = true,
        [ "path" ] = "mw2/tf141/"
    },
}

function GM:DoStartSounds()
    if GAMEMODE.AvailableTypes[ GAMEMODE.AnnouncerType ].gameStart then
        surface.PlaySound( GAMEMODE.AvailableTypes[ GAMEMODE.AnnouncerType ].path .. "gameStart.ogg" )
    end
    if GAMEMODE.AvailableTypes[ GAMEMODE.AnnouncerType ].announcerStart then
        timer.Simple( 2, function()
            surface.PlaySound( GAMEMODE.AvailableTypes[ GAMEMODE.AnnouncerType ].path .. "announcerStart.ogg" )
        end )
    end )
end

function GM:DoWinSounds()
    if GAMEMODE.AvailableTypes[ GAMEMODE.AnnouncerType ].gameWin then
        surface.PlaySound( GAMEMODE.AvailableTypes[ GAMEMODE.AnnouncerType ].path .. "gameWin.ogg" )
    end
    if GAMEMODE.AvailableTypes[ GAMEMODE.AnnouncerType ].announcerWin then
        timer.Simple( 2, function()
            surface.PlaySound( GAMEMODE.AvailableTypes[ GAMEMODE.AnnouncerType ].path .. "announcerWin.ogg" )
        end )
    end )
end

function GM:DoLoseSounds()
    if GAMEMODE.AvailableTypes[ GAMEMODE.AnnouncerType ].gameLose then
        surface.PlaySound( GAMEMODE.AvailableTypes[ GAMEMODE.AnnouncerType ].path .. "gameLose.ogg" )
    end
    if GAMEMODE.AvailableTypes[ GAMEMODE.AnnouncerType ].announcerLose then
        timer.Simple( 2, function()
            surface.PlaySound( GAMEMODE.AvailableTypes[ GAMEMODE.AnnouncerType ].path .. "announcerLose.ogg" )
        end )
    end )
end

function GM:DoTieSounds()
    if GAMEMODE.AvailableTypes[ GAMEMODE.AnnouncerType ].gameTie then
        surface.PlaySound( GAMEMODE.AvailableTypes[ GAMEMODE.AnnouncerType ].path .. "gameTie.ogg" )
    end
    if GAMEMODE.AvailableTypes[ GAMEMODE.AnnouncerType ].announcerTie then
        timer.Simple( 2, function()
            surface.PlaySound( GAMEMODE.AvailableTypes[ GAMEMODE.AnnouncerType ].path .. "announcerTie.ogg" )
        end )
    end )
end

net.Receive( "SetInteractionGroup", function()
    local newGroup = net.ReadString()

    if GAMEMODE.AvailableTypes[ newGroup ] then
        GAMEMODE.AnnouncerType = newGroup
    else
        GAMEMODE.AnnouncerType = "default"
    end
end )

net.Receive( "DoStart", GM:DoStartSounds )

net.Receive( "DoWin", GM:DoWinSounds )

net.Receive( "DoLose", GM:DoLoseSounds )

net.Receive( "DoTie", GM:DoTieSounds )