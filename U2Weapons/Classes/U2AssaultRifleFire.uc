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
// U2AssaultRifleFire.uc
// Fire class of the M32 Duster
// Nail 'em!
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2AssaultRifleFire extends U2InstantFire;

var() Sound FiringSound;

simulated function InitEffects()
{
	Super.InitEffects();

    // don't even spawn on server
    if ( (Level.NetMode == NM_DedicatedServer) || (AIController(Instigator.Controller) != None) )
		return;
    if ( FlashEmitter != None && !FlashEmitter.bDeleteMe )
        FlashEmitter.AttachToBone(Weapon, 'xMuzzleFlash');
}

function ModeDoFire()
{
	super.ModeDoFire();
    GotoState('Firing');
}


state Firing
{
	simulated event BeginState()
	{
		Instigator.AmbientSound = FiringSound;
	}

	simulated event EndState()
	{
		Instigator.AmbientSound = none;
	}

	simulated function ModeTick(float dt)
	{
		if (!bIsFiring || U2Weapon(Weapon).bIsReloading)
		{
		    StopFiring();
		}
	}

	function StopFiring()
	{
	    GotoState('');
	}
}

function PlayFireEnd()
{
	Super.PlayFireEnd();

	Instigator.PlayOwnedSound(sound'WeaponsA.AR_FireEnd',SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,Default.FireAnimRate/FireAnimRate,false);
	Instigator.AmbientSound = none;
}

defaultproperties
{
     DamageType=Class'U2Weapons.U2DamTypeAssaultRifle'
     DamageMin=7
     DamageMax=7
     AmmoClass=Class'U2Weapons.U2AssaultRifleAmmoInv'

     FiringSound=Sound'WeaponsA.AssaultRifle.AR_Fire'
     TraceRange=4800.000000
     Momentum=2000.000000
     FireLastRoundSound=Sound'WeaponsA.AssaultRifle.AR_FireLastRound'
     FireLastReloadTime=2.166666
     FireLastRoundTime=0.625000
     bPawnRapidFireAnim=True
     FireLoopAnim=
     FireForce="AssaultRifleFire"
     FireRate=0.100000
     BotRefireRate=0.990000
     FlashEmitterClass=Class'U2ASMuzFlash1st'
     aimerror=800.000000
     Spread=3.000000
}
