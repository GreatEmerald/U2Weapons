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
// U2DamTypeAssaultRifle.uc
// DamageType class of the M32 Duster
// What in XMP was controlled by Projectiles, is controlled by DamageTypes here.
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2DamTypeAssaultRifle extends WeaponDamageType
	abstract;

defaultproperties
{
     WeaponClass=Class'U2Weapons.U2AssaultRifleInv'
     DeathString="%o was dusted by %k's Combat Assault Rifle."
     FemaleSuicide="%o died of dust inhalation."
     MaleSuicide="%o died of dust inhalation."
     bRagdollBullet=True
     bBulletHit=True
     FlashFog=(X=600.000000)
     KDamageImpulse=2000.000000
}
