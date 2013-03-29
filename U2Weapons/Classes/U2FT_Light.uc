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
// 26 June 2004
//-----------------------------------------------------------

class U2FT_Light extends Light;


var() vector Offset;

var float Time;

//------------------------------------------------------------------------------
event Tick( float DeltaTime )
{
	if( Time > 0 )
	{
		Time -= DeltaTime;
		if( Time <= 0 )
		{
			Time = 0;
			TurnOff();
			return;
		}
	}
	if( LightType != LT_None )
	{
		if( Owner != None )
			SetLocation( Owner.Location + (Offset >> Owner.Rotation) );
	}
}

//------------------------------------------------------------------------------
function Trigger( actor Other, pawn Instigator )
{
	TurnOn();
	Time = 0.2;
}

//------------------------------------------------------------------------------
function TurnOn()
{
	LightType = LT_Steady;
}

//------------------------------------------------------------------------------
function TurnOff()
{
	LightType = LT_None;
}

defaultproperties
{
     LightHue=32
     LightSaturation=80
     LightBrightness=255.000000
     LightRadius=12.000000
     bStatic=False
     bNoDelete=False
     bDynamicLight=True
     RemoteRole=ROLE_None
     bMovable=True
}
