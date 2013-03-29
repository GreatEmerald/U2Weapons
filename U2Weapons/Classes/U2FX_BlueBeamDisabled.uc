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
class U2FX_BlueBeamDisabled extends U2FX_ForceWallSprite;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter18
         FadeOut=True
         FadeIn=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000))
         FadeOutStartTime=1.440000
         FadeInEndTime=1.200000
         CoordinateSystem=PTCS_Relative
         MaxParticles=60
         StartLocationRange=(X=(Max=500.000000),Z=(Min=18.000000,Max=18.000000))
         StartSizeRange=(X=(Min=5.000000,Max=25.000000),Y=(Min=5.000000,Max=25.000000),Z=(Min=5.000000,Max=25.000000))
         InitialParticlesPerSecond=30.000000
         Texture=Texture'AWGlobal.Coronas.SpotFlare01aw'
         LifetimeRange=(Min=2.000000)
     End Object
     Emitters(4)=SpriteEmitter'U2FX_BlueBeamDisabled.SpriteEmitter18'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter19
         FadeOut=True
         FadeIn=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000))
         FadeOutStartTime=1.440000
         FadeInEndTime=1.200000
         CoordinateSystem=PTCS_Relative
         MaxParticles=60
         StartLocationRange=(X=(Max=500.000000),Z=(Min=50.000000,Max=50.000000))
         StartSizeRange=(X=(Min=5.000000,Max=25.000000),Y=(Min=5.000000,Max=25.000000),Z=(Min=5.000000,Max=25.000000))
         InitialParticlesPerSecond=30.000000
         Texture=Texture'AWGlobal.Coronas.SpotFlare01aw'
         LifetimeRange=(Min=2.000000)
     End Object
     Emitters(5)=SpriteEmitter'U2FX_BlueBeamDisabled.SpriteEmitter19'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter23
         FadeOut=True
         FadeIn=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000))
         FadeOutStartTime=1.440000
         FadeInEndTime=1.200000
         CoordinateSystem=PTCS_Relative
         MaxParticles=60
         StartLocationRange=(X=(Max=500.000000),Z=(Min=-50.000000,Max=-50.000000))
         StartSizeRange=(X=(Min=5.000000,Max=25.000000),Y=(Min=5.000000,Max=25.000000),Z=(Min=5.000000,Max=25.000000))
         InitialParticlesPerSecond=30.000000
         Texture=Texture'AWGlobal.Coronas.SpotFlare01aw'
         LifetimeRange=(Min=2.000000)
     End Object
     Emitters(6)=SpriteEmitter'U2FX_BlueBeamDisabled.SpriteEmitter23'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter24
         FadeOut=True
         FadeIn=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000))
         FadeOutStartTime=1.440000
         FadeInEndTime=1.200000
         CoordinateSystem=PTCS_Relative
         MaxParticles=60
         StartLocationRange=(X=(Max=500.000000),Z=(Min=-18.000000,Max=-18.000000))
         StartSizeRange=(X=(Min=5.000000,Max=25.000000),Y=(Min=5.000000,Max=25.000000),Z=(Min=5.000000,Max=25.000000))
         InitialParticlesPerSecond=30.000000
         Texture=Texture'AWGlobal.Coronas.SpotFlare01aw'
         LifetimeRange=(Min=2.000000)
     End Object
     Emitters(7)=SpriteEmitter'U2FX_BlueBeamDisabled.SpriteEmitter24'

     AutoDestroy=True
     bNoDelete=False
     bDirectional=True
}
