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
// XMPProximitySensor.uc
// 2004 jasonyu
// 25 July 2004
//-----------------------------------------------------------

class U2ProximitySensor extends U2DeployedUnit
	placeable;

#exec obj load file=U2PST.usx

var()	float		TimeToTrack;
var()	float		ActionRate;					// refire rate (should come from weapon firerate but not working)
var()   bool		bAmbientActionSound;		//should the FireSound/AltFireSound be played as an ambient sound?
var()	float		TrackingRangeMultiplier;
var		Sound		TrackingSound;
var		Sound		ActionSound;
var		Sound		ActiveAlertSound;

//-----------------------------------------------------------------------------

function NotifyDeployed()
{
	if (U2ProximitySensorController(Controller) != none)
	{
        U2ProximitySensorController(Controller).NotifyDeployed();
	}
    Super.NotifyDeployed();
}

//-----------------------------------------------------------------------------

function SetEnabled( bool bVal )
{
	bEnabled = bVal;
	if( Controller != None )
	{
		if( bEnabled )
			U2ProximitySensorController(Controller).Activate();
		else
			U2ProximitySensorController(Controller).Deactivate();
	}
}

//-----------------------------------------------------------------------------

defaultproperties
{
     TimeToTrack=1.000000
     ActionRate=1.500000
     TrackingRangeMultiplier=2.000000
     TrackingSound=Sound'U2XMPA.ProximitySensor.ProximitySensorTracking'
     ActionSound=Sound'U2XMPA.ProximitySensor.ProximitySensorAlert'
     ShutDownSound=Sound'U2XMPA.ProximitySensor.ProximitySensorShutdown'
     DeploySound=Sound'U2XMPA.ProximitySensor.ProximitySensorActivate'
     DisabledSound=Sound'U2XMPA.ProximitySensor.ProximitySensorDisabled'
     EnabledSound=Sound'U2XMPA.ProximitySensor.ProximitySensorEnabled'
     AmbientNoiseSound=Sound'U2XMPA.ProximitySensor.ProximitySensorAmbient'
     Description="Proximity Sensor"
     InventoryType=Class'U2ProximitySensorDeploy'
     PickupMessage="You picked up a Proximity Sensor."
     SightRadius=4000.000000
     BaseEyeHeight=48.000000
     Health=300
     //AutoTurretControllerClass=Class'U2ProximitySensorController'
     ControllerClass=Class'U2ProximitySensorController'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'U2PST.ProximitySensor2'
     DrawScale=1.700000
     PrePivot=(Z=-1.500000)
     SoundRadius=100.000000
     TransientSoundRadius=1400.000000
     TransientSoundVolume=2.0
     CollisionRadius=18.000000
     CollisionHeight=31.000000
     ExplosionClass=Class'U2FX_TurretExplosion'
}
