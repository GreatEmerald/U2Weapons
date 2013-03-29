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

class U2DeployedRocketTurret extends U2DeployedTurret
	placeable;

//-----------------------------------------------------------------------------

defaultproperties
{
     WeaponType=Class'U2TurretWeaponRocket'
     bSplashDamage=True
     ViewOffset=(Z=14.000000)
     ActionRate=2.000000
     TrackingSound=Sound'U2XMPA.RocketTurret.RocketTurretTracking'
     ActiveAlertSound=Sound'U2XMPA.RocketTurret.RocketTurretAlert'
     ExplosionClass=Class'U2FX_TurretExplosion'
     ShutDownSound=Sound'U2XMPA.RocketTurret.RocketTurretShutdown'
     DeploySound=Sound'U2XMPA.AutoTurret.AutoTurretActivate'
     AmbientNoiseSound=Sound'U2XMPA.RocketTurret.RocketTurretAmbient'
     Description="Rocket Turret Deployable"
     CarcassMesh(0)=StaticMesh'Arch_TurretsM.Small.Deployable_Disabled_TD_02'
     InventoryType=Class'U2WeaponRocketTurret'
     PickupMessage="You picked up a Rocket Turret."
     DrawType=DT_Mesh
     Mesh=SkeletalMesh'Weapons3rdPK.Turret_Rocket'
     TransientSoundRadius=1000.000000
}
