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
// XMPUtil.uc
// 2004 jasonyu
// 28 April 2004
//-----------------------------------------------------------

class U2Util extends Actor
	abstract;

//=============================================================================
// Game-level utility functions, e.g. inventory, actor searching, AI.
//=============================================================================

struct ColorCode
{
    var string Code;
    var string Hex;
};

var array<ColorCode> ColorCodes;
var string TeamColorCodes[2];


static final function DumpInventory( Pawn P, optional string ContextString );
/*
{
	local Inventory Inv;

	P.DMTNS( "DumpInventory" @ ContextString $ ":" );
	for( Inv = P.Inventory; Inv != None; Inv = Inv.Inventory )
		Inv.Dump( "  ", "" );
}
*/
//-----------------------------------------------------------------------------
// Spawn and add to inventory if not already present. If an item of the same
// class is present, return that one.

static final function Inventory GiveInventoryClass( Pawn TargetPawn, class<Inventory> InvClass )
{
	local Inventory Inv, InvNew;

	//TargetPawn.DMTNS( "GiveInventoryClass " $ InvClass );
	//class'UtilGame'.static.DumpInventory( TargetPawn, "GiveInventoryClass BEGIN" );
	if( InvClass != None )
	{
		Inv = TargetPawn.FindInventoryType( InvClass );
		if( Inv == None )
		{
			InvNew = TargetPawn.Spawn( InvClass );
			if( InvNew != None )
				InvNew.GiveTo( TargetPawn );
		}
	}
	//class'UtilGame'.static.DumpInventory( TargetPawn, "GiveInventoryClass END" );
	if( Inv != None )
		return Inv;
	else
		return InvNew;
}

//-----------------------------------------------------------------------------
// Spawn and add to inventory if not already present.

static final function Inventory GiveInventoryString( Pawn TargetPawn, coerce string InventoryString )
{
	return GiveInventoryClass( TargetPawn, class<Inventory>(DynamicLoadObject( InventoryString, class'Class' )) );
}

//-----------------------------------------------------------------------------
// Add to inventory if not already present.

static final function bool GiveInventory( Pawn TargetPawn, Inventory Inv )
{
	local Inventory MatchingInv;

	if( Inv != None )
	{
		MatchingInv = TargetPawn.FindInventoryType( Inv.Class );
		if( MatchingInv == None )
		{
			Inv.GiveTo( TargetPawn );
			return true;
		}
	}

	return false;
}

//-----------------------------------------------------------------------------
// Return inventory item from holder's inventory matching class 'InventoryType'

static final function Inventory GetInventoryItem( Pawn InventoryHolder, class<Inventory> InventoryType )
{
	local Inventory CurrentInventoryItem;
	local Inventory FoundInventoryItem;

	if( InventoryHolder == None )
		return None;

	for( CurrentInventoryItem = InventoryHolder.Inventory;
			( ( None != CurrentInventoryItem ) && ( None == FoundInventoryItem ) );
			CurrentInventoryItem = CurrentInventoryItem.Inventory )
	{
		if( ClassIsChildOf( CurrentInventoryItem.Class, InventoryType ) )
		{
			FoundInventoryItem = CurrentInventoryItem;
		}
	}

	return FoundInventoryItem;
}

//-----------------------------------------------------------------------------

static function float ScaleAmmoResupplyRate( Pawn Other, float InitialRate )
{
	local Weapon W;
	local Inventory Inv;
	local int DepletedAmmoTypes, TotalAmmoTypes;

	if( Other == none )
		return InitialRate;

	// count the number of ammo types that need ammo
	for( Inv=Other.Inventory; Inv!=None; Inv=Inv.Inventory )
	{
		W = Weapon(Inv);
		if( W != none && (W.GetAmmoClass(0) != none || W.GetAmmoClass(1) != none) )
		{
			TotalAmmoTypes++;
			if( W.NeedAmmo(0) || W.NeedAmmo(1) )
				DepletedAmmoTypes++;
		}
	}

	if( DepletedAmmoTypes > 0 )
		InitialRate = InitialRate * float(TotalAmmoTypes) / float(DepletedAmmoTypes);

	return InitialRate;
}


//-----------------------------------------------------------------------------

static final function MakeShake( Actor Context, vector ShakeLocation, float ShakeRadius, float ShakeMagnitude, optional float ShakeDuration )
{
	local Controller C;
	local PlayerController Player;
	local float Dist,Pct;

	if( Context==None || ShakeRadius<=0 || ShakeMagnitude<=0 )
		return;

	for( C=Context.Level.ControllerList; C!=None; C=C.nextController )
	{
		Player = PlayerController(C);
		//NEW (mb) - don't shake a flying / ghosted player
		if( Player!=None && Player.Pawn != None && Player.Pawn.Physics != PHYS_Flying)
		{
			Dist = VSize(ShakeLocation-Player.Pawn.Location);
			if( Dist<ShakeRadius )
			{
				Pct = 1.0 - (Dist / ShakeRadius);
				Player.ShakeView(vect(1,1,1)*ShakeMagnitude,
								vect(1,1,1),
								ShakeDuration,
								vect(1,1,1)*ShakeMagnitude,
								vect(1,1,1),
								ShakeDuration);
			}
		}
	}
}

//=============================================================================
//@ Visibility
//=============================================================================

//-----------------------------------------------------------------------------
// Allows you to check if an object is in your view.
//-----------------------------------------------------------------------------
// ViewVec:	A vector facing "forward"						(relative to your location.)
// DirVec:	A vector pointing to the object in question.	(relative to your location.)
// FOVCos:	Cosine of how many degrees between ViewVec and DirVec to be seen.
//-----------------------------------------------------------------------------
// REQUIRE: FOVCos > 0
// NOTE: While normalization is not required for ViewVec or DirVec, it helps
// if both vectors are about the same size.
//-----------------------------------------------------------------------------

static final function bool IsInViewCos( vector ViewVec, vector DirVec, float FOVCos )
{
	local float CosAngle;		//cosine of angle from object's LOS to WP

    CosAngle = Normal( ViewVec ) dot  Normal( DirVec );

	//The first test makes sure the target is within the firer's front 180o view.
	//The second test might look backwards, but it isn't.  Since cos(0) == 1,
	//as the angle gets smaller, CosAngle *increases*, so an angle less than
	//the max will have a larger cosine value.

	return (0 <= CosAngle && FOVCos < CosAngle);
}

//-----------------------------------------------------------------------------
// Returns true if Target is in within given FOVCos wrt SeeingActor.
//-----------------------------------------------------------------------------

static final function bool ActorLookingAt( Actor SeeingActor, Actor Target, float FOVCos )
{
	//2002.12.19 (mdf) warning fix
	if( Target == None || SeeingActor == None )
		return false;

	return IsInViewCos( vector(SeeingActor.Rotation), Target.Location - SeeingActor.Location, FOVCos );
}


//-----------------------------------------------------------------------------
// GetDistanceBetweenCylinders:
//
// Return the distance between the 2 given cylinders (origin, radius and
// half-height for each). Can possibly return a negative value?
//-----------------------------------------------------------------------------

static final function float GetDistanceBetweenCylinders(
		vector FirstOrigin, float FirstRadius, float FirstHalfHeight,
 		vector SecondOrigin, float SecondRadius, float SecondHalfHeight )
{
	local float DistanceBetween;
	local vector OriginDifference, OriginDifferenceNormal;
	local vector FirstSurfaceLocation, SecondSurfaceLocation;

	//Log( "::Util::GetDistanceBetweenCylinders" );
	OriginDifference = SecondOrigin - FirstOrigin;
	OriginDifference.z = 0;
	OriginDifferenceNormal = Normal( OriginDifference );

	FirstSurfaceLocation = FirstOrigin + ( OriginDifferenceNormal * FirstRadius );
	SecondSurfaceLocation = SecondOrigin - ( OriginDifferenceNormal * SecondRadius );

	//Log( "::Util::GetDistanceBetweenCylinders: SecondOrigin.z - SecondHalfHeight: " $ SecondOrigin.z - SecondHalfHeight );
	//Log( "::Util::GetDistanceBetweenCylinders: FirstOrigin.z + FirstHalfHeight:   " $ FirstOrigin.z + FirstHalfHeight );
	//Log( "::Util::GetDistanceBetweenCylinders: FirstOrigin.z - FirstHalfHeight:   " $ FirstOrigin.z - FirstHalfHeight );
	//Log( "::Util::GetDistanceBetweenCylinders: SecondOrigin.z + SecondHalfHeight: " $ SecondOrigin.z + SecondHalfHeight );

	if( ( SecondOrigin.z - SecondHalfHeight ) > ( FirstOrigin.z + FirstHalfHeight ) )
	{
		//1st cylinder is above 2nd cylinder
		//distance is taken from closest point on bottom of 1st cylinder to
		//closest point on top of 2nd cylinder (within the connecting plane)
		SecondSurfaceLocation.z -= SecondHalfHeight;
		FirstSurfaceLocation.z += FirstHalfHeight;
		DistanceBetween = VSize( FirstSurfaceLocation - SecondSurfaceLocation );
		//Log( "::Util::GetDistanceBetweenCylinders Case 1" );
	}
	else if( ( FirstOrigin.z - FirstHalfHeight ) >	( SecondOrigin.z + SecondHalfHeight ) )
	{
		//1st cylinder is below 2nd cylinder
		//distance is taken from closest point on top of 1st cylinder to
		//closest point on bottom of 2nd cylinder (within the connecting plane)
		FirstSurfaceLocation.z -= FirstHalfHeight;
		SecondSurfaceLocation.z += SecondHalfHeight;
		DistanceBetween = VSize( FirstSurfaceLocation - SecondSurfaceLocation );
		//Log( "::Util::GetDistanceBetweenCylinders Case 2" );
	}
	else
	{
		//cylinders are at least partly on the same horizontal plane
		//distance is the distance between the surface locations
		//projected down to the z = 0 plane
		FirstSurfaceLocation.z = 0;
		SecondSurfaceLocation.z = 0;
		DistanceBetween = VSize( FirstSurfaceLocation - SecondSurfaceLocation );
		//Log( "::Util::GetDistanceBetweenCylinders: DistanceBetween: " $ DistanceBetween );

		//if the collision cylinders overlap, DistanceBetween is -ve
		if( VSize( OriginDifference ) < ( FirstRadius + SecondRadius ) )
		{
			DistanceBetween = -DistanceBetween;
		}
		//Log( "::Util::GetDistanceBetweenCylinders Case 3" );
	}

	//Log( "::Util::GetDistanceBetweenCylinders FirstOrigin: " $ FirstOrigin );
	//Log( "::Util::GetDistanceBetweenCylinders FirstRadius: " $ FirstRadius );
	//Log( "::Util::GetDistanceBetweenCylinders FirstHalfHeight: " $ FirstHalfHeight );
	//Log( "::Util::GetDistanceBetweenCylinders SecondOrigin: " $ SecondOrigin );
	//Log( "::Util::GetDistanceBetweenCylinders SecondRadius: " $ SecondRadius );
	//Log( "::Util::GetDistanceBetweenCylinders SecondHalfHeight: " $ SecondHalfHeight );
	//Log( "::Util::GetDistanceBetweenCylinders OriginDifference: " $ OriginDifference );
	//Log( "::Util::GetDistanceBetweenCylinders OriginDifferenceNormal: " $ OriginDifferenceNormal );
	//Log( "::Util::GetDistanceBetweenCylinders FirstSurfaceLocation : " $ FirstSurfaceLocation  );
	//Log( "::Util::GetDistanceBetweenCylinders SecondSurfaceLocation: " $ SecondSurfaceLocation );
	//Log( "::Util::GetDistanceBetweenCylinders returning " $ DistanceBetween );

	return DistanceBetween;
}




//=============================================================================
//@ randomness
//=============================================================================

//-----------------------------------------------------------------------------
// Randomly modifies the given float by +/- given %.
//
// e.g. PerturbFloatPercent( 100.0, 20.0) will return a value in 80.0..120.0
//-----------------------------------------------------------------------------

static final function float PerturbFloatPercent( float Num, float PerturbPercent )
{
	local float Perturb;

	Perturb = 2.0*PerturbPercent / 100.0;

	return Num + Num * ( ( Perturb * FRand() - Perturb / 2.0 ) );
}

static function float VSize2D( vector V )
{
    return Sqrt(Square(V.X) + Square(V.Y));
}

// TODO
static final function bool DoCylindersIntersect( vector Location1, float CollisionRadius1, float CollisionHeight1, vector Location2, float CollisionRadius2, float CollisionHeight2 )
{
	// x/y test
	if( VSize2D( Location1 - Location2 ) > (CollisionRadius1 + CollisionRadius2) )
		return false;
	// z tests
	if( (Location1.Z - CollisionHeight1) > (Location2.Z + CollisionHeight2) )
		return false;
	if( (Location1.Z + CollisionHeight1) < (Location2.Z - CollisionHeight2) )
		return false;

	return true;
}

static final function bool DoActorCylindersIntersect( Actor A1, Actor A2 )
{
	return DoCylindersIntersect( A1.Location, A1.CollisionRadius, A1.CollisionHeight, A2.Location, A2.CollisionRadius, A2.CollisionHeight );
}


//=============================================================================
//@ Aiming
//=============================================================================

static final function vector GetRotatedFireStart( Pawn SourcePawn, vector SourceLocation, rotator TargetRotation, vector FireOffset )
{
	local vector X, Y, Z;
	local vector ReturnedFireStart;

	GetAxes( TargetRotation, X, Y, Z );

	ReturnedFireStart = SourceLocation + SourcePawn.EyePosition() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;

	// prone NPCs are getting a fire start that is in the ground?
	ReturnedFireStart.Z = FMax( SourceLocation.Z - 0.5*SourcePawn.CollisionHeight, ReturnedFireStart.Z );

	//SourcePawn.DMTNS( "GetRotatedFireStart returning " $ ReturnedFireStart );
	//SourcePawn.DMTNS( "  TargetRotation: " $ TargetRotation );
	//SourcePawn.DMTNS( "  EyePosition:    " $ TargetPawn.EyePosition() );
	return ReturnedFireStart;
}

//------------------------------------------------------------------------------
// Color parsing
//------------------------------------------------------------------------------
static function int GetHexDigit(string D)
{
	switch(caps(D))
	{
    	case "0": return 0;
    	case "1": return 1;
    	case "2": return 2;
    	case "3": return 3;
    	case "4": return 4;
    	case "5": return 5;
    	case "6": return 6;
    	case "7": return 7;
    	case "8": return 8;
    	case "9": return 9;
    	case "A": return 10;
    	case "B": return 11;
    	case "C": return 12;
    	case "D": return 13;
    	case "E": return 14;
    	case "F": return 15;
	}
	return -1;
}

static final function int HexToDec(string hexcode) // From LibHTTP
{
    local int res, i, cur;

    if(!IsValidHex(hexcode))
        return -1;

    res = 0;
    hexcode = Caps(hexcode);
    for (i = 0; i < len(hexcode); i++)
    {
        cur = Asc(Mid(hexcode, i, 1));

        if (cur == 32)
            return res;

        cur -= 48;
        if (cur > 9)
            cur -= 7;

        if ((cur > 15) || (cur < 0))
            return -1; // not possible

        res = res << 4;
        res += cur;
    }
    return res;
}
static function bool IsValidHex(string Hex)
{
    local int strlen, i;
    strlen = len(hex);

    if(strlen > 6)
        return false;

    for(i=0; i < strlen; i++)
    {
        if(GetHexDigit(Mid(hex,i,1)) == -1)
            return false;
    }
    return true;
}

static function color HexToRGB(String hex)
{
    local Color C;

    C.A = 255;
    C.R = HexToDec(Mid(hex,0,2));
    C.G = HexToDec(Mid(hex,2,2));
    C.B = HexToDec(Mid(hex,4,2));

    return C;
}

static function GetShortColorCodes(out string replacer)
{
    local int i;
    local string workstr;

    workstr = replacer;

    for(i=0; i < default.ColorCodes.Length; i++)
        workstr = Repl(workstr, default.ColorCodes[i].Code, default.ColorCodes[i].Hex, false);
    replacer = workstr;
}

static function GetColorCodes(String in, out array<String> parts, out array<String> colors)
{
    local int i, index, strlen;
    local string colored;

    colored = in;

    index = InStr(colored,"#");

    if(index == -1)
    {
        parts.Length = parts.Length+1;
        parts[parts.Length-1] = colored;

        colors.length = colors.length + 1;
        colors[colors.length-1] = "";
        return;
    }

    strlen = len(colored);
    for(i=0; i < strlen; i++)
    {
        if(Mid(colored,i,1) ~= "#")
        {
            if(IsValidHex(Mid(colored,i+1,6)))
            {
                index = XInStr(colored,"#",i+7);
                if(index == -1 || (index != -1 && !IsValidHex(Mid(Colored,index+1,6))))
                {
                    if(i != 0 && parts.length == 0)
                    {
                        parts.Length = parts.Length+1;
                        parts[parts.Length-1] = Mid(colored,0,i);

                        colors.length = colors.length + 1;
                        colors[colors.length-1] = "";

                        parts.Length = parts.Length+1;
                        parts[parts.Length-1] = Mid(colored,i+7);

                        colors.length = colors.length + 1;
                        colors[colors.length-1] = Mid(colored,i+1,6);
                        return;
                    }
                    else
                    {
                        parts.Length = parts.Length+1;
                        parts[parts.Length-1] = Mid(colored,i+7);

                        colors.length = colors.length + 1;
                        colors[colors.length-1] = Mid(colored,i+1,6);
                        return;
                    }
                }
                else
                {
                    if(i != 0 && parts.length == 0)
                    {
                        parts.Length = parts.Length+1;
                        parts[parts.Length-1] = Mid(colored,0,i);

                        colors.length = colors.length + 1;
                        colors[colors.length-1] = "";

                        parts.Length = parts.Length+1;
                        parts[parts.Length-1] = Mid(colored,i+7,index - (i+7));

                        colors.length = colors.length + 1;
                        colors[colors.length-1] = Mid(colored,i+1,6);
                    }
                    else
                    {
                        parts.Length = parts.Length+1;
                        parts[parts.Length-1] = Mid(colored,i+7,index - (i+7));

                        colors.length = colors.length + 1;
                        colors[colors.length-1] = Mid(colored,i+1,6);
                    }
                }
            }
            else
                continue;
        }
    }
}

static function int XInStr(String in, string regex, int start)
{

    local int index;

    if(in == "")
        return -1;
    if(regex == "")
        return -1;

    index = InStr(Mid(in,start),regex);
    if(index != -1)
        return( start + index );
    else
        return -1;
}

static function String StripColors(String in)
{
    local array<String> parts, colors;
    local string res;
    local int i;

    GetColorCodes(in,parts,colors);

    for(i=0; i < parts.length; i++)
        res = res $ parts[i];

    return res;
}

static function string StripShortColors(string in)
{
    local int i;
    local string workstr;

    workstr = in;

    for(i=0; i < default.ColorCodes.Length; i++)
        workstr = Repl(workstr, default.ColorCodes[i].Code, "", false);

    return workstr;
}

// Draws one line of colorized text at a time
static function RenderColorizedText(Canvas Canvas, String text, float XPos, float YPos, optional Color defaultColor)
{
    local Color savedColor;
    local int i;
    local float drawX;
    local float XL, YL;

    local array<String> parts, colors;

    savedColor = Canvas.DrawColor;


    GetShortColorCodes(text);
    GetColorCodes(text,parts,colors);

    Canvas.SetPos( XPos, YPos );
    drawX = XPos;
    for(i=0; i < parts.length; i++)
    {
        if(colors[i] != "")
            Canvas.DrawColor = HexToRGB(colors[i]);
        else
            Canvas.DrawColor = defaultColor;

        Canvas.StrLen(parts[i], XL, YL);
        Canvas.DrawText(parts[i]);
        drawX += XL;
        Canvas.SetPos( drawX, YPos );
    }
    Canvas.DrawColor = savedColor;
}

defaultproperties
{
     ColorCodes(0)=(Code="^1",Hex="#E70000")
     ColorCodes(1)=(Code="^2",Hex="#0B7116")
     ColorCodes(2)=(Code="^3",Hex="#EAEA00")
     ColorCodes(3)=(Code="^4",Hex="#0101F4")
     ColorCodes(4)=(Code="^5",Hex="#00FBFC")
     ColorCodes(5)=(Code="^6",Hex="#C007C5")
     ColorCodes(6)=(Code="^7",Hex="#FFFFFF")
     ColorCodes(7)=(Code="^8",Hex="#7E7E7E")
     ColorCodes(8)=(Code="^9",Hex="#000000")
     TeamColorCodes(0)="#EF0000"
     TeamColorCodes(1)="#0017EF"
}
