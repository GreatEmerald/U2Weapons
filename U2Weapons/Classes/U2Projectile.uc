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
// U2Projectile.uc
// 2004 jasonyu
// 25 May 2004
//-----------------------------------------------------------

class U2Projectile extends Projectile;


// Motion information.
var		float	BounceDamping;
var		float	StopNormalZ;

var		sound	BounceSound;		// Sound made when projectile bounces.
var		float	BounceSoundRadius;	// Radius used when playing BounceSound.

var		bool	bNoFalloff;			// Falloff parm for HurtRadius.

//viewshake
var() float ShakeRadius, ShakeMagnitude, ShakeDuration;

var bool bDelayedExplosion;
var bool bHydrophobic;

var() class<Actor> HitWaterClass;	// Actor spawned when projectile hits water, usually an emitter
var() vector HitWaterEffectOffset;

replication
{
	unreliable if( (!bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement
			&& (((RemoteRole == ROLE_SimulatedProxy) && bNetInitial)
				|| (RemoteRole == ROLE_DumbProxy)) )
		bDelayedExplosion;
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	Velocity = vector(Rotation) * Speed;
}

//==============
// Encroachment
function bool EncroachingOn( actor Other )
{
	// Account for blocking volumes.
	if ( Volume(Other) != None )
		return false;

	if ( (Other.Brush != None) || (Brush(Other) != None) )
		return true;

	return false;
}

//==============
// Touching
simulated singular function Touch(Actor Other)

{
	local actor HitActor;
	local vector HitLocation, HitNormal, VelDir;
	local bool bBeyondOther;
	local float BackDist, DirZ;

	if ( Other == None ) // Other just got destroyed in its touch?
		return;
	if ( Other.bProjTarget || (Other.bBlockActors && Other.bBlockPlayers) )
	{
		if ( Velocity == vect(0,0,0) || Other.IsA('Mover') )
		{
			ProcessTouch(Other,Location);
			return;
		}

		//get exact hitlocation - trace back along velocity vector
		bBeyondOther = ( (Velocity Dot (Location - Other.Location)) > 0 );
		VelDir = Normal(Velocity);
		if( VelDir.Z >= 0 )
			DirZ = sqrt(VelDir.Z);
		else
			DirZ = -sqrt(-VelDir.Z);
		BackDist = Other.CollisionRadius * (1 - DirZ) + Other.CollisionHeight * DirZ;
		if ( bBeyondOther )
			BackDist += VSize(Location - Other.Location);
		else
			BackDist -= VSize(Location - Other.Location);

	 	HitActor = Trace(HitLocation, HitNormal, Location, Location - 1.1 * BackDist * VelDir, true);
		if (HitActor == Other)
			ProcessTouch(Other, HitLocation);
		else if ( bBeyondOther )
			ProcessTouch(Other, Other.Location - Other.CollisionRadius * VelDir);
		else
			ProcessTouch(Other, Location);
	}
}

simulated event PhysicsVolumeChange(PhysicsVolume NewVolume)
{
	Super.PhysicsVolumeChange(NewVolume);
	if (NewVolume.bWaterVolume)
		HitWater();
}

simulated event HitWater()
{
	local vector HitWaterEffectLocation;
	if (bHidden)
		return;

	if (Level.NetMode != NM_DedicatedServer)
	{
		if (HitWaterClass != None)
		{
			HitWaterEffectLocation = Location + (HitWaterEffectOffset >> Rotation);
			if (EffectIsRelevant(HitWaterEffectLocation, false))
			{
				Spawn(HitWaterClass, self,, HitWaterEffectLocation, Rotation);
			}
		}
	}

	if (bHydrophobic)
	{
		bHidden = true;
		Destroy();
	}
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
//	if ( Other != Instigator )
//		Explode(HitLocation,Normal(HitLocation-Other.Location),Other);

	// Generate a better hitnormal
	local vector HitNormal;
	if ( Other != Instigator )
	{
//		HitNormal = Normal( HitLocation - Other.Location );
		HitNormal = -Velocity;
		if( VSize(HitLocation - Other.Location)<(Other.CollisionRadius-1) )	// if we hit the top/bottom
		{
			HitNormal.X = 0;
			HitNormal.Y = 0;
		}
		else																	// otherwise we hit the side
		{
			HitNormal.Z = 0;
		}
		HitNormal = Normal( HitNormal );

		if( bBounce && Pawn(Other)==None )
		{
			HitWall( HitNormal, Other );
		}
		else
		{
			XExplode( HitLocation, HitNormal, Other );
		}
	}
}

simulated function Landed (vector HitNormal)
{
	if( !bBounce )
		HitWall(HitNormal, None);
}

simulated function HitWall (vector HitNormal, actor Wall)
{
	local float BounceSpeed;

    //log(self$": HitWall!");
	if( bBounce )
	{
		BounceSpeed = VSize(Velocity);
		PlaySound( BounceSound, SLOT_Misc, FMin( 800.0, 800.0 * BounceSpeed/256.0), false, BounceSoundRadius );

		Velocity = BounceDamping * ( ( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity );   // Reflect off Wall w/damping
		RandSpin( 100000 );

		if( BounceSpeed < 16 && HitNormal.Z > StopNormalZ )
		{
			SetPhysics( PHYS_None );
			Velocity = Vect(0,0,0);
			//why are we passing to Landed, if Landed is explicitly designed to do nothing?
			Landed( HitNormal );
		}
	}
	else
	{
		if ( Role == ROLE_Authority )
		{
			//NEW (mdf) allow for dynamic blocking volumes which want to handle damage
			if ( Mover(Wall) != None || BlockingVolume(Wall) != None )  // why? -- jy
			/*OLD
			if ( Mover(Wall) != None )
			*/
				Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
			MakeNoise(1.0);
		}
		XExplode(Location + ExploWallOut * HitNormal, HitNormal, Wall);
		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
			Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
	}
}

simulated function XExplode(vector HitLocation, vector HitNormal, actor HitActor)
{
	if( Role == ROLE_Authority )
	{
		MakeNoise( 1.0 );

		if( Damage > 0 && DamageRadius > 0 )
		{
			XHurtRadius( Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation, bNoFalloff );
		}
		else if ( HitActor != None  && !(bHydrophobic && PhysicsVolume.bWaterVolume) ) //&& !( (bHydrophobic && (HitActor.PhysicsVolume.bWaterVolume && (Pawn(HitActor) != none && Pawn(HitActor).HeadVolume.bWaterVolume))) || (bHydrophobic && HitActor.PhysicsVolume.bWaterVolume)))
		{
			HitActor.TakeDamage( Damage, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType );
		}
	}

	if (!DestroyOverride())
        Destroy();
}

//GE: Stub for overriding the Destroy() on XExplode. Because it's easier than rewriting everything. And maybe even handy.
simulated function bool DestroyOverride()
{
    return false;
}

simulated function actor ConglomerateID( actor A )
{
	if ( A.IsA('U2TurretBase') && A.Owner != none )
		return A.Owner;
	if ( A.IsA('ONSWeaponPawn') )
		return ONSWeaponPawn(A).VehicleBase;
	if ( A.IsA('Vehicle') )
		return A;
	return none;
}

simulated final function XHurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation, optional bool bNoFalloff )
{
	local actor Victims;
	local actor ConglomerateIDs[10];
	local int	i;
	local bool	bAlreadyDamaged;
	local float damageScale, dist;
	local vector dir;
	local actor HitActor;
	local vector NewHitLocation;
	local vector HitNormal;

	if( bHydrophobic && PhysicsVolume.bWaterVolume )
		return;

	if( bHurtEntry )
		return;

	if( DamageRadius <= 0 || DamageAmount <= 0.0  )
		return;

	bHurtEntry = true;

	HitActor = Trace(NewHitLocation,HitNormal,HitLocation + (DamageRadius*normal(velocity)),HitLocation,true);
	if ( HitActor != none && ConglomerateID(HitActor) != none && HitActor != none ) //We've hit either a vehicle or a stationary turret
	{
		ConglomerateIDs[0] = ConglomerateID(HitActor);
		ConglomerateIDs[0].TakeDamage
			(
				DamageAmount,
				Instigator,
				NewHitLocation,
				(Momentum * normal(velocity)),
				DamageType
			);
	}

	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if( (Victims != self) && (Victims.Role == ROLE_Authority) && (!Victims.IsA('FluidSurfaceInfo')) )
		{
			if( ConglomerateID(Victims) != none )
			{
				bAlreadyDamaged = false;
				for (i=0; ConglomerateIDs[i]!=none; i++)
				{
					if (ConglomerateID(Victims) == ConglomerateIDs[i])
						bAlreadyDamaged = true;
				}
				if (!bAlreadyDamaged)
				{
					ConglomerateIDs[i] = ConglomerateID(Victims);
					Victims = ConglomerateID(Victims);
				}
			}

            //GE: Use this for determining who is taking damage.
            XTakingDamage(Pawn(Victims), HitLocation);
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
			if (bNoFalloff) damageScale = 1.0;
			if( bAlreadyDamaged )
				damageScale = 0.0;
			if (damageScale > 0.0)
			Victims.TakeDamage
			(
				damageScale * DamageAmount,
				Instigator,
				Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				(damageScale * Momentum * dir),
				DamageType
			);
			if (Instigator != None && Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
				Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, Instigator.Controller, DamageType, Momentum, HitLocation);
		}
	}
	bHurtEntry = false;
}

//GE: Stub for subclasses.
simulated function XTakingDamage(Pawn Victim, vector HitLocation);

// util
static final function float Blend( float A, float B, float Pct )
{
	return Lerp(Pct,A,B);
}

static final function float Ablend( float A, float B, float Result )
{
	return (Result-A)/(B-A);
}

static final function float BlendR( Range R, float Pct )
{
	return Blend( R.Min, R.Max, Pct );
}

static final function float AblendR( Range R, float Result )
{
	return ABlend( R.Min, R.Max, Result );
}

defaultproperties
{
     BounceDamping=0.400000
     StopNormalZ=0.500000
     BounceSoundRadius=100.000000
     HitWaterClass=Class'XGame.WaterSplash'
}
