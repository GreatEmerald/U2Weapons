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
// U2ProjectileRocket.uc
// Projectile class of a Rocket
// Four warheads in a single rocket.
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2ProjectileRocket extends U2Projectile;

var	Emitter SmokeTrail;
var Effects Corona;
var() float ExplosionThreshold;
var() sound ExplodeSound;

simulated function Destroyed()
{
	if ( SmokeTrail != None )
		SmokeTrail.Emitters[0].RespawnDeadParticles=false;
	if ( Corona != None )
		Corona.Destroy();
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer)
	{
		SmokeTrail = Spawn(class'U2FX_RocketSmoke',self);
		SmokeTrail.SetBase(self);
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
		if (RL!=none) RL.LastFiredRocket=Self;
	}
}

simulated function XExplode(vector HitLocation, vector HitNormal, actor HitActor)
{
	local Actor Explosion;

	Super.XExplode(HitLocation,HitNormal,HitActor);

	if (Level.NetMode != NM_DedicatedServer)
	{
		Explosion = Spawn( class'U2FX_RLExplosion', self,, HitLocation + HitNormal*20, rotator(HitNormal) );
		Explosion.RemoteRole = ROLE_None;

		PlaySound( ExplodeSound, SLOT_Interact );
//		Spawn( class'GenericExplosionBlower' );

		class'U2Util'.static.MakeShake( Self, HitLocation, ShakeRadius, ShakeMagnitude, ShakeDuration );
	}
}

function TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType )
{
	if (Damage > ExplosionThreshold)
		XExplode( Location, vector(Rotation), None );
}

defaultproperties
{
     Speed=1533.000000
     MaxSpeed=1533.000000
     Damage=110.000000
     DamageRadius=256.000000
     MyDamageType=Class'U2Weapons.U2DamTypeRocket'

     ExplosionThreshold=20.000000
     ExplodeSound=Sound'WeaponsA.RocketLauncher.RL_ExplodeHeavy'
     ShakeRadius=1024.000000
     ShakeMagnitude=40.000000
     ShakeDuration=0.500000
     MomentumTransfer=80000.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'343M.Projectiles.Rocket_Whole'
     AmbientSound=Sound'WeaponsA.RocketLauncher.RL_Rocket'
     LifeSpan=6.000000
     AmbientGlow=96
     SoundVolume=255
     SoundPitch=100
     SoundRadius=30.000000
     TransientSoundRadius=800.000000
     bFixedRotationDir=True
     RotationRate=(Roll=50000)
     DesiredRotation=(Roll=30000)
}
