--//This file is strictly for creating custom vgui elements for the shop

local psheetbutton = { }
psheetbutton.text = ""
psheetbutton.font = "DermaDefault"
psheetbutton.psheet = nil
psheetbutton.sheet = nil
psheetbutton.spacer = 4

function psheetbutton:SetText( txt )
    self.text = txt
end

function psheetbutton:SetFont( fnt )
    self.font = fnt
end

function psheetbutton:SetParentSheet( parent )
    self.psheet = parent
end

function psheetbutton:SetTab( tab )
    self.tab = tab
end

function psheetbutton:OnCursorEntered()
    self.hover = true
end

function psheetbutton:OnCursorExited()
    self.hover = false
end

function psheetbutton:DoClick()
    self.psheet:SetActiveTab( self.tab )
    self.selected = true
end

function psheetbutton:Paint()
    surface.SetDrawColor( GAMEMODE.TeamColor )
    surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
    
    surface.SetTexture( GAMEMODE.GradientTexture )
    surface.SetDrawColor( 0, 0, 0, 164 )
    surface.DrawTexturedRectRotated( self:GetWide() / 2, 4, 8, self:GetWide(), 270 ) --self.TeamMain:GetWide() / 2, self.TeamMainTitleSize + 4, 8, self.TeamMain:GetWide(), 270
        
    surface.SetFont( self.font )
    local twide, ttall = surface.GetTextSize( self.text )
    surface.SetTextPos( self:GetWide() / 2 - ( twide / 2 ), self:GetTall() / 2 - ( ttall / 2) )
    surface.SetTextColor( 255, 255, 255 )
    surface.DrawText( self.text )
    --draw.SimpleText( self.text, self.font, self:GetWide() / 2, self:GetTall() / 2, Color( 255,255,255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    self.lerp = self.lerp or 0
    if self.hover or self.selected then
        self.lerp = math.Clamp( self.lerp + 3, 0, self:GetWide() / 3 )
        if self.selected then
            surface.SetDrawColor( colorScheme[LocalPlayer():Team()]["ButtonIndicator"] )
        else
            surface.SetDrawColor( 255, 255, 255 )
        end
    else
        surface.SetDrawColor( 255, 255, 255 )
        self.lerp = math.Clamp( self.lerp - 3, 0, self:GetWide() / 3 )
    end

    if self.lerp != 0 then
        surface.DrawLine( self:GetWide() / 2, self:GetTall() / 2 + ( ttall / 2 ) + 4, self:GetWide() / 2 + self.lerp, self:GetTall() / 2 + ( ttall / 2 ) + 4 )
        surface.DrawLine( self:GetWide() / 2, self:GetTall() / 2 + ( ttall / 2 ) + 4, self:GetWide() / 2 - self.lerp, self:GetTall() / 2 + ( ttall / 2 ) + 4 )
    end

    return true
end

function psheetbutton:Think()
    if self.psheet:GetActiveTab() == self.tab then --May be a bit expensive
        self.selected = true
    else
        self.selected = false
    end
end

vgui.Register( "PropertySheetButton", psheetbutton, "DButton" )

--//

local weaponsshop = { }
weaponsshop.tabs = { "Rifles", "Machine Guns", "Shotguns", "Pistols", "Equipment" }

function weaponsshop:Init()
    for k, v in pairs( self.tabs ) do
        local throwaway = vgui.Create( "DButton" )
        throwaway:SetSize( self:GetWide() / #self.tabs, 56 )
        throwaway:SetPos( throwaway:GetWide() * ( k - 1 ), 0 )
        throwaway:SetText( "" )
        throwaway.DoClick = function()

        end
        throwaway.Paint = function()
            surface.SetDrawColor( GAMEMODE.TeamColor )
            surface.DrawRect( 0, 0, throwaway:GetWide(), throwaway:GetTall() )
            
            surface.SetTexture( GAMEMODE.GradientTexture )
            surface.SetDrawColor( 0, 0, 0, 164 )
            surface.DrawTexturedRectRotated( throwaway:GetWide() / 2, 4, 8, throwaway:GetWide(), 270 ) --self.TeamMain:GetWide() / 2, self.TeamMainTitleSize + 4, 8, self.TeamMain:GetWide(), 270
                
            surface.SetFont( "ExoTitleFont" )
            local twide, ttall = surface.GetTextSize( v )
            surface.SetTextPos( throwaway:GetWide() / 2 - ( twide / 2 ), throwaway:GetTall() / 2 - ( ttall / 2) )
            surface.SetTextColor( 255, 255, 255 )
            surface.DrawText( v )

            throwaway.lerp = throwaway.throwaway or 0
            if throwaway.hover or throwaway.selected then
                throwaway.lerp = math.Clamp( throwaway.lerp + 3, 0, throwaway:GetWide() / 3 )
                if throwaway.selected then
                    surface.SetDrawColor( colorScheme[LocalPlayer():Team()]["ButtonIndicator"] )
                else
                    surface.SetDrawColor( 255, 255, 255 )
                end
            else
                surface.SetDrawColor( 255, 255, 255 )
                throwaway.lerp = math.Clamp( throwaway.lerp - 3, 0, throwaway:GetWide() / 3 )
            end

            if throwaway.lerp != 0 then
                surface.DrawLine( throwaway:GetWide() / 2, throwaway:GetTall() / 2 + ( ttall / 2 ) + 4, throwaway:GetWide() / 2 + throwaway.lerp, throwaway:GetTall() / 2 + ( ttall / 2 ) + 4 )
                surface.DrawLine( throwaway:GetWide() / 2, throwaway:GetTall() / 2 + ( ttall / 2 ) + 4, throwaway:GetWide() / 2 - throwaway.lerp, throwaway:GetTall() / 2 + ( ttall / 2 ) + 4 )
            end
        end

        self.tabs[ v ] = throwaway
    end
end

function weaponsshop:Paint()

end

vgui.Create( "WeaponsShopPanel", weaponsshop, "DPanel" )

--//

local skinsshop = { }

--//

local modelsshop = { }