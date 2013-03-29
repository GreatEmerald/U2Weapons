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
// TODO: keep emitters spawned on client
//-----------------------------------------------------------

class U2DeployableAutoTurret extends U2DeployedTurret
	placeable;


//-----------------------------------------------------------------------------

var Emitter MuzzleflashA1, MuzzleflashA2;
var Emitter MuzzleflashB1, MuzzleflashB2;
var byte FireCount, ClientFireCount; // used to let clients know when to do firing effects?

//-----------------------------------------------------------------------------

replication
{
	reliable if( bNetDirty && ROLE == ROLE_Authority )
		FireCount;
}

//-----------------------------------------------------------------------------

simulated function PostBeginPlay()
{
	if( Level.NetMode != NM_DedicatedServer )
		SetupAttachments();

	Super.PostBeginPlay();
}

//-----------------------------------------------------------------------------

simulated function Destroyed()
{
	if ( MuzzleFlashA1 != none )
		MuzzleflashA1.Kill();
	if ( MuzzleFlashA2 != none )
		MuzzleflashA2.Kill();
	if ( MuzzleflashB1 != none )
		MuzzleflashB1.Kill();
	if ( MuzzleflashB2 != none )
		MuzzleflashB2.Kill();
	Super.Destroyed();
}

//-----------------------------------------------------------------------------

simulated function SetupAttachments()
{
	MuzzleflashA1 = spawn(class'U2FX_AutoTurretMuzFlash');
	MuzzleflashB1 = spawn(class'U2FX_AutoTurretMuzFlash');
	MuzzleflashA2 = spawn(class'U2FX_AutoTurretMuzFlash');
	MuzzleflashB2 = spawn(class'U2FX_AutoTurretMuzFlash');

	AttachToBone( MuzzleflashA1, BoneLeftBarrelEnd );
	AttachToBone( MuzzleflashA2, BoneLeftBarrelEnd );
	AttachToBone( MuzzleflashB1, BoneRightBarrelEnd );
	AttachToBone( MuzzleflashB2, BoneRightBarrelEnd );
}

//-----------------------------------------------------------------------------

simulated function UpdateAttachments()
{
	MuzzleflashA1.SpawnParticle(1);
	MuzzleflashA2.SpawnParticle(1);
	MuzzleflashB1.SpawnParticle(1);
	MuzzleflashB2.SpawnParticle(1);
}

//-----------------------------------------------------------------------------


simulated event PostNetReceive()
{
	Super.PostNetReceive();

	if( FireCount != ClientFireCount )
	{
		UpdateAttachments();
		ClientFireCount = FireCount;
	}
}

//-----------------------------------------------------------------------------

function FiredWeapon()
{
	Super.FiredWeapon();
	if( Level.NetMode != NM_DedicatedServer	)
		UpdateAttachments();
	FireCount++;
}

//-----------------------------------------------------------------------------

function int GetConsumerClassIndex() { return 7; }

//-----------------------------------------------------------------------------

defaultproperties
{
     WeaponType=Class'U2WeaponAutoTurret'
     ViewOffset=(Z=15.000000)
     ActionRate=0.100000
     TrackingSound=Sound'U2XMPA.AutoTurret.AutoTurretTracking'
     ActionSound=Sound'U2XMPA.AutoTurret.AutoTurretFire'
     ActiveAlertSound=Sound'U2XMPA.AutoTurret.AutoTurretAlert'
     ExplosionClass=Class'U2FX_TurretExplosion'
     ShutDownSound=Sound'U2XMPA.AutoTurret.AutoTurretShutdown'
     DeploySound=Sound'U2XMPA.AutoTurret.AutoTurretActivate'
     DisabledSound=Sound'U2XMPA.AutoTurret.AutoTurretDisabled'
     EnabledSound=Sound'U2XMPA.AutoTurret.AutoTurretEnabled'
     AmbientNoiseSound=Sound'U2XMPA.AutoTurret.AutoTurretAmbient'
     Description="Automatic Turret"
     CarcassMesh(0)=StaticMesh'Arch_TurretsM.Small.Deployable_Disabled_TD_01'
     InventoryType=Class'U2AutoTurretDeploy'
     PickupMessage="You picked up an Auto Turret."
     EnergyCostPerSec=0.001800
     Health=350
     DrawType=DT_Mesh
     RemoteRole=ROLE_SimulatedProxy
     Mesh=SkeletalMesh'Weapons3rdPK.Turret_Cannon'
     DrawScale=0.750000
     CollisionRadius=40.000000
     CollisionHeight=50.000000
}
