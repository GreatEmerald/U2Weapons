/*
 * Copyright (c) 2009, 2013 Dainius "GreatEmerald" Masiliūnas
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
//=============================================================================
// TurretReplicationInfo.uc
// A simpler ReplicationInfo than the PlayerReplicationInfo.
// GreatEmerald, 2009
//=============================================================================

class U2TurretReplicationInfo extends PlayerReplicationInfo;
//GE: PRI is native, so can't just extend RI.

simulated event PostNetBeginPlay()
{
    if ( Team != None )
        bTeamNotified = true;
}

function SetCharacterVoice(string S)
{
    //Disable
}

function SetCharacterName(string S)
{
    //Disable
}

simulated function string GetHumanReadableName()
{
    return "";
}

simulated function string GetLocationName()
{
    return "";
}

function UpdatePlayerLocation()
{
    //Disable
}

function SetPlayerName(string S)
{
    //Disable
}

simulated function string GetCallSign()
{
    return "";
}

simulated event string GetNameCallSign()
{
    return "";
}


