surface.CreateFont( "MapFont", { font = "BF4 Numbers", size = 25, weight = 600, antialias = true } )
surface.CreateFont( "HeaderFont", { font = "BF4 Numbers", size = 70, weight = 600, antialias = true } )

GM.IconExplanations = {
    flags = " means map has conquest flags",
    snipers = " means sniper-heavy map"
}

net.Receive( "BeginMapvote", function()
    GAMEMODE.MapList = net.ReadTable() --Keys numbers, values are table containing a name and a subtable containing map ID, map size, and screenshot directory
    GAMEMODE.MapvoteTimeLeft = 10
    GAMEMODE.PlayerVotes = { } --Used to record each player's vote
    GAMEMODE.MapvoteOptions = { } --Contains the custom button vgui elements

    GAMEMODE:DrawMapvote()
end )

net.Receive( "UpdateCountdown", function()
    GAMEMODE.MapvoteTimeLeft = net.ReadInt( 6 )
end )

net.Receive( "PlayerVotedUpdate", function()
    local ply = net.ReadString()
    local choice = net.ReadString()
    ply = unid( ply )
    for k, v in pairs( player.GetAll() ) do
        if v:SteamID() == ply then
            ply = v
        end
    end
    if not isentity( ply ) and ply:IsPlayer() then 
        ErrorNoHalt( "Client received non-existant player's vote!\n", ply )
    else
        if GAMEMODE.PlayerVotes[ ply ] then
            GAMEMODE.MapvoteOptions[ GAMEMODE.PlayerVotes[ ply ] ]:AddVotes( -1 )
        end
        GAMEMODE.PlayerVotes[ ply ] = choice
        GAMEMODE.MapvoteOptions[ choice ]:AddVotes( 1 )
    end
end )

net.Receive( "MapvoteFinished", function()
    local winningMap = net.ReadString()

    if GAMEMODE.MapvoteOptions[ winningMap ] then
        for k, v in pairs( GAMEMODE.MapvoteOptions ) do
            if k != winningMap then
                v:Remove()
            end
        end

        GAMEMODE.CurrentSelection = winningMap --For the outline effect

        local guiObject = GAMEMODE.MapvoteOptions[ winningMap ]
        timer.Create( "Blinktimer", 0.5, 3, function()
            surface.PlaySound( "buttons/blip1.wav" )
        end )
        guiObject.OnCursorEntered = function()
            return false
        end
        guiObject.OnCursorExited = function()
            return false
        end
        guiObject.DoClick = function()
            return false
        end
    end
end )

function GM:DrawMapvote()
    if not self.MapList then return end
    local flagimg = Material( "vgui/flagIcon.png", "smooth" )

    self.MapvoteMain = vgui.Create( "DFrame" )
    self.MapvoteMain:SetPos( 0, 0 )
    self.MapvoteMain:SetSize( ScrW(), ScrH() )
    self.MapvoteMain:SetTitle( "" )
	self.MapvoteMain:SetDraggable( false )
	self.MapvoteMain:ShowCloseButton( false )
    self.MapvoteMain:MakePopup()
    --self.MapvoteMain:SetMouseInputEnabled( true )
    self.MapvoteMain:SetKeyboardInputEnabled( false )
    self.MapvoteMain.Paint = function()
        surface.SetDrawColor( 0, 0, 0, 210 )
        surface.DrawRect( 0, 0, self.MapvoteMain:GetWide(), self.MapvoteMain:GetTall() )

        local txt
        if self.MapvoteTimeLeft > 1 then
            txt = "Map Vote - Time Remaining: " .. self.MapvoteTimeLeft .. " seconds"
        elseif self.MapvoteTimeLeft == 1 then
            txt = "Map Vote - Time Remaining: " .. self.MapvoteTimeLeft .. " second"
        else
            txt = "Map Vote - No Time Remaining"
        end
        draw.SimpleText( txt, "HeaderFont", self.MapvoteMain:GetWide() / 2, 10, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
    end

    local positions = {
        { x = ( ScrW() / 4 ) - 6, y = ScrH() / 4 - 6 },
        { x = ( ScrW() / 2 ), y = ScrH() / 4 - 6 },
        { x = ( ScrW() / 4 ) * 3 + 6, y = ScrH() / 4 - 6 },
        { x = ( ScrW() / 4 ) - 6, y = ( ScrH() / 4 ) * 2 },
        { x = ( ScrW() / 2 ), y = ( ScrH() / 4 ) * 2 },
        { x = ( ScrW() / 4 ) * 3 + 6, y = ( ScrH() / 4 ) * 2 },
        { x = ( ScrW() / 4 ) - 6, y = ( ScrH() / 4 ) * 3 + 6 },
        { x = ( ScrW() / 2 ), y = ( ScrH() / 4 ) * 3 + 6 },
        { x = ( ScrW() / 4 ) * 3 + 6, y = ( ScrH() / 4 ) * 3 + 6 }
    }

    --//As soon as I added in random and repeat options, shit got messy
    for k, v in pairs( self.MapList ) do
        if v.info.custom then
            if v.name == "random" then
                local dumby = vgui.Create( "RandomOption", self.MapvoteMain )
                dumby:SetFont( "MapFont" )
                dumby:SetMapName( "random" )
                dumby:SetVotes( 0 )
                dumby:SetSize( ScrW() / 4, ScrH() / 4 )
                dumby:SetPos( positions[ k ].x - ( dumby:GetWide() / 2 ), positions[ k ].y - ( dumby:GetTall() / 2 ) )

                self.MapvoteOptions[ v.name ] = dumby
            elseif v.name == "repeat" then
                if self.MapTable[ game.GetMap() ] then
                    local dumby = vgui.Create( "RepeatOption", self.MapvoteMain )
                    dumby:SetFont( "MapFont" )
                    dumby:SetMapName( "repeat" )
                    dumby:SetVotes( 0 )
                    dumby:SetMapImage( self.MapTable[ game.GetMap() ].img )
                    dumby:SetSize( ScrW() / 4, ScrH() / 4 )
                    dumby:SetPos( positions[ k ].x - ( dumby:GetWide() / 2 ), positions[ k ].y - ( dumby:GetTall() / 2 ) )

                    self.MapvoteOptions[ v.name ] = dumby
                else
                    local dumby = vgui.Create( "DPanel", self.MapvoteMain )
                    dumby:SetSize( ScrW() / 4, ScrH() / 4 )
                    dumby:SetPos( positions[ k ].x - ( dumby:GetWide() / 2 ), positions[ k ].y - ( dumby:GetTall() / 2 ) )
                    dumby.Paint = function()
                        surface.SetDrawColor( 60, 60, 60, 240 )
                        surface.DrawRect( 0, 0, dumby:GetWide(), dumby:GetTall() )
                        draw.SimpleText( "Repeat Option Unavailable", "MapFont", dumby:GetWide() / 2, dumby:GetTall() / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )                    
                    end

                    self.MapvoteOptions[ v.name ] = dumby --Only added so it can be removed when a map is chosen
                end
            elseif v.name == "legend" then
                local dumby = vgui.Create( "DPanel", self.MapvoteMain )
                dumby:SetSize( ScrW() / 4, ScrH() / 4 )
                dumby:SetPos( positions[ k ].x - ( dumby:GetWide() / 2 ), positions[ k ].y - ( dumby:GetTall() / 2 ) )
                dumby.Paint = function()
                    surface.SetDrawColor( 60, 60, 60, 240 )
                    surface.DrawRect( 0, 0, dumby:GetWide(), dumby:GetTall() )

                    local counter = 0
                    for k, v in pairs( self.Icons.Mapvote ) do
                        counter = counter + 1

                        surface.SetMaterial( v )
                        surface.SetDrawColor( 76, 175, 80, 255 )
                        surface.DrawTexturedRect( 4, ( 4 * counter ) + ( 32 * ( counter - 1 ) ), 32, 32 )
                        draw.NoTexture()

                        draw.SimpleText( self.IconExplanations[ k ], "MapFont", 40, ( 4 * counter ) + ( 16 * counter ) + ( 16 * ( counter - 1 ) ), Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    end
                end

                self.MapvoteOptions[ v.name ] = dumby --Only added so it can be removed when a map is chosen
            end
        else
            local dumby = vgui.Create( "MapOption", self.MapvoteMain )
            dumby:SetFont( "MapFont" )
            dumby:SetMapName( v.name )
            dumby:SetMapSize( v.info.size )
            dumby:SetMapImage( v.info.img )
            dumby:SetVotes( 0 )
            dumby:SetTags( v.info.tags )
            dumby:SetSize( ScrW() / 4, ScrH() / 4 ) --1/4 the size of 16:9 resolutions
            dumby:SetPos( positions[ k ].x - ( dumby:GetWide() / 2 ), positions[ k ].y - ( dumby:GetTall() / 2 ) )

            self.MapvoteOptions[ v.name ] = dumby
        end
    end

    --[[self.MapvoteInfo = vgui.Create( "DPanel", self.MapvoteMain )
    self.MapvoteInfo:SetSize( 400, 50 )
    self.MapvoteInfo:SetPos( self.MapvoteMain:GetWide() / 2 - self.MapvoteInfo:GetWide() / 2, self.MapvoteMain:GetTall() - self.MapvoteInfo:GetTall() - 6 )
    self.MapvoteInfo.Paint = function()
        surface.SetMaterial( flagimg )
        surface.SetDrawColor( 76, 175, 80 )
        surface.DrawTexturedRect( 10, 10, 40, 40 )
        draw.SimpleText( "means the map has Conquest flags", "MapFont", 54, self.MapvoteInfo:GetTall() / 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end]]
end