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
// U2FireRocket.uc
// Fire class of a Rocket
// What, haven't seen a rocket?
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2FireRocket extends U2ProjectileFire;

defaultproperties
{
     AmmoClass=Class'U2Weapons.U2AmmoRocketLauncher'
     ProjectileClass=Class'U2Weapons.U2ProjectileRocket'

     ProjSpawnOffset=(X=10.000000,Y=19.000000,Z=4.000000)
     FireLastRoundSound=Sound'WeaponsA.RocketLauncher.RL_FireLastRound'
     FireLastReloadTime=4.000000
     FireLastReloadAnimRate=1.0625
     FireLastRoundTime=2.170000
     FireLastDownAnimRate=4.6875
     bSplashDamage=True
     bSplashJump=True
     bRecommendSplashDamage=True
     FireSound=Sound'WeaponsA.RocketLauncher.RL_Fire'
     FireRate=1.080000
     BotRefireRate=0.500000
     WarnTargetPct=0.900000
}
