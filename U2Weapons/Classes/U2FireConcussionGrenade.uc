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
// U2FireConcussionGrenade.uc
// Fire class of Concussion Grenade
// Boom! Aww, no concussion effect in UT2004 :(
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2FireConcussionGrenade extends U2FireGrenade;

defaultproperties
{
     bSplashJump=True
     AmmoClass=Class'U2Weapons.U2AmmoGrenadeLauncher'
     ProjectileClass=Class'U2Weapons.U2ProjectileConcussionGrenade'
}
