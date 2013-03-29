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
//-----------------------------------------------------------------------------
// U2PickupFlameThrower.uc
// Pickup class of the Vulcan
// Now how big should this be?
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2PickupFlameThrower extends UTWeaponPickup;

#exec OBJ LOAD FILE="../StaticMeshes/U2MalekythM.usx"

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Texture'U2GLMWeaponsT.FT_TP_Skin2');
    L.AddPrecacheStaticMesh(StaticMesh'U2MalekythM.Pickups.FT_TP_W');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Texture'U2GLMWeaponsT.FT_TP_Skin2');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
     MaxDesireability=0.730000
     InventoryType=Class'U2Weapons.U2WeaponFlameThrower'
     PickupMessage="You got a Flamethrower."
     PickupSound=Sound'U2WeaponsA.Flamethrower.FT_Pickup'
     PickupForce="U2PickupFlameThrower"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'U2MalekythM.Pickups.FT_TP_W'
     DrawScale=0.700000
}
