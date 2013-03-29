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
// U2HurterProxy_Fire.uc
// Proxy Hurter class of the Incendiary Grenade
// Water! Water!
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2HurterProxy_Fire extends U2HurterProxy;

defaultproperties
{
     myDamage=44.000000
     dt=Class'U2Weapons.U2DamTypeFire'
     Loops=5
     CollisionRadius=400.000000
     CollisionHeight=200.000000
}
