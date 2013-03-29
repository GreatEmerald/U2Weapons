/*
 * Copyright (c) 2009, 2013 Dainius "GreatEmerald" Masiliūnas
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
// U2FireChangeAmmo.uc
// A fire mode for changing ammo types.
// 2009, GreatEmerald
//-----------------------------------------------------------
class U2FireChangeAmmo extends U2WeaponFire;

DefaultProperties
{
    FireSound=Sound'WeaponsA.GrenadeLauncher.GL_ChangeAmmo'
    FireLoopAnim="ChangeAmmo"
    FireAnim="ChangeAmmo"
    FireRate=0.200000
    BotRefireRate=0.200000
    bWaitForRelease=True
    AmmoClass=Class'U2AmmoGrenadeLauncher'
    AmmoPerFire=0
     ShakeRotTime=0.000000
     ShakeOffsetTime=0.000000
}
