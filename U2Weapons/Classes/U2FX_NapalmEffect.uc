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
class U2FX_NapalmEffect extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Opacity=0.500000
         FadeOutStartTime=0.250000
         CoordinateSystem=PTCS_Relative
         StartLocationRange=(X=(Min=-32.000000,Max=32.000000),Y=(Min=-32.000000,Max=32.000000))
         SpinsPerSecondRange=(X=(Min=-0.125000,Max=0.125000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=8.000000,Max=8.000000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'SpecialFX.Leechsplat.leechsplat6_tw128'
         LifetimeRange=(Min=0.500000,Max=0.500000)
         InitialDelayRange=(Min=0.125000,Max=0.125000)
     End Object
     Emitters(0)=SpriteEmitter'U2FX_NapalmEffect.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseDirectionAs=PTDU_Normal
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         ColorScale(0)=(Color=(B=4,G=56,R=115))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=40,G=40,R=72))
         Opacity=0.600000
         FadeInEndTime=0.500000
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         StartLocationRange=(X=(Min=-16.000000,Max=16.000000),Y=(Min=-16.000000,Max=16.000000),Z=(Max=1.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=42.000000,Max=64.000000))
         InitialParticlesPerSecond=300.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'SpecialFX.Leechsplat.leechsplat1_tw128'
         LifetimeRange=(Min=22.000000,Max=22.000000)
     End Object
     Emitters(1)=SpriteEmitter'U2FX_NapalmEffect.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseDirectionAs=PTDU_Normal
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         ColorScale(0)=(Color=(B=14,G=112,R=97))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=17,G=91,R=60))
         Opacity=0.250000
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         StartLocationRange=(X=(Min=-32.000000,Max=32.000000),Y=(Min=-32.000000,Max=32.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=32.000000,Max=64.000000))
         InitialParticlesPerSecond=300.000000
         Texture=Texture'SpecialFX.Leechsplat.leechsplat6_tw128'
         LifetimeRange=(Min=22.000000,Max=22.000000)
     End Object
     Emitters(2)=SpriteEmitter'U2FX_NapalmEffect.SpriteEmitter2'

     bNoDelete=False
     RemoteRole=ROLE_SimulatedProxy
}
