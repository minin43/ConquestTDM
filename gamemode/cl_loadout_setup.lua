--//This file is strictly for creating/registering custom vgui elements for the loadout menu

local ChooseMainButton = {}
ChooseMainButton.PlainText = ""
ChooseMainButton.MarkupObject = markup.Parse( "" )
ChooseMainButton.Font = "DermaDefault"
ChooseMainButton.Icon = Material( "" )
ChooseMainButton.IconBuffer = 10 --in pixels, this will double since it applies to both sides
local gradient = surface.GetTextureID( "gui/gradient" )

function ChooseMainButton:RunMarkupSetup()
    self.MarkupObject = markup.Parse( "<font = " .. self.Font .. ">" .. self.PlainText .. "</font>" )
end

function ChooseMainButton:Init()
    self:RunMarkupSetup()
end

function ChooseMainButton:SetText( txt )
    self.PlainText = txt
    self:RunMarkupSetup()
end

function ChooseMainButton:SetFont( fnt )
    self.Font = fnt
    self:RunMarkupSetup()
end

function ChooseMainButton:SetIcon( icon )
    if isstring( icon ) then
        self.Icon = Material( icon )
    else
        self.Icon = icon
    end
end

function ChooseMainButton:OnCursorEntered()
    --surface.PlaySound( "" )
    self.Hover = true
end

function ChooseMainButton:OnCursorExited()
    self.Hover = false
end

function ChooseMainButton:Think()
    self.IconSize = self:GetWide() - ( self.IconBuffer * 2 )
end

function ChooseMainButton:Paint()
    self.MarkupObject:Draw( self:GetWide() / 2, self:GetTall() / 3, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    surface.SetMaterial( self.Icon )
    surface.DrawTexturedRect( self.IconSize, self.IconSize, self:GetWide() / 2 - self.IconSize / 2, self:GetTall() / 2 ) --To figure out

    if !self.Hover then
        surface.SetTexture( gradient )
        surface.SetDrawColor( 0, 0, 0, 164 )
        surface.DrawTexturedRectRotated( self:GetWide() / 2, self:GetTall() / 2, self:GetWide(), self:GetTall(), 90 )
        surface.DrawTexturedRectRotated( self:GetWide() / 2, self:GetTall() / 2, self:GetWide(), self:GetTall(), 270 )
    else

    end
end

vgui.Register( "ChooseMainButton", ChooseMainButton, "DButton" )

--//

local LoadoutOptionButton = {}
LoadoutOptionButton.Text = ""
LoadoutOptionButton.Font = "DermaDefault"
LoadoutOptionButton.Sheet = nil

function LoadoutOptionButton:SetText( txt )
    self.Text = txt
end

function LoadoutOptionButton:SetFont( fnt )
    self.Font = fnt
end

function LoadoutOptionButton:SetSheet( sht )
    self.Sheet = sht
end

function LoadoutOptionButton:OnCursorEntered()
    --surface.PlaySound( "" )
    self.Hover = true
end

function LoadoutOptionButton:OnCursorExited()
    self.Hover = false
end

function LoadoutOptionButton:DoClick()
    surface.PlaySound( "" )
    GAMEMODE.LoadoutSheet:SetActiveTab( self.sht )
end

function LoadoutOptionButton:Paint()
    draw.SimpleText( self.Text, self.Font, self:GetWide() / 2, self:GetTall() / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

vgui.Register( "LoadoutOptionButton", LoadoutOptionButton, "DButton" )

--//

local LoadoutSheetMasterPanel = {}
LoadoutSheetMasterPanel.List = {}

function LoadoutSheetMasterPanel:SetWeapons( weps )
    self.List = weps
end


vgui.Register( "LoadoutSheetMasterPanel", LoadoutSheetMasterPanel, "DPanel")