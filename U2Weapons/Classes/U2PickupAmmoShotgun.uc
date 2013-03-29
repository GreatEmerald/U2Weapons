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
// U2PickupAmmoShotgun.uc
// Pickup class of a pack of pellets
// Normal or incendiary?
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2PickupAmmoShotgun extends UTAmmoPickup;

defaultproperties
{
     AmmoAmount=8
     InventoryType=Class'U2Weapons.U2AmmoShotgun'
     PickupMessage="You picked up 8 shotgun shells."
     PickupSound=Sound'U2WeaponsA.Shotgun.S_PickupAmmo'
     PickupForce="U2PickupAmmoShotgun"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'U2343M.Pickups.Ammo_S'
     CollisionHeight=7.000000
}