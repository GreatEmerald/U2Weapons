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
// 28 July 2004
// UT2004 implementation by GreatEmerald, 2009
//-----------------------------------------------------------

class U2FireDeployLandMine extends U2DeployableFire;

function PostDeploy( actor DeployedActor, bool bAltActivate )
{
	U2LandMine(DeployedActor).SetTeam( Instigator.GetTeamNum() );
	DeployedActor.Instigator = Instigator;
}

function bool DeployDestinationIsValid( vector DeployLocation, rotator DeployRotation )
{
	return true;
}

defaultproperties
{
     DeployClass=Class'U2LandMine'
     DeploySkillCost=0.005000
     bTossProjectiles=True
     bCanIntersectDUs=True
     bCanIntersectPawns=True
     ActivateSound=Sound'U2XMPA.LandMines.M_Activate'
     AmmoClass=Class'U2AmmoLandMine'
}
