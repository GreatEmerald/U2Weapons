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
// XMPEMPGrenadeFX.uc
// (c) 2004 jasonyu
// 17 February 2005
//
//-----------------------------------------------------------
class U2FX_EMPGrenadeFX extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter14
         FadeOut=True
         RespawnDeadParticles=False
         ZTest=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=50,G=50,R=50,A=50))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=100,G=100,R=100,A=152))
         FadeOutStartTime=0.800000
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=10.000000,Max=10.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.500000)
         StartSizeRange=(X=(Min=200.000000,Max=200.000000),Y=(Min=200.000000,Max=200.000000),Z=(Min=200.000000,Max=200.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'ScottT.u1.carflare'
         LifetimeRange=(Min=2.000000,Max=2.000000)
     End Object
     Emitters(0)=SpriteEmitter'U2FX_EMPGrenadeFX.SpriteEmitter14'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter15
         UseCollision=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-100.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=0.640000
         MaxParticles=20
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=10.000000,Max=25.000000)
         SpinsPerSecondRange=(X=(Min=10.000000,Max=10.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=25.000000,Max=50.000000),Y=(Min=25.000000,Max=50.000000),Z=(Min=25.000000,Max=50.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'EpicParticles.Flares.OutSpark02aw'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-150.000000,Max=150.000000),Y=(Min=-150.000000,Max=150.000000),Z=(Max=150.000000))
     End Object
     Emitters(1)=SpriteEmitter'U2FX_EMPGrenadeFX.SpriteEmitter15'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter16
         UseCollision=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         UseRandomSubdivision=True
         Acceleration=(Z=-1500.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=0.640000
         MaxParticles=30
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=2.000000,Max=25.000000)
         SpinsPerSecondRange=(X=(Min=10.000000,Max=10.000000))
         StartSizeRange=(X=(Min=20.000000,Max=40.000000),Y=(Min=20.000000,Max=40.000000),Z=(Min=20.000000,Max=40.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'EpicParticles.Flares.OutSpark02aw'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         LifetimeRange=(Min=1.500000,Max=5.000000)
         StartVelocityRange=(X=(Min=-700.000000,Max=700.000000),Y=(Min=-700.000000,Max=700.000000),Z=(Min=-700.000000,Max=700.000000))
     End Object
     Emitters(2)=SpriteEmitter'U2FX_EMPGrenadeFX.SpriteEmitter16'

     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'WarEffectsMeshes.N_ball_M_jm'
         RenderTwoSided=True
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.400000
         FadeOutStartTime=0.470000
         CoordinateSystem=PTCS_Relative
         SpinsPerSecondRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-100.000000,Max=100.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=0.750000),Y=(Min=0.750000),Z=(Min=0.750000))
         InitialParticlesPerSecond=1000.000000
         LifetimeRange=(Min=1.000000,Max=1.500000)
     End Object
     Emitters(3)=MeshEmitter'U2FX_EMPGrenadeFX.MeshEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter17
         UseDirectionAs=PTDU_Normal
         FadeOut=True
         RespawnDeadParticles=False
         Disabled=True
         Backup_Disabled=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=50,G=50,R=50,A=50))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=100,G=100,R=100,A=152))
         FadeOutStartTime=0.880000
         MaxParticles=50
         SpinsPerSecondRange=(X=(Min=10.000000,Max=10.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=160.000000,Max=160.000000),Y=(Min=160.000000,Max=160.000000),Z=(Min=160.000000,Max=160.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'ScottT.u1.ut_corona_001'
         StartVelocityRange=(Z=(Min=10.000000,Max=10.000000))
     End Object
     Emitters(4)=SpriteEmitter'U2FX_EMPGrenadeFX.SpriteEmitter17'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter18
         FadeOut=True
         RespawnDeadParticles=False
         ZTest=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=50,G=50,R=50,A=50))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=100,G=100,R=100,A=152))
         FadeOutStartTime=0.800000
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=10.000000,Max=10.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.500000)
         StartSizeRange=(X=(Min=200.000000,Max=200.000000),Y=(Min=200.000000,Max=200.000000),Z=(Min=200.000000,Max=200.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'EpicParticles.Flares.OutSpark02aw'
         LifetimeRange=(Min=2.000000,Max=2.000000)
     End Object
     Emitters(5)=SpriteEmitter'U2FX_EMPGrenadeFX.SpriteEmitter18'

     AutoDestroy=True
     bNoDelete=False
}
