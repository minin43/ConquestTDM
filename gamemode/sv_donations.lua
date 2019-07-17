donations = {}

function donations.GetCredits( ply )
    return math.Round( tonumber( ply:GetPData( "donatorcredits" ) ) )
end

function donations.AddCredits( ply, amt )
    ply:SetPData( "donatorcredits", donations.GetCredits( ply ) + amt )
end

--//Should only be called by admins if we start selling these or there's a fuckup
function donations.SetCredits( ply, amt )
    ply:SetPData( "donatorcredits", amt )
end

function donations.SubtractCredits( ply, amt )
    ply:SetPData( "donatorcredits", donations.GetCredits( ply ) - math.abs( amt ) )
end

hook.Add( "PlayerInitialSpawn", "SetupDonatorPData", function( ply )
	timer.Simple( 5, function()
		if not ply:GetPData( "donatorcredits" ) then
			donations.SetCredits( ply, 0 )
		end
	end )
end )