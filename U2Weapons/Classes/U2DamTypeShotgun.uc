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
// U2DamTypeShotgun.uc
// Damage type of the Crowd Pleaser
// Clang! Cling! Chook-cheek! Urgh!
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2DamTypeShotgun extends WeaponDamageType;

defaultproperties
{
     WeaponClass=Class'U2Weapons.U2WeaponShotgun'
     DeathString="%o was blasted by %k's Shotgun."
     FemaleSuicide="%o somehow managed to blast herself."
     MaleSuicide="%o somehow managed to blast himself."
     bRagdollBullet=True
     bBulletHit=True
     FlashFog=(X=600.000000)
     KDamageImpulse=2000.000000
}
