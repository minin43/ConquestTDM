--//This file is used to draw perk icons when a perk affects the game

GM.IconQueue = { }
GM.PerkIcons = {
    [ "vendetta" ] = Material( "vgui/vendetta_icon.png" ),
    [ "headpopper" ] = Material( "vgui/headpopper_icon.png" ),
    [ "pyro" ] = Material( "vgui/pyro_icon.png" ),
    [ "vulture" ] = Material( "vgui/vulture_icon.png" ),
    [ "leech" ] = Material( "vgui/leech_icon.png" ),
    [ "spawn" ] = Material( "vgui/spawn_icon.png" )
}

net.Receive( "QueueUpIcon", function()
    local perk = net.ReadString()
    local dur = net.ReadFloat()

    --//Don't wanna set these in the global scope or they'll never change if someone changes their resolution
    GAMEMODE.ScreenWide = ScrW()
    GAMEMODE.ScreenTall = ScrH()

    if not GAMEMODE.PerkIcons[ perk ] then return end

    --//Here we check if the icon is already being displayed, and if so, reseting its duration to the new duration
    for k, v in pairs( GAMEMODE.IconQueue ) do
        if v.icon == GAMEMODE.PerkIcons[ perk ] then
            v.duration = dur + CurTime()
            return
        end
    end
    GAMEMODE.IconQueue[ #GAMEMODE.IconQueue + 1 ] = { icon = GAMEMODE.PerkIcons[ perk ], duration = dur, fade = 0.5 }
end )

GM.CrosshairIconSize = 32
GM.CrosshairIconBuffer = 8

hook.Add( "HUDPaint", "HUD_CrosshairIcons", function()
    for k, v in pairs( GAMEMODE.IconQueue ) do
        local posx = GAMEMODE.ScreenWide / 2 + ( GAMEMODE.CrosshairIconBuffer * k ) + ( GAMEMODE.CrosshairIconSize * ( k - 1 ) )
        local posy = GAMEMODE.ScreenTall / 2 + GAMEMODE.CrosshairIconBuffer

        if v.duration > CurTime() then
            surface.SetDrawColor( 255, 255, 255 )
            surface.SetMaterial( v.icon )
            surface.DrawTexturedRect( posx, posy, GAMEMODE.CrosshairIconSize, GAMEMODE.CrosshairIconSize )
        else
            if not v.endfade then
                v.endfade = CurTime() + v.fade
            end
            
            surface.SetDrawColor( 255, 255, 255, math.Clamp( 255 * ( ( v.endfade - CurTime() ) / v.fade ), 0, 255 ) )
            surface.SetMaterial( v.icon )
            surface.DrawTexturedRect( posx, posy, GAMEMODE.CrosshairIconSize, GAMEMODE.CrosshairIconSize )

            if v.endfade <= CurTime() then
                table.remove( GAMEMODE.IconQueue, k )
            end
        end
    end
end )
