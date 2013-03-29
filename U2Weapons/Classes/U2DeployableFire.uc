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
// GE: This is what's called when you drop the Deployable.
// 2004 jasonyu
// 25 July 2004
//-----------------------------------------------------------

class U2DeployableFire extends U2WeaponFire;


const DeployDropHeight		= 32.0;
const DeployHorizontalFudge =  8.0;

var class<Actor> DeployClass;
var Sound DeployFailedSound;
var float MinDUSeparation, MinPawnSeparation;
var float MaxDeployDistance;

var float DeploySkillCost;
var bool bTossProjectiles;
var bool bIgnoreOwnerYaw;				// hack to spawn meshes with particle attachments with their default orientation
var bool bCanIntersectDUs;				// allow deployed unit CCs to intersect
var bool bCanIntersectPawns;			// allow deployed unit CCs to intersect
var float EquipResidue;					// resuppling leftover between updates

var() Sound ActivateSound;				//
var() Sound DeActivateSound;			//
var() Sound EffectSound;				//

//-----------------------------------------------------------------------------

simulated function bool Ammo_ReloadRequired( optional int AmountNeeded )
{
	if( AmountNeeded == 0 )
		AmountNeeded = AmmoPerFire;

	return AmountNeeded > U2Weapon(Weapon).ClipRoundsRemaining;
}

event ModeDoFire()
{
	if( !HasNeededSkill( DeploySkillCost ) )
	{
		Instigator.PlayOwnedSound( DeployFailedSound );
		return;
	}
	if (!AllowFire())
		return;

	if (MaxHoldTime > 0.0)
		HoldTime = FMin(HoldTime, MaxHoldTime);

	// server
	if (Weapon.Role == ROLE_Authority)
	{
		//Weapon.ConsumeAmmo(ThisModeNum, Load);
		DoFireEffect();
		HoldTime = 0;	// if bot decides to stop firing, HoldTime must be reset first
		if ( (Instigator == None) || (Instigator.Controller == None) )
			return;

		if ( AIController(Instigator.Controller) != None )
		AIController(Instigator.Controller).WeaponFireAgain(BotRefireRate, true);

		Instigator.DeactivateSpawnProtection();
	}

	// client
	if (Instigator.IsLocallyControlled())
	{
		ShakeView();
		PlayFiring();
		FlashMuzzleFlash();
		StartMuzzleSmoke();
	}
	else // server
	{
		ServerPlayFiring();
	}

	Weapon.IncrementFlashCount(ThisModeNum);

	// set the next firing time. must be careful here so client and server do not get out of sync

	NextFireTime += FireRate;
	NextFireTime = FMax(NextFireTime, Level.TimeSeconds);

	Load = AmmoPerFire;
	HoldTime = 0;

	if (Instigator.PendingWeapon != Weapon && Instigator.PendingWeapon != None)
	{
		bIsFiring = false;
		Weapon.PutDown();
	}
	if ( HasAmmo() )
	{
		NextFireTime = Level.TimeSeconds + FireLastReloadTime;
		bIsFiring = false;
	}
}

function DoFireEffect()
{
	SetTimer(0.5,false);
}

function Timer()
{
	Instigator.MakeNoise( Instigator.SoundDampening );
	if( ActivateUnit(ThisModeNum == 1) )
		Weapon.ConsumeAmmo(ThisModeNum, 1);
}

function PlayFiring()
{
	if( !HasNeededSkill( DeploySkillCost ) ) // never executed..
	{
		HandleDeployFailed( true );
		//GotoState('Idle');
		return;
	}
	if ( Weapon.Mesh != None )
	{
		if( Weapon.AmmoAmount(ThisModeNum) > 1 )
		{
			U2Weapon(Weapon).PlayAnimEx(FireAnim);
			Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,,false);
		}
		else
		{
			U2Weapon(Weapon).PlayAnimEx(AnimFireLastDown);
			Weapon.PlayOwnedSound(FireLastRoundSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,,false);
		}
	}
    ClientPlayForceFeedback(FireForce);  // jdf
}

//-----------------------------------------------------------------------------

simulated function HandleDeployFailed( bool bFlashSkillBar )
{
	local Pawn P;
	local PlayerController PC;

	P = Instigator;
	if( P!=none ) PC = PlayerController(P.Controller);
	if( PC!=none && PC.ViewTarget!=none )
	{
		//mdfxmp 2003.09.01 (should play on anything but dedicated server)
		//if( Level.NetMode == NM_Client || Level.NetMode == NM_ListenServer )
		if( Level.NetMode != NM_DedicatedServer )
		{
			PC.ViewTarget.PlaySound( DeployFailedSound );
			//if( bFlashSkillBar ) class'UIConsole'.static.SendEvent( "FlashSkillBar" );
		}
	}
}

//-----------------------------------------------------------------------------

function bool PreSetAimingParameters( bool bAltFire, bool bInstant, float FireSpread, class<Projectile> ProjClass, bool bWarnTarget, bool bTrySplash )
{
	return true;
}

//-----------------------------------------------------------------------------

function Activate( bool AltActivate ) // global interface (overridden in the 'Inactive' and 'Actived' states)
{
	assert( false ); // never called
}

//-----------------------------------------------------------------------------

function Deactivate() // global interface (overridden in the 'Inactive' and 'Actived' states)
{
	assert( false ); // never called
}

//-----------------------------------------------------------------------------

function AdjustDamage( out float Damage )
{
	Instigator.PlaySound( EffectSound, SLOT_None );
}

//-----------------------------------------------------------------------------

function bool Deploy( vector DeployLocation, rotator DeployRotation, bool bAltActivate )
{
	local Actor A;

	// make sure owner won't be gibbed by item (e.g. if near wall & this causes item to move into player)
	Instigator.SetCollision( false, false, false );
	if( bIgnoreOwnerYaw )
		DeployRotation.Yaw = 0;

	A = Spawn( DeployClass, , , DeployLocation, DeployRotation ); //GE: No owner, because it's set later (KillerController).


	Instigator.SetCollision( Instigator.default.bCollideActors, Instigator.default.bBlockActors, Instigator.default.bBlockPlayers );

	if( A == None )
		return false;

	// if the spawn succeeds, complete the deployment

	// common initialization
	UseSkill( DeploySkillCost );
    A.SetPhysics( PHYS_Falling );
	A.Instigator = Instigator;
    if( Instigator.Controller!=none )
	{
        if ( U2DeployedUnit(A)!=none)
        {
			U2DeployedUnit(A).SetKillerController( Instigator.Controller );
			//U2DeployedUnit(A).PossessedBy(Instigator.Controller);
		}
        else if ( U2MineBase(A) != none)
        {
			U2MineBase(A).SetKillerController( Instigator.Controller );
			//U2MineBase(A).PossessedBy(Instigator.Controller);
		}
	}
	if( bTossProjectiles )
		TossDeployed( A, Instigator );

	// custom initialization
	PostDeploy( A, bAltActivate );

	return true;
}


//-----------------------------------------------------------------------------

function PostDeploy( Actor DeployedActor, bool bAltActivate )
{
	local U2DeployedUnit DU;

	assert( Instigator != None );

	DU = U2DeployedUnit(DeployedActor);
	if( DU!=none )
	{
		DU.SetActive( false );
		DU.SetTeam( Instigator.GetTeamNum());
		DU.Initialize( bAltActivate );
	}
}

//-----------------------------------------------------------------------------

simulated function bool DeployDestinationIsValid( vector DeployLocation, rotator DeployRotation )
{
	local vector EndTrace, Extents, HitLocation, HitNormal;
	local Actor HitActor;

	EndTrace = DeployLocation;
	EndTrace.Z -= Instigator.CollisionHeight + DeployDropHeight + MaxDeployDistance;
	Extents.X = DeployClass.default.CollisionRadius;
	Extents.Y = DeployClass.default.CollisionRadius;
	Extents.Z = DeployClass.default.CollisionHeight;

	HitActor = Trace( HitLocation, HitNormal, EndTrace, DeployLocation, true, Extents );

	return (HitActor != None && HitLocation.Z >= EndTrace.Z && HitActor.bWorldGeometry);
}

//-----------------------------------------------------------------------------

function TossDeployed( Actor A, Pawn Parent )
{
	local vector TossVel;
	if( Parent!=none && Parent.Controller!=none )
	{
		TossVel = Vector(Parent.Controller.GetViewRotation()) + 0.2*VRand();
		TossVel = TossVel * ((Parent.Velocity Dot TossVel) + 500) + Vect(0,0,200);
		A.Velocity = TossVel;
	}
}

//-----------------------------------------------------------------------------

simulated function bool HasNeededSkill( float SkillNeeded )
{
	return true;
}

//-----------------------------------------------------------------------------

function UseSkill( float SkillNeeded );

//-----------------------------------------------------------------------------

static function bool IsValidDefaultInventory( pawn PlayerPawn )
{
	return true;
}

//-----------------------------------------------------------------------------

function bool CanDeploy( vector DeployLocation, rotator DeployRotation )
{
	local Pawn P;
	local float CylinderCylinderDistance;
	//local Vehicle V;							//mdf 12/09/03 (don't allow placing inside vehicle)
	local vector TargetLocation;				//mdf 12/09/03 (don't allow placing inside vehicle)
	local float TargetRadius, TargetHeight;		//mdf 12/09/03 (don't allow placing inside vehicle)
//	local vector X, Y, Z;						//mdf 12/09/03 (don't allow placing inside vehicle)

	if( !HasNeededSkill( DeploySkillCost ) )
		return false;

	if( !bCanIntersectDUs || !bCanIntersectPawns )
	{
		// don't allow placing DU which overlaps with another DU?
		//for( P=Level.PawnList; P!=None; P=P.NextPawn )
		foreach Instigator.CollidingActors(class'Pawn', P, 750, DeployLocation )
		{
			if( P != Self && P.Health > 0 && (!bCanIntersectPawns || U2DeployedUnit(P) != None) )
			{
				//mdf 12/09/03 (don't allow placing inside vehicle)
			/*	V = Vehicle(P);
				if( V != None )
				{
					//mdf 12/09/03 (main vehicle pawn generally off center and tiny)
					GetAxes( V.Rotation, X, Y, Z );
					TargetLocation = V.Location;
					TargetLocation -= X*V.PseudoLocationOffset.Y;
					TargetLocation.Z += V.PseudoLocationOffset.Z;
					TargetRadius = V.PseudoRadius;
					TargetHeight = V.PseudoHeight;
				}
				else
				{
				*/
					TargetLocation = P.Location;
					TargetRadius = P.CollisionRadius;
					TargetHeight = P.CollisionHeight;
				//}

				CylinderCylinderDistance = class'U2Util'.static.GetDistanceBetweenCylinders(
												DeployLocation,
												DeployClass.default.CollisionRadius,
												DeployClass.default.CollisionHeight,
												TargetLocation,		//mdf 12/09/03 (don't allow placing inside vehicle)
												TargetRadius,		//mdf 12/09/03 (don't allow placing inside vehicle)
												TargetHeight );		//mdf 12/09/03 (don't allow placing inside vehicle)

				//AddCylinder( DeployLocation, DeployClass.default.CollisionRadius, DeployClass.default.CollisionHeight, ColorBlue() );
				if( (U2DeployedUnit(P) != None && CylinderCylinderDistance < MinDUSeparation) ||
				    (U2DeployedUnit(P) == None && CylinderCylinderDistance < MinPawnSeparation) )
				{
					return false;
				}
			}
		}
	}

	return DeployDestinationIsValid( DeployLocation, DeployRotation );
}

//-----------------------------------------------------------------------------

function bool CalcDeploySpot( out vector DeployLocation, out rotator DeployRotation )
{
	local vector X, Y, Z;

	DeployRotation.Roll = 0;
	DeployRotation.Pitch = 0;
	DeployRotation.Yaw = Instigator.Rotation.Yaw;

	GetAxes( DeployRotation, X, Y, Z );

	DeployLocation = Instigator.Location + ( DeployHorizontalFudge + Instigator.CollisionRadius + DeployClass.default.CollisionRadius ) * X + DeployDropHeight * Z;

	return true;
}

//-----------------------------------------------------------------------------

function bool ActivateUnit( bool bAltActivate )
{
	local vector DeployLocation;
	local rotator DeployRotation;
	local bool bSuccess;

	if( CalcDeploySpot( DeployLocation, DeployRotation ) &&
		CanDeploy( DeployLocation, DeployRotation ) )
	{
		bSuccess =  Deploy( DeployLocation, DeployRotation, bAltActivate );
	}

	if( !bSuccess )
		HandleDeployFailed( false );

	return bSuccess;
}

//-----------------------------------------------------------------------------

auto state Inactive
{
	function Activate( bool AltActivate )
	{
		Instigator.PlaySound( ActivateSound );
		GotoState('Activated');
	}

	function Deactivate()
	{
	}
}

//-----------------------------------------------------------------------------

state Activated
{
	function Activate( bool AltActivate )
	{
		Deactivate();
	}

	function Deactivate()
	{
		Instigator.PlaySound( DeactivateSound );
		GotoState('Inactive');
	}
}

//-----------------------------------------------------------------------------

defaultproperties
{
     DeployFailedSound=Sound'U2A.Suits.NoEnergy'
     MinDUSeparation=16.000000
     MinPawnSeparation=1.000000
     MaxDeployDistance=60.000000
     DeploySkillCost=0.004000
     FireLastReloadTime=1.680000
     FireLastRoundTime=1.680000
     FireRate=1.680000
     ShakeRotMag=(X=0.000000,Y=0.000000,Z=0.000000)
     ShakeRotRate=(X=0.000000,Y=0.000000,Z=0.000000)
     ShakeRotTime=0.000000
     ShakeOffsetMag=(X=0.000000,Y=0.000000,Z=0.000000)
     ShakeOffsetRate=(X=0.000000,Y=0.000000,Z=0.000000)
     ShakeOffsetTime=0.000000
}
