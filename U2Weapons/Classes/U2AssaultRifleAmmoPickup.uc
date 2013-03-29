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
// U2AssaultRifleAmmoPickup.uc
// Pickup class of the M32 Duster Clip
// Where did I put those bullets?
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2AssaultRifleAmmoPickup extends UTAmmoPickup;

defaultproperties
{
     AmmoAmount=75
     InventoryType=Class'U2Weapons.U2AssaultRifleAmmoInv'
     PickupMessage="You picked up an Assault Rifle clip."
     PickupSound=Sound'U2WeaponsA.AssaultRifle.AR_PickupAmmo'
     PickupForce="U2AssaultRifleAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'U2343M.Pickups.Ammo_AR'
     Skins(0)=Shader'343T.Projectiles.PickupsFX_TD_01'
     CollisionRadius=21.000000
     CollisionHeight=9.000000
}
