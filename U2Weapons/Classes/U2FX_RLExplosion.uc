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
// XMPRLExplosion.uc
// 2004 alexdobie
// 5 November 2004
//-----------------------------------------------------------

class U2FX_RLExplosion extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter334
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(1)=(RelativeTime=0.250000,Color=(B=225,G=225,R=225))
         ColorScale(2)=(RelativeTime=0.500000,Color=(B=173,G=173,R=173))
         ColorScale(3)=(RelativeTime=1.000000)
         Opacity=0.500000
         MaxParticles=24
         StartLocationRange=(X=(Min=-16.000000,Max=16.000000),Y=(Min=-16.000000,Max=16.000000),Z=(Min=-8.000000,Max=16.000000))
         SpinsPerSecondRange=(X=(Min=-0.250000,Max=0.250000))
         StartSpinRange=(X=(Min=-9.000000,Max=9.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=16.000000,Max=32.000000))
         InitialParticlesPerSecond=450.000000
         Texture=Texture'SpecialFX.Explode_primary.bigexplodeaa_tw014'
         LifetimeRange=(Min=0.450000,Max=0.500000)
         StartVelocityRange=(X=(Min=-128.000000,Max=128.000000),Y=(Min=-128.000000,Max=128.000000),Z=(Min=32.000000,Max=96.000000))
     End Object
     Emitters(0)=SpriteEmitter'U2FX_RLExplosion.SpriteEmitter334'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter335
         UseCollision=True
         UseMaxCollisions=True
         RespawnDeadParticles=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         UseSubdivisionScale=True
         UseRandomSubdivision=True
         Acceleration=(Z=-100.000000)
         DampingFactorRange=(X=(Min=0.200000,Max=0.250000),Y=(Min=0.200000,Max=0.250000),Z=(Min=0.200000,Max=0.250000))
         MaxCollisions=(Min=1.000000,Max=1.000000)
         MaxParticles=20
         StartSizeRange=(X=(Min=2.000000,Max=4.000000),Y=(Min=2.000000,Max=4.000000))
         InitialParticlesPerSecond=850.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'VMParticleTextures.TankFiringP.tankHitRocks'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=1.000000,Max=1.250000)
         StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=-200.000000,Max=200.000000))
         MaxAbsVelocity=(X=5000.000000,Y=5000.000000,Z=5000.000000)
     End Object
     Emitters(1)=SpriteEmitter'U2FX_RLExplosion.SpriteEmitter335'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter336
         UseDirectionAs=PTDU_Up
         UseCollision=True
         UseMaxCollisions=True
         UseColorScale=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ScaleSizeYByVelocity=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-400.000000)
         MaxCollisions=(Min=1.000000,Max=4.000000)
         ColorScale(1)=(Color=(B=22,G=116,R=241))
         ColorScale(2)=(Color=(B=40,G=183,R=251))
         ColorScale(3)=(RelativeTime=1.000000)
         MaxParticles=20
         StartLocationRange=(X=(Min=-16.000000,Max=16.000000),Y=(Min=-16.000000,Max=16.000000),Z=(Min=2.000000,Max=8.000000))
         SizeScale(0)=(RelativeTime=0.750000,RelativeSize=1.500000)
         StartSizeRange=(X=(Min=3.000000,Max=5.000000))
         ScaleSizeByVelocityMultiplier=(Y=0.035000)
         InitialParticlesPerSecond=450.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'AW-2004Particles.Energy.SparkHead'
         StartVelocityRange=(X=(Min=-400.000000,Max=400.000000),Y=(Min=-400.000000,Max=400.000000),Z=(Min=128.000000,Max=512.000000))
     End Object
     Emitters(2)=SpriteEmitter'U2FX_RLExplosion.SpriteEmitter336'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter337
         UseColorScale=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(1)=(RelativeTime=0.250000,Color=(B=124,G=142,R=167))
         ColorScale(2)=(RelativeTime=0.750000,Color=(B=147,G=171,R=198))
         ColorScale(3)=(RelativeTime=1.000000)
         ColorScaleRepeats=1.000000
         Opacity=0.075000
         MaxParticles=1
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=128.000000)
         StartSizeRange=(X=(Min=2.000000,Max=2.000000))
         InitialParticlesPerSecond=8.000000
         Texture=Texture'AW-2004Particles.Energy.SmoothRing'
         LifetimeRange=(Min=0.250000,Max=0.250000)
     End Object
     Emitters(3)=SpriteEmitter'U2FX_RLExplosion.SpriteEmitter337'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter338
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Opacity=0.125000
         FadeOutStartTime=0.750000
         FadeInEndTime=0.250000
         SpinsPerSecondRange=(X=(Min=-0.125000,Max=0.125000))
         StartSpinRange=(X=(Min=-8.000000,Max=8.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=16.000000)
         StartSizeRange=(X=(Min=8.000000,Max=8.000000))
         InitialParticlesPerSecond=4.000000
         DrawStyle=PTDS_Darken
         Texture=Texture'SpecialFX.Smoke.smokestill02_tw'
         LifetimeRange=(Min=1.250000,Max=1.500000)
         InitialDelayRange=(Min=0.450000,Max=0.500000)
         StartVelocityRange=(X=(Min=-16.000000,Max=16.000000),Y=(Min=-16.000000,Max=16.000000),Z=(Min=32.000000,Max=64.000000))
     End Object
     Emitters(4)=SpriteEmitter'U2FX_RLExplosion.SpriteEmitter338'

     AutoDestroy=True
     bNoDelete=False
}
