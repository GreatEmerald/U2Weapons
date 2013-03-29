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
// ====================================================================
//  Parent class for all forcewallbeams
//
//  Written by Alex Dobie
//  (c) 2004, Free Monkey Interactive.  All Rights Reserved
// ====================================================================
class U2FX_ForceWallBeam extends Emitter;

const DegreesToRadians					= 0.0174532925199432;	// PI / 180.0
const RadiansToDegrees					= 57.295779513082321;	// 180.0 / PI
const DegreesToRotationUnits			= 182.044; 				// 65536 / 360
const RotationUnitsToDegrees			= 0.00549; 				// 360 / 65536

simulated function ModLength(float NewLength)
{

	local int XOffset;
	local int theta;

	theta = Rotation.Pitch * RotationUnitsToDegrees * DegreesToRadians;
	XOffset = Sin(theta) / 25;

	BeamEmitter(Emitters[0]).BeamEndPoints[0].Offset.X.Max = NewLength;
	BeamEmitter(Emitters[1]).BeamEndPoints[0].Offset.X.Max = NewLength;
	BeamEmitter(Emitters[2]).BeamEndPoints[0].Offset.X.Max = NewLength;
	BeamEmitter(Emitters[3]).BeamEndPoints[0].Offset.X.Max = NewLength;

	BeamEmitter(Emitters[0]).BeamEndPoints[0].Offset.X.Min = NewLength;
	BeamEmitter(Emitters[1]).BeamEndPoints[0].Offset.X.Min = NewLength;
	BeamEmitter(Emitters[2]).BeamEndPoints[0].Offset.X.Min = NewLength;
	BeamEmitter(Emitters[3]).BeamEndPoints[0].Offset.X.Min = NewLength;

	BeamEmitter(Emitters[1]).StartLocationRange.X.Min = XOffset;
	BeamEmitter(Emitters[1]).StartLocationRange.X.Max = XOffset;
	BeamEmitter(Emitters[2]).StartLocationRange.X.Min = XOffset * -1;
	BeamEmitter(Emitters[2]).StartLocationRange.X.Max = XOffset * -1;
	BeamEmitter(Emitters[3]).StartLocationRange.X.Min = XOffset * 2;
	BeamEmitter(Emitters[3]).StartLocationRange.X.Max = XOffset * 2;
}

defaultproperties
{
     RemoteRole=ROLE_SimulatedProxy
}
