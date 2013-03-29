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
// XMPBreakableItem.uc
// 2004 jasonyu
// 26 July 2004
//-----------------------------------------------------------

class U2BreakableItem extends Decoration;

var() mesh BrokenMesh;
var() StaticMesh BrokenStaticMesh;
var() sound BreakSound;
var() Emitter BreakParticleEffectsRefs[6];
var() bool bDestroyCollision; 					// Turns off collision after light is broken

// HurtRadius
var() float DamageAmount;
var() float DamageRadius;
var() class<DamageType> DamageType;
var() float Momentum;

// ShakeView
var() bool bShakeView;							// set this to enable the following.
var(ShakeView) float	Duration;				// how long quake should last
var(ShakeView) float	ShakeMagnitude;			// How much to shake the camera.
var(ShakeView) float	BaseTossMagnitude;		// toss Magnitudenitude at epicenter, 0 at radius
var(ShakeView) float	Radius;					// radius of quake
var(ShakeView) bool		bTossNPCs;				// if true, NPCs in area are tossed around
var(ShakeView) bool		bTossPCs;				// if true, PCs in area are tossed around
var(ShakeView) float	MaxTossedMass;			// if bTossPawns true, only pawns <= this mass are tossed
var(ShakeView) float	TimeBetweenShakes;		// time between each shake
var(ShakeView) string	AmbientSoundStr;		// sound for duration of quake
var(ShakeView) string	ShakeSoundStr;			// sound for each shake

var()	string Description;

var(Display) array<Material> AlternateSkins;	// Multiple skin support - not replicated.
var(Display) int			RepSkinIndex;		// skin index to replicate
var Material RepSkinNew;

var int InitialHealth;

replication
{
	unreliable if ( (!bSkipActorPropertyReplication || bNetInitial) && (Role==ROLE_Authority) && bNetDirty )
		RepSkinNew, RepSkinIndex;
}

simulated event PostNetReceive()
{
	Skins[RepSkinIndex] = RepSkinNew;
}

final function SetTeamSkin( U2BreakableItem TargetActor, int NewTeam )
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

simulated function int GetTeamNum() { return 255; }
simulated function int GetTeam() { return 255; }
function int GetConsumerClassIndex() { return 0; }


event PreBeginPlay()
{
	Super.PreBeginPlay();
	InitialHealth = Health;
}

simulated function bool   HasUseBar( Controller User )		{ return true; }
simulated function float  GetUsePercent( Controller User )	{ return float(Health) / float(InitialHealth); }
simulated function string GetDescription( Controller User ) { return Description @ "(" @ Health @ ")"; }
simulated function int    GetUseIconIndex( Controller User ){ return 0; }

function BreakApart()
{
// breakable handling -- override in subclasses.
	local int i;

	if( BrokenMesh!=None )
		LinkMesh(BrokenMesh);
//		Mesh = BrokenMesh;

	if( BrokenStaticMesh!=None )
		SetStaticMesh( BrokenStaticMesh );

	for( i=0; i<ArrayCount(BreakParticleEffectsRefs); i++ )
		if( BreakParticleEffectsRefs[i]!=None )
			ParticleExplosionRef( BreakParticleEffectsRefs[i] );

	if( BreakSound!=None )
		PlaySound( BreakSound, SLOT_None );

	if( DamageAmount>0 )
		HurtRadius( DamageAmount, DamageRadius, DamageType, Momentum, Location );

	if( bShakeView )
		ShakeView();

	Scaleglow = 1.0;
	Ambientglow = 0;
	SoundVolume = 0;

	if( bDestroyCollision )
		SetCollision( false, false, false );

	if( BrokenMesh==none && BrokenStaticMesh==none )
		Destroy();
}


function TakeDamage( int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType )
{
	if( bStatic )
		return;

	Instigator = InstigatedBy;
	if( Instigator != None )
	{
		MakeNoise( 1.0 );
	}
	if( Health > 0 )
	{
		Health -= Damage;
		if( Health <= 0 )
		{
			BreakApart();
		}
	}
}


function ParticleExplosionRef( Emitter Effect )
{
//	local Emitter Spawner;
//	Spawner = Spawn( class'Emitter',,, Location, Rotation );
//	Spawner.SetEffect(Effect);
}


function ShakeView();
/*
{
	local EarthquakeTrigger T;

	T = Spawn( class'EarthquakeTrigger',,, Location );
	T.Duration				= Duration;
	T.ShakeMagnitude		= ShakeMagnitude;
	T.BaseTossMagnitude		= BaseTossMagnitude;
	T.Radius				= Radius;
	T.bTossNPCs				= bTossNPCs;
	T.bTossPCs				= bTossPCs;
	T.MaxTossedMass			= MaxTossedMass;
	T.TimeBetweenShakes		= TimeBetweenShakes;
	T.AmbientSoundStr		= AmbientSoundStr;
	T.ShakeSoundStr			= ShakeSoundStr;
	T.Trigger( self, Instigator );
}
*/

function NotifyTeamEnergyStatus( bool bEnabled );

defaultproperties
{
     bDestroyCollision=True
     Duration=10.000000
     ShakeMagnitude=20.000000
     BaseTossMagnitude=2500000.000000
     Radius=2048.000000
     bTossNPCs=True
     bTossPCs=True
     MaxTossedMass=500.000000
     TimeBetweenShakes=0.500000
     bDamageable=True
     Health=20
     bStatic=False
     bProjTarget=True
}
