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
//  Class:  XMP_RaptFX.XMP_Rapt_ShockAltExplodeFX
//
//  Shock Lance Alternate Fire Explosion Effect
//
//  Written by Alex Dobie
//  (c) 2004, Free Monkey Interactive.  All Rights Reserved
// ====================================================================
class U2FX_ShockAltExplodeFX extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         UseCollision=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         BlendBetweenSubdivisions=True
         FadeOutStartTime=0.500000
         MaxParticles=30
         SpinsPerSecondRange=(X=(Min=10.000000,Max=10.000000))
         StartSizeRange=(X=(Min=11.000000,Max=11.000000),Y=(Min=11.000000,Max=11.000000),Z=(Min=11.000000,Max=11.000000))
         InitialParticlesPerSecond=30.000000
         Texture=Texture'AW-2004Particles.Energy.ElecPanelsP'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=1.000000,Max=1.500000)
         StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-100.000000,Max=100.000000))
     End Object
     Emitters(0)=SpriteEmitter'U2FX_ShockAltExplodeFX.SpriteEmitter5'

     Begin Object Class=SpriteEmitter Name=CoreX
         FadeOut=True
         RespawnDeadParticles=False
         ZTest=False
         ZWrite=True
         SpinParticles=True
         UseSizeScale=True
         UseAbsoluteTimeForSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         FadeOutStartTime=0.250000
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=2.000000,Max=2.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
         InitialParticlesPerSecond=10.000000
         Texture=Texture'EmitterTextures.Flares.EFlareP2'
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(1)=SpriteEmitter'U2FX_ShockAltExplodeFX.CoreX'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter7
         UseCollision=True
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-100.000000)
         ColorScale(0)=(Color=(B=255,G=113,R=159))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=94,R=142))
         FadeOutStartTime=2.000000
         SpinsPerSecondRange=(X=(Min=1.000000,Max=10.000000))
         StartSizeRange=(X=(Min=10.000000,Max=20.000000),Y=(Min=10.000000,Max=20.000000),Z=(Min=10.000000,Max=20.000000))
         InitialParticlesPerSecond=10.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar2'
         StartVelocityRange=(X=(Min=-80.000000,Max=80.000000),Y=(Min=-80.000000,Max=80.000000),Z=(Max=100.000000))
     End Object
     Emitters(2)=SpriteEmitter'U2FX_ShockAltExplodeFX.SpriteEmitter7'

     AutoDestroy=True
     bNoDelete=False
}
