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
// U2ProjectileRocketSeeking.uc
// Projectile class of a seeking Rocket
// -> o | -? o | -! o | --> o | -->o | -o-> | o--> | o  >- | o   -? | o   (*)
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2ProjectileRocketSeeking extends U2Projectile;

var	xEmitter SmokeTrail;
var Effects Corona;

//viewshake
var() sound ExplodeSound;
var bool bExploded;

var int Index;

var Actor PaintedTarget;
var() float TurnRate;
var() float TurnRateRampUp;

var() float MidPointOffset;

var vector MidPoint;
var float MidPointTimer;

var float RocketContinueNotifyTimer;

replication
{
	reliable if( bNetInitial && bNetDirty && Role==ROLE_Authority )
		PaintedTarget, TurnRateRampUp, MidPoint, MidPointTimer, Index;
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	if (bPendingDelete || Level.NetMode==NM_DedicatedServer)
		return;

//	PlayAnim( 'Wing', 0.2 );	//ARL
}

simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer)
	{
		SmokeTrail = Spawn(class'RocketTrailSmoke',self);
		Corona = Spawn(class'RocketCorona',self);
	}

	Super.PostBeginPlay();
}

simulated function PostNetBeginPlay()
{
	local U2WeaponRocketLauncher RL1;

	Super.PostNetBeginPlay();

	if (Owner != none)
	{
		RL1 = U2WeaponRocketLauncher(Pawn(Owner).Weapon);
		if (RL1!=none) RL1.AltRockets[Index]=Self;
	}
}


simulated event Destroyed()
{
//	local Pawn P;
//	local PlayerController PC;
	Super.Destroyed();

	if ( SmokeTrail != None )
		SmokeTrail.mRegen = False;
	if ( Corona != None )
		Corona.Destroy();

	// Clear our targetting indicator - if another set is still targetting it'll get turned back on by them.
//TODO
/*
	P = Pawn(PaintedTarget);
	if (P!=none && P.IsLocallyControlled())
	{
		PC = PlayerController(P.Controller);
		if (PC!=none)
		{
			switch (Index)
			{
			case 0: PC.SendEvent("RocketNotifyHideA"); break;
			case 1: PC.SendEvent("RocketNotifyHideB"); break;
			case 2: PC.SendEvent("RocketNotifyHideC"); break;
			case 3: PC.SendEvent("RocketNotifyHideD"); break;
			};
		}
	}
	*/
}

function TakeDamage( int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType ){}

simulated function XExplode(vector HitLocation, vector HitNormal, actor HitActor)
{
	local Actor Explosion;

	Super.XExplode(HitLocation,HitNormal,HitActor);

	if (Level.NetMode != NM_DedicatedServer)
	{
		Explosion = Spawn( class'U2FX_RLExplosionAlt', self,, Location, rotator(HitNormal) );
		Explosion.RemoteRole = ROLE_None;

		PlaySound( ExplodeSound, SLOT_Interact );

		class'U2Util'.static.MakeShake( Self, HitLocation, ShakeRadius, ShakeMagnitude, ShakeDuration );
	}
}

simulated event Tick( float DeltaTime )
{
//	local Pawn P;
//	local PlayerController PC;
	local vector Dir,Desired,Delta,TargetLoc;
	if (PaintedTarget==none || PaintedTarget.bPendingDelete)
	{
		XExplode(Location,vector(Rotation),None);
		return;
	}
	TurnRateRampUp -= DeltaTime;
	TurnRate = (1.0-(TurnRateRampUp/default.TurnRateRampUp)) * default.TurnRate;
	Dir = vector(Rotation);
	MidPointTimer -= DeltaTime;
	if (MidPointTimer>0)	TargetLoc=MidPoint;
	else					TargetLoc=PaintedTarget.Location;
	Desired = normal(TargetLoc - Location);
	Delta = Desired - Dir;
	Dir += Delta * (TurnRate * DeltaTime);
	SetRotation( rotator(Dir) );
	Velocity = Dir * Speed;

	//TODO
	// Keep the triangle notifies up while we continue seeking.
	/*
	P = Pawn(PaintedTarget);
	if( P? && P.IsLocallyControlled() )
	{
		RocketContinueNotifyTimer -= DeltaTime;
		if( RocketContinueNotifyTimer <= 0.0 )
		{
			RocketContinueNotifyTimer = 1.0;
			PC = PlayerController(P.Controller);
			if (PC?) switch (Index)
			{
			case 0: PC.SendEvent("RocketNotifyFlashA"); break;
			case 1: PC.SendEvent("RocketNotifyFlashB"); break;
			case 2: PC.SendEvent("RocketNotifyFlashC"); break;
			case 3: PC.SendEvent("RocketNotifyFlashD"); break;
			};
		}
	}
	*/
}

function SetTarget( Actor A )
{
	local vector Offset,Diff;
	PaintedTarget = A;
	Diff = A.Location - Location;
	MidPoint = Location + (Diff * RandRange(0.3,0.6));
	Offset.Y = RandRange(-MidPointOffset,MidPointOffset);
	Offset.Z = RandRange(0,MidPointOffset);
	MidPoint += Offset >> rotator(Diff);
	MidPointTimer = VSize(MidPoint - Location) / Speed;
}

defaultproperties
{
     Speed=1233.000000
     Damage=38.500000
     MyDamageType=Class'U2Weapons.U2DamTypeRocketSeeking'
     //DrawScale=0.600000

     ExplodeSound=Sound'WeaponsA.RocketLauncher.RL_ExplodeMini'
     TurnRate=0.570000
     TurnRateRampUp=0.600000
     MidPointOffset=512.000000
     ShakeRadius=512.000000
     ShakeMagnitude=20.000000
     ShakeDuration=0.300000
     MaxSpeed=1233.000000
     DamageRadius=80.000000
     MomentumTransfer=25000.000000
     SpawnSound=Sound'WeaponsA.RocketLauncher.RL_ExplodeMini'
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=28
     LightBrightness=255.000000
     LightRadius=6.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'343M.Projectiles.Rocket_Small'
     LifeSpan=18.000000
     SoundVolume=255
     SoundPitch=100
     SoundRadius=30.000000
     TransientSoundRadius=500.000000

}
