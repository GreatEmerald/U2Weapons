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
// U2PickupShotgun.uc
// Pickup class of Crowd Pleaser
// *Cheer*
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2PickupShotgun extends UTWeaponPickup;

#exec OBJ LOAD FILE="../StaticMeshes/U2MalekythM.usx"

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Texture'U2GLMWeaponsT.S_TP_Skin1');
    L.AddPrecacheStaticMesh(StaticMesh'U2MalekythM.Pickups.S_TP_W');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Texture'U2GLMWeaponsT.S_TP_Skin1');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
     MaxDesireability=0.780000
     InventoryType=Class'U2Weapons.U2WeaponShotgun'
     PickupMessage="You got a Crowd Pleaser Shotgun."
     PickupSound=Sound'U2WeaponsA.Shotgun.S_Pickup'
     PickupForce="U2PickupShotgun"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'U2MalekythM.Pickups.S_TP_W'
     Skins(0)=Shader'U2WeaponFXT.Shotgun.S_TP_Skin1FX'
     DrawScale=0.600000
}
