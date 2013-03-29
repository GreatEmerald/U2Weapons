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
// U2PickupAmmoEnergyRifle.uc
// Pickup class of the Shock Lance Plasma Pack
// Ah, here it is.
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2PickupAmmoEnergyRifle extends UTAmmoPickup;

defaultproperties
{
     AmmoAmount=34
     InventoryType=Class'U2Weapons.U2AmmoEnergyRifle'
     PickupMessage="You picked up a Shock Lance plasma pack."
     PickupSound=Sound'U2WeaponsA.EnergyRifle.ER_PickupAmmo'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'U2343M.Pickups.Ammo_ER'
     CollisionRadius=12.000000
     CollisionHeight=10.000000
}
