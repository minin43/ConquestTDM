--//This file is strictly for creating/registering custom vgui elements for the mapvote screen
surface.CreateFont( "VoteFont", { font = "BF4 Numbers", size = 30, weight = 600, antialias = true } )

local MapOptionButton = {}
MapOptionButton.font = "DermaLarge"
MapOptionButton.mapname = "Unknown Map"
MapOptionButton.mapsize = "Uknown Size"
MapOptionButton.hasflags = false
MapOptionButton.votes = 0
MapOptionButton.infospace = 25
MapOptionButton.img = Material( "vgui/maps/noimage2.png", "smooth" ) --Should be a default "no image selected" image
MapOptionButton.flagimg = Material( "vgui/flag.png", "smooth" )
MapOptionButton.w, MapOptionButton.h = 480, 270 + MapOptionButton.infospace --Add a 20 pixel buffer along the bottom of the image for text

function MapOptionButton:SetFont(font)
    self.font = font
end

function MapOptionButton:SetText()
    return true
end

function MapOptionButton:SetMapName(text)
    self.mapname = text
end

function MapOptionButton:SetMapSize(text)
    self.mapsize = text
end

function MapOptionButton:SetVotes(text)
    self.votes = text
end

function MapOptionButton:SetFlags(bool)
    if bool then
        self.hasflags = true
    end
end

function MapOptionButton:AddVotes(text)
    self.votes = self.votes + text
end

function MapOptionButton:SetInfoSpace(newH)
    self.h = self.h - self.infospace

    self.infospace = newH

    self.h = self.h + self.infospace
end

function MapOptionButton:SetMapImage(dir)
    if dir and dir != "" then
        self.img = Material( dir, "smooth" )
    end
end

function MapOptionButton:DoClick()
    surface.PlaySound( "ui/buttons/buttonrollover3.wav" )

    if not GAMEMODE.CurrentSelection or GAMEMODE.CurrentSelection != self.mapname then
        GAMEMODE.CurrentSelection = self.mapname
        net.Start( "PlayerSelectedMap" )
            net.WriteString( self.mapname )
        net.SendToServer()
    end
end

function MapOptionButton:OnCursorEntered()
    surface.PlaySound( "ui/buttons/buttonclick1.wav" )
    self.cursorEntered = true
end

function MapOptionButton:OnCursorExited()
    self.cursorEntered = false
end

function MapOptionButton:Paint()
    local w, h = self:GetSize()

    surface.SetDrawColor( 255, 255, 255 )
    surface.SetMaterial( self.img )
    surface.DrawTexturedRect( 0, 0, self.w, self.h - 20 )
    draw.NoTexture()

    if self.hasflags then
        surface.SetMaterial( self.flagimg )
        --[[surface.SetDrawColor( 0, 0, 0, 255 )
        surface.DrawTexturedRect( 4, 4, 34, 34 )]]
        surface.SetDrawColor( 76, 175, 80, 255 )
        surface.DrawTexturedRect( 4, 4, 34, 34 )
        draw.NoTexture()

    end

    surface.SetDrawColor( 255, 255, 255 )
    surface.DrawOutlinedRect( 0, 0, w, h )

    surface.SetDrawColor( 60, 60, 60, 160 )
    surface.DrawRect( 0, h - self.infospace, w, h )
    draw.SimpleText( "Name: " .. self.mapname, self.font, 5, h - ( self.infospace / 2 ) - 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.SimpleText( "Size: " .. self.mapsize, self.font, w - 5, h - ( self.infospace / 2 ) - 2, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

    local rightTriangle = {
        { x = w, y = 0 }, --Top right corner
        { x = w, y = 45 }, --Bottom corner
        { x = w - 70, y = 0 } --Left corner
    }
    surface.SetDrawColor( 76, 175, 80, 190 )
    surface.DrawPoly( rightTriangle )
    draw.SimpleText( self.votes, "VoteFont", w - 18, 15, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    if self.cursorEntered then
        if GAMEMODE.CurrentSelection == self.mapname then
            surface.SetDrawColor( 180, 180, 180, 60 )
            surface.DrawRect( 0, 0, w, h )
            draw.SimpleText( "Voted!", self.font, w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        else
            surface.SetDrawColor( 76, 175, 80 )
            surface.DrawOutlinedRect( 0, 0, w, h )
        end
    end
    if GAMEMODE.CurrentSelection == self.mapname then
        surface.SetDrawColor( 76, 175, 80 )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end

    return true
end

vgui.Register( "MapOption", MapOptionButton, "DButton" )