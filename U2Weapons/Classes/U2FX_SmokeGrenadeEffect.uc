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
// XMPSmokeGrenadeEffect.uc
// (c) 2004 alexdobie
// 8 July 2004
//-----------------------------------------------------------

class U2FX_SmokeGrenadeEffect extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseCollision=True
         FadeOut=True
         FadeIn=True
         UseActorForces=True
         ResetAfterChange=True
         RespawnDeadParticles=False
         UseRevolution=True
         SpinParticles=True
         DampRotation=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         LowDetailFactor=0.850000
         DampingFactorRange=(X=(Min=8.000000,Max=8.000000),Y=(Min=8.000000,Max=8.000000),Z=(Min=8.000000,Max=8.000000))
         MaxCollisions=(Min=1.000000,Max=1.000000)
         ColorScale(0)=(Color=(A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=5.000000
         FadeInEndTime=0.400000
         MaxParticles=16
         EffectAxis=PTEA_PositiveZ
         StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Max=10.000000))
         SphereRadiusRange=(Max=10.000000)
         StartLocationPolarRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Max=5.000000))
         StartMassRange=(Min=0.000000,Max=0.000000)
         SpinCCWorCW=(X=1.000000,Y=0.000000,Z=0.000000)
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000),Y=(Min=-0.240000,Max=0.240000),Z=(Min=-0.240000,Max=0.240000))
         StartSpinRange=(X=(Min=-0.750000,Max=0.750000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.050000,RelativeSize=3.500000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=135.000000,Max=150.000000),Y=(Min=135.000000,Max=150.000000),Z=(Max=150.000000))
         ScaleSizeByVelocityMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
         ScaleSizeByVelocityMax=0.000000
         InitialParticlesPerSecond=25.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'SpecialFX.Smoke.smokestill12_tw128'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=26.000000,Max=20.000000)
         StartVelocityRange=(X=(Min=500.000000,Max=1500.000000),Y=(Min=500.000000,Max=1500.000000),Z=(Min=500.000000,Max=1500.000000))
         StartVelocityRadialRange=(Min=50.000000,Max=50.000000)
         MaxAbsVelocity=(X=1500.000000,Y=1500.000000,Z=1000.000000)
         VelocityLossRange=(X=(Max=4.000000),Y=(Max=4.000000),Z=(Max=4.000000))
         GetVelocityDirectionFrom=PTVD_StartPositionAndOwner
     End Object
     Emitters(0)=SpriteEmitter'U2FX_SmokeGrenadeEffect.SpriteEmitter0'

     AutoDestroy=True
     bNoDelete=False
     bNetTemporary=True
     RemoteRole=ROLE_SimulatedProxy
}
