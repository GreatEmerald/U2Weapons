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
// 29 July 2004
// UT2004 implementation by GreatEmerald, 2009
//-----------------------------------------------------------

class U2TripLaser extends Emitter;

var Actor EndActor;
var bool bInitialized;

var vector StartPt, EndPt;

var U2LaserProxy EndProxy, MotionDetector;

var(Damage) float				DamageTime;	// time between damage traces.
var         float				DamageTimer;
var(Damage) int					DamageAmount;
var(Damage) vector				DamageMomentum;
var(Damage) class<DamageType>	DamageType;
var(Damage) string				DamageEffect;
var(Damage) name				DamageEvent;
var(Damage) float				DamageSleep;

replication
{
//	unreliable if ( (!bSkipActorPropertyReplication || bNetInitial) && (Role==ROLE_Authority) && bNetDirty )
	reliable if ( Role==ROLE_Authority )
		StartPt, EndPt;
}

simulated event PostNetReceive()
{
	SetPos();
}

simulated function AddConnectionEx( vector Start, vector End, actor EndBase )
{
	EndProxy = Spawn(class'U2LaserProxy',,,End);
	EndProxy.SetBase( Owner );

	StartPt = Start;
	EndPt = End;
	SetPos();
	bInitialized = true;

	if( Level.NetMode != NM_Client )
	{
		MotionDetector = Spawn(class'U2LaserProxy',,,End);
		MotionDetector.SetBase( EndBase );
		MotionDetector.bProjTarget = true;
		MotionDetector.Laser = Self;
	}
}

simulated function SetPos()
{
	SetLocation(StartPt);
	BeamEmitter(Emitters[0]).BeamDistanceRange.Max = VSize(EndPt - StartPt);
	BeamEmitter(Emitters[0]).BeamDistanceRange.Min = VSize(EndPt - StartPt);
	SetRotation(Rotator(EndPt - StartPt));
}

//-----------------------------------------------------------------------------

event Tick( float DeltaTime )
{
	local Actor HitActor;
	local vector HitLocation, HitNormal;

//	if( !bInitialized || DamageTime <= 0 )
//	{
//		Disable('Tick');
//		return;
//	}

	if ( !bInitialized )
		return;

	DamageTimer += DeltaTime;

	if( DamageTimer >= DamageTime )
	{
		DamageTimer = 0;

		HitActor = Trace( HitLocation, HitNormal, EndPt, StartPt, true );
		HandleHitActor( HitActor, HitLocation, HitNormal );

		CheckMotionDetector();
	}
}

//-----------------------------------------------------------------------------

function bool CanBeTrippedBy( actor A )
{
	return( Pawn(A) != none );
}

//-----------------------------------------------------------------------------

function HandleHitActor( actor HitActor, vector HitLocation, vector HitNormal )
{
	// the mine laser end no longer hits the end point
	if( HitActor != MotionDetector )
	{
		// the mine-attached actor has moved or someone tripped the mine
		if( HitActor == None || CanBeTrippedBy(HitActor) )
		{
			if (Owner!=None)
				Owner.Touch( HitActor );
			DamageTimer = -DamageSleep;
		}
	}
}

//-----------------------------------------------------------------------------

function CheckMotionDetector()
{
	if( EndProxy == none || MotionDetector == none )
		return;

	if( class'U2Util'.static.GetDistanceBetweenCylinders(
													EndProxy.Location,
													EndProxy.CollisionRadius,
													EndProxy.CollisionHeight,
													MotionDetector.Location,
													MotionDetector.CollisionRadius,
													MotionDetector.CollisionHeight ) > 0 )
	{
		HandleHitActor( None, vect(0,0,0), vect(0,0,0) );
	}
}

//-----------------------------------------------------------------------------

event PostBeginPlay()
{
	Super.PostBeginPlay();
	if( Level.NetMode == NM_Client )
		Disable('Tick');
}

//-----------------------------------------------------------------------------

singular event BaseChange()
{
	Super.BaseChange();
	if( Owner != none )
		Owner.BaseChange();
}

//-----------------------------------------------------------------------------

event Destroyed()
{
	if( EndProxy != none )			{ EndProxy.Destroy();		EndProxy		= None; }
	if( MotionDetector != none )	{ MotionDetector.Destroy(); MotionDetector	= None; }
	Super.Destroyed();
}

//-----------------------------------------------------------------------------

defaultproperties
{
     DamageTime=0.200000
     bNoDelete=False
     RemoteRole=ROLE_SimulatedProxy
     bBlockKarma=True
     bNetNotify=True
}
