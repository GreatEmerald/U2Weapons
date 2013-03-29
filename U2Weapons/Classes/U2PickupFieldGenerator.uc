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
// U2PickupFieldGenerator.uc
// A pickup for the Force Field Generator
// 2009, GreatEmerald
//-----------------------------------------------------------
class U2PickupFieldGenerator extends UTWeaponPickup;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Texture'XMPT.items.HumanPDS1');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Texture'XMPT.items.HumanPDS1');

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
     InventoryType=Class'U2WeaponFieldGenerator'
     PickupMessage="You got a Field Generator."
     PickupSound=Sound'U2XMPA.FieldGenerator.FieldGeneratorPickup'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'XMPM.items.FieldGenerator'
     DrawScale=0.070000
     CollisionRadius=5.000000
     CollisionHeight=50.000000
     RespawnTime=60.0
     bWeaponStay=false
     TransientSoundVolume=0.6
}
