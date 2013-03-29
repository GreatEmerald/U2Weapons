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
// 25 July 2004
// UT2004 implementation by GreatEmerald, 2009
//-----------------------------------------------------------

class U2LandMine extends U2MineBase
	placeable;

//-----------------------------------------------------------------------------

var float TripDelayOverrideVelocity;		// mine will instantly explode if target is moving faster than this threshold

//-----------------------------------------------------------------------------

simulated event PostNetBeginPlay()
{
	super.PostNetBeginPlay();

	// put armed mines that are becoming relevant into the correct state
	if( Physics != PHYS_Falling )
	{
		GotoState( 'Armed' );
	}
}

//-----------------------------------------------------------------------------

auto state Deployed
{
	function Landed(vector HitNormal)
	{
		Super.Landed( HitNormal );
		bIgnoreEncroachers = true;
		GotoState( 'Armed' );
	}
}

//-----------------------------------------------------------------------------

state Armed
{
	event Touch(Actor Other)
	{
		if( VSize(Other.Velocity) > TripDelayOverrideVelocity )
			ExplodeDelay = 0.01;

		Super.Touch( Other );
	}


	//-------------------------------------------------------------------------

	event BeginState()
	{
		Super.BeginState();
		SetCollision(false,false,false);
	}
}

//-----------------------------------------------------------------------------

function int GetConsumerClassIndex() { return 4; }

//-----------------------------------------------------------------------------

defaultproperties
{
     TripDelayOverrideVelocity=1500.000000
     DeploySound=Sound'U2XMPA.LandMines.M_Activate'
     ArmingSound=Sound'U2XMPA.LandMines.M_Armed'
     TrippedSound=Sound'U2XMPA.LandMines.M_Tripped'
     ArmingDelay=2.000000
     ExplodeDelay=0.500000
     EnergyCostPerSec=0.001200
     DamageAmount=200.000000
     DamageRadius=500.000000
     DamageType=Class'U2DamTypeLandMine'
     Momentum=400000.000000
     Description="Land Mine"
     AlternateSkins(0)=Shader'XMPWorldItemsT.items.mine_sd_001_Red'
     AlternateSkins(1)=Shader'XMPWorldItemsT.items.mine_sd_001_blue'
     bDamageable=False
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'XMPWorldItemsM.items.Mine_SD_001'
     bIgnoreEncroachers=False
     Physics=PHYS_Falling
     PrePivot=(Z=40.000000)
     CollisionRadius=55.000000
     CollisionHeight=50.000000
     bUseCylinderCollision=True
}
