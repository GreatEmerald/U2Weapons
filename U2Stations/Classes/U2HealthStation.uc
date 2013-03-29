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
// U2HealthStation.uc
// GreatEmerald, 2008
// Based on UTXMP and Unreal II Health Stations
//------------------------------------------------------------------------------

class U2HealthStation extends U2PowerStation
	placeable;

simulated function UpdateMeterOpacity()
{
    local float Ascale;

    Ascale = float(HealthUnits)/float(default.HealthUnits);//mc: for more visible with more health
    StationColour.A = Clamp(Ascale * 256, 1, 255); //mc: the clamping (could also be a zero) is needed to prevent any byte rollover errors.
    EffectController.color = StationColour;
    //ActiveStationEffect.Emitters[0].MaxParticles = Clamp(Ascale * 20, 0, 20);
    //if (PowerUpOwner != None)
    //PowerUpOwner.ClientMessage("U2HealthStation: Alpha Scale is"@StationColour.A@"because HealthUnits are"@HealthUnits);
}

defaultproperties
{
     HealthUnits=25
     TransferRate=10
     Description="Health Station"
     StationStartUsingSound=Sound'U2A.Stations.HealthStationActivate'
     StationStopUsingSound=Sound'U2A.Stations.HealthStationDeactivate'
     StationInUseSound=Sound'U2A.Stations.HealthStationAmbient'
     StationErrorSound=Sound'U2A.Stations.HealthStationError'
     ParticleEffect=Class'U2StationEffect'//Class'XMP_RaptFX.XMP_Rapt_StationFX_Health' // GE: Needs changing!
     Skins(0)=Material'U2StationsT.Stations.station_FX_Health_001'
     StationColour=(A=255,R=255,G=192,B=0)
     //Skins(2)=Material'U2StationsT.Stations.StationHealth'
     //References: U2A.uax, XMP_RaptFX.u (needs changing)
     CollisionRadius=35.0
     CollisionHeight=32.0
     DrawScale=0.4
     RechargeRate=1.00//0.830000
     DelayTime=5.0
     //TouchingHeight=35.000000
     //TouchingRadius=35.000000
     //StationEffectOffset=(X=-8.000000,Z=30.000000) //Multiply by 0.4?
     bLimited=False
}
