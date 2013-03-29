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
// XMPDeployedUnit.uc
// 2004 jasonyu
// 25 July 2004
//-----------------------------------------------------------

class U2DeployedUnit extends U2StationaryPawn;


//const NotifyDeployedTimerName = 'NotifyDeployedTimer';

//var() class<Pickup>	PickupClass;
var() class<U2DamageFilter> DamageFilterClass;
var() class<Actor> HitEffect;		// effect to spawn when an impact happens
var() class<Actor> ExplosionClass;	// class used to handle explosion effect, sound
var() Sound			ShutdownSound;
var() Sound			DestroyedAlertSound;
var() Sound			DeploySound;
var() Sound			DisabledSound;
var() Sound			EnabledSound;
var() Sound			AmbientNoiseSound;
var() localized string	Description;
var() float			DisableTime;				// Number of seconds the unit remains disabled.
var() bool			bEnabled;
var() Shader		DisabledSkin;				// Skin/Shader to use when unit is Disabled.
var() array<StaticMesh>	CarcassMesh;			// Mesh to spawn when unit is destroyed.

var	bool			bActive;					// Unit becomes active when it has eventLanded() and is on.
var	bool			bDeployed;					// Unit is deployed through NotifyDeployed()
var private float	LandedNotifyDeployedDelay;
var() class<Inventory> InventoryType;
var() localized string PickupMessage; // Human readable description when picked up.
var int ClientTeamIndex;
var Texture	SpamTexture0, SpamTexture1, SpamTexture255; 	// temp hack until we get skins for these
var class<Actor> RedExplode, BlueExplode;

var() float EnergyCostPerSec;
var() float SelfDestructTimer, SelfDestructDuration;

var Controller KillerController;

var() float DeployableAddPctPer;

var float EnableUnitTime, NotifyDeployedTime, ReplicationReadyTime;
var bool bEnableUnit, bNotifyDeployed, bReplicationReady;

//-----------------------------------------------------------------------------

replication
{
	reliable if( bNetDirty && ROLE == ROLE_Authority )
		ClientTeamIndex; // data replicated to client
}

//-----------------------------------------------------------------------------

simulated event PostBeginPlay()
{
	//DMTN( "In PostBeginPlay  Role: " $ EnumStr( enum'ENetRole', Role ) );

	Super.PostBeginPlay();
	if( Role < ROLE_Authority )
		ReplicationReadyCheck();

}

//-----------------------------------------------------------------------------

event Destroyed()
{
	//DMTNS( "Destroyed" );
//	RemoveAllTimers(); // in case timer(s) somehow still active
// TODO
	UnRegisterConsumer();
	Super.Destroyed();
}

//-----------------------------------------------------------------------------

function bool IsActive() { return bActive; }

//-----------------------------------------------------------------------------

function bool IsEnabled() { return bEnabled; }

//-----------------------------------------------------------------------------

function SetActive( bool bVal ) { bActive = bVal; }

//-----------------------------------------------------------------------------

function SetEnabled( bool bVal ) { bEnabled = bVal; }

//-----------------------------------------------------------------------------

function bool IsUsable( Actor Other )
{
	local bool bRes;

	//DMTN( "IsUsable  Other: " $ Other );

	if( bDeleteMe )
	{
        //DMTN( "  return false (bDeleteMe)" );
		return false;
	}

	if( Other == None )
	{
		//DMTN( "  return true (Other==None)" );
		return true;
	}

	if( bEnabled )
	{
		bRes = ( Pawn(Other) != None && SameTeam( Pawn(Other) ) );
        //DMTN
//		log( "  return " $ bRes $ " (team check)  My Team: " $ GetTeam() $ "  Other Team: " $ Controller(Other).GetTeam() );
		return bRes;
	}
	return false;
}

//-----------------------------------------------------------------------------

//function OnUse( Actor Other )
event UsedBy(Pawn user)
{
//	local PlayerController PC;
	local xPawn P;

	if( IsUsable( user ) )
	{
		// units are returned to the player's inventory when used if on the same team,
		// if not on the same team but bFriendlyToPlayerTeam, they are disabled.
		//DM( "OnUse " $ Self $ " Team = " $ GetTeam() $ " " $ Other $ ".Team = " $ Controller(Other).Pawn.GetTeam() );
		P = xPawn(user);
		if( P != None)
		{
			ShutDownDeployedUnit( false, P );
		}
		else
		{
			DisableUnit();
		}
	}
}

function Vehicle FindEntryVehicle(Pawn P)
{
    if (VSize(P.Location - (Location + (EntryPosition >> Rotation))) < EntryRadius)
        UsedBy(P);
    return Super.FindEntryVehicle(P);
}

//-----------------------------------------------------------------------------

simulated function string GetDescription( Controller User )
{
	return default.Description $ " (" $ Health $ ")";
}

//-----------------------------------------------------------------------------

function Initialize( bool bAltActivate )
{
	PlaySound( DeploySound, SLOT_None );
	if( Level.NetMode != NM_DedicatedServer )
		SetTextures( Self );
}

//-----------------------------------------------------------------------------

function SetSkin( bool bDisabledSkin );

//-----------------------------------------------------------------------------

function DisableUnit()
{
	// 2003.01.29 (mdf) fix for adding timers (etc.) to invalid (e.g. deleted) actors
	if( bDeleteMe )
		return;

	//DM( "@@@ DisableUnit Disabling " $ Self );
	// Turn off collision
	DisableCollision();
	// Disable
	SetEnabled( false );
	// Disabled skin
	SetSkin( true );
	if( DisabledSound != None )
		PlaySound( DisabledSound, SLOT_None );
//	AddTimer( 'EnableUnit', DisableTime, false );
	EnableUnitTime = DisableTime;
// TODO
}

simulated function Tick(float DeltaTime)
{
	if ( ReplicationReadyTime > 0 )
	{
		ReplicationReadyTime -= DeltaTime;
		if ( ReplicationReadyTime <= 0 )
			ReplicationReadyCheck();
	}

	if ( NotifyDeployedTime > 0 )
	{
		NotifyDeployedTime -= DeltaTime;
		if ( NotifyDeployedTime <= 0 )
			NotifyDeployedTimer();
	}
	if ( EnableUnitTime > 0 )
	{
		EnableUnitTime -= DeltaTime;
		if ( EnableUnitTime <= 0 )
			EnableUnit();
	}
}



//-----------------------------------------------------------------------------

function EnableUnit()
{
	if( bDeleteMe )
		return;

	EnableCollision();
	SetEnabled( true );
	SetSkin( false );

	if( EnabledSound != None )
		PlaySound( EnabledSound, SLOT_None );
}

//-----------------------------------------------------------------------------

function KillInventory()
{
	local Inventory NextInv;

	while( Inventory != None )
	{
		NextInv = Inventory.Inventory;
		Inventory.Destroy();
		Inventory = NextInv;
	}
	Weapon = None;
}

//-----------------------------------------------------------------------------

function ShutDownDeployedUnit( bool bDestroyed, optional Pawn P )
{
	local U2DeployableInventory DInv;

	// if being used and turned into a pickup
	if( !bDestroyed )
	{
		// Add one of these to the player's inventory
		if( Health > 0 )
			PlaySound( ShutdownSound, SLOT_None );

		// Make sure the deployable item is in owner's inventory
		if (P != None)
		{
            DInv = U2DeployableInventory(class'U2Util'.static.GiveInventoryClass( P, InventoryType ));
            DInv.AddAmmo( 1,0 );
        }

		/*
		!!ARL (mdf): tbd - too spammy?
		// Give player a pickup message
		if( P != None && P.IsRealPlayer() )
		{
			//!! MERGE class'UIConsole'.static.BroadcastStatusMessage( Self, PickupMessage );
		}
		*/

		// Destroy myself
		if( !bDeleteMe )
			KillInventory();
		if (Controller != None) //GE: Controller can be None when switching rounds.
            Controller.PawnDied( Self );
		//DMTN( "ShutDownDeployedUnit #1" );
		Destroy();
	}
	else	// else, being destroyed
	{
		//DMTN( "CarcassMesh.Length = " $ CarcassMesh.Length );
		if( CarcassMesh.Length > 0 && Health <= 0 )
		{
			if( Level.NetMode != NM_DedicatedServer )
			{
				SetDrawType( DT_StaticMesh );
				//class'UtilGame'.static.
				SetTeamSkin( Self, 255 );
				SetStaticMesh( CarcassMesh[ Rand(CarcassMesh.Length) ] );
			}
			GotoState( 'Decaying' );
		}
		else
		{
			if( Health > 0 )
				PlaySound( ShutdownSound, SLOT_None );
			if( !bDeleteMe )
				KillInventory();
			Controller.PawnDied( Self );
			//DMTN( "ShutDownDeployedUnit #2" );
			Destroy();
		}
	}
}

//-----------------------------------------------------------------------------

function NotifyDeployed()
{
	bMovable=false;
}

//-----------------------------------------------------------------------------

simulated event PostNetReceive()
{
	Super.PostNetReceive();

	if( !bDeleteMe && Health <= 0 && DrawType != DT_StaticMesh )
	{
		// hack alert
		SetDrawType( DT_StaticMesh );
		SetStaticMesh( CarcassMesh[ Rand(CarcassMesh.Length) ] );
	}

	SetTeamSkin(Self, ClientTeamIndex ); // hack
}

//-----------------------------------------------------------------------------

function TakeDamage( int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType )
{
	local Controller InstigatingController;

	//DMTN( "TakeDamage" );
	if( bPendingDelete || (Role < ROLE_Authority) )
		return;

	if( Health > 0 )
	{
		//DMTN( "Health > 0" );

		if( DamageFilterClass!=none )
		 	DamageFilterClass.static.ApplyFilter( Damage, momentum, DamageType );

		if( Damage > 0 )
		{
			//DMTN( "Damage > 0" );

			Health -= Damage;

			//DMTN( "bPendingDelete:    " $ bPendingDelete );
			//DMTN( "ParticleHitEffect: " $ ParticleHitEffect );
			//DMTN( "Level.NetMode:     " $ EnumStr( enum'ENetMode', Level.NetMode ) );

			if( HitEffect!=none && (Health > 0) )
				Spawn(HitEffect);
		}
	}

	if( Health <= 0 )
	{
		//log( "Dead" );
		AmbientSound = None;
		if( DestroyedAlertSound != None )
			PlaySound( DestroyedAlertSound, SLOT_None );
		if( InstigatedBy!=none )
			InstigatingController = InstigatedBy.Controller;
		Explode();
		ShutDownDeployedUnit( true );
	}
}

//-----------------------------------------------------------------------------

function Explode()
{
	if (bPendingDelete)
		return;

	if(ClientTeamIndex == 0 && RedExplode != None)
	{
		Spawn(RedExplode);
		return;
	}

	if(ClientTeamIndex == 1 && BlueExplode != None)
	{
		Spawn(BlueExplode);
		return;
	}

	if (ExplosionClass!=none)
		Spawn(ExplosionClass);
}

//-----------------------------------------------------------------------------


function NotifyDeployedTimer()
{
/*	// sanity checks
    if( !bDeleteMe )
	{
        // DMTN( "NotifyDeployedTimer up  Physics: " $ EnumStr( enum'EPhysics', Physics ) );
		if( Physics != PHYS_Falling )
		{
			log("U2: Notifying.");
            //AddActor( Self, ColorGreen() );
			bActive = true;
			bDeployed = true;
			SetPhysics( PHYS_None ); // don't want to leave these in PHYS_Walking (unnecessary overhead)
			NotifyDeployed();
		}
		else
		{
//			AddTimer( NotifyDeployedTimerName, LandedNotifyDeployedDelay, false );
			log("U2: Still falling.");
            NotifyDeployedTime = LandedNotifyDeployedDelay;
		}
	}
 */
}

//-----------------------------------------------------------------------------

event Landed( vector HitNormal )
{
	//DMTN( "Landed" );
	//AddActor( Self, ColorYellow() );
	if( bDeleteMe )
		return;

	// wait until location "settles down" before sending out NotifyDeployed
//	AddTimer( NotifyDeployedTimerName, LandedNotifyDeployedDelay, false );
	bActive = true;
			bDeployed = true;
			SetPhysics( PHYS_None ); // don't want to leave these in PHYS_Walking (unnecessary overhead)
			NotifyDeployed();

    NotifyDeployedTime = LandedNotifyDeployedDelay;
}

//-----------------------------------------------------------------------------

function Controller GetKillerController() { return KillerController; }

function SetKillerController( Controller C )
{
    KillerController = C;
    //if( U2StationaryPawnController(Controller)!=none )
	//{
        U2StationaryPawnController(Controller).KillerController=C;
	//}
}

//-----------------------------------------------------------------------------

static function DamageEncroacher( Pawn P, Pawn DamageInstigator )
{
	//if( !P.bDeleteMe && P.Health > -9999 && !SameTeam( P ) && !P.IsRealPlayer() )
	//mdf-tbd: damage *any* Pawn that is in the way?
	if( P!=none && !P.bDeleteMe && P.Health > -9999 )
		P.TakeDamage( 10000, DamageInstigator, P.Location, vect(0,0,0), class'U2DamTypeEMP' ); //TODO -- "zapped" damage type?
}

//-----------------------------------------------------------------------------

function CheckForEncroachingPawns();

//-------------------------------------------------------------------------

function EnableCollision()
{
	SetCollision( true, true, true );
	CheckForEncroachingPawns();
	KSetBlockKarma( default.bBlockKarma );
}

//-----------------------------------------------------------------------------

function DisableCollision()
{
	SetCollision( false, false, false );
	KSetBlockKarma( false );
}

//-----------------------------------------------------------------------------

event bool EncroachingOn( Actor Other )
{
	DamageEncroacher( Pawn(Other), Pawn(Owner) );
	return false;
}

//-----------------------------------------------------------------------------

simulated function SetTeam( int NewTeam)
{
	//DMTN( "SetTeam: " $ NewTeam );
	Super.SetTeam( NewTeam);
	ClientTeamIndex = NewTeam;
	SetTeamSkin(Self, NewTeam); // hack
}

//-----------------------------------------------------------------------------

simulated function SetTextures( Actor TargetActor )
{
	//DMTN( "SetTextures  Team: " $ ClientTeamIndex );

//	if( AlternateSkins.Length == 2 && AlternateSkins[ 0 ] != None && AlternateSkins[ 1 ] != None )
//	{
		//DMTN( "AlternateSkins[ 0 ]: " $ AlternateSkins[ 0 ] );
		//DMTN( "AlternateSkins[ 1 ]: " $ AlternateSkins[ 1 ] );
		//class'UtilGame'.static.
		SetTeamSkin( U2DeployedUnit(TargetActor), ClientTeamIndex );
//	}
	/*
	else if( ClientTeamIndex == 0 && SpamTexture0 != None )
		class'Util'.static.SpamTextures( TargetActor, SpamTexture0 );
	else if( ClientTeamIndex == 1 && SpamTexture1 != None )
		class'Util'.static.SpamTextures( TargetActor, SpamTexture1 );
	else if( SpamTexture255 != None )
		class'Util'.static.SpamTextures( TargetActor, SpamTexture255 );
	*/
}

//-----------------------------------------------------------------------------

simulated function SetupClient()
{
	//DMTN( "SetupClient" );
	SetTextures( Self );
}

//-----------------------------------------------------------------------------

simulated function bool ReplicationReady()
{
	//DMTN( "ReplicationReady: " $ ClientTeamIndex );
	return ( ClientTeamIndex != 255 );
}

//-----------------------------------------------------------------------------

simulated function ReplicationReadyCheck()
{
	// hack: assume replication complete once changes from defaults
	if( ReplicationReady() )
		SetupClient();
	else
		ReplicationReadyTime = 0.2;
//		AddTimer( 'ReplicationReadyCheck', 0.2, false );
}

//-----------------------------------------------------------------------------

function NotifyTeamEnergyStatus( bool bEnabled )
{
//	log("NotifyTeamEnergyStatus: "$bEnabled);

	if( !bEnabled )
		GotoState( 'Offline' );
}

//-----------------------------------------------------------------------------

state Offline
{
	event Timer()
	{
		local float Damage;
		// keep doing damage until unit is destroyed

		Damage = default.Health;
		if( SelfDestructDuration > 0 )
			Damage /= SelfDestructDuration;
		TakeDamage( Damage, None, vect(0,0,0), vect(0,0,0), class'Suicided' );
	}

    //-------------------------------------------------------------------------

	function NotifyTeamEnergyStatus( bool bEnabled )
	{
		if( bEnabled )					// back online
		{
/* SAD: We want them to continue to use energy until they are destroyed.
			RegisterConsumer();
*/
			GotoState( 'Armed' );
		}
	}

	//-------------------------------------------------------------------------
/* SAD: We want them to continue to use energy until they are destroyed.
	event BeginState()
	{
		UnRegisterConsumer();
	}
*/
	//-------------------------------------------------------------------------

Begin:
	Sleep( FRand() );		// so that all units don't appear in sync
	SetTimer( SelfDestructTimer, true );
}

//-----------------------------------------------------------------------------

state Decaying
{
	ignores Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer;

	event Timer()
	{
		if ( !PlayerCanSeeMe() )
		{
			//DMTN( "Destroy in Decaying" );
			Destroy();
		}
		else
			SetTimer( 2.0, false );
	}

	event BeginState()
	{
		if ( bTearOff && (Level.NetMode == NM_DedicatedServer) )
			LifeSpan = 1.0;
		else
			SetTimer( 18.0, false );
		bInvulnerableBody = true;
		if ( Controller != None )
		{
			//NEW (mdf) -- PawnDied should be called for non players too -- and let PawnDied decided whether to destroy the Controller
			// Not calling this also means that the Pawn isn't correctly unpossessed?
			Controller.PawnDied( Self );
		}
		SetEnabled( false );
		//DM( "@@@ Decaying.BeginState Disabling " $ Self );
		DisableCollision();
		KillInventory();
		UnRegisterConsumer();
	}

Begin:
//	DM( "@@@-------------------------- Starting DecayingState" );
	Sleep(0.2);
	bInvulnerableBody = false;
}

//-----------------------------------------------------------------------------

function RegisterConsumer();

//-----------------------------------------------------------------------------

function UnRegisterConsumer();

simulated function int GetTeamNum() { return ClientTeamIndex; }

//-----------------------------------------------------------------------------

function Reset()
{
    ShutDownDeployedUnit(false);
}

defaultproperties
{
     DamageFilterClass=Class'U2DamageFilterDeployed'
     DisableTime=3.000000
     bEnabled=True
     bActive=True
     LandedNotifyDeployedDelay=0.500000
     ClientTeamIndex=255
     SelfDestructTimer=1.000000
     SelfDestructDuration=8.000000
     bUsable=True
     Health=1000
     Physics=PHYS_Falling
     bAnimByOwner=True
     EntryRadius=80.0
     bIgnoreEncroachers=True
}
