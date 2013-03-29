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
// XMPEMPExplosion.uc
// 2004 jasonyu
// 27 June 2004
//-----------------------------------------------------------

class U2FX_EMPExplosion extends Effects;

var() Sound ExplosionSound;

simulated function PreBeginPlay()
{
	local Emitter Particles;

	Super.PreBeginPlay();
	if (bPendingDelete || Level.NetMode == NM_DedicatedServer)
		return;

//	Particles = Spawn(class'XMP_Rapt_ShockAltExplodeFX');
	Particles = Spawn(class'U2FX_ShockAltExplodeFX');
//	Particles.Trigger( Self, Instigator );
//	Particles.SetParticleLifeSpan( Particles.GetMaxLifeSpan() + Particles.TimerDuration );

	PlaySound( ExplosionSound );
}

simulated event Tick( float DeltaTime )
{
	LightBrightness = default.LightBrightness * LifeSpan / default.LifeSpan;
}

defaultproperties
{
     ExplosionSound=Sound'WeaponsA.EnergyRifle.ER_EMPExplode'
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=150
     LightSaturation=150
     LightBrightness=255.000000
     LightRadius=10.000000
     bHidden=True
     bDynamicLight=True
     LifeSpan=0.500000
     TransientSoundRadius=500.000000
}
