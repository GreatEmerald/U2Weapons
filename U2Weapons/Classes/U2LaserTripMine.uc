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
// todo: figure out why Touch() doesn't work, clientside removal of laser fx.
// UT2004 implementation by GreatEmerald, 2009
//-----------------------------------------------------------

class U2LaserTripMine extends U2MineBase
	placeable;

//-----------------------------------------------------------------------------

var() array< class<U2TripLaser> > TeamLaserEffects;
var() U2TripLaser LaserFX;
var vector StartPt, EndPt;				// endpoints of laser
var actor EndActor;						// actor that the end of the laser hit
var vector BasedLocation;				// cached location so that we can explode in the right place when un-based.
var bool bTripped;

//-----------------------------------------------------------------------------

replication
{
	reliable if( bNetDirty && Role==ROLE_Authority )
		StartPt, EndPt, EndActor;
}

//-----------------------------------------------------------------------------

simulated event PreBeginPlay()
{
	Super.PreBeginPlay();

	// On the client, use a timer to wait the arming delay before
	// spawning the laser.  On the server, this is accomplished through state code
	// of the parent class in the Armed state.  Since these are instantly placed,
	// and not tossed, they should be armed at the same time on client and server.
	if ( Level.NetMode == NM_Client )
		SetTimer(ArmingDelay, False);

}

//-----------------------------------------------------------------------------

simulated event Timer()
{
	CreateTheLaserBeam();
}

//-----------------------------------------------------------------------------

simulated event Destroyed()
{
	if( LaserFX!=none )
	{
		LaserFX.Kill();
		LaserFX = None;
	}
	Super.Destroyed();
}

//-----------------------------------------------------------------------------

simulated function CreateTheLaserBeam()
{
	local int EffectsIndex;

	EffectsIndex = GetTeam();
	if( EffectsIndex < TeamLaserEffects.Length )
	{
		if( LaserFX==none )
		{
			LaserFX = Spawn(TeamLaserEffects[EffectsIndex],Self,,StartPt);
			LaserFX.SetOwner(Self);
			LaserFX.AddConnectionEx( StartPt, EndPt, EndActor );
//			LaserFX.DamageAmount = 0;
			BasedLocation = StartPt;
		}
	}
}

//-----------------------------------------------------------------------------

function Explode()
{
	SetLocation( BasedLocation );
	//AddCylinder( BasedLocation, DamageRadius, DamageRadius );
	Super.Explode();
}

//-----------------------------------------------------------------------------

auto state Deployed
{
/*
	function BeginState()
	{
		Super.BeginState();
		GotoState('Armed');
	}
*/
Begin:
	Sleep(ArmingDelay);
	GotoState('Armed');
}

//-----------------------------------------------------------------------------

state Armed
{
	event Touch(Actor Other)
	{
		if( LaserFX!=none )
			Super.Touch( Other );
	}

	//-------------------------------------------------------------------------

	function PostArmed()
	{
		Super.PostArmed();
		CreateTheLaserBeam();
	}

	//-------------------------------------------------------------------------

	function HandleTripped()
	{
		if( !bTripped )
		{
			Super.HandleTripped();
			bTripped = true;
		}
	}

	//-------------------------------------------------------------------------

	singular event BaseChange()
	{
		if( LaserFX!=none )
			HandleTripped();
	}
}

//-----------------------------------------------------------------------------

function int GetConsumerClassIndex() { return 6; }

//-----------------------------------------------------------------------------

defaultproperties
{
     TeamLaserEffects(0)=Class'U2TripLaserRed'
     TeamLaserEffects(1)=Class'U2TripLaserBlue'
     DeploySound=Sound'U2XMPA.LaserTripMines.LM_Activate'
     ArmingSound=Sound'U2XMPA.LaserTripMines.LM_Armed'
     TrippedSound=Sound'U2XMPA.LaserTripMines.LM_Tripped'
     AmbientNoiseSound=Sound'U2XMPA.LaserTripMines.LM_Ambient'
     ArmingDelay=2.000000
     ExplodeDelay=0.200000
     EnergyCostPerSec=0.001500
     DamageAmount=90.000000
     DamageRadius=512.000000
     DamageType=Class'U2DamTypeLaserTripMine'
     Momentum=600000.000000
     Description="Laser Trip Mine"
     AlternateSkins(0)=Shader'XMPWorldItemsT.items.LASERTRIPMINE_SD_001_RED'
     AlternateSkins(1)=Shader'XMPWorldItemsT.items.lasertripmine_sd_001_blue'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'XMPWorldItemsM.items.Laser_Tripmine_001'
     bIgnoreEncroachers=False
     bAlwaysRelevant=True
     bHardAttach=True
     SoundVolume=30
     CollisionRadius=9.000000
     CollisionHeight=9.000000
     bBlockKarma=True
}
