/*
 * Copyright (c) 2010, 2013 Dainius "GreatEmerald" Masiliūnas
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
// ShieldRewardRules.uc
// Adds the functionality of dropping remaining shields on death.
// GreatEmerald and Infernus, 2010
//-----------------------------------------------------------
class ShieldRewardRules extends GameRules;

function bool PreventDeath(Pawn Killed, Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	local ShieldReward DroppedShield;

	if(Killed != None && Killed.ShieldStrength > 0)
	{
		DroppedShield = Spawn(Class'ShieldReward',,,Killed.Location, Killed.Rotation);
		if (DroppedShield == None)
		    Warn("Could not fit the dropped shield in!");
		else
		{
            //DroppedShield.InitDroppedPickup();
            DroppedShield.JustDied = Killed;
		    DroppedShield.InitDrop(Killed.ShieldStrength);
		}
	}

	return Super.PreventDeath(Killed, Killer, DamageType, HitLocation);
}

DefaultProperties
{

}
