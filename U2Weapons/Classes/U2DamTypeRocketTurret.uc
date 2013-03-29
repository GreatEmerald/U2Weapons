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
// U2DamTypeRocketTurret.uc
// Damage Type of the Rocket Turret.
// 2009, GreatEmerald
//-----------------------------------------------------------
class U2DamTypeRocketTurret extends U2DamTypeRocket;

DefaultProperties
{
     WeaponClass=Class'U2TurretWeaponRocket'
     DeathString="%o was throughly eradicated by a rocket from %k's Rocket Turret."
     FemaleSuicide="%o made her Rocket Turret mad."
     MaleSuicide="%o made his Rocket Turret mad."
}
