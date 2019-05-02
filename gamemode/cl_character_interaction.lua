--//This file is actually used for announcer sounds & music, but I figured I'd keep the naming moniker the same, just for consistency
GM.PlayedSounds  = { }
GM.AnnouncerType = "default"
GM.AvailableTypes = {
    --//Default game music, ripped from BF4
    [ "default" ] = {
        [ "musicWin" ] = true,
        [ "announcerWin" ] = false,
        [ "musicLose" ] = true,
        [ "announcerLose" ] = false,
        [ "musicStart" ] = false,
        [ "announcerStart" ] = false,
        [ "musicTie" ] = false,
        [ "announcerTie" ] = false,
        [ "path" ] = "default/" --To organize
    },
    --//HL2 Sounds
    [ "rebels" ] = {
        [ "musicWin" ] = true,
        [ "announcerWin" ] = false,
        [ "musicLose" ] = true,
        [ "announcerLose" ] = false,
        [ "musicStart" ] = true,
        [ "announcerStart" ] = false,
        [ "musicTie" ] = false,
        [ "announcerTie" ] = false,
        [ "path" ] = "hl2/rebels/"
    },
    [ "combine" ] = {
        [ "musicWin" ] = true,
        [ "announcerWin" ] = false,
        [ "musicLose" ] = true,
        [ "announcerLose" ] = false,
        [ "musicStart" ] = true,
        [ "announcerStart" ] = true,
        [ "musicTie" ] = false,
        [ "announcerTie" ] = false,
        [ "path" ] = "hl2/combine/"
    },
    --//INS2 Sounds
    [ "security" ] = {
        [ "musicWin" ] = true,
        [ "announcerWin" ] = false,
        [ "musicLose" ] = true,
        [ "announcerLose" ] = false,
        [ "musicStart" ] = true,
        [ "announcerStart" ] = true,
        [ "musicTie" ] = false,
        [ "announcerTie" ] = false,
        [ "path" ] = "ins2/security/"
    },
    [ "insurgent" ] = {
        [ "musicWin" ] = true,
        [ "announcerWin" ] = false,
        [ "musicLose" ] = true,
        [ "announcerLose" ] = false,
        [ "musicStart" ] = true,
        [ "announcerStart" ] = true,
        [ "musicTie" ] = false,
        [ "announcerTie" ] = false,
        [ "path" ] = "ins2/insurgent/"
    },
    --//MW2 Sounds
    [ "opfor" ] = {
        [ "musicWin" ] = true,
        [ "announcerWin" ] = false,
        [ "musicLose" ] = true,
        [ "announcerLose" ] = false,
        [ "musicStart" ] = true,
        [ "announcerStart" ] = true,
        [ "musicTie" ] = true,
        [ "announcerTie" ] = true,
        [ "path" ] = "mw2/opfor/"
    },
    [ "spetsnaz" ] = {
        [ "musicWin" ] = true,
        [ "announcerWin" ] = true,
        [ "musicLose" ] = true,
        [ "announcerLose" ] = true,
        [ "musicStart" ] = true,
        [ "announcerStart" ] = true,
        [ "musicTie" ] = true,
        [ "announcerTie" ] = true,
        [ "path" ] = "mw2/spetsnaz/"
    },
    --[[[ "militia" ] = {
        [ "musicWin" ] = true,
        [ "announcerWin" ] = true,
        [ "musicLose" ] = true,
        [ "announcerLose" ] = true,
        [ "musicStart" ] = true,
        [ "announcerStart" ] = true,
        [ "musicTie" ] = true,
        [ "announcerTie" ] = true,
        [ "path" ] = "mw2/militia/"
    },]]
    [ "rangers" ] = {
        [ "musicWin" ] = true,
        [ "announcerWin" ] = true,
        [ "musicLose" ] = true,
        [ "announcerLose" ] = true,
        [ "musicStart" ] = true,
        [ "announcerStart" ] = true,
        [ "musicTie" ] = true,
        [ "announcerTie" ] = true,
        [ "path" ] = "mw2/rangers/"
    },
    [ "seals" ] = {
        [ "musicWin" ] = true,
        [ "announcerWin" ] = true,
        [ "musicLose" ] = true,
        [ "announcerLose" ] = true,
        [ "musicStart" ] = true,
        [ "announcerStart" ] = true,
        [ "musicTie" ] = true,
        [ "announcerTie" ] = true,
        [ "path" ] = "mw2/seals/"
    },
    [ "tf141" ] = {
        [ "musicWin" ] = true,
        [ "announcerWin" ] = true,
        [ "musicLose" ] = true,
        [ "announcerLose" ] = true,
        [ "musicStart" ] = true,
        [ "announcerStart" ] = true,
        [ "musicTie" ] = true,
        [ "announcerTie" ] = true,
        [ "path" ] = "mw2/tf141/"
    },
}

function GM:DoGameSound( soundName, isVoice, numVariance )
    if numVariance then
        numVariance = math.random( numVariance )
    else
        numVariance = ""
    end
    soundName = soundName .. numVariance

    if self.PlayedSounds.Current and self.PlayedSounds.Current:IsPlaying() and !isVoice then
        self.PlayedSounds.Current:Stop()
    end
    if self.PlayedSounds.CurrentAnnouncer and self.PlayedSounds.CurrentAnnouncer:IsPlaying() and isVoice then
        self.PlayedSounds.CurrentAnnouncer:Stop()
    end

    self.PlayedSounds[ self.AnnouncerType ] = self.PlayedSounds[ self.AnnouncerType ] or { }

    if !self.PlayedSounds[ self.AnnouncerType ][ soundName ] then
        self.PlayedSounds[ self.AnnouncerType ][ soundName ] = CreateSound( LocalPlayer(), self.AvailableTypes[ self.AnnouncerType ].path .. soundName .. ".ogg" )
        self.PlayedSounds[ self.AnnouncerType ][ soundName ]:SetSoundLevel( 45 )
    end

    self.PlayedSounds[ self.AnnouncerType ][ soundName ]:Play()
    if isVoice then
        self.PlayedSounds.CurrentAnnouncer = self.PlayedSounds[ self.AnnouncerType ][ soundName ]
    else
        self.PlayedSounds.Current = self.PlayedSounds[ self.AnnouncerType ][ soundName ]

        timer.Simple( 25, function()
            self.PlayedSounds[ self.AnnouncerType ][ soundName ]:FadeOut( 5 )
        end )
    end
end

function GM:DoStartSounds()
    if self.AvailableTypes[ self.AnnouncerType ].musicStart then
        self:DoGameSound( "musicStart" )
    end
    if self.AvailableTypes[ self.AnnouncerType ].announcerStart then
        timer.Simple( 2, function()
            if isnumber( self.AvailableTypes[ self.AnnouncerType ][ "announcerStart" ] ) then
                self:DoGameSound( "announcerStart", true, self.AvailableTypes[ self.AnnouncerType ][ "announcerStart" ] )
            else
                self:DoGameSound( "announcerStart", true )
            end
        end )
    end
end

function GM:DoWinSounds()
    if LocalPlayer():Team() == 0 then return end
    if self.AvailableTypes[ self.AnnouncerType ].musicWin then
        self:DoGameSound( "musicWin" )
    end
    if self.AvailableTypes[ self.AnnouncerType ].announcerWin then
        timer.Simple( 2, function()
            if isnumber( self.AvailableTypes[ self.AnnouncerType ][ "announcerWin" ] ) then
                self:DoGameSound( "announcerWin", true, self.AvailableTypes[ self.AnnouncerType ][ "announcerWin" ] )
            else
                self:DoGameSound( "announcerWin", true )
            end
        end )
    end
end

function GM:DoLoseSounds()
    if LocalPlayer():Team() == 0 then return end
    if self.AvailableTypes[ self.AnnouncerType ].musicLose then
        self:DoGameSound( "musicLose" )
    end
    if self.AvailableTypes[ self.AnnouncerType ].announcerLose then
        timer.Simple( 2, function()
            if isnumber( self.AvailableTypes[ self.AnnouncerType ][ "announcerLose" ] ) then
                self:DoGameSound( "announcerLose", true, self.AvailableTypes[ self.AnnouncerType ][ "announcerLose" ] )
            else
                self:DoGameSound( "announcerLose", true )
            end
        end )
    end
end

function GM:DoTieSounds()
    if LocalPlayer():Team() == 0 then return end
    if self.AvailableTypes[ self.AnnouncerType ].musicTie then
        self:DoGameSound( "musicTie" )
    end
    if self.AvailableTypes[ self.AnnouncerType ].announcerTie then
        timer.Simple( 2, function()
            if isnumber( self.AvailableTypes[ self.AnnouncerType ][ "announcerTie" ] ) then
                self:DoGameSound( "announcerTie", true, self.AvailableTypes[ self.AnnouncerType ][ "announcerTie" ] )
            else
                self:DoGameSound( "announcerTie", true )
            end
        end )
    end
end

net.Receive( "SetInteractionGroup", function()
    local newGroup = net.ReadString()

    if GAMEMODE.AvailableTypes[ newGroup ] then
        GAMEMODE.AnnouncerType = newGroup
    else
        GAMEMODE.AnnouncerType = "default"
    end
end )

net.Receive( "DoStart", function()
    GAMEMODE:DoStartSounds()
end )

net.Receive( "DoWin", function()
    GAMEMODE:DoWinSounds()
end )

net.Receive( "DoLose", function()
    GAMEMODE:DoLoseSounds()
end )

net.Receive( "DoTie", function()
    GAMEMODE:DoTieSounds()
end )