if not file.Exists( "tdm/map_edits", "DATA" ) then
	file.CreateDir( "tdm/map_edits" )
end

if not file.Exists( "tdm/map_edits/" .. game.GetMap() .. ".txt", "DATA" ) then
	file.Write( "tdm/map_edits/" .. game.GetMap() .. ".txt", util.TableToJSON( { propSpawns = {}, Deletions = {} } ) )
end

function GM:RefreshCustomProps( doCleanUp )
    if doCleanUp then
        local deletedEnts = 
        game.CleanUpMap( false, { "player", "func_breakable", "prop_dynamic", "weapon_*", "item_*" } ) --//Will * work as wildcard symbol?
    end

    self.referenceFile = file.Read( "tdm/map_edits/" .. game.GetMap() .. ".txt", "DATA" )
    self.cleanedFile = util.JSONToTable( self.referenceFile )
    if not self.cleanedFile then return end

    for k, v in pairs( self.cleanedFile.propSpawns ) do
        local prop = ents.Create( "prop_physics" )
        if !IsValid( prop ) then return end
        prop:SetModel( v.model )
        prop:SetPos( v.pos )
        prop:SetAngles( v.ang )
        prop:Spawn()
        prop:SetMoveType( MOVETYPE_NONE )

        local physobject = prop:GetPhysicsObject()
        if physobject and physobject:IsValid() then physobject:EnableMotion( false ) end
    end

    for k, v in pairs( self.cleanedFile.Deletions ) do
        local entToDelete = ents.GetMapCreatedEntity( k )
        local openSesame = { func_door_rotating = true, func_door = true, prop_door_rotating = true }

        if entToDelete and openSesame[ entToDelete:GetClass() ] then
            entToDelete:Fire( "Unlock" )
            entToDelete:Fire( "Use" )
        end
        if entToDelete and entToDelete:IsValid() then
            timer.Simple( 0.5, function() entToDelete:Remove() end )
        end
    end
end

hook.Add( "InitPostEntity", "SpawnCustomProps", function()
    timer.Simple( 3, function() --//Fucking really?
        GAMEMODE:RefreshCustomProps() 
    end )
end )