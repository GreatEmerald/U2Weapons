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

class U2FieldGenerator extends U2DeployedUnit;

struct TFGLink
{
	var U2FieldGenerator		LinkFG;
	var U2ForceWall        	LinkFW;
};

// properties which control force wall behavior
var float LinkRadius;
var int	NumPriLinks;
var int	NumAltLinks;
var float CosMinAngle;
var float TraceTolerance;
var Sound LinkSound;
var Sound UnlinkSound;

var int AvailableLinks;			// number of available links (=FGLinks.Length)
var int NumLinks;				// number of active links

var bool bDidShutDownDestroy;	// recursion lockout
var bool bOneLinkOnly;

// Link array.
var	TFGLink FGLinks[2];

replication
{
	reliable if( bNetDirty && ROLE == ROLE_Authority )
		AvailableLinks; // data replicated to client
}

function Initialize( bool AltActivate )
{
	Super.Initialize( AltActivate );

	if( !AltActivate )
		AvailableLinks = NumPriLinks;
	else
		AvailableLinks = NumAltLinks;

    /*log("U2: Available links:"$AvailableLinks);
	FGLinks.Length = AvailableLinks;
	log("U2: FGLinks length:"$FGLinks.Length);

	if (AltActivate)
	    bOneLinkOnly = True;
    else
        bOneLinkOnly =  False; */

	NumLinks = 0;
}

event Destroyed()
{
	if( !bDidShutDownDestroy )
		ShutDownDeployedUnit( true );

	Super.Destroyed();
}

function int GetLinkIndex( U2FieldGenerator F )
{
	local int i;

	for( i=0; i<AvailableLinks; i++ )
	{
		if( FGLinks[i].LinkFG == F )
			return i;
	}

	return -1;
}

function int GetFirstFreeSlot()
{
	local int i;
	local int Retval;

	Retval = -1;
	for( i=0; i<AvailableLinks; i++ )
	{
		if( FGLinks[i].LinkFG == None )
		{
			Retval = i;
			break;
		}
	}
	return Retval;
}

function Unlink( int UnlinkSlot, bool bDestroyWall )
{
	// Unlinks the given slot
	FGLinks[UnlinkSlot].LinkFG = None;
	if( bDestroyWall && FGLinks[UnlinkSlot].LinkFW != None && !FGLinks[UnlinkSlot].LinkFW.bDeleteMe )
        FGLinks[UnlinkSlot].LinkFW.Destroy();

	PlaySound( UnlinkSound, SLOT_None );
	FGLInks[UnlinkSlot].LinkFW = None;
	AmbientSound = default.AmbientSound;
	NumLinks--;
}

function ShutDownDeployedUnit( bool bDestroyed, optional Pawn P )
{
	local int i;

	for( i=0; i<AvailableLinks; i++ )
	{
		if( FGLinks[i].LinkFG != None )
		{
			FGLinks[i].LinkFG.Unlink( FGLinks[i].LinkFG.GetLinkIndex( Self ), false );
			Unlink( i, true );
		}
	}

	bDidShutDownDestroy = true;
	Super.ShutDownDeployedUnit( bDestroyed, P );
}

function DisableUnit()
{
	local int i;

	// Disable all links
	for( i=0; i<AvailableLinks; i++ )
	{
		if( FGLinks[i].LinkFW != None && FGLinks[i].LinkFW.IsEnabled() )
			FGLinks[i].LinkFW.DisableUnit();
	}

	Super.DisableUnit();
}

function EnableUnit()
{
	local int i;
    for( i=0; i<AvailableLinks; i++ )
	{
		if( FGLinks[i].LinkFW != None && !FGLinks[i].LinkFW.IsEnabled() )
			FGLinks[i].LinkFW.EnableUnit();
	}

	Super.EnableUnit();
}

simulated event bool IgnoreEncroachingMovement( actor Other )
{
	return true;
}

function TakeDamage( int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType )
{
	local int i;

	Super.TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );

	if( !bDeleteMe )
	{
		for( i=0; i<AvailableLinks; i++ )
		{
			if( FGLinks[i].LinkFW != None  )
				FGLinks[i].LinkFW.TookHit();
		}
	}
}

function ForceWallTakeDamage( int Damage, Pawn InstigatedBy )
{
	Super.TakeDamage( Damage, InstigatedBy, vect(0,0,0), vect(0,0,0), class'Crushed' );
}

function AddLink( U2FieldGenerator OtherFG, U2ForceWall FW, int LinkSlot )
{
    if (LinkSlot > (AvailableLinks - 1)) //GE: We do nothing if current slot is 1, and AL is only 1.
        return;
    FGLinks[ LinkSlot ].LinkFG = OtherFG;
	FGLinks[ LinkSlot ].LinkFW = FW;
	PlaySound( LinkSound, SLOT_None );
	AmbientSound = class'U2ForceWall'.default.AmbientSound;
	NumLinks++;
}

function U2ForceWall CreateForceWall( U2FieldGenerator StartFG, U2FieldGenerator EndFG )
{
	local U2ForceWall FW;

	FW = Spawn( class'U2ForceWall', , , (StartFG.Location + EndFG.Location)/2 );

	if( StartFG.bDeleteMe || EndFG.bDeleteMe )
	{
        FW.Destroy();
		return None;
	}
	FW.SetOwner( Owner );
	FW.Initialize( StartFG, EndFG, GetTeamNum() );
	return FW;
}

function AddLinks( U2FieldGenerator F, int LinkSlot )
{
	local U2ForceWall FW;

    if (F == None)
        return;

	// Create force field
	FW = CreateForceWall( Self, F );
	if( FW != none )
	{
		AddLink( F, FW, LinkSlot );
		F.AddLink( Self, FW, F.GetFirstFreeSlot() );
	}
}

function int ForceWallIndex( U2FieldGenerator F )
{
	local int i;
	local int Retval;

	Retval = -1;
	for( i=0; i<AvailableLinks; i++ )
	{
		if( FGLinks[i].LinkFG == F )
		{
			if( FGLinks[i].LinkFW != None )
			{
				Retval = i;
				break;
			}
		}
	}

	return Retval;
}

function bool AnglesOK( U2FieldGenerator SourceFG, U2FieldGenerator TargetFG )
{
	local vector ExistingVector, PossibleVector;
	local bool bAngleOK;
	local int i;

	PossibleVector = TargetFG.Location - SourceFG.Location;
	PossibleVector.Z = 0;
	PossibleVector = Normal( PossibleVector );

	bAngleOK = true;
	for( i=0; i<SourceFG.AvailableLinks; i++ )
	{
		if( SourceFG.FGLinks[ i ].LinkFG != None )
		{
			ExistingVector = SourceFG.FGLinks[ i ].LinkFG.Location - SourceFG.Location;
			ExistingVector.Z = 0;
			ExistingVector = Normal( ExistingVector );

			if( (ExistingVector dot PossibleVector) > CosMinAngle )
			{
				bAngleOK = false;
				break;
			}
		}
	}

	return bAngleOK;
}

function bool TraceCheck( U2FieldGenerator TraceToFG )
{
	local vector HitLocation, HitNormal;
    local actor HitActor;
    HitActor = Trace(HitLocation, HitNormal, TraceToFG.Location, Location);

    return((    (HitActor == None || HitActor == TraceToFG || Pawn(HitActor) != None) ||
                (TraceToFG.AvailableLinks >= 1 && TraceToFG.FGLinks[0].LinkFW != none && HitActor == TraceToFG.FGLinks[0].LinkFW) ||
                (TraceToFG.AvailableLinks >= 2 && TraceToFG.FGLinks[1].LinkFW != none && HitActor == TraceToFG.FGLinks[1].LinkFW)
           ) &&
            (U2ForceWallPart(HitActor) == none) &&
            !HitActor.bWorldGeometry);
}

function bool CanLinkTo( U2FieldGenerator FG )
{
	if( FG == Self )
		return false;

	if( !FG.bActive )
		return false;

	if( !FG.bEnabled )
		return false;

	if( FG.GetTeamNum() != GetTeamNum() )
		return false;

	if( FG.NumLinks >= FG.AvailableLinks )
		return false;

	if( GetLinkIndex( FG ) != -1 )
		return false;

	if( !TraceCheck( FG ) )
		return false;

	return true;
}

function CheckForLinks()
{
	local int i, j;
	local Controller C;
	local U2FieldGenerator FG;
	local array<U2FieldGenerator> SortedFGs;
	local int StartCandidate;
	local float FGDistance;

	// build a list of candidate FGs in the area sorted by increasing distance
	//foreach VisibleCollidingActors( class'FieldGenerator', FG, LinkRadius ) // FGs getting blocked by forcewalls?
	for( C=Level.ControllerList; C!=None; C=C.NextController )
	{
		FG = U2FieldGenerator( C.Pawn );
		if( FG == None )
			continue;

		FGDistance = VSize( FG.Location - Location );
		//DMTN( "  FGDistance: " $ FGDistance );
		if( FGDistance > LinkRadius )
			continue;

		if( CanLinkTo( FG ) )
		{
			// insert into array with closest first
			i = 0;
			while( i < SortedFGs.Length && VSize( SortedFGs[ i ].Location - Location ) < FGDistance )
				i++;

			// insert at i after moving everything else down
			SortedFGs.Length = SortedFGs.Length + 1;
			for( j=SortedFGs.Length-2; j>=i; j-- )
				SortedFGs[ j+1 ] = SortedFGs[ j ];
			SortedFGs[ i ] = FG;
		}
	}

	//DMTN( "CheckForLinks found: " $ SortedFGs.Length $ " candidate FGS for " $ AvailableLinks $ " links" );

	// link to the closest candidate FGs which don't result in "bad" angles
	StartCandidate = 0;
	for( i=0; i<AvailableLinks; i++ )
	{
		if( FGLinks[ i ].LinkFG == None )
		{
			for( j=StartCandidate; j<SortedFGs.Length; j++ )
			{
				// make sure that adding this link won't create any "bad" angles (angles which are too acute)
				if( AnglesOK( Self, SortedFGs[ j ] ) && AnglesOK( SortedFGs[ j ], Self ))
				{
					// add it
					AddLinks( SortedFGs[ j ], i );
					StartCandidate = j+1; // if checking other link slot, start with this one
					break;
				}
			}
		}
	}
}

function CheckForEncroachingPawns()
{
	local Controller C;

	for( C=Level.ControllerList; C!=None; C=C.NextController )
	{
		if( VSize( C.Pawn.Location - Location ) < (LinkRadius + 50.0) )
		{
			if( class'U2Util'.static.DoActorCylindersIntersect( Self, C.Pawn ) )
				DamageEncroacher( C.Pawn, Pawn(Owner) );
		}
	}
}

function NotifyDeployed()
{
	Super.NotifyDeployed();

	if( AvailableLinks <= 0 )
	{
		SetTeam( 1 );
		Initialize( false );
	}
	CheckForLinks();
}

defaultproperties
{
     LinkRadius=1000.000000
     NumPriLinks=2
     NumAltLinks=1
     CosMinAngle=0.707000
     TraceTolerance=16.000000
     LinkSound=Sound'U2XMPA.FieldGenerator.FieldGeneratorLink'
     UnlinkSound=Sound'U2XMPA.FieldGenerator.FieldGeneratorUnlink'
     ExplosionClass=Class'U2FX_TurretExplosion'
     ShutDownSound=Sound'U2XMPA.FieldGenerator.FieldGeneratorShutdown'
     DestroyedAlertSound=Sound'U2XMPA.FieldGenerator.FieldGeneratorDestroyedAlert'
     DeploySound=Sound'U2XMPA.FieldGenerator.FieldGeneratorActivate'
     DisabledSound=Sound'U2XMPA.FieldGenerator.FieldGeneratorDisabled'
     EnabledSound=Sound'U2XMPA.FieldGenerator.FieldGeneratorEnabled'
     Description="Field Generator"
     InventoryType=Class'U2WeaponFieldGenerator'
     PickupMessage="You picked up a Field Generator."
     RedExplode=Class'U2FWExplosionRed'
     BlueExplode=Class'U2FWExplosionBlue'
     AlternateSkins(0)=Shader'XMPT.items.Metl_FieldGen_SD_001_Red'
     AlternateSkins(1)=Shader'XMPT.items.Metl_FieldGen_SD_001_Blue'
     Health=300
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'XMPM.items.FieldGenerator'
     DrawScale=0.110000
     PrePivot=(X=-10.000000,Y=-5.000000,Z=-20.000000)
     CollisionRadius=2.000000 //16
     CollisionHeight=70.000000
     bHasAttack=True //GE: Otherwise bots ignore them.
}
