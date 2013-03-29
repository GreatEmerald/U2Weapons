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
// U2ProjectileAltShotgun.uc
// Projectile class of a fire pellet
// Incendiary!
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2ProjectileAltShotgun extends U2Projectile;

var bool bExploded;

var Emitter Trail;

// explosion effects
var   class<Actor> ExplosionEffect;
var() sound ExplosionSound;

simulated function PostBeginPlay()
{
    if ( Level.NetMode != NM_DedicatedServer )
    {
        if ( !PhysicsVolume.bWaterVolume )
        {
            Trail = Spawn(class'U2FX_ShotgunAltTrailFX',self);
		Trail.setbase(self);
            //Trail.Lifespan = Lifespan;
        }
    }

	LifeSpan = 0.35 + FRand() * (0.2);

    Super.PostBeginPlay();
}

simulated function XExplode(vector HitLocation, vector HitNormal, actor HitActor)
{
    local U2FlameDamager FD;

	bExploded = true;

	Super.XExplode(HitLocation,HitNormal,HitActor);
	FD = Spawn(class'U2FlameDamager');
    if (FD != None && HitActor != none && HitActor.IsA('Pawn') )
        FD.BeginDamaging(Pawn(HitActor), MyDamageType, HitLocation, , 2.0, 17.5);


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
	}
}

simulated event Destroyed()
{
    if ( Trail != None )
        Trail.Destroy();

	if( !bExploded && !bHidden)
		XExplode( Location, -normal(Velocity), none );

	Super.Destroyed();
}

defaultproperties
{
     Damage=12.100000
     MyDamageType=Class'U2Weapons.U2DamTypeAltShotgun'
     DrawScale=0.600000

     ExplosionEffect=Class'U2FX_ShotgunProjAltExplosion'
     ExplosionSound=Sound'U2AmbientA.Explosions.Xplode_18'
     bHydrophobic=True
     HitWaterClass=Class'UTClassic.ClassicSniperSmoke'
     Speed=3000.000000
     MaxSpeed=4000.000000
     DamageRadius=140.000000
     MomentumTransfer=4000.000000
     LifeSpan=0.550000
}
