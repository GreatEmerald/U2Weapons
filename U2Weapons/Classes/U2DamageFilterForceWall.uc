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
// (c) 2004 jasonyu
// 7 September 2004
// UT2004 implementation by GreatEmerald, 2009
//-----------------------------------------------------------
class U2DamageFilterForceWall extends U2DamageFilter;

defaultproperties
{
     filter(0)=(DamageType=Class'U2DamTypeEMP',DamageMultiplier=1.000000,MomentumMultiplier=0.500000)
     filter(1)=(DamageType=Class'U2DamTypeAssaultSlug',DamageMultiplier=0.250000,MomentumMultiplier=0.500000)
     filter(2)=(DamageType=Class'U2DamTypeIncendiaryGrenade',DamageMultiplier=0.150000,MomentumMultiplier=0.500000)
     filter(3)=(DamageType=Class'U2DamTypeToxicGrenade',DamageMultiplier=0.020000,MomentumMultiplier=0.500000)
     filter(4)=(DamageType=Class'U2DamTypeRocket',DamageMultiplier=0.500000,MomentumMultiplier=0.500000)
     filter(5)=(DamageType=Class'U2DamTypeShotgun',DamageMultiplier=0.500000,MomentumMultiplier=0.500000)
     filter(6)=(DamageType=Class'Engine.DamageType',DamageMultiplier=0.250000,MomentumMultiplier=0.500000)
     filter(7)=(DamageType=Class'U2DamTypeEMPGrenade',DamageMultiplier=1.000000,MomentumMultiplier=0.500000)
     filter(8)=(DamageType=Class'U2DamTypeThermalFlaming',DamageMultiplier=0.150000,MomentumMultiplier=0.500000)
     filter(9)=(DamageType=Class'U2DamTypeSniper',DamageMultiplier=0.500000,MomentumMultiplier=0.500000)
     filter(10)=(DamageType=Class'U2DamTypeShotgun',DamageMultiplier=0.500000,MomentumMultiplier=0.500000)
     filter(11)=(DamageType=Class'U2DamTypeGas',DamageMultiplier=0.020000,MomentumMultiplier=0.500000)
}
