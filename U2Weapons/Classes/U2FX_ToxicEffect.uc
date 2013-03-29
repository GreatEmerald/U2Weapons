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
// XMPToxicEffect.uc
// 2004 jasonyu
// 31 May 2004
// tweaked by alexdobie, 28 jul 04
// pwned by alexdobie, 05 nov 04
//-----------------------------------------------------------

class U2FX_ToxicEffect extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.125000
         FadeOutStartTime=3.780000
         FadeInEndTime=0.450000
         MaxParticles=60
         SpinsPerSecondRange=(X=(Max=0.125000),Y=(Max=0.125000),Z=(Max=0.125000))
         SizeScale(0)=(RelativeSize=4.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=8.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=4.000000)
         StartSizeRange=(X=(Min=25.000000,Max=25.000000))
         InitialParticlesPerSecond=24.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'SpecialFX.ToxicSmoke.toxic6_tw128'
         LifetimeRange=(Min=10.000000,Max=19.000000)
         StartVelocityRange=(X=(Min=-128.000000,Max=128.000000),Y=(Min=-128.000000,Max=128.000000),Z=(Min=-32.000000,Max=128.000000))
         VelocityScale(0)=(RelativeVelocity=(X=32.000000,Y=32.000000,Z=26.000000))
         VelocityScale(1)=(RelativeTime=0.010000,RelativeVelocity=(X=-0.012500,Y=-0.012500,Z=-0.012500))
         VelocityScale(2)=(RelativeTime=1.000000)
     End Object
     Emitters(0)=SpriteEmitter'U2FX_ToxicEffect.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(X=8.000000,Y=8.000000,Z=8.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.600000
         FadeOutStartTime=0.150000
         FadeInEndTime=0.250000
         MaxParticles=1
         SpinCCWorCW=(Z=5.000000)
         SpinsPerSecondRange=(X=(Min=-0.250000,Max=0.250000),Y=(Min=-0.250000,Max=0.250000),Z=(Max=0.125000))
         SizeScale(0)=(RelativeTime=0.430000,RelativeSize=96.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=128.000000)
         StartSizeRange=(X=(Min=2.000000,Max=2.000000))
         InitialParticlesPerSecond=2.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'SpecialFX.ToxicSmoke.toxicring1_tw128'
         LifetimeRange=(Min=0.650000,Max=0.650000)
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(1)=SpriteEmitter'U2FX_ToxicEffect.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         ColorScale(1)=(RelativeTime=0.125000,Color=(G=176,R=164))
         ColorScale(2)=(RelativeTime=0.500000,Color=(B=18,G=129,R=112))
         ColorScale(3)=(RelativeTime=1.000000)
         MaxParticles=25
         StartLocationRange=(X=(Min=-256.000000,Max=256.000000),Y=(Min=-256.000000,Max=256.000000),Z=(Min=-32.000000,Max=192.000000))
         SpinsPerSecondRange=(X=(Min=-0.192000,Max=0.192000),Y=(Min=-0.192000,Max=0.192000))
         StartSizeRange=(X=(Min=0.750000,Max=1.750000))
         InitialParticlesPerSecond=1.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'SpecialFX.Leechsplat.leechsplat2_tw128'
         LifetimeRange=(Min=10.000000,Max=19.000000)
         StartVelocityRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-1.000000,Max=2.000000))
         VelocityScale(0)=(RelativeTime=0.750000,RelativeVelocity=(Z=-8.000000))
     End Object
     Emitters(2)=SpriteEmitter'U2FX_ToxicEffect.SpriteEmitter3'

     AutoDestroy=True
     bNoDelete=False
     bNetTemporary=True
     RemoteRole=ROLE_SimulatedProxy
}
