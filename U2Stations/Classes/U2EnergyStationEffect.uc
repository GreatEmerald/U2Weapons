/*
 * Copyright (c) 2010, 2013 Dainius "GreatEmerald" Masiliūnas
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
// U2EnergyStationEffect.uc
// Particle effect for all energy stations. Use StationEffect for the Health effect
// GreatEmerald, 2010
//-----------------------------------------------------------
class U2EnergyStationEffect extends U2StationEffect;

#exec obj load file=U2StationsT.utx

function PreBeginPlay()
{
   Emitters[0].ColorMultiplierRange.X.Min=0.0;
   Emitters[0].ColorMultiplierRange.X.Max=0.0;
   Emitters[0].ColorMultiplierRange.Z.Min=1.0;
   Emitters[0].ColorMultiplierRange.Z.Max=1.0;
   Emitters[0].Texture = Texture'U2StationsT.Stations.PlayerIcon_Tech_TD_01';

   Emitters[1].Texture = Texture'U2StationsT.Stations.Icon_Energy_TD_001';
   Emitters[1].StartSizeRange.X.Min = 22.5;
   Emitters[1].StartSizeRange.X.Max = 22.5;
   Emitters[1].StartSizeRange.Y.Min = 22.5;
   Emitters[1].StartSizeRange.Y.Max = 22.5;
   Emitters[1].StartSizeRange.Z.Min = 22.5;
   Emitters[1].StartSizeRange.Z.Max = 22.5;
   Emitters[1].ColorMultiplierRange.X.Min=0.7;
   Emitters[1].ColorMultiplierRange.X.Max=0.7;
   Emitters[1].ColorMultiplierRange.Y.Min=0.8;
   Emitters[1].ColorMultiplierRange.Y.Max=0.8;
   Emitters[1].ColorMultiplierRange.Z.Min=1.0;
   Emitters[1].ColorMultiplierRange.Z.Max=1.0;
}

DefaultProperties
{

}
