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
// MutShieldReward.uc
// The mutator for enabling Shield Rewards.
// GreatEmerald, 2010
//-----------------------------------------------------------
class MutShieldReward extends Mutator
    config;

var GameRules GRules;

function PostBeginPlay()
{
    local GEUtilities Util;

    Super.PostBeginPlay();
    Util = Spawn(class'GEUtilities');
    Util.RegisterGameRules(class'ShieldRewardRules');
}

DefaultProperties
{
    FriendlyName="Shield Reward"
    Description="Any remaining shields are thrown from players when they are fragged. Also includes Unreal II-style shield pickups."
    bAddToServerPackages=True
    IconMaterialName="MutatorArt.nosym"
    ConfigMenuClassName=""
}
