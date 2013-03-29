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
// U2ProjectileRocketDrunken.uc
// Projectile class of a drunken Rocket
// \v -> -> /^ -> \v -> -> -> <- <- ?- ??
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2ProjectileRocketDrunken extends U2Projectile;

var	xEmitter SmokeTrail;
var Effects Corona;

//viewshake
var() sound ExplodeSound;
var bool bExploded;

var int Index;

var() Range xMagRange, yMagRange;	// spiral parameters.
var float xMag, yMag;

var() range PeriodRange;
var float xPeriods, yPeriods;

var float TimePassed;
var vector StartLocation, StartVelocity;

replication
{
	reliable if( bNetInitial && bNetDirty && Role==ROLE_Authority )
		xMag, yMag, xPeriods, yPeriods, TimePassed, StartLocation, StartVelocity, Index;
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	Disable('Tick');
    //if (bPendingDelete || Level.NetMode==NM_DedicatedServer)
	//	return;

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
	local U2WeaponRocketLauncher RL;

	Super.PostNetBeginPlay();

	if (Owner != none)
	{
		RL = U2WeaponRocketLauncher(Pawn(Owner).Weapon);
		if (RL!=none) RL.AltRockets[Index]=Self;
	}
}

simulated function Destroyed()
{
	if ( SmokeTrail != None )
		SmokeTrail.mRegen = False;
	if ( Corona != None )
		Corona.Destroy();
	Super.Destroyed();
}

function TakeDamage( int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType );

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
	TimePassed += DeltaTime;
	SetCorrectLocation( DeltaTime );
}

simulated function SetupData()
{
    xMag = BlendR(xMagRange, FRand());
	if (FRand() > 0.5) xMag = -xMag;

	yMag = BlendR(yMagRange, FRand());
	if (FRand() > 0.5) yMag = -yMag;

	// calc estimated time to target (clamped to a reasonable value).
	xPeriods = BlendR(PeriodRange, FRand());
	yPeriods = BlendR(PeriodRange, FRand());

	StartLocation = Location;
	StartVelocity = normal(vector(Rotation)) * Speed;
}

simulated function SetCorrectLocation( optional float DeltaTime )
{
	local vector NewLocation;

    NewLocation = CalcLocation();
    Move( NewLocation - Location );
}

simulated function vector CalcLocation()
{
	local vector Center;
	local vector Offset;

	Center = StartLocation + (StartVelocity * TimePassed);
	Offset.Y = xMag * sin(TimePassed * PI * xPeriods);
	Offset.Z = yMag * sin(TimePassed * PI * yPeriods);

	return Center + (Offset >> Rotation);	// if we make the rocket spin, we may want to ignore Rotation.Roll here.
}

defaultproperties
{
     Speed=1233.000000
     Damage=38.500000
     MyDamageType=Class'U2Weapons.U2DamTypeRocketDrunken'

     ExplodeSound=Sound'WeaponsA.RocketLauncher.RL_ExplodeMini'
     xMagRange=(Min=32.000000,Max=140.000000)
     yMagRange=(Min=32.000000,Max=140.000000)
     PeriodRange=(Min=0.800000,Max=1.500000)
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
     LifeSpan=12.000000
     SoundVolume=255
     SoundPitch=100
     SoundRadius=30.000000
     TransientSoundRadius=500.000000
}
