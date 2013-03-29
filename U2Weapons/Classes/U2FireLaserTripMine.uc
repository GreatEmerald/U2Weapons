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
//-----------------------------------------------------------
// 2004 jasonyu
// 28 July 2004
// UT2004 implementation by GreatEmerald, 2009
//-----------------------------------------------------------

class U2FireLaserTripMine extends U2DeployableFire;

//-----------------------------------------------------------------------------

var() float MaxLaserLength;			// max length of the laser before it must hit something to properly deploy
var vector LaserStartPt;			// computed starting point of laser
var vector LaserEndPt;				// computed end point of laser
var actor LaserStartActor;			// actor hit by the starting part of the laser
var actor LaserEndActor;			// actor hit by the ending part of the laser
var int UseDistance;

//-----------------------------------------------------------------------------

simulated function DestroyEffects()
{
	Super.DestroyEffects();

    if (LaserStartActor != None)
        LaserStartActor.Destroy();
    if (LaserEndActor != None)
        LaserEndActor.Destroy();
}

//-----------------------------------------------------------------------------
// figure out where to mount the laser trip mine

function bool CalcDeploySpot( out vector DeployLocation, out rotator DeployRotation )
{
	local vector X, Y, Z;
	local Actor HitActor;
	local vector StartTrace, EndTrace, Extents, HitLocation, HitNormal;
	local rotator ViewRotation;

	if( Instigator!=none && Instigator.Controller!=none )
	{
		ViewRotation = Instigator.GetViewRotation();
		StartTrace = Instigator.Location;
		StartTrace.Z += Instigator.BaseEyeHeight;

		EndTrace = StartTrace + UseDistance * vector(ViewRotation);

		Extents.X = DeployClass.default.CollisionRadius;
		Extents.Y = DeployClass.default.CollisionRadius;
		Extents.Z = DeployClass.default.CollisionHeight;

		HitActor = Trace( HitLocation, HitNormal, EndTrace, StartTrace, true, Extents); //, , TRACE_AllBlocking );
		//AddArrow( StartTrace, EndTrace, ColorGreen() );
		//AddCylinder( HitLocation, Extents.X, Extents.Z, ColorYellow() );

		if( HitActor!=none )
		{
			GetAxes( ViewRotation, X, Y, Z );	// use the "up" (Z) direction of the pawn to orient the mine

			X = HitNormal;
			Y = Z cross X;
			Z = X cross Y;

			DeployLocation = HitLocation;
			DeployRotation = OrthoRotation(X,Y,Z);
			LaserStartActor = HitActor;
			return true;
		}
	}
	return false;
}

//-----------------------------------------------------------------------------

function bool CanDeploy( vector DeployLocation, rotator DeployRotation )
{
	local Actor HitActor;
	local vector StartTrace, EndTrace, HitLocation, HitNormal;

	if( !Super.CanDeploy( DeployLocation, DeployRotation ) )
		return false;

	// check if there's something the laser can hit
	StartTrace = DeployLocation + vector(DeployRotation)*DeployClass.default.CollisionRadius;
	EndTrace = StartTrace + vector(DeployRotation)*MaxLaserLength;
	//AddArrow( StartTrace, EndTrace, ColorCyan() );

	HitActor = Trace( HitLocation, HitNormal, EndTrace, StartTrace, true ); //, , , TRACE_AllBlocking );

	if( HitActor != None )
	{
		LaserStartPt = StartTrace;
		LaserEndPt = HitLocation;
		LaserEndActor = HitActor;
		return true;
	}
	else
	{
		return false;
	}
}

//-----------------------------------------------------------------------------

function PostDeploy( actor DeployedActor, bool bAltActivate )
{
	local U2LaserTripMine Mines;

	assert( Instigator != None );
	DeployedActor.SetPhysics( PHYS_None );

	Mines = U2LaserTripMine(DeployedActor);
	if( Mines!=none )
	{
		Mines.StartPt = LaserStartPt;
		Mines.EndPt = LaserEndPt;
		Mines.EndActor = LaserEndActor;			// pass down the actor that the laser end hit
		Mines.SetBase( LaserStartActor );		// set base of mine to mounting actor
//NOTE: attempt to get mines to stick to players without their alignment getting messed up.
//		if( Pawn(LaserStartActor)? )
//			LaserStartActor.AttachToBone( Mines, Pawn(LaserStartActor).RootBone );
		Mines.SetTeam( Instigator.GetTeamNum() );
		Mines.Instigator = Instigator;
		//AddArrow( LaserStart, LaserEnd, ColorRed() );
	}
}

//-----------------------------------------------------------------------------

defaultproperties
{
     MaxLaserLength=1500.000000
     DeployClass=Class'U2LaserTripMine'
     DeploySkillCost=0.005000
     bCanIntersectDUs=True
     bCanIntersectPawns=True
     ActivateSound=Sound'U2XMPA.LaserTripMines.LM_Activate'
     AmmoClass=Class'U2AmmoLaserTripMine'
     UseDistance=350
}
