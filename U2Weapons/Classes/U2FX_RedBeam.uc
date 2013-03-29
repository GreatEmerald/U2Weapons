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
//  new force wall fx
//
//  Written by Alex Dobie
//  (c) 2004, Free Monkey Interactive.  All Rights Reserved
// ====================================================================
class U2FX_RedBeam extends U2FX_ForceWallBeam;

defaultproperties
{
     Begin Object Class=BeamEmitter Name=BeamEmitter20
         BeamDistanceRange=(Min=250.000000,Max=250.000000)
         BeamEndPoints(0)=(ActorTag="NodeA",offset=(X=(Min=500.000000,Max=500.000000)),Weight=1.000000)
         DetermineEndPointBy=PTEP_Offset
         LowFrequencyPoints=2
         HighFrequencyNoiseRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
         HighFrequencyPoints=3
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(Y=(Min=0.200000,Max=0.300000),Z=(Min=0.200000,Max=0.300000))
         Opacity=0.900000
         FadeOutStartTime=1.000000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationRange=(Z=(Min=18.000000,Max=18.000000))
         StartSizeRange=(X=(Min=15.000000,Max=15.000000),Y=(Min=15.000000,Max=15.000000),Z=(Min=15.000000,Max=15.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'SpecialFX.Alex.beam1'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(0)=BeamEmitter'U2FX_RedBeam.BeamEmitter20'

     Begin Object Class=BeamEmitter Name=BeamEmitter22
         BeamDistanceRange=(Min=250.000000,Max=250.000000)
         BeamEndPoints(0)=(ActorTag="NodeA",offset=(X=(Min=500.000000,Max=500.000000)),Weight=1.000000)
         DetermineEndPointBy=PTEP_Offset
         LowFrequencyPoints=2
         HighFrequencyNoiseRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
         HighFrequencyPoints=3
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(Y=(Min=0.200000,Max=0.300000),Z=(Min=0.200000,Max=0.300000))
         Opacity=0.900000
         FadeOutStartTime=1.000000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationRange=(Z=(Min=-18.000000,Max=-18.000000))
         StartSizeRange=(X=(Min=15.000000,Max=15.000000),Y=(Min=15.000000,Max=15.000000),Z=(Min=15.000000,Max=15.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'SpecialFX.Alex.beam1'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(1)=BeamEmitter'U2FX_RedBeam.BeamEmitter22'

     Begin Object Class=BeamEmitter Name=BeamEmitter23
         BeamDistanceRange=(Min=250.000000,Max=250.000000)
         BeamEndPoints(0)=(ActorTag="NodeA",offset=(X=(Min=500.000000,Max=500.000000)),Weight=1.000000)
         DetermineEndPointBy=PTEP_Offset
         LowFrequencyPoints=2
         HighFrequencyNoiseRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
         HighFrequencyPoints=3
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(Y=(Min=0.200000,Max=0.300000),Z=(Min=0.200000,Max=0.300000))
         Opacity=0.900000
         FadeOutStartTime=1.000000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationRange=(Z=(Min=50.000000,Max=50.000000))
         StartSizeRange=(X=(Min=15.000000,Max=15.000000),Y=(Min=15.000000,Max=15.000000),Z=(Min=15.000000,Max=15.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'SpecialFX.Alex.beam1'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(2)=BeamEmitter'U2FX_RedBeam.BeamEmitter23'

     Begin Object Class=BeamEmitter Name=BeamEmitter24
         BeamDistanceRange=(Min=250.000000,Max=250.000000)
         BeamEndPoints(0)=(ActorTag="NodeA",offset=(X=(Min=500.000000,Max=500.000000)),Weight=1.000000)
         DetermineEndPointBy=PTEP_Offset
         LowFrequencyPoints=2
         HighFrequencyNoiseRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
         HighFrequencyPoints=3
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(Y=(Min=0.200000,Max=0.300000),Z=(Min=0.200000,Max=0.300000))
         Opacity=0.900000
         FadeOutStartTime=1.000000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationRange=(Z=(Min=-50.000000,Max=-50.000000))
         StartSizeRange=(X=(Min=15.000000,Max=15.000000),Y=(Min=15.000000,Max=15.000000),Z=(Min=15.000000,Max=15.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'SpecialFX.Alex.beam1'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(3)=BeamEmitter'U2FX_RedBeam.BeamEmitter24'

     AutoDestroy=True
     bNoDelete=False
     bDirectional=True
}
