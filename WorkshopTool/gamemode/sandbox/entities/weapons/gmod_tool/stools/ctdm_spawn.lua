AddCSLuaFile()

language.Add( "tool.ctdm_spawn.name", "Conquest Team Deathmatch Spawn Placer Tool" )
language.Add( "tool.ctdm_spawn.desc", "Used to place & save spawn zones for CTDM to use" )

TOOL.Category = "ConquestTDM"
TOOL.Name = "#tool.ctdm_spawn.name"
TOOL.ClientConVar[ "team" ] = 1 --1 is red team, 2 is blue team
TOOL.ClientConVar[ "show" ] = true
TOOL.ClientConVar[ "flags" ] = {}
TOOL.ClientConVar[ "spawns" ] = {}

function TOOL:Init()

end

--//Places spawn point
function TOOL:LeftClick( trace )
    if !trace.HitPos or ( IsValid( trace.Entity ) and !trace.Entity:IsWorld() ) then return false end --Has to be the ground
    if ( CLIENT ) then return true end
    
    if self.StartedFlagPlacement then return end

    if !self.StartedSpawnPlacement then
        self.StartedSpawnPlacement = true
    end

    local ply = self:GetOwner()

    self.PosOne = nil
    self.PosTwo = nil

    if self.PosOne == nil then
        self.PosOne = trace.HitPos
        ply:ChatPrint( "Point one placed - click again to place point two" )
    elseif self.PosTwo == nil then
        self.PosTwo = trace.HitPos
        ply:ChatPrint( "Point two placed - press enter to review the values" )
    end
end

--//Places Conquest flags
function TOOL:RightClick( trace )
    if !trace.HitPos or ( IsValid( trace.Entity ) and !trace.Entity:IsWorld() ) then return false end --Has to be the ground
    if ( CLIENT ) then return true end

    if self.StartedSpawnPlacement then return end
    
    if !self.StartedFlagPlacement then
        self.StartedFlagPlacement = true
    end

    local ply = self:GetOwner()

    self.FlagPos = nil
    self.FlagSize = nil
    
    if !self.FlagPos then
        self.FlagPos = trace.HitPos
        ply:ChatPrint( "Flag position placed - click again to set flag interaction size" )
    elseif !self.FlagSize then
        self.FlagSize = math.abs( math.Distance( self.FlagPos.x, self.FlagPos.y, trace.HitPos.x, trace.HitPos.y ) )
        ply:ChatPrint( "Flag interaction size taken - press enter to review the values" )
    end
end

--//Suppose this'll need to run disables on the 3D2D drawing on client
function TOOL:Holster()
    self.PosOne = nil
    self.PosTwo = nil
    self.StartedSpawnPlacement = false
    self.FlagPos = nil
    self.FlagSize = nil
    self.StartedFlagPlacement = false
end

--//Undoes the last action - spawn placement or flag placement
function TOOL:Reload()
    local ply = self:GetOwner()

    if self.StartedSpawnPlacement then
        if self.PosTwo then
            self.PosTwo = nil
            ply:ChatPrint( "Undid point two placement" )
        elseif self.PosOne then
            self.PosOne = nil
            self.StartedSpawnPlacement = false
            ply:ChatPrint( "Undid point one placement" )
        end
    elseif self.StartedFlagPlacement then
        if  then

        elseif  then

        end
    end

end

function TOOL.BuildCPanel( CPanel )
    CPanel:AddControl( "Header", { Description = "#tool.ctdm_spawn.name" } )
    CPanel:AddControl( "Slider", { Description = "Sets which team the current player spawn is for", Command = "ctdm_spawn_team", Type = "Integer", Min = 1, Max = 2, Help = false })
end

--//
if SERVER then
    hook.Add( "PlayerButtonDown", "CTDM_SpawnPlacement", function( ply, key )
        if key != ENTER then return end -- So we don't run GetWeapon on every key press

        local wep = ply:GetWeapon( "gmod_tool" )
        if not wep then return end
        if not wep.StartedSpawnPlacement then return end

        if wep.PosOne and wep.PosTwo then
            if key == ENTER then
                ply:ChatPrint( "Spawn placement saved" )

                wep.PosOne = nil
                wep.PosTwo = nil
                wep.StartedSpawnPlacement = false
            end
        elseif wep.FlagPos and wep.FlagSize then
            if key == ENTER then
                ply:ChatPrint( "" )
            end
        end
    end )
end

if CLIENT then

end