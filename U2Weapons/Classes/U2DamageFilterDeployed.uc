/*
 * Copyright (c) 2013 Dainius "GreatEmerald" Masiliūnas
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
// XMPDamageFilterDeployed.uc
// 2004 jasonyu
// 25 July 2004
//-----------------------------------------------------------

class U2DamageFilterDeployed extends U2DamageFilter;

defaultproperties
{
     filter(0)=(DamageType=Class'U2DamTypeEMP',DamageMultiplier=4.000000,MomentumMultiplier=1.000000)
     filter(1)=(DamageType=Class'U2DamTypeThermalFlaming',DamageMultiplier=0.600000,MomentumMultiplier=1.000000)
     filter(2)=(DamageType=Class'U2DamTypeGas',DamageMultiplier=0.040000,MomentumMultiplier=1.000000)
     filter(3)=(DamageType=Class'U2DamTypeRocket',DamageMultiplier=2.000000,MomentumMultiplier=1.000000)
     filter(4)=(DamageType=Class'Engine.DamageType',DamageMultiplier=1.000000,MomentumMultiplier=1.000000)
}
