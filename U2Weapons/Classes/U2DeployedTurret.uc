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

class U2DeployedTurret extends U2ProximitySensor;


var() class<Weapon> WeaponType;
var() bool bSplashDamage;
var() Sound	TurretMoveSound;
var Weapon MyWeapon;

var() name BonePitch;
var() name BoneYaw;
var() name BoneLeftBarrelEnd;
var() name BoneRightBarrelEnd;
var() name BoneElevatorEnd;
var vector ViewOffset;

var vector AimingVector, ClientAimingVector;
var rotator AimingRotation;

//-----------------------------------------------------------------------------

replication
{
	reliable if( bNetDirty && Role == ROLE_Authority )
		AimingVector;
}

//-----------------------------------------------------------------------------

function Initialize( bool bAltActivate )
{
	Super.Initialize( bAltActivate );

	if( ROLE == ROLE_Authority )
	{
		MyWeapon = Spawn( WeaponType, self );
		if (MyWeapon != none)
        {
           MyWeapon.GiveTo( Self );
		   MyWeapon.BringUp();
		   PendingWeapon = MyWeapon;
		   ChangedWeapon();
        }

		AimingRotation = Rotation;
	}

	SetAnimAction( 'Base' );
}

function bool IsPlayerPawn()
{
    return false;
}

//-----------------------------------------------------------------------------

function RegisterConsumer()
{
}

//-----------------------------------------------------------------------------

function UnRegisterConsumer()
{
}

//-----------------------------------------------------------------------------

function FiredWeapon()
{
	SetAnimAction( 'Fire' );
}

//-----------------------------------------------------------------------------

simulated function SetYaw( rotator NewRotation )
{
	NewRotation.Pitch = 0;
	NewRotation.Roll = 0;
	SetBoneDirection( BoneYaw, NewRotation );
}

//-----------------------------------------------------------------------------

simulated function SetPitch( rotator NewRotation )
{
	NewRotation.Yaw = -NewRotation.Pitch;
	NewRotation.Roll = 0;
	NewRotation.Pitch = 0;
	SetBoneRotation( BonePitch, NewRotation );
}

//-----------------------------------------------------------------------------

simulated function ApplyAimingRotation()
{
	local vector LocalDir, InvertedDir;
	local rotator AimRot;

	LocalDir = AimingVector << Rotation;

	InvertedDir.X = LocalDir.X;
	InvertedDir.Y = -LocalDir.Y;
	InvertedDir.Z = -LocalDir.Z;

	AimRot = rotator(InvertedDir);

	SetYaw( AimRot );
	SetPitch( AimRot );
}

//-----------------------------------------------------------------------------

function SetAimingRotation( vector AimVector )
{
	AimingVector = AimVector;
	AimingRotation = rotator(AimingVector);
	if( Level.NetMode != NM_DedicatedServer )
		ApplyAimingRotation();
}

//-----------------------------------------------------------------------------

simulated event PostNetReceive()
{
	// something was replicated to client ForceWall
	Super.PostNetReceive();

	if( AimingVector != ClientAimingVector )
	{
		ClientAimingVector = AimingVector;
		ApplyAimingRotation();
	}
	SetTeamSkin(Self,TeamIndex);
}

//-----------------------------------------------------------------------------

function rotator GetAimingRotation()
{
	return AimingRotation;
}

//-----------------------------------------------------------------------------

function ShutDownDeployedUnit( bool bDestroyed, optional Pawn P )
{
	if( MyWeapon!=none )
	{
		MyWeapon.Destroy();
		MyWeapon = None;
	}
	Super.ShutDownDeployedUnit( bDestroyed, P );
}

//-----------------------------------------------------------------------------

function TakeDamage( int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType )
{
	if( Health > 0 )
	{
		//DM( "*** " $ Self $ " InVisibilityCone = " $ AutoTurretController(Controller).InVisibilityCone() );
		if( Controller != none && //???
			Controller.Enemy == None &&
			InstigatedBy != None &&
			!InstigatedBy.bDeleteMe &&
			U2TurretController(Controller).InVisibilityCone( InstigatedBy ) )
		{
			Controller.GotoState( 'Action' );
		}
	}

	Super.TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
}

//-----------------------------------------------------------------------------

simulated function vector GetViewLocation()
{
	//return GetBoneCoords( BoneElevatorEnd ).Origin - ViewOffset;
	return GetBoneCoords( BoneElevatorEnd ).Origin;  // hack - adjust for offset
}

//-----------------------------------------------------------------------------

simulated event SetAnimAction( name NewAction )
{
	local name CurAnimName;
	local float CurAnimFrame, CurAnimRate;

	if( Health > 0 )
	{
		AnimAction = NewAction;

		GetAnimParams( 0, CurAnimName, CurAnimFrame, CurAnimRate );

		if( AnimAction != CurAnimName || !IsAnimating( 0 ) )
		{
			PlayAnim( NewAction, , 0.1 );
			AnimBlendToAlpha( 1, 0.0, 0.05 );
		}
	}
}

//-----------------------------------------------------------------------------

state Offline
{
	event BeginState()
	{
		Super.BeginState();
		SetEnabled( false );
	}

	event EndState()
	{
		Super.EndState();
		SetEnabled( true );
	}
}

//-----------------------------------------------------------------------------

defaultproperties
{
     TrackingRangeMultiplier=1.5
     BonePitch="Elevator"
     BoneYaw="Rotator"
     BoneLeftBarrelEnd="LeftEnd"
     BoneRightBarrelEnd="RightEnd"
     BoneElevatorEnd="ElevatorEnd"
     ClientAimingVector=(X=9999999.000000,Y=9999999.000000,Z=9999999.000000)
     Description="Turret"
     DeployableAddPctPer=0.012500
     AlternateSkins(0)=Shader'Arch_TurretsT.Small.metl_DeployableTurret_001_Red'
     AlternateSkins(1)=Shader'Arch_TurretsT.Small.metl_deployableturret_001_blue'
     bHasAttack=True
     SightRadius=4000.000000
     PeripheralVision=0.500000
     BaseEyeHeight=0.0
     Health=500
     //AutoTurretControllerClass=Class'U2TurretController'
     ControllerClass=Class'U2TurretController'
     StaticMesh=StaticMesh'Arch_TurretsM.Small.Deployable_Base_TD_01'
     DrawScale=0.500000
     PrePivot=(Z=0.000000)
     CollisionRadius=30.000000
     CollisionHeight=30.000000
     WeaponType=Class'U2WeaponAutoTurret'
     TransientSoundRadius=700.000000
     TransientSoundVolume=1.5
}
