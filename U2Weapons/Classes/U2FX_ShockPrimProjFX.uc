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
//  Class:  XMP_RaptFX.XMP_Rapt_ShockPrimProjFX
//
//  Particle effect for shock lance primary fire projectile
//                         _     _
//              _     _   (_>WTF<_)
//             (_>WTF<_)
//          _     _     _     _
//         (_>WTF<_)   (_>WTF<_)
//
//          WTF MOSQUITO ATTACK!!!11111
//
//  Written by Alex Dobie
//  (c) 2004, Free Monkey Interactive.  All Rights Reserved
// ====================================================================
class U2FX_ShockPrimProjFX extends Emitter;

simulated function DisableRegen()
{
	local int i;

	for( i=0; i<Emitters.Length; i++ )
	{
		if ( Emitters[i] != None )
			Emitters[i].RespawnDeadParticles = false;
	}

}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter9
         FadeOut=True
         SpinParticles=True
         UniformSize=True
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.700000,Max=0.700000),Y=(Min=0.500000,Max=0.500000))
         Opacity=0.850000
         FadeOutStartTime=0.100000
         MaxParticles=75
         SpinsPerSecondRange=(X=(Min=2.000000,Max=3.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=5.000000,Max=10.000000),Z=(Min=5.000000,Max=10.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'EpicParticles.Flares.SoftFlare'
         LifetimeRange=(Min=0.300000,Max=0.600000)
     End Object
     Emitters(0)=SpriteEmitter'U2FX_ShockPrimProjFX.SpriteEmitter9'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter10
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.700000,Max=0.700000),Y=(Min=0.500000,Max=0.500000))
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         SpinsPerSecondRange=(X=(Min=5.000000,Max=5.000000))
         StartSizeRange=(X=(Min=33.000000,Max=33.000000),Y=(Min=33.000000,Max=33.000000),Z=(Min=33.000000,Max=33.000000))
         InitialParticlesPerSecond=100.000000
         Texture=Texture'EpicParticles.Flares.Sharpstreaks2'
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(1)=SpriteEmitter'U2FX_ShockPrimProjFX.SpriteEmitter10'

     AutoDestroy=True
     bNoDelete=False

}
