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
// U2FireFlameThrower.uc
// Fire class of the Vulcan
// When it says "fire", it does mean FIRE!
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2FireFlameThrower extends U2InstantFire;

#EXEC OBJ LOAD FILE=..\Sounds\WeaponsA.uax

var U2FX_PilotLight PilotA, PilotB;

simulated function DestroyEffects()
{
	//super.DestroyEffects();

	if ( U2FX_FlameEffect(FireEffect) != None )
	{
		U2FX_FlameEffect(FireEffect).Deactivate();
		FireEffect = None;
	}
}

function ModeDoFire()
{
	super.ModeDoFire();
    GotoState('Firing');
}

function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X1, End1, HitLocation1, HitNormal1;
    local Actor hitActor1;

    X1 = Vector(Dir);
    End1 = Start + TraceRange * X1;

	HitActor1 = Weapon.Trace(HitLocation1, HitNormal1, End1, Start, true);
   	if (DamageMin != DamageMax)
       Weapon.HurtRadius(Lerp(FRand(), DamageMin, DamageMax), 256, DamageType, 0, HitLocation1);
    else
        Weapon.HurtRadius(DamageMin, 256, DamageType, 0, HitLocation1);

	if ( Instigator.PhysicsVolume.Gravity.Z > -1500 )
		Instigator.AddVelocity( X1 * -16.0 );
}

state Firing
{
	function ModeDoFire()
    {
        super.ModeDoFire();
    }

	simulated event BeginState()
	{
		Instigator.AmbientSound = Sound'WeaponsA.Flamethrower.FT_FireLoop';
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
		if ( U2FX_FlameEffect(FireEffect) != none )
		{
			U2FX_FlameEffect(FireEffect).Deactivate();
			FireEffect = None;
		}
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
				FireEffect = spawn(class'U2FX_FlameEffect');

			FireEffect.Trigger(Weapon,Instigator);
			//TriggerLights();
		}
	}
}

function PlayFireEnd()
{
	Super.PlayFireEnd();

	Weapon.PlayOwnedSound(sound'WeaponsA.FT_FireEnd',SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,Default.FireAnimRate/FireAnimRate,false);
	Instigator.AmbientSound = none;

	if ( U2FX_FlameEffect(FireEffect) != none )
	{
		U2FX_FlameEffect(FireEffect).Deactivate();
		FireEffect = None;
	}
}

defaultproperties
{
     DamageType=Class'U2Weapons.U2DamTypeThermalFlaming'
     DamageMin=8
     DamageMax=9
     FireLastReloadTime=2.533000
     FireLastReloadAnimRate=0.967869
     FireLastDownAnimRate=1.333333
     AmmoClass=Class'U2Weapons.U2AmmoFlameThrower'

     TraceRange=1024.000000
     Momentum=0.000000
     FireLastRoundSound=Sound'WeaponsA.Flamethrower.FT_FireLastRound'
     FireLastRoundTime=0.660000
     FireEffectClass=Class'U2FX_FlameEffect'
     bPawnRapidFireAnim=True
     FireRate=0.100000
     ShakeRotMag=(X=0.000000,Y=0.000000,Z=0.000000)
     ShakeRotRate=(X=0.000000,Y=0.000000,Z=0.000000)
     ShakeRotTime=0.000000
     ShakeOffsetMag=(X=0.000000,Y=0.000000,Z=0.000000)
     ShakeOffsetRate=(X=0.000000,Y=0.000000,Z=0.000000)
     ShakeOffsetTime=0.000000
     BotRefireRate=0.990000
     Spread=6.000000
}
