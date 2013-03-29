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
// U2AssaultRifleAltFire.uc
// Alternative Fire class of the M32 Duster
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2AssaultRifleAltFire extends U2ProjectileFire;

simulated function InitEffects()
{
	Super.InitEffects();

    // don't even spawn on server
    if ( (Level.NetMode == NM_DedicatedServer) || (AIController(Instigator.Controller) != None) )
		return;
    if ( FlashEmitter != None && !FlashEmitter.bDeleteMe )
        FlashEmitter.AttachToBone(Weapon, 'xAltFireMuzzleFlash');
}

defaultproperties
{
     AmmoClass=Class'U2Weapons.U2AssaultRifleAmmoInv'
     ProjectileClass=Class'U2Weapons.U2AssaultRifleProjAlt'

     ProjSpawnOffset=(X=40.000000,Y=12.000000,Z=-16.000000)
     AnimFireLastRound="AltFireLastRound"
     AnimFireLastDown="AltFireLastDown"
     AnimFireLastReload="AltFireLastReload"
     FireLastRoundSound=Sound'WeaponsA.AssaultRifle.AR_AltFireLastRound'
     FireLastReloadTime=2.8
     FireLastRoundTime=1.100000
     bSplashDamage=True
     bRecommendSplashDamage=True
     bSplashJump=True
     FireAnim="AltFire"
     FireSound=Sound'WeaponsA.AssaultRifle.AR_AltFire'
     FireRate=1.000000
     AmmoPerFire=5
     FlashEmitterClass=Class'XEffects.MinigunMuzFlash1st'
}
