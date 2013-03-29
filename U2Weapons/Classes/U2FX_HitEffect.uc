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
// XMPHitEffect.uc
// 2004 jasonyu
// 5 July 2004
//-----------------------------------------------------------

class U2FX_HitEffect extends Effects;

var() array<Sound> Sounds;
var() range Pitch;

simulated function PostNetBeginPlay()
{
	Super.PostNetBeginPlay();

	if ( Role == ROLE_Authority )
	{
		if ( Instigator != None )
			MakeNoise(0.3);
	}
	if ( Level.NetMode != NM_DedicatedServer )
		SpawnEffects();
}

simulated function SpawnEffects()
{
	if (Sounds.length>0)
		PlaySound( Sounds[Rand(Sounds.length)], SLOT_None, 1.0, false, 100.0, GetRand(Pitch), true );
}

simulated final function float GetRand(Range R)
{
    return ( R.Min + (R.Max - R.Min) * FRand() );
}

defaultproperties
{
     Pitch=(Min=0.950000,Max=1.000000)
     DrawType=DT_None
     CullDistance=7000.000000
     LifeSpan=0.100000
     Style=STY_Additive
}
