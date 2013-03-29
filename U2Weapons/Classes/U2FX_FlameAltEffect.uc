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
// FlameAltEffect.uc
// (c) 2004 jasonyu
// 10 October 2004
//
//-----------------------------------------------------------
class U2FX_FlameAltEffect extends Emitter;

var float Time;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	Deactivate();
}

event Tick( float DeltaTime )
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

simulated event Trigger( Actor Other, Pawn EventInstigator )
{
	Activate();
	Time = 0.5;
}

simulated function bool Active()
{
	if ( Emitters[0].Disabled )
		return false;
	else
		return true;
}

simulated function Activate()
{
	local int i;
	if ( !Active() )
	{
		for( i=0; i<Emitters.Length; i++ )
		{
			if( Emitters[i] != None )
				Emitters[i].Trigger();
		}
	}
}

simulated function Deactivate()
{
	local int i;
	if ( Active() )
	{
		for( i=0; i<Emitters.Length; i++ )
		{
			if( Emitters[i] != None )
				Emitters[i].Trigger();
		}
		AmbientSound = None;
	}
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-900.000000)
         ColorScale(0)=(Color=(G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(Z=(Min=0.000000,Max=0.000000))
         FadeOutStartTime=0.330000
         CoordinateSystem=PTCS_Relative
         MaxParticles=35
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=30.000000)
         StartSizeRange=(X=(Min=4.000000,Max=4.000000),Y=(Min=4.000000,Max=4.000000),Z=(Min=4.000000,Max=4.000000))
         InitialParticlesPerSecond=35.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'SpecialFX.Leechsplat.leechsplat6_tw128'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=500.000000,Max=500.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-100.000000,Max=100.000000))
     End Object
     Emitters(0)=SpriteEmitter'U2FX_FlameAltEffect.SpriteEmitter1'

     AutoDestroy=True
     bNoDelete=False
}
