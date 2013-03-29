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
// U2ProjectileSmokeGrenade.uc
// Projectile class of Smoke Grenade
// Smokescreen!
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2ProjectileSmokeGrenade extends U2Grenade;

//GE: TODO: add an 'invisibility' field - makes everyone inside less aware of
// the surroundings and less accurate. Collision radius 800, height 500+prepivot of +100Z
// Idea: Invisibility deployable for UT3?

simulated function XExplode(vector HitLocation, vector HitNormal, actor HitActor)
{
    local vector SpawnPlace;

    Super.XExplode(HitLocation, HitNormal, HitActor);
    SpawnPlace = Location;
    SpawnPlace.Z += 100;
    spawn(class'U2SmokeProxy',,,SpawnPlace);
}

defaultproperties
{
     MyDamageType=Class'U2Weapons.U2DamTypeSmokeGrenade'
     ExplosionEffect=Class'U2FX_SmokeGrenadeEffect'
     ExplosionSound=Sound'WeaponsA.GrenadeLauncher.GL_ExplodeSmoke'
     Damage=5.000000
     DamageRadius=50.000000
}
