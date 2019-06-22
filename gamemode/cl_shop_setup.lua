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

local weaponsshopbutton = table.Copy( psheetbutton )
weaponsshopbutton.gradient = false

function weaponsshopbutton:DoClick()
    self:GetParent().selected = self.text
    --//Call panel reset function here
    --//Maybe do a sound
end

function weaponsshopbutton:Think()
    if self:GetParent().selected == self.text then
        self.selected = true
    else
        self.selected = false
    end
end

function weaponsshopbutton:DoGradient()
    self.gradient = true
end

function weaponsshopbutton:Paint()
    surface.SetDrawColor( GAMEMODE.TeamColor )
    surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
    
    if self.gradient then
        surface.SetTexture( GAMEMODE.GradientTexture )
        surface.SetDrawColor( 0, 0, 0, 164 )
        surface.DrawTexturedRectRotated( self:GetWide() / 2, 4, 8, self:GetWide(), 270 ) --self.TeamMain:GetWide() / 2, self.TeamMainTitleSize + 4, 8, self.TeamMain:GetWide(), 270
    end

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

vgui.Register( "WeaponsShopButton", weaponsshopbutton, "DButton" )

local weaponsshop = { }
weaponsshop.tabs = { "ar", "smgs", "sg", "sr", "lmg", "pt", "mn", "eq" }

function weaponsshop:Init()
    net.Start( "RequestLockedWeapons" )
    net.SendToServer()

    net.Receive( "RequestLockedWeaponsCallback", function()
        weaponsshop.lockedweapons = net.ReadTable()
        if not weaponsshop.Reset then
            timer.Simple( 0, function()
                weaponsshop:Reset( "ar" )
            end )
        else
            weaponsshop:Reset( "ar" )
        end
        --[[if self.delayresetwithtype then
            weaponsshop:Reset( self.delayresetwithtype )
        end]]
    end )
    
    for k, v in pairs( self.tabs ) do
        local rowoffset = 0
        if k > 4 then rowoffset = 56 end

        local throwaway = vgui.Create( "WeaponsShopButton", self )
        throwaway:SetSize( self:GetWide() / 4, 56 )
        throwaway:SetPos( throwaway:GetWide() * ( k - 1 - rowoffset ), rowoffset )
        throwaway:SetText( v )
        if k > 4 then
            throwaway:DoGradient()
        end

        self.tabs[ v ] = throwaway
    end

    function self:Reset( type )
        if !IsValid( self.lockedweapons ) then return end

        self.scrollpanel = vgui.Create( "DScrollPanel", self )
        self.scrollpanel:SetPos( 0, 56 * 2 )
        self.scrollpanel:SetSize( self:GetWide() / 3, self:GetTall() - ( 56 * 2 ) )

        for k, v in pairs( self.lockedweapons ) do
            if GAMEMODE.WeaponsList[ k ].type == type then
                --//Create & add a button to the scroll panel here
                --//Button should show either prim/sec/equip icon next to name
                --//Icon displaying level availability and cash availability
            end
        end
    end

end

function weaponsshop:Paint()
    if self.delayresetwithtype then
        draw.SimpleText( "Loading...", "ExoTitleFont", self:GetWide() / 2, self:GetTall() / 2, Color( colorScheme[LocalPlayer():Team()]["ButtonIndicator"] ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
end

vgui.Create( "WeaponsShopPanel", weaponsshop, "DPanel" )

--//

local skinsshop = { }

--//

local modelsshop = { }