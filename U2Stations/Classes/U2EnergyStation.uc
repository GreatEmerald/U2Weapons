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
//------------------------------------------------------------------------------
// U2EnergyStation.uc
// GreatEmerald, 2008
// Based on UTXMP and Unreal II Energy Stations
//------------------------------------------------------------------------------

class U2EnergyStation extends U2PowerStation
	placeable;

simulated function UpdateMeterOpacity()
{
    local float Ascale;

    Ascale = float(EnergyUnits)/float(default.EnergyUnits);//mc: for more visible with more health
    StationColour.a = Clamp(Ascale * 256, 1, 255); //mc: the clamping (could also be a zero) is needed to prevent any byte rollover errors.
    EffectController.color = StationColour;

}

defaultproperties
{
     EnergyUnits=50
     TransferRate=10
     MaxShield=50
     Description="Shield Station"
     StationStartUsingSound=Sound'U2A.Stations.EnergyStationActivate'
     StationStopUsingSound=Sound'U2A.Stations.EnergyStationDeactivate'
     StationInUseSound=Sound'U2A.Stations.EnergyStationAmbient'
     StationErrorSound=Sound'U2A.Stations.EnergyStationError'
     ParticleEffect=Class'U2EnergyStationEffect'
     Skins(0)=Shader'U2StationsT.Stations.Station_FX_Energy_001'
     //Skins(2)=Shader'U2StationsT.Stations.StationEnergy'
     StationColour=(A=255,R=0,G=192,B=255)
     //References: U2A.uax (needs changing)
     CollisionRadius=35.0
     CollisionHeight=32.0
     DrawScale=0.4
     RechargeRate=1.660000
     //TouchingHeight=35.000000
     //TouchingRadius=35.000000
     //StationEffectOffset=(X=-8.000000,Z=30.000000) //Multiply by 0.4?
     bLimited=False
}
