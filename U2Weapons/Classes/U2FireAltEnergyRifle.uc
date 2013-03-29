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
// U2FireAltEnergyRifle.uc
// Alternative Fire class of the Shock Lance
// EMP = ?
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2FireAltEnergyRifle extends U2ProjectileFire;

function PlayFiring()
{
  Super.PlayFiring();
  //if(FireEffect == None)
  //{
    FireEffect = spawn(FireEffectClass);
    Weapon.AttachToBone(FireEffect, 'xAltFireMuzzleFlash');
  //}
}

defaultproperties
{
     ProjSpawnOffset=(Y=7.500000,Z=-7.000000)
     AnimFireLastRound="AltFireLastRound"
     AnimFireLastDown="AltFireLastDown"
     AnimFireLastReload="AltFireLastReload"
     FireLastRoundSound=Sound'WeaponsA.EnergyRifle.ER_AltFireLastRound'
     FireLastRoundTime=1.440000
     FireEffectClass=Class'U2FX_ShockFlareAlt'
     bSplashDamage=True
     FireAnim="AltFire"
     FireSound=Sound'WeaponsA.EnergyRifle.ER_AltFire'
     FireRate=2.000000
     AmmoPerFire=10
     BotRefireRate=0.500000
     WarnTargetPct=0.900000
     FireLastReloadTime=2.625000
     FireLastReloadAnimRate=0.976190
     AmmoClass=Class'U2Weapons.U2AmmoEnergyRifle'
     ProjectileClass=Class'U2Weapons.U2ProjectileAltEnergyRifle'
}
