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
// U2DamTypeLaserTripMine.uc
// The damage type of the Laser Trip Mine.
// GreatEmerald, 2009
//-----------------------------------------------------------
class U2DamTypeLaserTripMine extends U2DamTypeLandMine;

DefaultProperties
{
     DeathString="%o didn't notice the laser from %k's Laser Trip Mine."
     FemaleSuicide="%o now knows why they're named 'Laser Trip Mines'."
     MaleSuicide="%o now knows why they're named 'Laser Trip Mines'."
}
