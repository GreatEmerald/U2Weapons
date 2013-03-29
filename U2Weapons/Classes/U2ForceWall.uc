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
// A Force Wall.
// This is trouble.
// GreatEmerald, 2009
//=============================================================================

class U2ForceWall extends Actor;

enum FWTransition
{
	FWT_None,
	FWT_Init,
	FWT_Disable,
	FWT_Enable,
	FWT_Hit,
};

var localized string Description;

// When using the forcewall hack, we need this to keep damage reasonable
struct BeamHitInfo
{
    var Pawn LastInstigator;
    var float LastDamageTime;
    var class<DamageType> LastDamageType;
};

var float ReplicationReadyTime;
var U2FieldGenerator StartFG, EndFG;
var vector StartFGLocation, EndFGLocation;

var int TeamIndex;

// Effects
var Emitter DisabledEffect;
var Emitter ForceWallEffect;
var class<Emitter> ForceWalls[2];
var class<Emitter> DisabledForceWalls[2];

var bool bShouldSpawnEnabledFX;
var bool bShouldSpawnDisabledFX;
var bool bShouldEnable;

var int MaxDamageFromVehicle;
var float VehicleDamageRatio;
var float VehicleDamageBaseMass;
var float VehicleDamageBaseSpeed;

var bool bServerCollision, bClientCollision, bCreatedCollision;
var float WallRadius, WallHeight;

var float EnergyCostPerSec;
var() float DeployableAddPctPer;

var	bool bEnabled;

var U2ForceWallPart BeamHeads[4];

var float FieldHeight, BottomOffset;

var bool bBatchedDamageHandlerEnabled;
var float DamageAccumulator;
var Pawn LastInstigatedBy;
var float DamageTransferPct;

var() class<U2DamageFilter> DamageFilterClass;

var FWTransition PendingTransitionType;
var int ServerNumTransitions, ClientNumTransitions;

// To prevent each ForceWallPart doing damage..
/*var Pawn LastInstigator;
var float LastDamageTime;
var class<DamageType> LastDamageType;
*/
var BeamHitInfo BeamHitInfos[4];         // eheheh..
var float HitExpiration;    // Time until next damage will be considered as a new hit

var bool bServerCreatedCollision, bClientCreatedCollision;

// For native version
var U2ForceWallBlockingVolume ForceWall;

replication
{
	// data to replicate to client
 	reliable if( bNetDirty && Role == ROLE_Authority )
		StartFGLocation, EndFGLocation, TeamIndex, PendingTransitionType, ServerNumTransitions, bServerCollision;

	reliable if( bNetDirty && Role == ROLE_Authority )
		 bServerCreatedCollision;
}

simulated event PreBeginPlay()
{
	Super.PreBeginPlay();
	RegisterConsumer();
	VehicleDamageRatio = 1.0 / (VehicleDamageBaseMass * VehicleDamageBaseSpeed);
}

//-----------------------------------------------------------------------------

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	if( Role < ROLE_Authority )
		ReplicationReadyCheck();
}

simulated event Destroyed()
{
	local int i;

    if( ForceWallEffect != none )
	{
		ForceWallEffect.Destroy();
		ForceWallEffect= None;
	}
	if(DisabledEffect != none)
	{
	   DisabledEffect.Destroy();
	   DisabledEffect = none;
	}





for(i=0; i < ArrayCount(BeamHeads); i++)
	   if(BeamHeads[i] != None)
	       BeamHeads[i].DestroyBeam();


	if( Role == ROLE_Authority )
		UnRegisterConsumer();

	Super.Destroyed();
}

simulated event PostNetReceive()
{
	// something was replicated to client ForceWall
	Super.PostNetReceive();

	if ( bServerCreatedCollision && !bClientCreatedCollision )
	{
		CreateCollision();
		bClientCreatedCollision = true;
	}

    //log(self$": ServerNumTransitions"@ServerNumTransitions$", while Client's"@ClientNumtransitions);
	if( ServerNumTransitions != ClientNumTransitions )
	{
		StartTransition( PendingTransitionType );
		ClientNumTransitions = ServerNumTransitions;
	}

	if(	bServerCollision != bClientCollision )
	{
		if( bServerCollision )
			ClientEnableCollision();
		else
			ClientDisableCollision();

		bClientCollision = bServerCollision;
	}
}

function RegisterConsumer()
{
}

function UnRegisterConsumer()
{
}

simulated function int GetTeam() { return TeamIndex; }
simulated function int GetTeamNum() { return TeamIndex; }

function SetTeam( byte NewTeam )
{
	TeamIndex = NewTeam;
	SetupTransition( FWT_Init );
}

function bool SameTeam( Pawn Other )
{
	return (TeamIndex == Other.GetTeamNum() );
}

//-----------------------------------------------------------------------------

simulated function string GetDescription( Controller User )
{
	if( User.GetTeamNum() == GetTeamNum() )
		return default.Description;
}

//-----------------------------------------------------------------------------

function bool IsEnabled()
{
	return bEnabled;
}

function SetEnabled( bool bVal )
{
	bEnabled = bVal;
}

//-------------------------------------------------------------------------
// Called on server to set up a transition on the client. Simply sets the
// transition type (which is replicated to the client) and enables the
// client's tick function (to check for the arrival of the replicated
// transition type). Note: whenever the client detects a new transition
// type it sets it back to FWT_None so its possible to determine when
// this has been set again (and replicated).

simulated function StartTransition( FWTransition TransitionType )
{
//	ElapsedTransitionTime = 0.0;
//log(self$": StartTransition"@TransitionType);
	switch( TransitionType )
	{
	case FWT_Init:
		CreateDisabledEffect();
		break;
	case FWT_Disable:
		DestroyEnabledEffect();
		break;
	case FWT_Enable:
		CreateEnabledEffect();
		break;
	case FWT_Hit:
		break;
	}
}

//-------------------------------------------------------------------------
// Called on server to set up a transition on the client. Simply sets the
// transition type (which is replicated to the client). Once this is
// replicated to the client, PostNetReceive should be called, telling the
// client to start the transition and enable the client tick function to
// process it.

function SetupTransition( FWTransition TransitionType )
{
//log(self$": SetupTransition"@TransitionType);
	if( Level.NetMode != NM_DedicatedServer )
	{
		StartTransition( TransitionType );
		PendingTransitionType = FWT_None;
	}

	if( Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer )
	{
		PendingTransitionType = TransitionType;
		ServerNumTransitions++; // force replication in case PendingTransitionType reset to same value?
	}

}

function EnableUnit()
{
	if( !bDeleteMe )
	{
		EnableCollision();
		SetupTransition( FWT_Enable );
		PlaySound( class'U2FieldGenerator'.default.EnabledSound, SLOT_None );
		SetEnabled( true );
	}
}

function DisableUnit()
{
	if( !bDeleteMe )
	{
		DisableCollision();
		SetupTransition( FWT_Disable );
		PlaySound( class'U2FieldGenerator'.default.DisabledSound, SLOT_None );
        bShouldEnable=true;
        SetTimer(class'U2FieldGenerator'.default.DisableTime,false);
		SetEnabled( false );
	}
}

function ForceWallKilled()
{
	// Destroy the FieldGenerators that own this ForceWallProxy
	if( StartFG != None )
	{
		StartFG.ShutdownDeployedUnit( true );
		StartFG.Explode();
		StartFG.Destroy();
		StartFG = none;
	}
	if( EndFG != none )
	{
		EndFG.ShutdownDeployedUnit( true );
		EndFG.Explode();
		EndFG.Destroy();
		EndFG = none;
	}
}

function UsedBy(Pawn user)
{
	if( StartFG.IsUsable( user ) )
		DisableUnit();
}

function bool CanHit( Controller AttackingController )
{
	return ( !SameTeam( AttackingController.Pawn ) );
}

function BatchedDamageHandler()
{
	local int FGDamage;

	bBatchedDamageHandlerEnabled = false;
	if( DamageAccumulator >= 1.0 )
	{
		FGDamage = FMax( 1, Round( DamageAccumulator*DamageTransferPct ) );
        // Deal a fraction of the damage to the connecting FieldGenerators
		// NOTE: StartFG and EndFG should always be set at this point on the server
		StartFG.ForceWallTakeDamage( FGDamage, LastInstigatedBy );
		EndFG.ForceWallTakeDamage( FGDamage, LastInstigatedBy );

		TookHit();
		DamageAccumulator = 0.0;
	}
	LastInstigatedBy = none;
}

function XTakeDamage( int Damage, Pawn DamageInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, U2ForceWallPart head)
{
    local int i;

	if( bDeleteMe )
        return;


// Only need this when using non-native collision
    for(i=0; i < ArrayCount(BeamHeads); i++)
    {
        if(BeamHeads[i] == head)
            break;
    }

    if(BeamHitInfos[i].LastInstigator == DamageInstigator && BeamHitInfos[i].LastDamageType == DamageType && Level.TimeSeconds <= BeamHitInfos[i].LastDamageTime + HitExpiration)
        return;


	if( DamageFilterClass != none )
	 	DamageFilterClass.static.ApplyFilter( Damage, Momentum, DamageType );

	DamageAccumulator += Damage;

    LastInstigatedBy = DamageInstigator;

    if( !bBatchedDamageHandlerEnabled )
	{
		bBatchedDamageHandlerEnabled = true;
        SetTimer(0.001,false);
	}


// Only need this when using non-native collision
    BeamHitInfos[i].LastInstigator = DamageInstigator;
    BeamHitInfos[i].LastDamageType = DamageType;
    BeamHitInfos[i].LastDamageTime = Level.TimeSeconds;

}

// Ignore direct damage
function TakeDamage( int Damage, Pawn DamageInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType )
{
/*//    log(self $ "TakeDamage");
	if( !bDeleteMe )
	{
       // roffles
        if(LastInstigatedBy == DamageInstigator && LastDamageType == DamageType && Level.TimeSeconds <= LastDamageTime + HitExpiration)
            return;



        log(self $ " took damage: "$Damage);
        // "batch" damage during the current tick and process it asap in timer afterwards
		//(mdf): I'm not sure why this was done for the forcewalls but its not a bad idea if generalized
		DamageAccumulator += Damage;

        LastInstigatedBy = DamageInstigator;
       LastDamageType = DamageType;
        LastDamageTime = Level.TimeSeconds;

        if( !bBatchedDamageHandlerEnabled )
		{
			bBatchedDamageHandlerEnabled = true;
            SetTimer(0.001,false);
		}
	}       */
}

function DamageEncroacher( Pawn P )
{
	local Pawn DamageInstigator;
	if( Controller(Owner) != none )		DamageInstigator = Controller(Owner).Pawn;
	else							DamageInstigator = Pawn(Owner);
	if (P.class != class'U2FieldGenerator') //GE: Make sure we don't encroach our own FGs!
        class'U2DeployedUnit'.static.DamageEncroacher( P, DamageInstigator );
}


function bool CheckIntersect( vector TestLocation, vector TargetLocation, float TargetRadius, float TargetHeight ) //mdf 12/09/03
{
	return class'U2Util'.static.DoCylindersIntersect(
				TestLocation,
				WallRadius,
				WallHeight,
				TargetLocation,
				TargetRadius,
				TargetHeight );
}

function bool CheckForEncroachment( Actor InActor )
{
	local vector WallVector, TestLocation;
	local float BlockerDistance;
	local bool bEncroach;
	local float WallLen, TotalLen;
	local vector TargetLocation;
	local float TargetRadius, TargetHeight;

    if(InActor == none || InActor.bDeleteMe)
        return false;

	TargetLocation = InActor.Location;
	TargetRadius = InActor.CollisionRadius;
	TargetHeight = InActor.CollisionHeight;

	// quick check whether anywhere near force field
	bEncroach = false;
	BlockerDistance = VSize( TargetLocation - Location );
	if( BlockerDistance < (0.5*class'U2FieldGenerator'.default.LinkRadius + TargetRadius) )
	{
		// check every N units along wall from start to end location
		WallVector = EndFGLocation - StartFGLocation;
		WallLen = VSize( WallVector );
		WallVector = Normal( WallVector );

		TotalLen = 0.0;
		TestLocation = StartFGLocation;
		while( TotalLen < WallLen )
		{
			//AddCylinder( TestLocation, WallRadius, WallHeight, ColorGreen() );
			if( CheckIntersect( TestLocation, TargetLocation, TargetRadius, TargetHeight) ) //mdf 12/09/03
			{
				bEncroach = true;
				break;
			}
			TestLocation += 2*WallRadius*WallVector;
			TotalLen += 2*WallRadius;
		}
	}
	return bEncroach;
}

function CheckForEncroachingPawns()
{
    local Controller C;
    local Vehicle tempV;

	for( C=Level.ControllerList; C!=None; C=C.nextController)
	{
        if(C.Pawn == None || C.Pawn == StartFG || C.Pawn == EndFG)
			continue;

	    if( (CheckForEncroachment( C.Pawn )) && (SameTeam(C.Pawn)) )
            DisableUnit();

		else if( CheckForEncroachment( C.Pawn ) )
			DamageEncroacher( C.Pawn );
	}

	foreach DynamicActors(class'Vehicle', tempV)
	{
		if( CheckForEncroachment( tempV ) )
			DamageEncroacher( tempV );
    }
}

function CheckEnableUnit()
{
   local Controller C;

   for( C=Level.ControllerList; C!=None; C=C.nextController)
   {
        if( C.Pawn == StartFG || C.Pawn == EndFG )
            continue;

        if( (CheckForEncroachment( C.Pawn )) && (SameTeam(C.Pawn)) )
        {
 //           DM(P.Class@" is still being encroached!");
            bShouldEnable = true;
            SetTimer(class'U2FieldGenerator'.default.DisableTime, false );
            return;
        }
   }
//   DM("No longer encroaching anything. Don't let those bastards through then.");
   EnableUnit();
}

function bool IntersectsTeleporters()
{
	local NavigationPoint N;

	for	( N=Level.NavigationPointList; N!=None;	N=N.NextNavigationPoint	)
	{
		if( Teleporter(N) != none && CheckForEncroachment(N) )
			return true;
	}
	return false;
}

event bool EncroachingOn( Actor Other )
{
	if( Owner != none )	// need for the proper death message, CheckForEncroachingPawns will cause damage with the correct owner
		DamageEncroacher( Pawn(Other) );
	return false;
}

function TouchedByVehicle( Vehicle V )
{
	local int Damage;
	if( V != none )
	{
		if (SameTeam(V))
	        DisableUnit();
        else
        {
            Damage = MaxDamageFromVehicle * V.Mass * VSize(V.Velocity) * VehicleDamageRatio;
   		    TakeDamage( Damage, V, Location, vect(0,0,0), class'Crushed' );
   		}
	}
}

event Touch( Actor Other )
{
	Super.Touch( Other );

    if( Mover(Other) != None )
		TakeDamage( 10000, None, Location, vect(0,0,0), class'Crushed' );
	else if( Vehicle(Other) != None )
		TouchedByVehicle( Vehicle(Other) );
}

event Bump(Actor Other)
{
    if (Pawn(Other) != None && SameTeam(Pawn(Other)))
	    DisableUnit();
}

function EnableCollision()
{
	// Don't enable collision for this actor, get the weird "bump" in the middle of the FW if you do
	SetCollision( false, false, false );
    SetBeamCollision(true);

    bServerCollision = true;

	if( ROLE == ROLE_Authority )
		CheckForEncroachingPawns();
}

function DisableCollision()
{
	SetCollision( false, false, false );
    SetBeamCollision(false);

	bServerCollision = false;
}

function SetBeamCollision(bool bOn)
{
    local int i;
    if(bOn)
    {



for(i=0; i < ArrayCount(BeamHeads); i++)
        {
            if(BeamHeads[i] != None)
                BeamHeads[i].EnableCollision();
        }

}
    else
    {



for(i=0; i < ArrayCount(BeamHeads); i++)
        {
            if(BeamHeads[i] != None)
                BeamHeads[i].DisableCollision();
        }

}
}

simulated function ClientSetBeamCollision(bool bOn)
{
    local int i;
    if(bOn)
    {



for(i=0; i < ArrayCount(BeamHeads); i++)
        {
            if(BeamHeads[i] != None)
                BeamHeads[i].EnableCollision();
        }

}
    else
    {



for(i=0; i < ArrayCount(BeamHeads); i++)
        {
            if(BeamHeads[i] != None)
                BeamHeads[i].DisableCollision();
        }

}
}


simulated function ClientEnableCollision()
{
	SetCollision( true, true, true );
    ClientSetBeamCollision(true);
}

simulated function ClientDisableCollision()
{
	SetCollision( false, false, false );
    ClientSetBeamCollision(false);
}

simulated function CreateDisabledEffect()
{
	local rotator Direction;
	if(DisabledEffect == none && TeamIndex != 255)
	{
		Direction = rotator(EndFGLocation - StartFGLocation);
		DisabledEffect = spawn(DisabledForceWalls[TeamIndex],self,,StartFGLocation,Direction);
		U2FX_ForceWallSprite(DisabledEffect).ModLength( VSize(EndFGLocation - StartFGLocation) ); // alex
	}
}

simulated function CreateEnabledEffect()
{
	local rotator Direction;
	//log("Create enabled effect 1.");
    if(ForceWallEffect == none && TeamIndex != 255)
	{
    	//log("Create enabled effect 2.");
		Direction = rotator(EndFGLocation - StartFGLocation);
		ForceWallEffect = spawn(ForceWalls[TeamIndex],self,,StartFGLocation,Direction);
		U2FX_ForceWallBeam(ForceWallEffect).ModLength( VSize(EndFGLocation - StartFGLocation) ); // alex
	}
}

simulated function DestroyEnabledEffect()
{
	if ( ForceWallEffect != none )
		ForceWallEffect.Destroy();
}

simulated function CreateCollision()
{

/*	local vector StartLocation, EndLocation, WallVector;
	local vector StartLocation3D, EndLocation3D;
	local vector WallWidthVector;
	local vector PA1, PA2, PA3, PA4, PB1, PB2, PB3, PB4;
	local array<DynamicBlockingVolume.Face> Faces; */

    local vector Dir, BeamLoc;
    local int numParts;

    if(bCreatedCollision)
        return;

//GE: OMFGWTFBBQ WHITE PLACE?!!!



























































//GE: Hack if I ever saw one. Shouldn't this be put in a loop?

Dir = EndFGLocation - StartFGLocation;

    numParts = int(VSize(Dir) / (class'U2ForceWallPart'.default.CollisionRadius * 2));

    BeamLoc = StartFGLocation;
    BeamLoc.Z -= 50.0f;
    BeamHeads[0] = spawn(class'U2ForceWallPart',self,,BeamLoc, rotator(Dir));
    BeamHeads[0].CreateBeam(numParts,rotator(Dir));

    BeamLoc.Z += 32.0f;
    BeamHeads[1] = spawn(class'U2ForceWallPart',self,,BeamLoc, rotator(Dir));
    BeamHeads[1].CreateBeam(numParts,rotator(Dir));

    BeamLoc = StartFGLocation;
    BeamLoc.Z += 18.0f;
    BeamHeads[2] = spawn(class'U2ForceWallPart',self,,BeamLoc, rotator(Dir));
    BeamHeads[2].CreateBeam(numParts,rotator(Dir));

    BeamLoc.Z += 32.0f;
    BeamHeads[3] = spawn(class'U2ForceWallPart',self,,BeamLoc, rotator(Dir));
    BeamHeads[3].CreateBeam(numParts,rotator(Dir));


    bCreatedCollision=true;
    EnableCollision();
}

function Initialize( U2FieldGenerator _StartFG, U2FieldGenerator _EndFG, int _TeamIndex )
{
	StartFG			= _StartFG;
	EndFG			= _EndFG;
	StartFGLocation	= StartFG.Location;
	EndFGLocation	= EndFG.Location;
	SetTeam( _TeamIndex );

	// hack to prevent forcewalls from interfering with teleporters
	if( IntersectsTeleporters() )
	{
		Destroy();
		return;
	}

	SetEnabled( true );

	CreateCollision();
	bServerCreatedCollision = true;

   	if( Level.NetMode != NM_DedicatedServer )
		CreateDisabledEffect();

    bShouldEnable=true;
    SetTimer(1.5,false);
}

simulated function Timer()
{
    if(bShouldEnable)
    {
        bShouldEnable=false;
        CheckEnableUnit();
    }
	if( bBatchedDamageHandlerEnabled )
	{
	   BatchedDamageHandler();
	}
}

simulated function SetupClient()
{
	CreateDisabledEffect();
//    bShouldSpawnEnabledFX=true;
//    SetTimer(1.5,false);
}

simulated function Tick(float DeltaTime)
{
	if( Role < ROLE_Authority )
	{
		if ( ReplicationReadyTime > 0 )
		{
			ReplicationReadyTime -= DeltaTime;
			if ( ReplicationReadyTime <= 0 )
				ReplicationReadyCheck();
		}
	}
}

simulated function bool ReplicationReady()
{
	return ( StartFGLocation != default.StartFGLocation && EndFGLocation != default.EndFGLocation );
}

simulated function ReplicationReadyCheck()
{
	// hack: assume replication complete once changes from defaults
	if( ReplicationReady() )
		SetupClient();
	else
		ReplicationReadyTime = 0.2;
}

function int GetConsumerClassIndex() { return 5; }

function TookHit();

defaultproperties
{
     Description="Disable Force Wall"
     StartFGLocation=(X=-100000000.000000,Y=-100000000.000000,Z=-100000000.000000)
     EndFGLocation=(X=-100000000.000000,Y=-100000000.000000,Z=-100000000.000000)
     TeamIndex=-1
     ForceWalls(0)=Class'U2FX_RedBeam'
     ForceWalls(1)=Class'U2FX_BlueBeam'
     DisabledForceWalls(0)=Class'U2FX_RedBeamDisabled'
     DisabledForceWalls(1)=Class'U2FX_BlueBeamDisabled'
     MaxDamageFromVehicle=300
     VehicleDamageBaseMass=500.000000
     VehicleDamageBaseSpeed=1000.000000
     WallRadius=8.000000
     WallHeight=70.000000
     EnergyCostPerSec=0.001000
     DeployableAddPctPer=0.012500
     FieldHeight=60.000000
     BottomOffset=10.000000
     DamageTransferPct=0.333333
     DamageFilterClass=Class'U2DamageFilterForceWall'
     HitExpiration=0.050000
     bHidden=True
     bAlwaysRelevant=True
     RemoteRole=ROLE_SimulatedProxy
     bNetNotify=True
     AmbientSound=Sound'U2XMPA.FieldGenerator.ForceWallAmbient'
     SoundVolume=255
     SoundRadius=60.000000
     bProjTarget=True
}
