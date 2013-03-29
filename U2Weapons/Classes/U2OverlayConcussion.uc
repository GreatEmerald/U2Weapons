/*
 * Copyright (c) 2011, 2013 Dainius "GreatEmerald" Masiliūnas
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
//-----------------------------------------------------------------------------
// U2OverlayConcussion.uc
// The white thing after you get conc'd
// No moar hax!
// GreatEmerald, 2011
//-----------------------------------------------------------------------------
class U2OverlayConcussion extends HUDOverlay;

var float Countdown;

simulated function PreBeginPlay()
{
    Disable('Tick');
    Super.PreBeginPlay();
}

simulated function Render(Canvas C)
{
    local plane OldModulate;

    OldModulate = C.ColorModulate;

    C.ColorModulate.X=1;
    C.ColorModulate.Y=1;
    C.ColorModulate.Z=1;
    C.ColorModulate.W=1;

	C.SetDrawColor(255,255,255,FlashbangAlpha(Countdown));
	C.Style = ERenderStyle.STY_Alpha;
	C.SetPos(0,0);
	C.DrawTile(Texture'Engine.WhiteTexture',
			C.ClipX,C.ClipY,
			0.0,
			0.0,
			Texture'Engine.WhiteTexture'.USize,
			Texture'Engine.WhiteTexture'.VSize);

	C.ColorModulate = OldModulate;
}

simulated static function float FlashbangAlpha(float Time)	{ return FClamp( (Time / 4.0) * 255.0, 1.0, 255.0 ); } //GE: Byte rollover hack. No way to do it right..

//GE: Countdown.
simulated function Tick(float DeltaTime)
{
    if (Countdown - DeltaTime > 0)
        Countdown -= DeltaTime;
	else
	//{
    	//log(self$": Shutting down overlay!");
        Disable('Tick');//GE: Not Destroy() because spawning things is costy, and you are likely to get conc'd again soon
    //}
}

DefaultProperties
{
}
