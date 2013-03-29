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
// U2PickupRocketTurret.uc
// A pickup for the Rocket Turret
// 2009, GreatEmerald
//-----------------------------------------------------------
class U2PickupRocketTurret extends UTWeaponPickup;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Texture'Arch_TurretsT.Small.METL_DeployTurrets_TD_01');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Texture'Arch_TurretsT.Small.METL_DeployTurrets_TD_01');

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
     InventoryType=Class'U2WeaponRocketTurret'
     PickupMessage="You got a Rocket Turret."
     PickupSound=Sound'U2XMPA.RocketTurret.RocketTurretPickup'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'U2Turrets.Turrets.RocketTurret'
     DrawScale=0.700000
     CollisionRadius=40.000000
     CollisionHeight=45.000000
     PrePivot=(Z=-15.0)
     RespawnTime=60.0
     bWeaponStay=false
     TransientSoundVolume=0.6
}
