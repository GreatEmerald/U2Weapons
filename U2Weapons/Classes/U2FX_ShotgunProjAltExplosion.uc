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
class U2FX_ShotgunProjAltExplosion extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(1)=(RelativeTime=0.125000,Color=(B=255,G=255,R=255))
         ColorScale(2)=(RelativeTime=0.850000,Color=(B=224,G=224,R=224))
         ColorScale(3)=(RelativeTime=1.000000)
         FadeOutStartTime=0.400000
         FadeInEndTime=0.125000
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=-0.250000,Max=0.250000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=4.000000)
         StartSizeRange=(X=(Min=11.000000,Max=11.000000))
         InitialParticlesPerSecond=4.000000
         Texture=Texture'ScottT.u1.ut_corona_003'
         LifetimeRange=(Min=0.250000,Max=0.250000)
     End Object
     Emitters(0)=SpriteEmitter'U2FX_ShotgunProjAltExplosion.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         ColorScale(1)=(RelativeTime=0.125000,Color=(B=255,G=255,R=255))
         ColorScale(2)=(RelativeTime=0.900000,Color=(B=255,G=255,R=255))
         ColorScale(3)=(RelativeTime=1.000000)
         MaxParticles=2
         SpinsPerSecondRange=(X=(Min=-0.075000,Max=0.075000))
         StartSizeRange=(X=(Min=32.000000,Max=36.000000))
         InitialParticlesPerSecond=16.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'SpecialFX.Fire.multifire'
         TextureUSubdivisions=4
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.750000,Max=0.750000)
         InitialDelayRange=(Min=0.165000,Max=0.165000)
     End Object
     Emitters(1)=SpriteEmitter'U2FX_ShotgunProjAltExplosion.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter7
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Opacity=0.125000
         FadeOutStartTime=0.125000
         MaxParticles=4
         SpinsPerSecondRange=(X=(Min=-0.250000,Max=0.250000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=12.000000)
         StartSizeRange=(X=(Min=2.000000,Max=4.000000))
         DrawStyle=PTDS_Darken
         Texture=Texture'SpecialFX.Smoke.smokestill02_tw'
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(X=(Min=-4.000000,Max=4.000000),Y=(Min=-4.000000,Max=4.000000),Z=(Min=-4.000000,Max=4.000000))
     End Object
     Emitters(2)=SpriteEmitter'U2FX_ShotgunProjAltExplosion.SpriteEmitter7'

     AutoDestroy=True
     bNoDelete=False
}
