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
// XMPAutoTurretWeapon.uc
// 2004 jasonyu
// 25 July 2004
//-----------------------------------------------------------

class U2WeaponAutoTurret extends U2AssaultRifleInv;

//-----------------------------------------------------------------------------

var float TraceSpread;

//-----------------------------------------------------------------------------

simulated function SendEvent( string EventName );
simulated function SetupAttachments();
simulated function UpdateAttachments();
simulated function AttachToPawn(Pawn P);

//-----------------------------------------------------------------------------

defaultproperties
{
     bUpdateLocation=False
     FireModeClass(0)=Class'U2AutoTurretFire'
     FireModeClass(1)=Class'U2AutoTurretFire'
     Priority=21
     PlayerViewOffset=(X=0.000000,Z=0.000000)
     SelectSound=Sound'U2XMPA.AutoTurret.AutoTurretActivate'
     TransientSoundVolume=0.6
}
