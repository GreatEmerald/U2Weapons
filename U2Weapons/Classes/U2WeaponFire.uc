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
//-----------------------------------------------------------
// U2WeaponFire.uc
// Releasing all pointers to XMP again.
// 2009, GreatEmerald
//-----------------------------------------------------------
class U2WeaponFire extends WeaponFire;

var		bool	bLastRound;		// just fired last round of current clip

var name	AnimFireLastRound,
			AnimFireLastDown,
			AnimFireLastReload;

var sound FireLastRoundSound;		// played for both FireLastReload (followed by ReloadUnloaded), and FireLastDown.
var float	FireLastReloadTime;
var float	FireLastRoundTime;
//GE: What about FireLastDownTime? Interesting...

//GE: Percentage to speed up or slow down the anim. This is the formula to calculate it:
//(Frames / (Sequence->Rate) ) / FireLastReloadTime

/*
 * How to recheck values:
 * U2Fire* -> FireLastReloadTime -> FireLastReloadAnimRate
 *         -> FireLastDownAnimRate
 * Alt is the same, just add Alt everywhere
 * U2Weapon* -> ReloadTime -> ReloadAnimRate
 *           -> PutDownTime -> PutDownAnimRate
 */
var float FireLastReloadAnimRate;
var float FireLastDownAnimRate;

var Emitter FireEffect;
var class<Emitter> FireEffectClass;


simulated function DestroyEffects()
{
	Super.DestroyEffects();

    if (FireEffect != None)
        FireEffect.Destroy();
}

simulated function bool AllowFire()
{

    if ( Instigator.Health <= 0 )
		return false;

	if ( Ammo_ReloadRequired(AmmoPerFire) )
        return false;


	if ( U2Weapon(Weapon).bIsReloading )
		return false;
    //log(self$": AllowFire SUPER - "$Weapon.AmmoAmount(ThisModeNum) >= AmmoPerFire);
    return Super.AllowFire();
}

simulated function bool HasAmmo()
{
	// use projected ammoamount for client
	// note: only use this AFTER ConsumeAmmo (WeaponFire::ModeDoFire)
	if ( Weapon.Role == ROLE_Authority )
		return Weapon.HasAmmo();
	else
		return Weapon.AmmoAmount(0) > 1;
}

simulated function bool Ammo_ReloadRequired( optional int AmountNeeded )
{
	if( AmountNeeded == 0 )
		AmountNeeded = AmmoPerFire;

	//if ( Weapon.Role == ROLE_Authority )
		return AmountNeeded > U2Weapon(Weapon).ClipRoundsRemaining;
	//else
	//	return AmountNeeded > U2Weapon(Weapon).ClientRoundsRemaining;
}

event ModeDoFire()
{
	//log(self$": ModeDoFire() and AllowFire"@AllowFire());
    bLastRound = Ammo_ReloadRequired(AmmoPerFire + 1);
	U2Weapon(Weapon).bLastRound = bLastRound;
    if (Ammo_ReloadRequired(AmmoPerFire) )
    {
        U2Weapon(Weapon).Reload();
        return;
    }

	super.ModeDoFire();
}

//// server propagation of firing ////
function ServerPlayFiring()
{
	if( !bLastRound )
	{
		U2Weapon(Weapon).PlayAnimEx(FireAnim);
		Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,,false);
	}
	else if ( HasAmmo() )
	{
		//log(self@"Server: playing AnimFireLastReload:"@AnimFireLastReload);
        SetTimer(FireRate, false);
		U2Weapon(Weapon).PlayAnimEx(AnimFireLastReload, FireLastReloadAnimRate);
		U2Weapon(Weapon).ReloadTime = FireLastReloadTime - FireRate;
		Weapon.PlayOwnedSound(FireLastRoundSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,,false);
	}
	else
	{
		U2Weapon(Weapon).PlayAnimEx(AnimFireLastDown, FireLastDownAnimRate);
		Weapon.PlayOwnedSound(FireLastRoundSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,,false);
	}
}


function PlayFiring()
{
	//log(self$": PlayFiring()");
    //U2Weapon(Weapon).ClientRoundsRemaining -= Load;

	if ( !bLastRound )
	{
		U2Weapon(Weapon).PlayAnimEx(FireAnim);
		Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,,false);
	}
	else if ( HasAmmo() )
	{
		//log(self@"Client: playing AnimFireLastReload:"@AnimFireLastReload);
        SetTimer(FireRate, false);
		U2Weapon(Weapon).PlayAnimEx(AnimFireLastReload, FireLastReloadAnimRate);
		U2Weapon(Weapon).ReloadTime = FireLastReloadTime - FireRate;
		Weapon.PlayOwnedSound(FireLastRoundSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,,false);
	}
	else
	{
		U2Weapon(Weapon).PlayAnimEx(AnimFireLastDown, FireLastDownAnimRate);
		Weapon.PlayOwnedSound(FireLastRoundSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,,false);
	}

    ClientPlayForceFeedback(FireForce);  // jdf
}

simulated function Timer()
{
	bIsFiring = false;
	if ( Instigator.PendingWeapon == none )
		U2Weapon(Weapon).Reload();
}

defaultproperties
{
     AnimFireLastRound="FireLastRound"
     AnimFireLastDown="FireLastDown"
     AnimFireLastReload="FireLastReload"
     FireLastReloadTime=1.000000
     FireLastRoundTime=1.000000
     TransientSoundVolume=1.000000
     AmmoClass=Class'XWeapons.SniperAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=50.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=1.000000,Y=1.000000,Z=1.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.000000
     SpreadStyle=SS_Random
     FireLastDownAnimRate=1.0
     FireLastReloadAnimRate=1.0
}
