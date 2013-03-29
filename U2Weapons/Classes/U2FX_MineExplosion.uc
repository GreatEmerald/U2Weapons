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
class U2FX_MineExplosion extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter20
         UseCollision=True
         FadeOut=True
         ResetAfterChange=True
         RespawnDeadParticles=False
         ZWrite=True
         SpinParticles=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         UseSubdivisionScale=True
         UseRandomSubdivision=True
         Acceleration=(Z=-200.000000)
         DampingFactorRange=(X=(Min=0.200000,Max=0.250000),Y=(Min=0.200000,Max=0.250000),Z=(Min=0.200000,Max=0.250000))
         MaxCollisions=(Min=1.000000,Max=1.000000)
         FadeOutStartTime=2.000000
         MaxParticles=75
         SphereRadiusRange=(Min=50.000000,Max=100.000000)
         SpinsPerSecondRange=(X=(Min=0.250000,Max=2.000000))
         RotationDampingFactorRange=(X=(Min=0.100000,Max=0.250000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=0.250000)
         StartSizeRange=(X=(Min=2.000000,Max=10.000000))
         InitialParticlesPerSecond=850.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'VMParticleTextures.TankFiringP.tankHitRocks'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         SecondsBeforeInactive=2.000000
         StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Max=600.000000))
         MaxAbsVelocity=(X=5000.000000,Y=5000.000000,Z=5000.000000)
         VelocityScale(0)=(RelativeTime=0.750000,RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=3.000000,RelativeVelocity=(X=2.000000,Y=2.000000))
     End Object
     Emitters(0)=SpriteEmitter'U2FX_MineExplosion.SpriteEmitter20'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter15
         UseCollision=True
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         ColorScale(1)=(RelativeTime=0.171429,Color=(B=56,G=56,R=56,A=255))
         ColorScale(2)=(RelativeTime=0.639286,Color=(B=77,G=77,R=77,A=255))
         ColorScale(3)=(RelativeTime=0.875000,Color=(B=53,G=53,R=53,A=255))
         ColorScale(4)=(RelativeTime=1.000000,Color=(A=255))
         ColorScale(5)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorScale(6)=(RelativeTime=1.000000)
         MaxParticles=50
         StartLocationRange=(Z=(Max=100.000000))
         SphereRadiusRange=(Min=180.000000,Max=180.000000)
         SpinsPerSecondRange=(X=(Min=-0.020000,Max=0.020000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Max=200.000000),Y=(Max=200.000000),Z=(Max=200.000000))
         InitialParticlesPerSecond=50000000.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'XMP-ECE-Content.fX.ExploTrans'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=5.000000,Max=5.000000)
         InitialDelayRange=(Min=0.150000,Max=0.150000)
         StartVelocityRange=(X=(Min=-85.000000,Max=85.000000),Y=(Min=-85.000000,Max=85.000000),Z=(Max=500.000000))
     End Object
     Emitters(1)=SpriteEmitter'U2FX_MineExplosion.SpriteEmitter15'

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
         Acceleration=(Z=15.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         MaxParticles=15
         StartLocationRange=(Z=(Min=0.500000,Max=0.500000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=1.010000)
         SizeScale(1)=(RelativeSize=2.000000)
         SizeScale(2)=(RelativeTime=0.250000,RelativeSize=3.000000)
         SizeScale(3)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=20.000000,Max=40.000000),Y=(Min=20.000000,Max=40.000000),Z=(Min=20.000000,Max=40.000000))
         InitialParticlesPerSecond=70.000000
         Texture=Texture'XMP-ECE-Content.fX.ExploTrans'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-100.000000,Max=100.000000))
     End Object
     Emitters(2)=SpriteEmitter'U2FX_MineExplosion.SpriteEmitter16'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter18
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         MaxParticles=2
         SpinsPerSecondRange=(X=(Min=1.000000,Max=1.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=0.150000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=150.000000,Max=150.000000),Y=(Min=150.000000,Max=150.000000),Z=(Min=150.000000,Max=150.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Fire.NapalmSpot'
         LifetimeRange=(Min=0.250000,Max=0.250000)
     End Object
     Emitters(3)=SpriteEmitter'U2FX_MineExplosion.SpriteEmitter18'

     Begin Object Class=MeshEmitter Name=MeshEmitter1
         StaticMesh=StaticMesh'ParticleMeshes.Complex.ExplosionSphere'
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(Y=(Min=0.750000,Max=0.750000),Z=(Min=0.750000,Max=0.750000))
         MaxParticles=1
         StartLocationRange=(Z=(Min=15.000000,Max=15.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=0.100000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=1.680000,Max=1.680000),Y=(Min=1.680000,Max=1.680000),Z=(Min=1.680000,Max=1.680000))
         InitialParticlesPerSecond=100.000000
         LifetimeRange=(Min=0.333000,Max=0.333000)
     End Object
     Emitters(4)=MeshEmitter'U2FX_MineExplosion.MeshEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter19
         RespawnDeadParticles=False
         UniformSize=True
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.000000
         MaxParticles=1
         Sounds(0)=(Sound=Sound'U2Ambient2A.Explosions.Explosion_10',Radius=(Min=250.000000,Max=250.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=256.000000,Max=256.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_LinearGlobal
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(5)=SpriteEmitter'U2FX_MineExplosion.SpriteEmitter19'

     AutoDestroy=True
     bNoDelete=False
     bDirectional=True
}
