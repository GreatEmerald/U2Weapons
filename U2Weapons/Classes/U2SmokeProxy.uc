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
// U2SmokeProxy.uc
// AI: A trigger that makes bots slightly disoriented and less visible.
// GreatEmerald, 2010
//-----------------------------------------------------------
class U2SmokeProxy extends Triggers;

function Touch( actor Other )
{
    local Bot B;

    if (Pawn(Other) == None || Bot(Pawn(Other).Controller) == None)
        return;
    B = Bot(Pawn(Other).Controller);
    B.BaseAlertness = (B.BaseAlertness+1)*0.4-1;
    B.Accuracy = (B.Accuracy+1)*0.4-1;  //GE: gear towards -1, not 0
    B.Pawn.Visibility = 1;

}

//GE: Possible conflicts?
function UnTouch (actor Other)
{
    local Bot B;

    if (Pawn(Other) == None || Bot(Pawn(Other).Controller) == None)
        return;
    B = Bot(Pawn(Other).Controller);
    B.BaseAlertness = B.default.BaseAlertness;
    B.Accuracy = B.default.Accuracy;
    B.Pawn.Visibility = B.Pawn.default.Visibility;
}

function Destroyed()
{
    local Pawn P;

    ForEach TouchingActors(class'Pawn', P)
        UnTouch(P);
    Super.Destroyed();
}

DefaultProperties
{
    CollisionHeight=500
    CollisionRadius=800
    //bHidden=False //Debug!
    //DrawScale=5.0 //Debug!
    LifeSpan=20
}
