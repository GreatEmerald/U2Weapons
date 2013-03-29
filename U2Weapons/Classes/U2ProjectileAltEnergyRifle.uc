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
// U2ProjectileAltEnergyRifle.uc
// EMP Projectile class of the Shock Lance
// Numbers, numbers...
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2ProjectileAltEnergyRifle extends U2Projectile;

var Emitter Effect;
var float ActivationTime;
var bool bExploded;
var bool bCanCombo;

//viewshake
//var() float ShakeRadius, ShakeMagnitude, ShakeDuration;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if (bPendingDelete || Level.NetMode==NM_DedicatedServer)
		return;

	Effect = spawn(class'U2FX_ShockAltProjEffect');
//	Effect = spawn(class'XMP_Rapt_ShockAltProjFX');
	//Effect.Trigger(Self,Instigator);
	Effect.SetBase( Self );

	if( Role == ROLE_Authority )
		SetTimer(ActivationTime,false);
	Disable('Tick');
}

simulated function XExplode(vector HitLocation, vector HitNormal, actor HitActor)
{
	local Actor Explosion;

	bExploded = true;

	Super.XExplode(HitLocation,HitNormal,HitActor);

	if (Level.NetMode != NM_DedicatedServer)
	{
		Explosion = Spawn( class'U2FX_EMPExplosion', self,, Location, rotator(HitNormal) );
		Explosion.RemoteRole = ROLE_None;
	}
}

simulated event Destroyed()
{

	if( Effect != None )
		Effect.Destroy(); // fugly, should probably do this another way

	if( !bExploded )
		XExplode( Location, -normal(Velocity), None );

	Super.Destroyed();
}

simulated event Timer()
{
	Enable('Tick');
}

event Tick( float DeltaTime )
{
	local pawn Victims;
	if(default.LifeSpan-LifeSpan<ActivationTime) return;	// ignore first call when we are spawned.
	foreach VisibleCollidingActors( class'Pawn', Victims, DamageRadius * 0.5, Location )
		if( (Victims != self) && (Victims.Role == ROLE_Authority) )
			Destroy();
}

defaultproperties
{
     ActivationTime=0.900000
     bNoFalloff=True
     ShakeRadius=1024.000000
     ShakeMagnitude=30.000000
     ShakeDuration=1.000000
     MomentumTransfer=5000.000000
     DrawType=DT_None
     SoundVolume=218
     SoundRadius=80.000000
     TransientSoundRadius=500.000000
     Speed=800.000000
     MaxSpeed=800.000000
     Damage=19.8
     DamageRadius=120.000000
     MyDamageType=Class'U2Weapons.U2DamTypeEMP'
     LifeSpan=7.000000
     DrawScale=0.600000
}
