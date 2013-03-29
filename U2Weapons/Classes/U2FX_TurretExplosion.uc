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
// 2004 jasonyu
// 25 July 2004
//-----------------------------------------------------------

class U2FX_TurretExplosion extends Effects;

var() Sound ExplosionSound;
var class<Emitter> ExplosionEmitter;

simulated function PreBeginPlay()
{
	local Emitter Particles;

	Super.PreBeginPlay();
	if (bPendingDelete || Level.NetMode == NM_DedicatedServer)
		return;

	Particles = Spawn(ExplosionEmitter); // TODO -- use something different?

	PlaySound( ExplosionSound );
}

defaultproperties
{
     ExplosionSound=Sound'U2XMPA.RocketTurret.RocketTurretExplode'
     ExplosionEmitter=Class'U2FX_RLExplosion'
     DrawType=DT_None
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=1.000000
}
