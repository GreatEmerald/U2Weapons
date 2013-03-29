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
// Alex 'RaptoR' Dobie
// 6 November 2004
//-----------------------------------------------------------

class U2FX_FlameEffect extends Emitter;

var float Time;

simulated event Trigger( Actor Other, Pawn EventInstigator )
{
	Activate();
	Time = 0.2;
}

simulated event Tick( float DeltaTime )
{
	if( Time > 0 )
	{
		Time -= DeltaTime;
		if( Time <= 0 )
		{
			Time = 0;
			Deactivate();
			return;
		}
	}
}

simulated function bool Active()
{
	return Emitters[0].RespawnDeadParticles;
}

simulated function Activate()
{
	local int i;

	// emitters disabled at start
	for( i=0; i<Emitters.Length; i++ )
	{
		if( Emitters[i] != None )
		{
			Emitters[i].ParticlesPerSecond = 100;
			Emitters[i].InitialParticlesPerSecond = 100;
			Emitters[i].AllParticlesDead = false;
		}
	}
}

simulated function Deactivate()
{
	local int i;

	for( i=0; i<Emitters.Length; i++ )
	{
		if( Emitters[i] != None )
		{
			Emitters[i].ParticlesPerSecond = 0;
			Emitters[i].InitialParticlesPerSecond = 0;
		}
	}
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter17
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         LowDetailFactor=0.300000
         Acceleration=(Z=15.000000)
         Opacity=0.800000
         FadeOutStartTime=0.155000
         MaxParticles=100
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(1)=(RelativeTime=0.280000,RelativeSize=0.750000)
         SizeScale(2)=(RelativeTime=0.870000,RelativeSize=2.000000)
         SizeScale(3)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=1.000000),Y=(Min=1.000000),Z=(Min=1.000000))
         InitialParticlesPerSecond=400.000000
         Texture=Texture'SpecialFXB.Fire.FX_FlameThrower_001b'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.250000,Max=0.250000)
         StartVelocityRange=(X=(Min=4000.000000,Max=4000.000000),Y=(Min=-25.000000,Max=25.000000),Z=(Min=-25.000000,Max=25.000000))
     End Object
     Emitters(0)=SpriteEmitter'U2FX_FlameEffect.SpriteEmitter17'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter52
         UseCollision=True
         UseMaxCollisions=True
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         UseRandomSubdivision=True
         LowDetailFactor=0.300000
         MaxCollisions=(Min=2.000000,Max=2.000000)
         ColorScale(1)=(RelativeTime=0.003571,Color=(B=143,G=16,R=29))
         ColorScale(2)=(RelativeTime=0.250000,Color=(B=191,G=26,R=21))
         ColorScale(3)=(RelativeTime=0.550000,Color=(B=244,G=215,R=217))
         ColorScale(4)=(RelativeTime=1.000000)
         FadeOutStartTime=0.005000
         MaxParticles=46
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=3.500000)
         StartSizeRange=(X=(Min=8.000000,Max=16.000000))
         InitialParticlesPerSecond=400.000000
         Texture=Texture'SpecialFXB.Fire.FX_FlameThrower_001b'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.010000,Max=0.010000)
         StartVelocityRange=(X=(Min=20480.000000,Max=21504.000000))
     End Object
     Emitters(1)=SpriteEmitter'U2FX_FlameEffect.SpriteEmitter52'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter53
         UseColorScale=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         LowDetailFactor=0.300000
         ColorScale(1)=(RelativeTime=0.007143,Color=(B=100,G=48,R=36))
         ColorScale(2)=(RelativeTime=0.600000,Color=(B=4,G=63,R=236))
         ColorScale(3)=(RelativeTime=1.000000)
         Opacity=0.500000
         MaxParticles=24
         UseRotationFrom=PTRS_Actor
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=10.000000)
         StartSizeRange=(X=(Min=32.000000,Max=32.000000))
         InitialParticlesPerSecond=400.000000
         Texture=Texture'ScottT.u1.ut_corona_007'
         LifetimeRange=(Min=0.250000,Max=0.250000)
         StartVelocityRange=(X=(Min=4608.000000,Max=4608.000000))
     End Object
     Emitters(2)=SpriteEmitter'U2FX_FlameEffect.SpriteEmitter53'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter54
         UseCollision=True
         UseMaxCollisions=True
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         UseRandomSubdivision=True
         LowDetailFactor=0.300000
         MaxCollisions=(Min=2.000000,Max=2.000000)
         ColorScale(1)=(RelativeTime=0.300000,Color=(B=129,G=164,R=245))
         ColorScale(2)=(RelativeTime=1.000000)
         Opacity=0.250000
         StartLocationOffset=(X=640.000000)
         UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Min=-0.025000,Max=0.025000),Y=(Max=1.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.250000)
         StartSizeRange=(X=(Min=164.000000,Max=164.000000))
         InitialParticlesPerSecond=400.000000
         Texture=Texture'SpecialFX.Fire.multifire'
         TextureUSubdivisions=4
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.750000,Max=0.750000)
         StartVelocityRange=(X=(Min=128.000000,Max=256.000000))
     End Object
     Emitters(3)=SpriteEmitter'U2FX_FlameEffect.SpriteEmitter54'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter55
         UseCollision=True
         UseMaxCollisions=True
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         LowDetailFactor=0.500000
         Acceleration=(Z=-128.000000)
         DampingFactorRange=(X=(Min=0.350000,Max=0.400000),Y=(Min=0.350000,Max=0.400000),Z=(Min=0.200000,Max=0.250000))
         MaxCollisions=(Min=2.000000,Max=2.000000)
         ColorScale(1)=(RelativeTime=0.500000,Color=(B=32,G=131,R=240))
         ColorScale(2)=(RelativeTime=1.000000)
         MaxParticles=3
         UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Min=-0.125000,Max=0.125000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=2.000000,Max=2.500000))
         InitialParticlesPerSecond=8.000000
         Texture=Texture'SpecialFX.Fire.fireball_tw015'
         LifetimeRange=(Min=1.000000,Max=6.000000)
         StartVelocityRange=(X=(Min=128.000000,Max=256.000000),Y=(Min=-16.000000,Max=16.000000),Z=(Max=16.000000))
     End Object
     Emitters(4)=SpriteEmitter'U2FX_FlameEffect.SpriteEmitter55'

     AutoDestroy=True
     bNoDelete=False
     bDirectional=True
}
