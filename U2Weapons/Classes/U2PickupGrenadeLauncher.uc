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
// U2PickupGrenadeLauncher.uc
// Pickup class of Hydra
// Ow, it bites.
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2PickupGrenadeLauncher extends UTWeaponPickup;

#exec OBJ LOAD FILE="../StaticMeshes/U2MalekythM.usx"

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Texture'U2GLMWeaponsT.GL_TP_Skin1');
    L.AddPrecacheStaticMesh(StaticMesh'U2MalekythM.Pickups.GL_TP_W');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Texture'U2GLMWeaponsT.GL_TP_Skin1');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
     MaxDesireability=0.700000
     InventoryType=Class'U2Weapons.U2WeaponGrenadeLauncher'
     PickupMessage="You got a Grenade Launcher."
     PickupSound=Sound'U2WeaponsA.GrenadeLauncher.GL_Pickup'
     PickupForce="U2PickupGrenadeLauncherLight"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'U2MalekythM.Pickups.GL_TP_W'
     Skins(0)=Shader'U2WeaponFXT.Grenade.GL_TP_Skin1FX'
     DrawScale=0.500000
}
