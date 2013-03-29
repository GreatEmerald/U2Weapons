/*
 * Copyright (c) 2008, 2013 Dainius "GreatEmerald" Masiliūnas
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
//-----------------------------------------------------------------------------
// U2DamTypeThermalFlaming.uc
// Damage type of the Vulcan
// Just because I don't like how it sounds. Oh, cool, skeletons!
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2DamTypeThermalFlaming extends WeaponDamageType;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictimHealth )
{
    HitEffects[0] = class'HitSmoke';

    if( VictimHealth <= 0 )
        HitEffects[1] = class'HitFlameBig';
    else if ( FRand() < 0.8 )
        HitEffects[1] = class'HitFlame';
}

defaultproperties
{
     WeaponClass=Class'U2Weapons.U2WeaponFlameThrower'
     DeathString="%o was toasted by %k's Flamethrower."
     FemaleSuicide="%o couldn't avoid the heat from her own Flamethrower."
     MaleSuicide="%o couldn't avoid the heat from his own Flamethrower."
     bSkeletize=True
     bDelayedDamage=True
     bFlaming=True
     bDetonatesGoop=True
}
