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
// 17 July 2004
//-----------------------------------------------------------

class U2FX_WallHitEffect extends U2FX_HitEffect;

simulated function SpawnEffects()
{
	local playercontroller P;
	local bool bViewed;
	local WallSparks Sparks;

	Super.SpawnEffects();

	P = Level.GetLocalPlayerController();
	if ( (P != None) && (P.ViewTarget != None) && (VSize(P.Viewtarget.Location - Location) < 1600*P.FOVBias) && ((vector(P.Rotation) dot (Location - P.ViewTarget.Location)) > 0) )
	{
		Spawn(class'BulletDecal',self,,Location, rotator(-1 * vector(Rotation)));
		bViewed = true;
	}
	if ( PhysicsVolume.bWaterVolume )
		return;

	if ( (Level.DetailMode == DM_Low) || Level.bDropDetail )
	{
		if ( bViewed && (FRand() < 0.25) )
			Spawn(class'pclImpactSmoke');
		else
			Spawn(class'WallSparks');
		return;
	}

	if ( bViewed && (FRand() < 0.5) )
		Spawn(class'pclImpactSmoke');
	Sparks = Spawn(class'WallSparks');
	Sparks.mStartParticles = 16;
	Sparks.mSizeRange[0] = 6;
	Sparks.mSizeRange[1] = 4;
}

defaultproperties
{
     Sounds(0)=Sound'WeaponsA.Impacts.BulletMetal02'
     Sounds(1)=Sound'WeaponsA.Impacts.BulletMetal03'
     Sounds(2)=Sound'WeaponsA.Impacts.RicMetal09'
     Sounds(3)=Sound'WeaponsA.Impacts.RicMetal14'
}
