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
// 25 July 2004
//-----------------------------------------------------------

class U2StationaryPawnController extends AIController;

var Controller KillerController; //GE: Actually utilised only in Proximity Sensor controller.
var bool bShouldLive; //GE: To prevent Accessed Nones and chaos on round ends.

simulated function SetTeam(int NewTeam)
{
    if( U2StationaryPawn(Pawn) != None )
		U2StationaryPawn(Pawn).Team = NewTeam;
}

//-----------------------------------------------------------------------------

function MaybeInheritEnemy( Pawn Other, Pawn NewEnemy, optional bool bCanSee );

//-----------------------------------------------------------------------------

function PawnDied(Pawn P)
{
	if ( Pawn != P )
		return;
	if ( Pawn != None )
	{
		SetLocation(Pawn.Location);
		Pawn.UnPossessed();
	}
	Pawn = None;
	PendingMover = None;
	if (!bShouldLive)
        Destroy();
}

//-----------------------------------------------------------------------------

auto state Active
{
	ignores EnemyNotVisible, HearNoise, NotifyLanded, NotifyPhysicsVolumeChange, NotifyHeadVolumeChange, NotifyLanded, NotifyHitWall, NotifyBump;
}

//-----------------------------------------------------------------------------

function RoundHasEnded()
{
    if ( Pawn != None )
        Pawn.bNoWeaponFiring = true;
    bShouldLive = true; //GE: We kill it in Reset().
    GotoState('RoundEnded');
}

/*function GameHasEnded()
{
    if ( Pawn != None )
        Pawn.bNoWeaponFiring = true;
    bShouldLive = true; //GE: We kill it in Reset().
    GotoState('GameEnded');
} */

state GameEnded
{
ignores SeePlayer, HearNoise, KilledBy, NotifyBump, HitWall, NotifyPhysicsVolumeChange, NotifyHeadVolumeChange, Falling, TakeDamage, ReceiveWarning;

    function BeginState()
    {
        if ( Pawn != None )
        {
            if ( Pawn.Weapon != None )
                Pawn.Weapon.HolderDied();
            Pawn.SimAnim.AnimRate = 0;
            Pawn.TurnOff();
            Pawn.UnPossessed();
            Pawn = None;
        }
/*        if ( !bIsPlayer && !bShouldLive)
            Destroy(); */
    }
}

state RoundEnded
{
ignores SeePlayer, HearNoise, KilledBy, NotifyBump, HitWall, NotifyPhysicsVolumeChange, NotifyHeadVolumeChange, Falling, TakeDamage, ReceiveWarning;

    function BeginState()
    {
        if ( Pawn != None )
        {
            if ( Pawn.Weapon != None )
                Pawn.Weapon.HolderDied();
            Pawn.SimAnim.AnimRate = 0;
            Pawn.TurnOff();
            Pawn.UnPossessed();
            Pawn = None;
        }
        if ( !bIsPlayer && !bShouldLive)
            Destroy();
    }
}

defaultproperties
{
     bAdjustFromWalls=False
     //PlayerReplicationInfoClass=Class'U2TurretReplicationInfo'
     bIsPlayer=False
     bShouldLive=False
}
