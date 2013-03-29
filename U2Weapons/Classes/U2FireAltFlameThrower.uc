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
// U2FireAltFlameThrower.uc
// Alternative Fire class of the Vulcan
// OK, I'm done, I'll use a mix of old and new naming styles from now on.
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2FireAltFlameThrower extends U2ProjectileFire;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	FireEffect = spawn(class'U2FX_FlameAltEffect');
}

simulated function DestroyEffects()
{
	super.DestroyEffects();

    if ( FireEffect != None )
        FireEffect.Destroy();
}

function ModeDoFire()
{
	super.ModeDoFire();
    GotoState('Firing');
}

state Firing
{
	function ModeDoFire() { super.ModeDoFire(); }

	simulated event BeginState()
	{
		Instigator.AmbientSound = Sound'WeaponsA.Flamethrower.FT_AltFire';
	}

	simulated event EndState()
	{
		Instigator.AmbientSound = none;
	}

	simulated function ModeTick(float dt)
	{
		local U2AttachmentFlamethrower A;
		local vector EffectLocation;
		local rotator EffectRotation;
		local vector Dir,End,Start;
		local actor HitActor;
		local vector HitLocation,HitNormal;


		if (!bIsFiring || U2Weapon(Weapon).bIsReloading)
		{
		    StopFiring();
		}
		Weapon.SetLocation( Instigator.Location + Instigator.CalcDrawOffset(Weapon) );
		Weapon.SetRotation( Instigator.GetViewRotation() );

		EffectLocation = Weapon.GetBoneCoords('xMuzzleFlash').Origin;
		EffectRotation = Weapon.GetBoneRotation('xMuzzleFlash');

		Dir = vector(EffectRotation);
		End = EffectLocation;
		Start = End - (Dir * 64.0);
		HitActor = Trace(HitLocation,HitNormal,End,Start,true);
		if( HitActor != none )
			EffectLocation = HitLocation - Dir; //(Dir * 6.0);

		A = U2AttachmentFlamethrower(Weapon.ThirdPersonActor);
		if (A != none)
		{
			A.EffectLocation = EffectLocation;
			A.EffectRotation = EffectRotation;
		}

		if ( FireEffect != none )
		{
			FireEffect.SetLocation( EffectLocation );
			FireEffect.SetRotation( EffectRotation );
		}
	}

	function StopFiring()
	{
	    GotoState('');
	}
}

function PlayFiring()
{
	super.PlayFiring();

	if ( Weapon.Mesh != None )
	{
		if( !bLastRound )
		{
			if ( FireEffect == none )
				FireEffect = spawn(class'U2FX_FlameAltEffect'); //spawn(FireEffectClass);
			FireEffect.Trigger(Weapon,Instigator);
			U2WeaponFlameThrower(Weapon).PilotsOff();
		}
	}
}

function PlayFireEnd()
{
	Super.PlayFireEnd();

	Instigator.AmbientSound = none;
}

defaultproperties
{
     FireRate=0.100000
     AmmoClass=Class'U2Weapons.U2AmmoFlameThrower'
     ProjectileClass=Class'U2Weapons.U2ProjectileAltFlameThrower'

     ProjSpawnOffset=(Y=3.000000)
     FireLastReloadTime=2.533000
     FireLastReloadAnimRate=0.967869
     FireLastRoundTime=0.660000
     FireLastDownAnimRate=1.333333
     bPawnRapidFireAnim=True
     FireEndAnim="FireEnd"
     ShakeRotMag=(X=0.000000,Y=0.000000,Z=0.000000)
     ShakeRotRate=(X=0.000000,Y=0.000000,Z=0.000000)
     ShakeRotTime=0.000000
     ShakeOffsetMag=(X=0.000000,Y=0.000000,Z=0.000000)
     ShakeOffsetRate=(X=0.000000,Y=0.000000,Z=0.000000)
     ShakeOffsetTime=0.000000
}
