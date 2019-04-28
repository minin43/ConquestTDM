--//This file is strictly for creating/registering custom vgui elements for the loadout menu

local ChooseMainButton = {}
ChooseMainButton.PlainText = ""
ChooseMainButton.MarkupObject = markup.Parse( "" )
ChooseMainButton.Font = "DermaDefault"
ChooseMainButton.Icon = Material( "" )
ChooseMainButton.IconBuffer = 45 --in pixels, this will double since it applies to both sides
ChooseMainButton.Disabled = false
ChooseMainButton.SoundTable = {
    "ambient/machines/keyboard2_clicks.wav",
    "ambient/machines/keyboard3_clicks.wav",
    "ambient/machines/keyboard1_clicks.wav",
    "ambient/machines/keyboard4_clicks.wav",
    "ambient/machines/keyboard5_clicks.wav",
    "ambient/machines/keyboard6_clicks.wav",
    "ambient/machines/keyboard7_clicks_enter.wav"
}
local gradient = surface.GetTextureID( "gui/gradient" )

function ChooseMainButton:RunMarkupSetup()
    self.MarkupObject = markup.Parse( "<font=" .. self.Font .. "><colour=0,0,0>" .. self.PlainText .. "</colour></font>" )
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

function ChooseMainButton:Disable( bool )
    if bool then
        self.Disabled = bool
    else
        self.Disabled = false
    end
end

function ChooseMainButton:OnCursorEntered()
    if !self.Disabled then
        --surface.PlaySound( self.SoundTable[ math.random( #self.SoundTable ) ] )
        self.Hover = true
    end
end

function ChooseMainButton:OnCursorExited()
    self.Hover = false
end

function ChooseMainButton:Think()
    self.IconSize = self:GetWide() - ( self.IconBuffer * 2 )
end

function ChooseMainButton:Paint()
    surface.SetDrawColor( 0, 0, 0 )
    surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )

    self.MarkupObject:Draw( self:GetWide() / 2, 24, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    surface.SetDrawColor( 0, 0, 0, 220 )
    surface.SetMaterial( self.Icon )
    surface.DrawTexturedRect( self:GetWide() / 2 - ( self.IconSize / 2 ), self:GetTall() / 2 - ( self.IconSize / 2 ), self.IconSize, self.IconSize ) --To figure out

    if !self.Hover then
        surface.SetTexture( gradient )
        surface.SetDrawColor( 0, 0, 0, 164 )
        surface.DrawTexturedRectRotated( self:GetWide() - 10, self:GetTall() / 2, 20, self:GetTall(), 180 )
        surface.DrawTexturedRectRotated( 10, self:GetTall() / 2, 20, self:GetTall(), 0 )
        surface.DrawTexturedRectRotated( self:GetWide() / 2, 10, 20, self:GetWide(), 270 )
    else

    end

    if self.Disabled then
        surface.SetDrawColor( Color( 0, 0, 0, 160 ) )
		surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
    end
    
    return true
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

local AttachmentButton = {}

--//Shit I ripped from P:OL
--[[function AttachmentButton:SetInfo(basePanel, attachment, attachmentType, baseWepType)
    self.basePanel = basePanel
    self.attachment = attachment
    self.attachmentType = attachmentType
    self.wepType = baseWepType

    --print(self.attachment)
    if self.attachment then
        self.img = CustomizableWeaponry.registeredAttachmentsSKey[self.attachment].displayIcon
    else
        self.img = Material("a") --missing texture
    end
end

function AttachmentButton:DoClick()
    surface.PlaySound("buttons/lightswitch2.wav")
    if self.wepType == "primaries" then
        GAMEMODE.PRIMARY_WEAPON_ATTACHMENTS[self.attachmentType] = self.attachment
    elseif self.wepType == "Secondaries" then
        GAMEMODE.SECONDARY_WEAPON_ATTACHMENTS[self.attachmentType] = self.attachment
    elseif self.wepType == "equipment" then
        GAMEMODE.EQUIPMENT_WEAPON_ATTACHMENTS[self.attachmentType] = self.attachment
    end
    self.basePanel.isOpen = false
    GAMEMODE:RefreshWeapons()
end

function AttachmentButton:OnCursorEntered()
    surface.PlaySound("garrysmod/ui_hover.wav")
    self.hover = true
end

function AttachmentButton:OnCursorExited()
    self.hover = false
end

function AttachmentButton:Paint()
    surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColor.r, GAMEMODE.myTeam.menuTeamColor.g, GAMEMODE.myTeam.menuTeamColor.b)
    surface.DrawRect(0, 0, self:GetSize())
    surface.SetDrawColor(255, 255, 255)
    surface.DrawOutlinedRect(0, 0, self:GetSize())

    if self.attachment then
        surface.SetTexture(self.img)
    else
        surface.SetMaterial(self.img)
    end
    surface.DrawTexturedRect(0, 0, self:GetSize())
    if self.hover then
        surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColorLightAccent.r, GAMEMODE.myTeam.menuTeamColorLightAccent.g, GAMEMODE.myTeam.menuTeamColorLightAccent.b)
        --surface.DrawOutlinedRect(0, 0, self:GetSize())
    end
    return true
end

--[[function AttachmentButton:Think()
    self:MoveToFront()
    if self.basePanel and self.basePanel:IsValid() and self.basePanel.isOpen then return end
    self:Remove()
end]]

vgui.Register("AttachmentButton", AttachmentButton, "DButton")

--//

local SelectionPanel = {}
--SelectionPanel.Object
SelectionPanel.Type = 1
SelectionPanel.TypeEnumerations = { TYPE_WEAPON = 1, TYPE_NONWEAPON = 2 }
SelectionPanel.TitleText = "Tertiary"
SelectionPanel.TitleFont = "DermaDefault"
SelectionPanel.TitleBuffer = 2 --//in pixels

function SelectionPanel:SetType( enum )
    self.Type = enum
end

function SelectionPanel:SetTitle( txt )
    self.TitleText = txt
    self:AdjustTitleBox()
end

function SelectionPanel:SetFont( fnt )
    self.TitleFont = fnt
    self:AdjustTitleBox()
end

function SelectionPanel:AdjustTitleBox()
    surface.SetFont( self.TitleFont )
    self.TitleWide, self.TitleTall = surface.GetTextSize( self.TitleText )
    self.FullTitleTall = ( self.TitleTall * 2 ) - ( self.TitleBuffer * 3 ) --Do we want a buffer under the name?

    self.TitleBox = {
        { x = self:GetWide() / 2 - ( self.TitleWide / 2 ) - ( self.TitleBuffer * 3 ), y = 0 },
        { x = self:GetWide() / 2 + ( self.TitleWide / 2 ) + ( self.TitleBuffer * 3 ), y = 0 },
        { x = self:GetWide() / 2 + ( self.TitleWide / 2 ) + ( self.TitleBuffer * 2 ), y = self.TitleTall / 2 + self.TitleBuffer },
        { x = self:GetWide() / 2 + ( self.TitleWide / 2 ) + self.TitleBuffer, y = self.TitleTall + ( self.TitleBuffer * 2 ) },
        { x = self:GetWide() / 2 - ( self.TitleWide / 2 ) - self.TitleBuffer, y = self.TitleTall + ( self.TitleBuffer * 2 ) },
        { x = self:GetWide() / 2 - ( self.TitleWide / 2 ) - ( self.TitleBuffer * 2 ), y = self.TitleTall / 2 + self.TitleBuffer }
    }
end

function SelectionPanel:DrawModel( mdl )
    self.ModelPanel = vgui.Create( "DModelPanel", self )
    self.ModelPanel:SetSize( self:GetWide(), self:GetTall() / 2 - self.FullTitleTall )
    self.ModelPanel:SetPos( 0, self.FullTitleTall )
    self.ModelPanel:SetModel( weapons.GetStored( self.Object ).WorldModel or mdl )
    self.ModelPanel:SetCamPos( Vector(0, 35, 0 ) ) --Courtesy of Spy
    self.ModelPanel:SetLookAt( Vector(0, 0, 0 ) ) --Courtesy of Spy
    self.ModelPanel:SetFOV( 90 ) --Courtesy of Spy
    --self.ModelPanel:GetEntity():SetAngles
    self.ModelPanel:GetEntity():SetPos( Vector( -6, 13.5, -1 ) )
    self.ModelPanel:SetAmbientLight( Color( 255, 255, 255 ) )
    self.ModelPanel.LayoutEntity = function() return true end --Disables rotation
end

function SelectionPanel:SetObject( objClass, drawNonWepModel )
    self.Object = objClass
    if self.Type == 1 then --//If type weapon
        if !weapons.Get( objClass ) then return end
        self:DrawModel()
    else
        if weapons.Get( objClass ) and drawNonWepModel then
            self:DrawModel()
        else
            --center the name text
        end
    end
end

function SelectionPanel:Paint()
    surface.SetDrawColor( 0, 0, 0 )
    surface.DrawPoly( self.TitleBox )
    draw.SimpleText( self.TitleText, self.TitleFont, self:GetWide() / 2, self.TitleTall / 2 + self.TitleBuffer, Color(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end