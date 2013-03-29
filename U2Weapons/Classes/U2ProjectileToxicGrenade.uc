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
// U2ProjectileToxicGrenade.uc
// Projectile class of Toxic Grenade
// *cough*
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2ProjectileToxicGrenade extends U2Grenade;

simulated function XExplode(vector HitLocation, vector HitNormal, actor HitActor)
{
  Super.XExplode(HitLocation, HitNormal, HitActor);
  spawn(class'U2Weapons.U2HurterProxy_Gas',self);
}

defaultproperties
{
     Damage=55.000000
     MyDamageType=Class'U2Weapons.U2DamTypeToxicGrenade'
     ExplosionEffect=Class'U2FX_ToxicEffect'
     ExplosionSound=Sound'WeaponsA.GrenadeLauncher.GL_ExplodeToxic'
     bDurational=True
     DamageRadius=50.000000
     MomentumTransfer=10000.000000
}
