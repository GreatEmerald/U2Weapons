/*
 * Copyright (c) 2013 Dainius "GreatEmerald" Masiliūnas
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
//-----------------------------------------------------------
// XMPProximitySensorController.uc
// 2004 jasonyu
// 25 July 2004
//-----------------------------------------------------------

class U2ProximitySensorController extends U2StationaryPawnController;

const	ScanningState		= 'Scanning';
const	TrackingTargetState = 'TrackingTarget';
const	ActionState			= 'Action';
const	DeactivatedState	= 'Deactivated';
const	BeginLabel			= 'Begin';
const	ActionLabel			= 'Action';
const	TL_Off				= 0;
const	TL_Scanning			= 1;
const	TL_Tracking			= 2;
const	TL_LockedOn			= 3;

//-----------------------------------------------------------------------------

var U2ProximitySensor PS;
var	float CheckFOVRate, NextCheckFOVTime;

//-----------------------------------------------------------------------------

function Possess( Pawn P )
{
	PS = U2ProximitySensor( P );
	Super.Possess( P );
}

//-----------------------------------------------------------------------------

function NotifyDeployed()
{
	if( PS.IsEnabled() )
	{
		if( PS.AmbientSound == None )
			PS.AmbientSound = PS.AmbientNoiseSound;
		GotoState( 'Scanning' );
	}
	else
		Deactivate();
}

//-----------------------------------------------------------------------------

function float GetTrackingRange()
{
	return ( PS.SightRadius * PS.TrackingRangeMultiplier );
}

//-----------------------------------------------------------------------------

function bool ValidEnemy( Pawn Enemy )
{

    if( Pawn==none ||
		Enemy==none ||
		Pawn.Health <= 0 ||
		Enemy.Health <= 0 ||
		Enemy.Controller == none )
        return false;


    //GE: deathmatch-specific settings.
    if (Pawn.GetTeamNum() == 255 &&
        Enemy.Controller != KillerController)
        return true;

    //GE: deathmatch-specific settings.
    if (Pawn.GetTeamNum() == 255 &&
        U2DeployedUnit(Enemy) != none &&
        U2DeployedUnit(Enemy).KillerController != KillerController)
        return true;

    if (U2StationaryPawn(Pawn).SameTeam(Enemy))
        return false;

	return true;
}

//-----------------------------------------------------------------------------

function bool CanPerformAction()
{
	return( ValidEnemy(Enemy) &&
			VSize(Enemy.GetAimTarget().Location - Location) <= GetTrackingRange() &&
			PS.IsEnabled() );
}

//-----------------------------------------------------------------------------

function SetTargetingEffect( int TrackLevel );

//-----------------------------------------------------------------------------

function HandleEnemyLost()
{
    Enemy = None;
	GotoState( 'Scanning' );
}

//-----------------------------------------------------------------------------

function bool InVisibilityCone( Pawn Other )
{
	if( Pawn == None || Other == None )
		return false;

	// If this device has a 360 degree visual range
	if( Pawn.PeripheralVision == 0 )
		return true;

	if( (Normal( Other.Location - Pawn.Location ) dot vector( Rotation ) ) < Pawn.PeripheralVision )
		return false;
	else
		return true;
}

//-----------------------------------------------------------------------------

function Activate()
{
	NotifyDeployed();
}

//-----------------------------------------------------------------------------

function DeActivate()
{
	GotoState( 'Deactivated' );
}

//-----------------------------------------------------------------------------

state Deactivated
{
	ignores SeePlayer;

	event BeginState()
	{
		SetTargetingEffect( TL_Off );
		PS.AmbientSound = None;
	}
}
//-----------------------------------------------------------------------------

function SeeMonster( Pawn Seen )
{
	SeePlayer(Seen);
}

//-----------------------------------------------------------------------------

auto state Active
{
	function SeePlayer( Pawn Seen )
	{
		// use this event to control acquiring an enemy
	}
}

//-----------------------------------------------------------------------------

state Scanning
{
	//-------------------------------------------------------------------------

	function SeePlayer( Pawn Seen )
	{
        if( ValidEnemy( Seen ) && PS.IsActive() && PS.IsEnabled() )
		{
            Enemy = Seen;
			GotoState( 'TrackingTarget' );
		}
	}

	event BeginState()
	{
		SetTargetingEffect( TL_Scanning );
		bIsPlayer=true;
	}

	event EndState()
	{
		SetTargetingEffect( TL_Off );
		bIsPlayer=false;
	}
}

//-----------------------------------------------------------------------------

state TrackingTarget
{
	ignores SeePlayer;

	event EnemyNotVisible()
	{
		HandleEnemyLost();
	}

	event EnemyInvalid()
	{
		HandleEnemyLost();
	}

	event Tick( float DeltaTime )
	{
		Global.Tick( DeltaTime );

		if( Level.TimeSeconds > NextCheckFOVTime )
		{
			NextCheckFOVTime = Level.TimeSeconds + CheckFOVRate;
			//DMTNS( "Degrees: " $ Acos( (Normal( Enemy.Location - Pawn.Location ) dot vector( Rotation ) ) ) * RadiansToDegrees );
			if( Pawn != None && Enemy != None )
			{
				if( !InVisibilityCone( Enemy ) || !PS.IsEnabled() )
					HandleEnemyLost();
			}
		}
	}

	event BeginState()
	{
		SetTargetingEffect( TL_Tracking );
	}

	event EndState()
	{
		SetTargetingEffect( TL_Off );
	}

Begin:
	Pawn.PlaySound( PS.TrackingSound, SLOT_None, 0.15 );
	Sleep( PS.TimeToTrack );
	GotoState( 'Action' );
}

//-----------------------------------------------------------------------------

state Action extends TrackingTarget
{
	ignores SeePlayer;

	event BeginState()
	{
		SetTargetingEffect( TL_LockedOn );
	}

	event EndState()
	{
        SetTargetingEffect( TL_Off );
		if( Vehicle(Pawn) != None )
			Vehicle(Pawn).StopWeaponFiring();
        StopAction();
	}

	function StopAction();

	function PerformAction()
	{
		Pawn.PlaySound( PS.ActionSound, SLOT_None );
	}

Begin:
	if( PS.ActiveAlertSound != None )
	{
		Pawn.PlaySound( PS.ActiveAlertSound, SLOT_None );
		Sleep( GetSoundDuration( PS.ActiveAlertSound ) );
	}

	if( PS.bAmbientActionSound )
		PS.AmbientSound = PS.ActionSound;

Action:
	if( CanPerformAction() )
		PerformAction();
	else
		HandleEnemyLost();

	Sleep( PS.ActionRate );
	Goto( ActionLabel );
}

//-----------------------------------------------------------------------------

defaultproperties
{
     CheckFOVRate=0.500000
     //PlayerReplicationInfoClass=Class'U2TurretReplicationInfo'
}
