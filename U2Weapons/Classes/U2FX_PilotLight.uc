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
// 2 July 2005
//
//-----------------------------------------------------------
class U2FX_PilotLight extends Emitter;

simulated function SetEmitterStatus(bool bEnabled)
{
	if(bEnabled)
	{
		Emitters[0].ParticlesPerSecond = 300.0;
		Emitters[0].InitialParticlesPerSecond = 300.0;
		Emitters[0].AllParticlesDead = false;
	}
	else
	{
		Emitters[0].ParticlesPerSecond = 0.0;
		Emitters[0].InitialParticlesPerSecond = 0.0;
	}
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=191,A=255))
         Opacity=0.750000
         CoordinateSystem=PTCS_Relative
         MaxParticles=30
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=2.000000,Max=2.000000),Y=(Min=2.000000,Max=2.000000),Z=(Min=2.000000,Max=2.000000))
         Texture=Texture'ScottT.Effects.ShockLance_Impact_001'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.010000,Max=0.010000)
         StartVelocityRange=(Z=(Max=1350.000000))
     End Object
     Emitters(0)=SpriteEmitter'U2FX_PilotLight.SpriteEmitter0'

     bNoDelete=False
     bHardAttach=True
}
