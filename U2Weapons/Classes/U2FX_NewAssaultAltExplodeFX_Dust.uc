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
//
//  Particle effect for Assault Rifle altfire projectile explosion
//
//  Written by Alex Dobie
//  (c) 2005, Free Monkey Interactive.  All Rights Reserved
// ====================================================================
class U2FX_NewAssaultAltExplodeFX_Dust extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter8
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
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=2.000000
         MaxParticles=5
         SphereRadiusRange=(Min=50.000000,Max=100.000000)
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         RotationDampingFactorRange=(X=(Min=0.100000,Max=0.250000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=0.250000)
         StartSizeRange=(X=(Min=2.000000,Max=5.000000),Y=(Min=2.000000,Max=5.000000),Z=(Min=2.000000,Max=5.000000))
         InitialParticlesPerSecond=850.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'VMParticleTextures.TankFiringP.tankHitRocks'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         SecondsBeforeInactive=2.000000
         StartVelocityRange=(X=(Min=-35.000000,Max=35.000000),Y=(Min=-35.000000,Max=35.000000),Z=(Min=80.000000,Max=150.000000))
         MaxAbsVelocity=(X=5000.000000,Y=5000.000000,Z=5000.000000)
         VelocityScale(0)=(RelativeTime=0.750000,RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=3.000000,RelativeVelocity=(X=2.000000,Y=2.000000))
     End Object
     Emitters(3)=SpriteEmitter'U2FX_NewAssaultAltExplodeFX_Dust.SpriteEmitter8'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter9
         UseCollision=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=5.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.540000
         FadeOutStartTime=1.920000
         MaxParticles=3
         SpinsPerSecondRange=(X=(Max=0.200000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=20.000000,Max=60.000000),Y=(Min=20.000000,Max=60.000000),Z=(Min=20.000000,Max=60.000000))
         InitialParticlesPerSecond=1000.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'SpecialFX.Debris.Dirtexplode5_tw128'
         StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Max=15.000000))
     End Object
     Emitters(4)=SpriteEmitter'U2FX_NewAssaultAltExplodeFX_Dust.SpriteEmitter9'

     AutoDestroy=True
     bNoDelete=False
}
