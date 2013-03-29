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
// 4 July 2005
//
//-----------------------------------------------------------
class U2FX_Hit extends Effects;

var(HitEffect) class<Actor> HitEffectDefault;
var(HitEffect) class<Actor> HitEffectRock;
var(HitEffect) class<Actor> HitEffectDirt;
var(HitEffect) class<Actor> HitEffectMetal;
var(HitEffect) class<Actor> HitEffectWood;
var(HitEffect) class<Actor> HitEffectPlant;
var(HitEffect) class<Actor> HitEffectFlesh;
var(HitEffect) class<Actor> HitEffectIce;
var(HitEffect) class<Actor> HitEffectSnow;
var(HitEffect) class<Actor> HitEffectWater;
var(HitEffect) class<Actor> HitEffectGlass;

static function class<Actor> GetHitEffect( Actor Victim, Vector HitLocation, Vector HitNormal )
{
    if ( Victim == None )
        return Default.HitEffectDefault;

	if ( Victim.IsA('UnrealPawn') )
		return Default.HitEffectFlesh;

	if ( Victim.IsA('TerrainInfo') )
		return Default.HitEffectDirt;

    switch (Victim.SurfaceType)
    {
        case EST_Rock:
            return Default.HitEffectRock;
        case EST_Dirt:
            return Default.HitEffectDirt;
        case EST_Metal:
            return Default.HitEffectMetal;
        case EST_Wood:
            return Default.HitEffectWood;
        case EST_Plant:
            return Default.HitEffectPlant;
        case EST_Flesh:
            return Default.HitEffectFlesh;
        case EST_Ice:
            return Default.HitEffectIce;
        case EST_Snow:
            return Default.HitEffectSnow;
        case EST_Water:
            return Default.HitEffectWater;
        case EST_Glass:
            return Default.HitEffectGlass;
        default:
            return Default.HitEffectDefault;
    }
}

defaultproperties
{
     HitEffectDefault=Class'U2FX_WallHitEffect'
     HitEffectRock=Class'U2FX_WallHitEffect'
     HitEffectDirt=Class'U2FX_DirtHitEffect'
     HitEffectMetal=Class'XEffects.xHeavyWallHitEffect'
     HitEffectWood=Class'XEffects.pclImpactSmoke'
     HitEffectPlant=Class'XEffects.pclImpactSmoke'
     HitEffectFlesh=Class'XEffects.BloodSmallHit'
     HitEffectIce=Class'U2FX_WallHitEffect'
     HitEffectSnow=Class'U2FX_WallHitEffect'
     HitEffectWater=Class'U2FX_WallHitEffect'
     HitEffectGlass=Class'XEffects.xHeavyWallHitEffect'
}
