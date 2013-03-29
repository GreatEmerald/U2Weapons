/*
 * Copyright (c) 2010, 2013 Dainius "GreatEmerald" Masiliūnas
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
// GEUtilities.uc
// A set of helpful static utilities that you can call from any class.
// GreatEmerald, 2010
//-----------------------------------------------------------
class GEUtilities extends Info;

//GE: Returns the Y of a point in a line function when given two points and an X of the third.
static final function float LinearInterpolateY(float x1, float y1, float x2, float y2, float x3)
{
    local InterpCurve IC;

    //GE: Df: x2-x1 != 0
    if (x1 == x2)
    {
        warn("Nothing to interpolate or not a function!");
        return y1;
    }

    IC.Points.Length=2;
    IC.Points[0].InVal=x1;
    IC.Points[0].OutVal=y1;
    IC.Points[1].InVal=x2;
    IC.Points[1].OutVal=y2;

    //log("GEUtilities: Returning"@InterpCurveEval(IC, x3)@"as opposed to"@((x3-x1)*y2+(x2-x3)*y1)/(x2-x1));
    return InterpCurveEval(IC, x3);
    //GE: Uncomment the following line for an alternative solution.
    //return (((x3-x1)*y2+(x2-x3)*y1)/(x2-x1));
}

//GE: Swaps the two entered values.
static final function FSwap(out float A, out float B)
{
    local float temp;

    temp = A;
    A=B;
    B=temp;
}

static final function LogSelf(Object Other, coerce string LogString)
{
    Log(Other$":"@LogString);
}

static final function float FPositive(float Number)
{
    return FMax(Number, -Number);
}

static final function float FNegative(float Number)
{
    return FMin(Number, -Number);
}

static final function int Positive(int Number)
{
    return Max(Number, -Number);
}

static final function int Negative(int Number)
{
    return Min(Number, -Number);
}

//GE: Easy way to register GameRules.
final function bool RegisterGameRules(class<GameRules> GRClass)
{
    local GameRules GR;

    GR = spawn(GRClass);
	if (GR != None)
	{
    	if ( Level.Game.GameRulesModifiers == None )
            Level.Game.GameRulesModifiers = GR;
    	else
            Level.Game.GameRulesModifiers.AddGameRules(GR);

        return true;
    }
    return false;
}

DefaultProperties
{

}
