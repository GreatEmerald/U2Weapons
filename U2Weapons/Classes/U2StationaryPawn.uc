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

class U2StationaryPawn extends Vehicle;


var() bool bUsable;
var int TeamIndex; // used if no PlayerReplicationInfo

var(Display) array<Material> AlternateSkins;	// Multiple skin support - not replicated.
var(Display) int			RepSkinIndex;		// skin index to replicate
var Material RepSkinNew;

var bool bHasAttack;		// whether the stationary pawn is capable of attacking
var bool bCoverActor;		// whether NPCs can use this actor for cover (hide behind it)


replication
{
	unreliable if ( (!bSkipActorPropertyReplication || bNetInitial) && (Role==ROLE_Authority) )
		bUsable;
	unreliable if ( (!bSkipActorPropertyReplication || bNetInitial) && (Role==ROLE_Authority) && bNetDirty )
		RepSkinNew, RepSkinIndex;
	reliable if( bNetDirty && Role==ROLE_Authority )
		TeamIndex;
}

/*simulated function PostBeginPlay()
{
    local controller NewController;

    super.PostBeginPlay();

    if ( bDeleteMe )
        return;

    // Glue a shadow projector on
    if ( bVehicleShadows && bDrawVehicleShadow && (Level.NetMode != NM_DedicatedServer) )
    {
        VehicleShadow = Spawn(class'ShadowProjector', self, '', Location);
        VehicleShadow.ShadowActor       = Self;
        VehicleShadow.bBlobShadow       = false;
        VehicleShadow.LightDirection    = Normal(vect(1,1,6));
        VehicleShadow.LightDistance     = 1200;
        VehicleShadow.MaxTraceDistance  = ShadowMaxTraceDist;
        VehicleShadow.CullDistance      = ShadowCullDistance;
        VehicleShadow.InitShadow();
    }

    if ( Role == Role_Authority )
    {
        if ( bAutoTurret && (Controller == None) && (AutoTurretControllerClass != None) )
        {
            NewController = spawn(AutoTurretControllerClass);
            if ( NewController != None )
            {
                NewController.Possess(self);
                Controller=NewController;
            }
        }
        if ( !bAutoTurret && !bNonHumanControl && IndependentVehicle() )
            Level.Game.RegisterVehicle(self);
    }

    OldTeam = Team;
    PrevTeam = Team;
} */

simulated event PostNetReceive()
{
	Skins[RepSkinIndex] = RepSkinNew;
}

final function SetTeamSkin( U2StationaryPawn TargetActor, int NewTeam )
{
	local int i;
	local bool bFound;

	if( NewTeam == 255 )
	{
		// neutral team - clear team skin
		if( TargetActor.Level.NetMode != NM_DedicatedServer )
		{
			// access skins array directly
			if( TargetActor.Skins.Length > TargetActor.RepSkinIndex )
				TargetActor.Skins[TargetActor.RepSkinIndex] = None;
		}

		if( TargetActor.Level.NetMode == NM_DedicatedServer ||
			TargetActor.Level.NetMode == NM_ListenServer )
		{
			// replicate to client
			TargetActor.RepSkinNew = None;
		}

		// skins array with empty entries was causing meshes (SVehicles) to display the bubble texture
		for( i=0; i < TargetActor.Skins.Length; i++ )
			if( TargetActor.Skins[i] != none )
			{
				bFound = true;
				break;
			}

		if( !bFound )
			TargetActor.Skins.Length = 0;
	}
	else
	{
		// team skin - assign to actor
		if( NewTeam < TargetActor.AlternateSkins.Length )
		{
			if( TargetActor.Level.NetMode != NM_DedicatedServer )
			{
				// access skins array directly
				if( TargetActor.Skins.Length <= TargetActor.RepSkinIndex )
					TargetActor.Skins.Length = TargetActor.RepSkinIndex + 1;
				TargetActor.Skins[TargetActor.RepSkinIndex] = TargetActor.AlternateSkins[NewTeam];
			}

			if( TargetActor.Level.NetMode == NM_DedicatedServer ||
				TargetActor.Level.NetMode == NM_ListenServer )
			{
				// replicate to client
				TargetActor.RepSkinNew	= TargetActor.AlternateSkins[NewTeam];
			}
		}
	}
}

function OnUnuse( Actor Other ); // stub

simulated function string GetDescription ( Controller User ) { return ""; }
simulated function bool   HasUseBar      ( Controller User ) { return false; }
simulated function float  GetUsePercent  ( Controller User );
simulated function int    GetUseIconIndex( Controller User ) { return 0; }
simulated function int    GetRadarIconIndex() { return 0; }

function int GetConsumerClassIndex() { return 0; }

simulated function SetTeam(int NewTeam)
{
	if( U2StationaryPawnController(Controller)!=none )
		U2StationaryPawnController(Controller).SetTeam( NewTeam);
	else
		Team = NewTeam;
}

simulated function bool SameTeam( Pawn Other )
{
	return( Other!=none && GetTeamNum() == Other.GetTeamNum() );
}

simulated function int GetTeamNum()
{
	if( Controller!=none )
		return Controller.GetTeamNum();
	else
	{
		if ( PlayerReplicationInfo != None && PlayerReplicationInfo.Team != None )
			return PlayerReplicationInfo.Team.TeamIndex;
		else
			return TeamIndex;
	}
}

//-----------------------------------------------------------------------------

function bool IsMobile() { return false; }

//-----------------------------------------------------------------------------
/*
function LaunchPawn( Pawn Other )
{
	// allow StationaryPawns to rest on other StationaryPawns (had this for U2 for some reason)?
	if( StationaryPawn( Other ) == None )
		Super.LaunchPawn( Other );
}
*/
//-----------------------------------------------------------------------------

//mdf-tbd: function LaunchPawnDamage( Pawn Other ); // don't get damaged by Pawn landing on me

//-----------------------------------------------------------------------------
// Subclasses can override this if they consist of multiple actors.

function bool HitSelf( Actor HitActor )
{
	return( HitActor == Self );
}

//-----------------------------------------------------------------------------

simulated function AddVelocity( vector NewVelocity );

//-----------------------------------------------------------------------------


event PostBeginPlay()
{
	local AIScript A;

	Super(Actor).PostBeginPlay();
	SplashTime = 0;
	SpawnTime = Level.TimeSeconds;
	EyeHeight = BaseEyeHeight;
	OldRotYaw = Rotation.Yaw;

	// check if I have an AI Script
	if ( AIScriptTag != '' )
	{
		ForEach AllActors(class'AIScript',A,AIScriptTag)
			break;
		// let the AIScript spawn and init my controller
		if ( A != None )
		{
			A.SpawnControllerFor(self);
			if ( Controller != None )
				return;
		}
	}
	if ( (ControllerClass != None) && (Controller == None) )
		Controller = spawn(ControllerClass);
	if ( Controller != None )
	{
		Controller.Possess(self);
		//PossessedBy(Controller);
		AIController(Controller).Skill += SkillModifier;
	}
}

function NotifyTeamEnergyStatus( bool bEnabled );

defaultproperties
{
     bCanBeBaseForPawns=False
     MaxDesiredSpeed=0.000000
     HearingThreshold=0.000000
     SightRadius=0.000000
     GroundSpeed=0.000000
     WaterSpeed=0.000000
     AccelRate=0.000000
     JumpZ=0.000000
     Health=500
     //AutoTurretControllerClass=Class'U2StationaryPawnController'
     ControllerClass=Class'U2StationaryPawnController'
     bStasis=False
     RemoteRole=ROLE_DumbProxy
     bCanTeleport=False
     bUseCylinderCollision=True
     bNetNotify=True
     RotationRate=(Pitch=0,Yaw=0,Roll=0)
     //bAutoTurret=True
     bRemoteControlled=True
     bNonHumanControl=True
     bStalled=True
     bNoFriendlyFire=True //GE: Not sure if that should be true or false?
}
