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

class U2MineBase extends U2BreakableItem;

var() class<Actor> HitEffect;					// The effect to spawn when an impact happens
var() class<Actor> ExplosionClass;				// class used to handle explosion effect, sound
var() sound DeploySound;
var() sound ArmingSound;
var() sound TrippedSound;
var() sound AmbientNoiseSound;
var() float ArmingDelay;						// seconds needed, after landing, for the mine to be active
var() float ExplodeDelay;						// once tripped, seconds before exploding
var() float SelfDestructTimer, SelfDestructDuration;
var() float EnergyCostPerSec;
var int ClientTeamIndex;

var Controller KillerController;

//-----------------------------------------------------------------------------

replication
{
	reliable if( bNetDirty && ROLE == ROLE_Authority )
		ClientTeamIndex; // data replicated to client
}


//-----------------------------------------------------------------------------

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	if( Role < ROLE_Authority )
		ReplicationReadyCheck();
}

//-----------------------------------------------------------------------------

simulated event Destroyed()
{
//	RemoveAllTimers();
	AmbientSound = None;
	Super.Destroyed();
}

//-----------------------------------------------------------------------------

simulated function SetupClient()
{
	//class'UtilGame'.static.
	SetTeamSkin( Self, ClientTeamIndex );
}

//-----------------------------------------------------------------------------

simulated function bool ReplicationReady()
{
	return ( ClientTeamIndex != 255 );
}

//-----------------------------------------------------------------------------

simulated function ReplicationReadyCheck()
{
	// hack: assume replication complete once changes from defaults
	if( ReplicationReady() )
		SetupClient();
//	else
//		AddTimer( 'ReplicationReadyCheck', 0.05, false );
}

//-----------------------------------------------------------------------------

simulated function int GetTeamNum() { return ClientTeamIndex; }
simulated function int GetTeam() { return ClientTeamIndex; }
simulated function SetTeam( int NewTeam )
{
	//Super.SetTeam( NewTeam );
	ClientTeamIndex = NewTeam;
	SetTeamSkin( Self, ClientTeamIndex );
	CheckTeamEnergy();
}

//-----------------------------------------------------------------------------

function Controller GetKillerController() { return KillerController; }
function SetKillerController( Controller C ) { KillerController = C; }

//-----------------------------------------------------------------------------

function CheckTeamEnergy();

//-----------------------------------------------------------------------------

simulated function bool   HasUseBar( Controller User )		{ return false; }
simulated function string GetDescription( Controller User ) { return ""; }

//-----------------------------------------------------------------------------

singular event BaseChange()
{

	// hack to preserve instigator (engine version can clear the instigator)
	// it's safer to work around it than to change the engine code without knowing the side effects
	local Pawn SavedInstigator;
	SavedInstigator = Instigator;
    super.BaseChange();
	Instigator = SavedInstigator;
}

//-----------------------------------------------------------------------------

function TakeDamage( int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType )
{
	if( bPendingDelete || !bDamageable || (Role < ROLE_Authority) )
		return;

	if( Health > 0 )
	{
		if( Damage > 0 )
		{
			Health -= Damage;

			if( HitEffect!=none && (Health > 0) )
				Spawn(HitEffect);
		}
	}

	if( Health <= 0 )
	{
		Explode();
	}
}

//-----------------------------------------------------------------------------

function SetEnabled( bool bEnabled )
{
	if( bEnabled )
		Activate();
	else
		Deactivate();
}

//-----------------------------------------------------------------------------

function Activate()
{
}

//-----------------------------------------------------------------------------

function Deactivate()
{
	DamageAmount = 0;
	GotoState( 'Offline' );
}

//-----------------------------------------------------------------------------

function NotifyTeamEnergyStatus( bool bEnabled )
{
	if( !bEnabled )
		SetEnabled( bEnabled );
}

//-----------------------------------------------------------------------------

function HandleTripped();

//-----------------------------------------------------------------------------

function Explode()
{
	if( Role == ROLE_Authority )
	{
		if( DamageAmount>0 )
			MineHurtRadius( DamageAmount, DamageRadius, DamageType, Momentum, Location );
		if (ExplosionClass!=none)
			Spawn(ExplosionClass);
		if( EnergyCostPerSec > 0 )
	}
	Destroy();
}

//-----------------------------------------------------------------------------
// copied from Actor's HurtRadius so the mine can perform special handling for
// pawn(s) killed by its explosion.  This might be the ugliest copy and paste job evar.

simulated function MineHurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation, optional bool bNoFalloff )
{
	local actor Victims;
//	local actor ConglomerateIDs[10];
//	local int	i;
	local bool	bAlreadyDamaged;
	local float damageScale, dist;
	local vector dir;
	local actor HitActor;
	local vector NewHitLocation;
	local vector HitNormal;

	if( bHurtEntry )
		return;

	if( DamageRadius <= 0 || DamageAmount <= 0.0  )
		return;
	bHurtEntry = true;
	HitActor = Trace(NewHitLocation,HitNormal,HitLocation + (DamageRadius*normal(HitLocation - Location)),HitLocation,true);

	if( HitActor!=none && HitActor != Self) //We've hit either a vehicle or a stationary turret
	{
//		ConglomerateIDs[0] = HitActor.ConglomerateID;
		MineTakeDamage
			(
				HitActor, //.ConglomerateID,
				DamageAmount,
				Instigator,
				NewHitLocation,
				(Momentum * normal(velocity)),
				DamageType
			);
	}

	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if( (Victims != self) && (Victims.Role == ROLE_Authority) && (!Victims.IsA('FluidSurfaceInfo')) )
		{
		/*
			if( Victims.ConglomerateID? )
			{
				bAlreadyDamaged = false;
				for (i=0; ConglomerateIDs[i]?; i++)
				{
					if (Victims.ConglomerateID == ConglomerateIDs[i])
						bAlreadyDamaged = true;
				}
				if (!bAlreadyDamaged)
				{
					ConglomerateIDs[i] = Victims.ConglomerateID;
					Victims = Victims.ConglomerateID;
				}
			}
			*/
			if (Vehicle(Victims)!=none)
			{
				//dir = (Victims.Location /* + (Vehicle(Victims).PseudoLocationOffset >> Victims.Rotation)*/ )  - HitLocation;
				dir = Victims.Location - HitLocation;
				dist = FMax(1,VSize(dir));
				dir = dir/dist;
				damageScale = 1 - FClamp((dist - Vehicle(Victims).CollisionRadius)/DamageRadius,0,1);
				if (bNoFalloff) damageScale = 1.0;
				if( bAlreadyDamaged )
					damageScale = 0.0;
				if (damageScale > 0.0)
				MineTakeDamage
				(
					Victims,
					damageScale * DamageAmount,
					Instigator,
					//Victims.Location /*+ (Vehicle(Victims).PseudoLocationOffset >> Victims.Rotation)*/ - 0.5 * (Vehicle(Victims).PseudoRadius + Vehicle(Victims).PseudoRadius) * dir,
					Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
					(damageScale * Momentum * dir),
					DamageType
				);
			}else
			{
				dir = Victims.Location - HitLocation;
				dist = FMax(1,VSize(dir));
				dir = dir/dist;
				damageScale = 1 - FClamp((dist - Victims.CollisionRadius)/DamageRadius,0,1);
				if (bNoFalloff) damageScale = 1.0;
				if( bAlreadyDamaged )
					damageScale = 0.0;
				if (damageScale > 0.0)
				MineTakeDamage
				(
					Victims,
					damageScale * DamageAmount,
					Instigator,
					Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
					(damageScale * Momentum * dir),
					DamageType
				);
			}
		}
	}
	bHurtEntry = false;
}

//-----------------------------------------------------------------------------
// take damage for mines which keeps track of when it kills an actor

function MineTakeDamage( Actor DamagedActor, int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> DamageType )
{
	local int OldHealth, NewHealth;

	if( Pawn(DamagedActor)!=none)
		OldHealth = Pawn(DamagedActor).Health;
	else if( U2BreakableItem(DamagedActor)!=none )
		OldHealth = U2BreakableItem(DamagedActor).Health;
	else
		OldHealth = -1;		// not a scorable actor

	DamagedActor.TakeDamage( Damage, None, HitLocation, Momentum, DamageType );

	if( Pawn(DamagedActor)!=none )
		NewHealth = Pawn(DamagedActor).Health;
	else if( U2BreakableItem(DamagedActor)!=none )
		NewHealth = U2BreakableItem(DamagedActor).Health;
	else
		NewHealth = +1;		// not a scorable actor

	if( OldHealth > 0 && NewHealth <= 0 )
		MineKilled( DamagedActor, DamageType );
}

//-----------------------------------------------------------------------------
// Special handling for destroying an actor with a mine.

function MineKilled( Actor DamagedActor, class<DamageType> DamageType )
{
	local Pawn VictimPawn;
	local Controller Killer, Victim;

	VictimPawn = Pawn(DamagedActor);
	Killer = GetKillerController();

	if( VictimPawn!=none )
	{
		// give death credit
		if( xPawn(VictimPawn)!=none )
		{
			Level.Game.Killed( Killer, VictimPawn.Controller, VictimPawn, DamageType );
		}
		Victim = VictimPawn.Controller;
		if( Victim!=none ) Level.Game.BroadcastDeathMessage(Killer, Victim, DamageType);
	}
}

//-----------------------------------------------------------------------------

auto state Deployed
{
	function BeginState()
	{
		PlaySound( DeploySound );
	}
}

//-----------------------------------------------------------------------------

function bool CanBeTrippedBy( actor A )
{
	return( A==none || Pawn(A) != none );
}

//-----------------------------------------------------------------------------

state Armed
{
	event Touch(Actor Other)
	{
		if( CanBeTrippedBy( Other ) )
			HandleTripped();
	}

	//-------------------------------------------------------------------------

	function HandleTripped()
	{
		PlaySound( TrippedSound );
		AmbientSound = None;
		//AddTimer( 'ExplodeTimer', ExplodeDelay );
		SetTimer(ExplodeDelay, False);
		//ExplodeTimer();
		Disable('Touch');
	}

	function Timer()
	{
		ExplodeTimer();
	}

	//-------------------------------------------------------------------------

	function ExplodeTimer()
	{
		Explode();
	}

	//-------------------------------------------------------------------------

	function PostArmed()
	{
		AmbientSound = AmbientNoiseSound;
		bDamageable = true;
		SetCollision(true,false,false);
	}

	//-------------------------------------------------------------------------

	function PreArmed()
	{
		PlaySound( ArmingSound );
	}

	//-------------------------------------------------------------------------

Begin:
	PreArmed();
	Sleep( ArmingDelay );
	PostArmed();
}

//-----------------------------------------------------------------------------

state Offline
{
	function OnUse( actor Other );

    //-------------------------------------------------------------------------

	event Timer()
	{
		local float Damage;
		Damage = default.Health;

		if( SelfDestructDuration > 0 )
			Damage /= SelfDestructDuration;

		// keep doing damage until unit is destroyed
		TakeDamage( Damage, None, vect(0,0,0), vect(0,0,0), class'Suicided' );
	}

    //-------------------------------------------------------------------------

	function Activate()
	{
		DamageAmount = default.DamageAmount;
		GotoState( 'Armed' );
	}

	//-------------------------------------------------------------------------

	function Deactivate()
	{
	}

	//-------------------------------------------------------------------------

	function NotifyTeamEnergyStatus( bool bEnabled )
	{
		if( bEnabled )		// back online
			SetEnabled( bEnabled );
	}

	//-------------------------------------------------------------------------

	event BeginState();

	//-------------------------------------------------------------------------

Begin:
	Sleep( FRand() );		// so that all units don't appear in sync
	SetTimer( SelfDestructTimer, true );
}

//-----------------------------------------------------------------------------

defaultproperties
{
     HitEffect=Class'XEffects.WallSparks'
     ExplosionClass=Class'U2MineExplosion'
     SelfDestructTimer=1.000000
     SelfDestructDuration=5.000000
     ClientTeamIndex=255
     Health=15
     bStasis=False
     bIgnoreEncroachers=True
     bCollideWorld=True
     bNetNotify=True
     bDirectional=True
}
