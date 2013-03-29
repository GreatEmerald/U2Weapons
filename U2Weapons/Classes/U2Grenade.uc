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
// XMPGrenade.uc
// 2004 jasonyu
// 30 May 2004
//-----------------------------------------------------------

class U2Grenade extends U2Projectile;

var bool bExploded;

var xEmitter Trail;

// explosion effects
var   class<Actor> ExplosionEffect;
var() sound ExplosionSound;


//var bool bParticlesDoDamage;
var bool  bDurational; // If true, spawn AvoidMarker
var AvoidMarker MyMarker;

simulated function PreBeginPlay()
{
	local PlayerController PC;

	Super.PreBeginPlay();

	if (bPendingDelete || Level.NetMode==NM_DedicatedServer)
		return;

	// rocket trail
    if ( Level.NetMode != NM_DedicatedServer)
    {
		PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 5500 )
			Trail = Spawn(class'GrenadeSmokeTrail', self,, Location, Rotation);
    }
}

simulated function PostNetBeginPlay()
{
	Super.PostNetBeginPlay();
	bBounce = bDelayedExplosion;
}

simulated function XExplode(vector HitLocation, vector HitNormal, actor HitActor)
{
//	local ParticleGenerator Explosion;
	bExploded = true;

	Super.XExplode(HitLocation,HitNormal,HitActor);

	if (Level.NetMode != NM_DedicatedServer )
	{
	    if ( ExplosionEffect != None && EffectIsRelevant(Location,false) )
	    {
	        Spawn(ExplosionEffect,,, HitLocation, rotator(vect(0,0,1)));
			Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
	    }
	}

	if (Level.NetMode != NM_DedicatedServer)
	{
		if( ExplosionSound != None )
			PlaySound( ExplosionSound, SLOT_Interact );
		class'U2Util'.static.MakeShake( Self, HitLocation, ShakeRadius, ShakeMagnitude, ShakeDuration );
	}

	if(Role == ROLE_Authority)
    {
        if(MyMarker == None)
        {
            MyMarker = Spawn(Class'AvoidMarker', self,,Location, Rotation);
            MyMarker.SetCollisionSize(DamageRadius + 64, MyMarker.CollisionHeight);
        }
    }
}

simulated event Destroyed()
{
    if ( Trail != None )
        Trail.mRegen = false; // stop the emitter from regenerating

	if( !bExploded )
		XExplode( Location, -normal(Velocity), none );

	if(Role == ROLE_Authority)
    {
        if(MyMarker != None)
        {
            MyMarker.Destroy();
            MyMarker = none;
        }
    }


	Super.Destroyed();
}

defaultproperties
{
     BounceSound=Sound'WeaponsA.GrenadeLauncher.GL_Bounce'
     ShakeRadius=1024.000000
     ShakeMagnitude=60.000000
     ShakeDuration=0.500000
     bDelayedExplosion=True
     Speed=2600.000000
     MaxSpeed=2600.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'343M.Projectiles.Grenade'
     Physics=PHYS_Falling
     AmbientSound=Sound'WeaponsA.GrenadeLauncher.GL_Grenade'
     LifeSpan=3.000000
     DrawScale=2.000000
     AmbientGlow=96
     SoundVolume=255
     SoundPitch=100
     SoundRadius=255.000000
     TransientSoundRadius=800.000000
     bBounce=True
     bFixedRotationDir=True
     RotationRate=(Roll=65536)
}
