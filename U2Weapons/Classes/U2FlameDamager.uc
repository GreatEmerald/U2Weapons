/*
 * Copyright (c) 2009, 2013 Dainius "GreatEmerald" Masiliūnas
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
// U2FlameDamager.uc
// A class used as a placeholder for setting enemies on fire
// 2009, GreatEmerald
//-----------------------------------------------------------
class U2FlameDamager extends Actor;

var float DamageTimeAccum;
var Pawn Victim;
var int Damage;     // Weapon damage will be spread out over a second
//var Pawn Instigator;
var Vector HitLocation;
var Vector Momentum;
var class<DamageType> DamageType;
var float Duration;         // How long pawn stays on fire.
var float SecondsPerDamage; // How long it takes to do one point of damage
var bool beingdamaged;

//
// oh gee I seem to be on fire
//

function PreBeginPlay()
{
   //GE: We spawned, but we serve no purpose! Save our resources!
   beingdamaged = false; //GE: PreBeginPlay is called earlier than BeginDamaging.
   SetTimer(1.0, false);
}

function Timer()
{
    if (!beingdamaged)
        Destroy();
}

function BeginDamaging (Pawn Vict, /*Pawn Inst,*/ class<DamageType> DT, Vector HLocation, optional Vector M, optional int Dur, optional int Dam)
{
    local U2FlameDamager CheckList;

    foreach AllActors(class'U2FlameDamager', CheckList)
    {
        if (CheckList != self && CheckList.Victim == Vict)
        {
            Destroy();
            return;
        }
    }

    Victim=Vict;
    if (Dam > 0)
        Damage=Dam;
    //Instigator=Inst;  //GE: Do we need an Instigator? It autosets it on spawn
    HitLocation=HLocation;
    Momentum=vect( 0, 0, 0 );
    DamageType=DT;
    if (Dur > 0)
        Duration=Dur;
    DamageTimeAccum = 0;
//    Instigator=Inst;
    if (Victim != None && !Victim.IsA('Vehicle')) //GE: Metal doesn't go on fire.
    {
        beingdamaged = True;
        GotoState('DoingDamage');
    }
}

function StopDamaging ()
{
    Victim.TakeDamage( 1, Instigator, HitLocation, Momentum, DamageType );
    GotoState('');
    Destroy();
}

state DoingDamage
{
event BeginState()
{
    enable ('Tick');
}
event EndState()
{
    disable ('Tick');
}
event Tick( float DeltaTime )
{
    local int DamageDealt;
    if (Victim!=None && Victim.Health>0 && !Victim.bDeleteMe && !bDeleteMe)
    {

        DamageTimeAccum += DeltaTime;
        DamageDealt=0;
        // Accumulate damage for this tick.
        while( DamageTimeAccum > SecondsPerDamage )
        {
            DamageTimeAccum -= SecondsPerDamage;
            DamageDealt+=1;
        }
        if( DamageDealt>0 )
        {
            Victim.TakeDamage( DamageDealt, Instigator, HitLocation, Momentum, DamageType );
        }
    } else Destroy();
}
Begin:
    sleep (Duration);
    StopDamaging();
}

defaultproperties
{
    Damage=40   //17.5
    Duration=5.000000
    SecondsPerDamage=0.100000
    bHidden=true
}
