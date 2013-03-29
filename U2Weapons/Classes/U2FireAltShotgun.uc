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
// U2FireAltShotgun.uc
// Althernate fire class of the Crowd Pleaser
// Want to look at two references?
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2FireAltShotgun extends U2ProjectileFire;

function PlayFiring()
{
  Super.PlayFiring();
    FireEffect = spawn(FireEffectClass);
    Weapon.AttachToBone(FireEffect, 'xMuzzleFlash');
}

defaultproperties
{
     AmmoClass=Class'U2Weapons.U2AmmoShotgun'
     ProjectileClass=Class'U2Weapons.U2ProjectileAltShotgun'

     ProjPerFire=16
     ProjSpawnOffset=(X=42.000000,Y=9.000000)
     AnimFireLastRound="AltFireLastRound"
     AnimFireLastDown="AltFireLastDown"
     AnimFireLastReload="AltFireLastReload"
     FireLastRoundSound=Sound'WeaponsA.Shotgun.S_AltFireLastRound'
     FireLastReloadTime=3.363000
     FireLastRoundTime=0.570000
     FireLastDownAnimRate=3.395669
     FireEffectClass=Class'U2FX_ShotgunMuzzleFlash'
     bSplashDamage=True
     FireAnim="AltFire"
     FireSound=Sound'WeaponsA.Shotgun.S_AltFire'
     FireRate=1.180000
     Spread=20.000000
}
