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
class U2DynamicBlockingVolume extends BlockingVolume;

struct Face
{
	var array<vector> Points;
};

function SetFaces( array<Face> Faces );


event Destroyed()
{
	SetPhysics(PHYS_None); // Uninit karma if needed..
	Super.Destroyed();
}

defaultproperties
{
     DrawType=DT_None
     bStatic=False
     bNoDelete=False
     RemoteRole=ROLE_None
     Texture=None
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     bCollideWorld=True
     bBlockPlayers=True
}
