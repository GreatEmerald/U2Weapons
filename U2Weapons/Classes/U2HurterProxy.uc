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
//
//  Proxy class that handles damage for gas/fire grenades
//
//  Written by Alex Dobie
//  (c) 2004, Free Monkey Interactive.  All Rights Reserved
// ====================================================================
class U2HurterProxy extends AvoidMarker;

var float Interval, myDamage, myMomentum;
var int Loops, CurrentLoop;
var class<DamageType> DT;

simulated function PostBeginPlay()
{

  Super.PostBeginPlay();
  HurtRadius(myDamage, CollisionRadius, DT, myMomentum, Location);
  SetTimer(Interval, true);

}

function Timer()
{

  if(CurrentLoop >= Loops)
  {
    SetTimer(0.0,false);
    Destroy();
    return;
  }

  CurrentLoop+=1;
  HurtRadius(myDamage, CollisionRadius, DT, myMomentum, Location);

}

defaultproperties
{
     Interval=0.500000
     myDamage=25.000000
     Loops=3
     dt=Class'U2DamTypeThermalFlaming'
     CollisionHeight=100.000000
}
