/*
 * Copyright (c) 2013 Dainius "GreatEmerald" Masiliūnas
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
// ====================================================================
//  Parent class for all forcewallsprites
//
//  Written by Alex Dobie
//  (c) 2004, Free Monkey Interactive.  All Rights Reserved
// ====================================================================
class U2FX_ForceWallSprite extends Emitter;

simulated function ModLength(float NewLength)
{


  SpriteEmitter(Emitters[4]).StartLocationRange.X.Max = NewLength;
  SpriteEmitter(Emitters[5]).StartLocationRange.X.Max = NewLength;
  SpriteEmitter(Emitters[6]).StartLocationRange.X.Max = NewLength;
  SpriteEmitter(Emitters[7]).StartLocationRange.X.Max = NewLength;

}

defaultproperties
{
     RemoteRole=ROLE_SimulatedProxy
}
