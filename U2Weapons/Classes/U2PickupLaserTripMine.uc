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
// U2PickupLaserTripMine.uc
// A pickup for the Land Mine
// 2009, GreatEmerald
//-----------------------------------------------------------
class U2PickupLaserTripMine extends UTWeaponPickup;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Texture'XMPWorldItemsT.items.LaserTripMine_SD_001');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Texture'XMPWorldItemsT.items.LaserTripMine_SD_001');

    super.UpdatePrecacheMaterials();
}

function SetWeaponStay()
{
    bWeaponStay = false;
}

function float GetRespawnTime()
{
    return ReSpawnTime;
}

defaultproperties
{
     MaxDesireability=0.700000
     InventoryType=Class'U2WeaponLaserTripMine'
     PickupMessage="You got a Laser Trip Mine."
     PickupSound=Sound'U2XMPA.EnergyRelay.EnergyRelayPickup'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'XMPWorldItemsM.items.Laser_Tripmine_001'
     DrawScale=0.700000
     CollisionRadius=15.000000
     CollisionHeight=12.000000
     PrePivot=(Y=-14,Z=-10)
     RespawnTime=60.0
     bWeaponStay=false
     TransientSoundVolume=0.6
}
