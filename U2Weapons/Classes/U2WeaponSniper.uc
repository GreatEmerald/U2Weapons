/*
 * Copyright (c) 2008, 2013 Dainius "GreatEmerald" Masiliūnas
 * 
 * This file is part of Unreal II/XMP Weapons Mutator Pack for UT2004.
 * 
 * You can redistribute the Unreal II/XMP Weapons Mutator Pack for 
 * UT2004 and/or modify it under the terms of the GNU Lesser General 
 * Public License as published by the Free Software Foundation, either 
 * version 3 of the License, or (at your option) any later version, 
 * with the exception that the code cannot be commercially exploited in 
 * any way without prior consent of Epic Games.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
//-----------------------------------------------------------------------------
// U2WeaponSniper.uc
// Weapon class of the Widowmaker
// Head Shot!
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2WeaponSniper extends U2Weapon;

#EXEC OBJ LOAD FILE=..\UTXMP\Textures\XMPHUDTexB.utx
#EXEC OBJ LOAD FILE=..\UTXMP\Textures\KA_XMP.utx

var color ChargeColor;

var bool bZoomed, bWasZoomed;
var() float ZoomFOV;

var vector RingDir;
var float LastTimeSeconds;
var() float RingDelayFactor;
var float Angle, Radius;
var Point RingLocation;

var() Sound ZoomInSound;
var() Sound ZoomOutSound;
var() Sound AdjustZoomSound;

var() TexRotator RotatingRing;

//------------------------------------------------------------------------------

simulated event RenderOverlays( Canvas Canvas )
{
	local float CX, CY, Scale;
    local plane OldModulate;

	if (bZoomed)	// don't draw weapon model while zoomed.
	{
		UpdateCrosshair( Canvas );

		CX = Canvas.ClipX * 0.5;
		CY = Canvas.ClipY * 0.5;
		Scale = Canvas.ClipX/1024;

		Canvas.Style = ERenderStyle.STY_Alpha;

		RotatingRing.Rotation.Yaw = Angle * 182;

		OldModulate = Canvas.ColorModulate;
		Canvas.ColorModulate.X = 1;
	    Canvas.ColorModulate.Y = 1;
		Canvas.ColorModulate.Z = 1;
		Canvas.ColorModulate.W = 1;

		// Draw the large ring
		Canvas.SetDrawColor(255,255,255,180);
		Canvas.SetPos(0,0);
		Canvas.DrawTile(RotatingRing,
						Canvas.ClipX,
						Canvas.ClipY,
						0,
						128,
						1024,
						768);

		// draw the center crosshairs
		Canvas.SetDrawColor(255,255,255,255);
		Canvas.SetPos( CX-(64*Scale), CY-(64*Scale) );
		Canvas.DrawTile(Texture'KA_XMP.uSniperZoom',
						128*Scale,
						128*Scale,
						0, 0, 64, 64);

		// draw the delayed ring
		Canvas.SetDrawColor(255,255,255,30);
		Canvas.SetPos( CX-(128-RingLocation.X)*Scale,
						CY-(128-RingLocation.Y)*Scale );
		Canvas.DrawTile(Texture'XMPHUDTexB.SniperRing_SM',
						256*Scale,
						256*Scale,
						0, 0, 256, 256);

		Canvas.ColorModulate = OldModulate;

		return;
	}

	Super.RenderOverlays(Canvas);
}


simulated function HandleTargetDetails( Actor A, Canvas Canvas, vector ViewLoc, rotator ViewRot )
{
	local vector ScreenLoc;
	local float DeltaSeconds;
	local float Pct;

	if (bZoomed)
	{
		// Update delayed ring.
		ViewRot = Instigator.GetViewRotation();
		DeltaSeconds = Level.TimeSeconds - LastTimeSeconds;
		LastTimeSeconds = Level.TimeSeconds;
		Pct = FMin( 1.0, RingDelayFactor * DeltaSeconds );
		RingDir = normal(RingDir + ((normal(vector(ViewRot))-RingDir)*Pct));
		ScreenLoc = (RingDir*50) << ViewRot;
		RingLocation.X = ScreenLoc.Y;
		RingLocation.Y = -ScreenLoc.Z;

		// Update big ring.
		Angle = Instigator.Controller.FOVAngle;

		// Update zoom bars.
		Radius = (Instigator.Controller.FOVAngle/120 * 196) - 2;
	}
}

//------------------------------------------------------------------------------

simulated function ClientWeaponThrown()
{
    if( (Instigator != None) && (PlayerController(Instigator.Controller) != None) )
        PlayerController(Instigator.Controller).EndZoom();
    Super.ClientWeaponThrown();
}
/*
simulated function ClientReload()
{
	bWasZoomed = bZoomed;
	UnZoom();
	super.ClientReload();
}

simulated function ClientFinishReloading()
{
	super.ClientFinishReloading();
	if ( bWasZoomed )
		Zoom();
}
*/

simulated function ClientStartFire(int mode)
{
    if (mode == 1)
    {
        FireMode[mode].bIsFiring = true;
		if (bZoomed)
			UnZoom();
		else
			Zoom();
    }
    else
    {
        Super.ClientStartFire(mode);
    }
}

simulated function ClientStopFire(int mode)
{
    if (mode == 1)
    {
        FireMode[mode].bIsFiring = false;
       // if( PlayerController(Instigator.Controller) != None )
        //    PlayerController(Instigator.Controller).StopZoom();
    }
    else
    {
        Super.ClientStopFire(mode);
    }
}

simulated function BringUp(optional Weapon PrevWeapon)
{
//    if( Instigator.Controller.IsA( 'PlayerController' ) )
    if (bZoomed)
        UnZoom();
    Super.BringUp(PrevWeapon);
}

simulated function bool PutDown()
{
//    if( Instigator.Controller.IsA( 'PlayerController' ) )
    if (bZoomed)
        UnZoom();
    if ( Super.PutDown() )
		return true;
	return false;
}


//prevents weapon switching for the sniper rifle
simulated function Weapon PrevWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
	if (bZoomed)
	{
		ZoomIn();
		return None;
	}
	return Super.PrevWeapon(CurrentChoice, CurrentWeapon);
}

simulated function Weapon NextWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
	if (bZoomed)
	{
		ZoomOut();
		return None;
	}
	return Super.NextWeapon(CurrentChoice, CurrentWeapon);
}

simulated function SetPlayerFOV( float NewFOV )
{
	assert(bZoomed);

	ZoomFOV = FClamp( NewFOV, 1.0, 60.0 );

	if (PlayerController(Instigator.Controller) != none)
	{
		PlayerController(Instigator.Controller).DesiredFOV = ZoomFOV;
	}
}

exec simulated function ZoomIn()
{
	if( bZoomed )
	{
		if( ZoomFOV > 20 )
		{
			// 90 --> 20 by 10
			SetPlayerFOV( ZoomFOV - 10 );
		}
		else if( ZoomFOV > 5 )
		{
			// 20 --> 5 by 5
			SetPlayerFOV( ZoomFOV - 5 );
		}
		else
		{
			// 5 --> 1 by 2
			SetPlayerFOV( ZoomFOV - 2 );
		}
		PlaySound( AdjustZoomSound );
	}
}

exec simulated function ZoomOut()
{
	if( bZoomed )
	{
		if( ZoomFOV >= 20 )
		{
			// 20 --> 90 by 10
			SetPlayerFOV( ZoomFOV + 10 );
		}
		else if( ZoomFOV >= 5 )
		{
			// 5 --> 20 by 5
			SetPlayerFOV( ZoomFOV + 5 );
		}
		else
		{
			// 1 --> 5 by 2
			SetPlayerFOV( ZoomFOV + 2 );
		}
		PlaySound( AdjustZoomSound );
	}
}

simulated function Zoom()
{
	//only execute this code on the local machine and server ... not the third-person players
	if ( !bZoomed && Instigator.Controller != None )
	{
		bZoomed = true;
		SetPlayerFOV( ZoomFOV );
//		SendEvent("Rotate");
		PlaySound( ZoomInSound );
		bAllowCustomCrosshairs=false;
	}
}

simulated function UnZoom( optional bool bForce )
{
	//only execute this code on the local machine and server ... not the third-person players
	if ( /*bZoomed &&*/ Instigator.Controller != None )
	{
		bZoomed = false;

		if( PlayerController(Instigator.Controller) != None )
		{
			PlayerController(Instigator.Controller).DesiredFOV = PlayerController(Instigator.Controller).DefaultFOV;
			if( bForce )
				PlayerController(Instigator.Controller).FOVAngle = PlayerController(Instigator.Controller).DefaultFOV;
		}

	    if( Instigator.Controller.IsA( 'PlayerController' ) )
	        PlayerController(Instigator.Controller).EndZoom();

//		SendEvent("UnRotate");
		PlaySound( ZoomOutSound );
		bAllowCustomCrosshairs=true;
	}
}


simulated function vector GetEffectStart()
{
    local Coords C;

    if ( !bZoomed && Instigator.IsFirstPerson() )
    {
        if ( WeaponCentered() )
            return CenteredEffectStart();
        C = GetBoneCoords('tip');
        return C.Origin - 15 * C.XAxis;
    }
    else if ( !Instigator.IsFirstPerson() && U2AttachmentSniper(ThirdPersonActor) != None )
        return U2AttachmentSniper(ThirdPersonActor).GetTipLocation();

    return Super.GetEffectStart();
}


simulated state Reloading
{
	simulated event BeginState()
	{
		Super.BeginState();
		bWasZoomed = bZoomed;
		UnZoom();
	}
	simulated event EndState()
	{
		Super.EndState();
		if (bWasZoomed && Instigator != none && Instigator.PendingWeapon == None)
			Zoom();
	}
}


// AI Interface
function float SuggestAttackStyle()
{
    return -0.4;
}

function float SuggestDefenseStyle()
{
    return 0.2;
}

/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode()
{
	return 0;
}

function float GetAIRating()
{
	local Bot B;
	local float ZDiff, /*dist,*/ Result;

	B = Bot(Instigator.Controller);
	if ( B == None )
		return Super.GetAIRating();
	if ( B.IsShootingObjective() )
		return Super.GetAIRating() - 0.15;
	if ( B.Enemy == None )
		return Super.GetAIRating();

	if ( B.Stopped() )
		result = Super.GetAIRating() + 0.1;
	else
		result = Super.GetAIRating() - 0.1;
	if ( Vehicle(B.Enemy) != None )
		result -= 0.2;
	ZDiff = Instigator.Location.Z - B.Enemy.Location.Z;
	if ( ZDiff < -200 )
		result += 0.1;
	if ( !B.EnemyVisible() )
		return Super.GetAIRating() - 0.1;

	return result;
}


function bool RecommendRangedAttack()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return true;

	return ( VSize(B.Enemy.Location - Instigator.Location) > 2000 * (1 + FRand()) );
}
// end AI Interface

defaultproperties
{
     ClipSize=10
     FireModeClass(0)=Class'U2Weapons.U2FireSniper'
     FireModeClass(1)=Class'U2Weapons.U2FireAltSniper'
     Description="The T72 Widowmaker Sniper Rifle is a highly specialized weapon that should be used only for long-range sniping, but it does its job very, very well. Its targeting system compensates for wind and other variables to create an instant hit on virtually any target you can see."
     Priority=40
     InventoryGroup=9
     PickupClass=Class'U2Weapons.U2PickupSniper'
     BobDamping=2.200000
     AttachmentClass=Class'U2Weapons.U2AttachmentSniper'
     IconMaterial=Texture'U2343T.HUD.U2HUD'
     IconCoords=(X1=122,Y1=202,X2=174,Y2=217)
     ItemName="Widowmaker Sniper Rifle"
     //PlayerViewOffset=(X=6.00000,Y=1.000000,Z=-11.000000)
     //DrawScale=0.4

     ChargeColor=(B=255,G=255,R=255,A=255)
     ZoomFOV=30.000000
     RingDelayFactor=6.000000
     ZoomInSound=Sound'WeaponsA.SniperRifle.SR_ScopeOn'
     ZoomOutSound=Sound'WeaponsA.SniperRifle.SR_ScopeOff'
     AdjustZoomSound=Sound'WeaponsA.SniperRifle.SR_Zoom'
     RotatingRing=TexRotator'XMPHUDTexB.Sniper.SniperRot'
     AutoSwitchPriority=16
     ReloadSound=Sound'WeaponsA.SniperRifle.SR_Reload'
     ReloadUnloadedSound=Sound'WeaponsA.SniperRifle.SR_ReloadUnloaded'
     ReloadTime=1.875000
     ReloadUnloadedTime=1.330000
     SelectSound=Sound'WeaponsA.SniperRifle.SR_Select'
     AIRating=0.500000
     //CurrentRating=0.690000
     bSniping=True
     bUseOldWeaponMesh=True
     CustomCrosshair=61
     CustomCrossHairTextureName="KA_XMP.U2.uSniper"
     PlayerViewOffset=(X=13.000000,Y=1.500000,Z=-29.000000)
     Mesh=SkeletalMesh'WeaponsK.SR_FP'
     Skins(0)=Shader'U2WeaponFXT.Sniper.SR_Skin1FX'

    RangeMinFire=0.000000
    RangeIdealFire=256.000000
    RangeMaxFire=2048.000000
    RangeLimitFire=32767.000000
    RatingRangeMinFire=0.500000
    RatingRangeIdealFire=0.500000
    RatingRangeMaxFire=0.150000
    AIRatingFire=0.500000
    AIRatingAltFire=-50.000000

}
