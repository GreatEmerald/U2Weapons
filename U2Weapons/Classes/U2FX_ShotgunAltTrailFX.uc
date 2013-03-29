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
//-----------------------------------------------------------
// (c) 2004 jasonyu
// 4 July 2005
//
//-----------------------------------------------------------
class U2FX_ShotgunAltTrailFX extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter143
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(1)=(RelativeTime=0.125000,Color=(B=91,G=222,R=255))
         ColorScale(2)=(RelativeTime=0.946429,Color=(B=157,G=206,R=255))
         ColorScale(3)=(RelativeTime=1.000000)
         Opacity=0.125000
         MaxParticles=90
         SpinsPerSecondRange=(X=(Min=1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.250000,RelativeSize=1.500000)
         SizeScale(2)=(RelativeTime=0.750000,RelativeSize=0.500000)
         SizeScale(3)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=4.000000,Max=4.000000))
         Texture=Texture'ScottT.u1.ut_corona_008'
         LifetimeRange=(Min=0.012500,Max=0.012500)
     End Object
     Emitters(0)=SpriteEmitter'U2FX_ShotgunAltTrailFX.SpriteEmitter143'

     AutoDestroy=True
     bNoDelete=False
}
