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
// 2004 jasonyu
// 25 July 2004
//-----------------------------------------------------------

class U2TurretController extends U2ProximitySensorController;

var U2DeployedTurret		MyTurret;
var vector		CurrentAimingLocation;			// where the satellite is
var vector		DesiredAimingLocation;			// where we'd like to move the satellite to
var float		MinHitNonPawnDistance;
var int			TrackLevel;
var float		TurningRateDegreesPerSecond;	// rate at which turrent can adjust its aiming direction
var bool		bSettled;

const DegreesToRadians					= 0.0174532925199432;	// PI / 180.0
const RadiansToDegrees					= 57.295779513082321;	// 180.0 / PI
const DegreesToRotationUnits			= 182.044; 				// 65536 / 360
const RotationUnitsToDegrees			= 0.00549; 				// 360 / 65536

//-----------------------------------------------------------------------------

function vector GetStraightAheadLocation()
{
	return ( MyTurret.Location + 1024.0*vector(Rotation) );
}

//-----------------------------------------------------------------------------

function Possess( Pawn P )
{
	Super.Possess( P );
	MyTurret = U2DeployedTurret( P );
	CurrentAimingLocation = GetStraightAheadLocation();
}

//-----------------------------------------------------------------------------

function SetTargetingEffect( int NewTrackLevel )
{
	if( MyTurret != None )
	{
		if( TrackLevel == NewTrackLevel )
			return;
		TrackLevel = NewTrackLevel;
	}
}

//-----------------------------------------------------------------------------

function vector GetFireOffset()
{
//	if( Pawn.Weapon == None )
		return MyTurret.Location;
//	else
//		return Pawn.Weapon.EffectOffset; //FireOffset;
}

//-----------------------------------------------------------------------------

function rotator AdjustAim(FireProperties FiredAmmunition, vector projStart, int aimerror)
{
    return MyTurret.GetAimingRotation();
}

//-----------------------------------------------------------------------------

function bool OKToHit( Actor HitActor, vector HitLocation, vector HitNormal )
{
	if( Pawn(HitActor) == None && VSize( MyTurret.Location - HitLocation ) < MinHitNonPawnDistance )
		return false;

	if( HitActor == None )
		return true;

	if( Pawn(HitActor) == None )
		return false; //HitActor.CanHit( Self );

	if( HitActor == Enemy.GetAimTarget() )
		return true;

   // if (Pawn.GetTeamNum() == 255)
   //     return true;

	return U2DeployedTurret(Pawn).SameTeam( Pawn(HitActor) );
}

//-----------------------------------------------------------------------------

function bool CanPerformAction()
{
	local vector HitLocation, HitNormal;
	local Actor HitActor;

	if( !Super.CanPerformAction() )
		return false;

	HitActor = Trace( HitLocation, HitNormal, DesiredAimingLocation, GetFireOffset(), true );

	return OKToHit( HitActor, HitLocation, HitNormal );
}

//-----------------------------------------------------------------------------
// Returns true if aiming changed, false otherwise.

function UpdateAiming( float DeltaTime )
{
	local vector CurrentAimingDirectionNormal, DesiredAimingDirectionNormal;
//	local vector Axis;
	local float Degrees, MaxDegrees;
	local vector StartLocation;

	// we would like to aim at TargetLocation but we're not allowed to
	// turn faster than a certain rate.
	if( CurrentAimingLocation != DesiredAimingLocation )
	{
		StartLocation = MyTurret.GetViewLocation();
		CurrentAimingDirectionNormal = vector(MyTurret.GetAimingRotation()); //Normal( CurrentAimingLocation - StartLocation );
		DesiredAimingDirectionNormal = Normal( DesiredAimingLocation - StartLocation );

		Degrees = ACos( CurrentAimingDirectionNormal dot DesiredAimingDirectionNormal ) * RadiansToDegrees;
		MaxDegrees = TurningRateDegreesPerSecond*DeltaTime;
/*
// TODO: Interpolate rotation change
		if( Degrees > MaxDegrees )
		{
			Axis = Normal( CurrentAimingDirectionNormal cross DesiredAimingDirectionNormal );
			CurrentAimingLocation = StartLocation + 1024*Normal( RotateAngleAxis( CurrentAimingDirectionNormal, Axis, MaxDegrees*DegreesToRotationUnits ) );
		}
		else
		{
			CurrentAimingLocation = DesiredAimingLocation;
		}
*/
		CurrentAimingLocation = DesiredAimingLocation;
		MyTurret.SetAimingRotation( CurrentAimingLocation - StartLocation );
	}
}

// TODO
static final function vector RotateAngleAxis( vector p, vector r, INT theta ) // Axis is assumed to be normalized
{
	local vector q;
	local float costheta,sintheta;

	costheta = cos(theta);
	sintheta = sin(theta);

	q.x += (costheta + (1 - costheta) * r.x * r.x) * p.x;
	q.x += ((1 - costheta) * r.x * r.y - r.z * sintheta) * p.y;
	q.x += ((1 - costheta) * r.x * r.z + r.y * sintheta) * p.z;

	q.y += ((1 - costheta) * r.x * r.y + r.z * sintheta) * p.x;
	q.y += (costheta + (1 - costheta) * r.y * r.y) * p.y;
	q.y += ((1 - costheta) * r.y * r.z - r.x * sintheta) * p.z;

	q.z += ((1 - costheta) * r.x * r.z - r.y * sintheta) * p.x;
	q.z += ((1 - costheta) * r.y * r.z + r.x * sintheta) * p.y;
	q.z += (costheta + (1 - costheta) * r.z * r.z) * p.z;

	return q;
}




//-----------------------------------------------------------------------------

function SetDesiredAimingLocation( vector NewDesiredAimingLocation )
{
	DesiredAimingLocation = NewDesiredAimingLocation;
	//AddCylinder( DesiredAimingLocation, 8, 8, ColorPink() );
}

//-----------------------------------------------------------------------------

function rotator GetAimRotation()
{
	return MyTurret.GetAimingRotation();
}

//-----------------------------------------------------------------------------

function rotator GetViewRotation()
{
	return MyTurret.GetAimingRotation();
}

//-----------------------------------------------------------------------------

function bool ValidEnemy( Pawn Enemy )
{
	local vector EnemyVector;

    if( MyTurret==none )
		return false;

	if( !Super.ValidEnemy( Enemy ) || Enemy.Controller == none )
		return false;

	EnemyVector = Normal( Enemy.Location - MyTurret.Location );
	if( EnemyVector dot vector(Rotation) < MyTurret.PeripheralVision )
        return false;

	return true;
}

//-----------------------------------------------------------------------------

state Scanning
{
	event Tick( float DeltaTime )
	{
		Global.Tick( DeltaTime );
		UpdateAiming( DeltaTime );
	}

	//-------------------------------------------------------------------------

	event BeginState()
	{
		Super.BeginState();
		SetDesiredAimingLocation( GetStraightAheadLocation() );
	}

Begin:
    if( !bSettled )
	{
		WaitForLanding();
		bSettled = true;
		CurrentAimingLocation = GetStraightAheadLocation();
	}
}

//-----------------------------------------------------------------------------

state TrackingTarget
{
	ignores SeePlayer;

	event Tick( float DeltaTime )
	{
		if( ValidEnemy( Enemy ) )
		{
            SetDesiredAimingLocation( Enemy.GetAimTarget().Location );
			UpdateAiming( DeltaTime );
		}
		else
			HandleEnemyLost();

		Super.Tick( DeltaTime );
	}

	event BeginState()
	{
		if( MyTurret.TurretMoveSound != None )
			PlaySound( MyTurret.TurretMoveSound, SLOT_None );
	}
}

//-----------------------------------------------------------------------------

state Action
{
	//-------------------------------------------------------------------------

	function StopAction()
	{
		//if( MyTurret != None )
		//	MyTurret.PlayAnim( 'FireEnd' );
		If (Pawn != None && Pawn.Weapon != None)
        Pawn.Weapon.ClientStopFire(0);
        //GoToState('Scanning');
		//	Pawn.Weapon.GotoState( 'Idle' );
	}

	//-------------------------------------------------------------------------

	function PerformAction()
	{
		//MyTurret.PlayAnim('Fire');
		//Pawn.Weapon.Fire(0);

		Focus = Enemy.GetAimTarget();
		Target = Enemy;
		bFire = 1;
		if ( Pawn.Weapon != None )
			Pawn.Weapon.BotFire(false);

        MyTurret.Fire();
		MyTurret.FiredWeapon();
	}

	//-------------------------------------------------------------------------

	event Tick( float DeltaTime )
	{
		if( ValidEnemy( Enemy ) )
		{
            SetDesiredAimingLocation( Enemy.GetAimTarget().Location );
			UpdateAiming( DeltaTime );
		}
		else
			HandleEnemyLost();

		Global.Tick( DeltaTime );
	}
}

//-----------------------------------------------------------------------------

state Deactivated
{
	ignores SeePlayer;

	//-------------------------------------------------------------------------

	event Tick( float DeltaTime )
	{
		Global.Tick( DeltaTime );
		UpdateAiming( DeltaTime );
	}

	//-------------------------------------------------------------------------

	event BeginState()
	{
		local rotator SpecialRotation;

		Super.BeginState();

		SpecialRotation = Rotation;
		SpecialRotation.Pitch = -8000;
		SetDesiredAimingLocation( MyTurret.Location + 1024.0*vector(SpecialRotation) );
	}
}

//-----------------------------------------------------------------------------

defaultproperties
{
     MinHitNonPawnDistance=512.000000
     TurningRateDegreesPerSecond=270.000000
     //PlayerReplicationInfoClass=Class'U2TurretReplicationInfo'
}
