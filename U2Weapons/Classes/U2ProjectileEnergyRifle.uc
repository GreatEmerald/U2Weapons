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
// U2ProjectileEnergyRifle.uc
// Bouncing Projectile class of the Shock Lance
// Look, an Izarian! Oops, it's just Malcolm.
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2ProjectileEnergyRifle extends U2Projectile;

var Emitter Effect;
var float ActivationTime;
var bool bExploded;
var int bounces;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if (bPendingDelete || Level.NetMode==NM_DedicatedServer)
		return;

	Effect = spawn(class'U2FX_ShockPrimProjFX');
	Effect.SetBase( Self );
}

simulated function HitWall(vector HitNormal, actor Wall)
{
	local float theta;

	if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
		Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));

	theta = -HitNormal dot Normal(Velocity);
	if ( theta > 0.93 || !Wall.bWorldGeometry )
	{
		bBounce = false;
	}

	Super.HitWall( HitNormal, Wall );

	bounces++;
	if ( bounces >= 3 )
		bBounce = false;
}

simulated function XExplode(vector HitLocation, vector HitNormal, actor HitActor)
{
	local Actor Explosion;

	bExploded = true;

	Super.XExplode(HitLocation,HitNormal,HitActor);

	if (Level.NetMode != NM_DedicatedServer)
	{
		Explosion = Spawn( class'U2FX_EMPPrimExplosion', self,, Location, rotator(HitNormal) );
		Explosion.RemoteRole = ROLE_None;

		//class'XMPUtil'.static.MakeShake( Self, HitLocation, ShakeRadius, ShakeMagnitude, ShakeDuration );
	}
}

simulated event Destroyed()
{
	if( Effect!=None )
	{
		Effect.Destroy();
	}

	if( !bExploded )
		XExplode( Location, -normal(Velocity), None );

	Super.Destroyed();
}

defaultproperties
{
     ActivationTime=0.900000
     BounceDamping=1.000000
     StopNormalZ=0.100000
     bNoFalloff=True
     ShakeDuration=1.000000
     DamageRadius=32.000000
     ExplosionDecal=Class'XEffects.ShockImpactScorch'
     DrawType=DT_None
     SoundVolume=255
     SoundRadius=100.000000
     bBounce=True
     ShakeRadius=128.000000
     ShakeMagnitude=10.000000
     Speed=1200.000000
     MaxSpeed=1200.000000
     Damage=1.1
     MomentumTransfer=40000.000000
     MyDamageType=Class'U2Weapons.U2DamTypeShockLance'
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=134
     LightSaturation=50
     LightBrightness=200.000000
     LightRadius=4.000000
     LifeSpan=7.500000
     DrawScale=0.600000
}
