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
// U2DecoyHealth.uc
// A decoy for attracting bots
//-----------------------------------------------------------
class U2DecoyHealth extends TournamentHealth;

var U2PowerStation Station;

//GE: Disable respawn effect.
function RespawnEffect();

function Take(Pawn P)
{
    //P.ClientMessage("DecoyHealth: HealingAmount is"@HealingAmount);
    /*if ( ValidTouch(P) )
    {
        AnnouncePickup(P);
        SetRespawn();
    }  */
}

function bool ValidTouch( actor Other )
{
    // make sure its a live player
    if ( (Pawn(Other) == None) || !Pawn(Other).bCanPickupInventory || (Pawn(Other).DrivenVehicle == None && Pawn(Other).Controller == None) )
        return false;

    // make sure not touching through wall
    if ( !FastTrace(Other.Location, Location) )
        return false;

    // make sure game will let player pick me up
    if( Level.Game.PickupQuery(Pawn(Other), self) )
    {
        TriggerEvent(Event, self, Pawn(Other));
        return true;
    }
    return false;
}

event float BotDesireability(Pawn Bot)
{
    local float desire, result;
    local int HealMax;

    if (Station != None && Station.PowerUpOwner != None && Station.PowerUpOwner != Bot) //GE: if already in use
       return 0.0;

    HealMax = GetHealMax(Bot);
    desire = Min(HealingAmount, HealMax - Bot.Health);

    if ( (Bot.Weapon != None) && (Bot.Weapon.AIRating > 0.5) )
        desire *= 1.7;
    if ( bSuperHeal || (Bot.Health < 45) )
        result = ( FMin(0.03 * desire, 2.2) );
    else
    {
        if ( Bot.Controller.bHuntPlayer )
            result = 0;
        else
            result = ( FMin(0.017 * desire, 2.0) );
    }
    //log("U2Stations.DecoyHealth: BotDesireability is"@result);
    return result;
}


//GE: Disable picking up.
auto state Pickup
{
	function Touch( actor Other );
	/*{
        local Pawn P;

        //P.ClientMessage("DecoyHealth: HealingAmount is"@HealingAmount);
        if ( ValidTouch(Other) )
        {
            P = Pawn(Other);
            P.HandlePickup(self);
        }

	}*/
}

//GE: Adjusted so that on respawn it would readjust health/shield units
State Sleeping
{
    ignores Touch;

    /*function bool ReadyToPickup(float MaxWait)
    {
        return ( bPredictRespawns && (LatentFloat < MaxWait) );
    }

    function StartSleeping() {}

    function BeginState()
    {
        local int i;

        NetUpdateTime = Level.TimeSeconds - 1;
        bHidden = true;
        for ( i=0; i<4; i++ )
            TeamOwner[i] = None;
    }

    function EndState()
    {
        NetUpdateTime = Level.TimeSeconds - 1;
        bHidden = false;
    } */

DelayedSpawn:
    if ( Level.NetMode == NM_Standalone )
        Sleep(FMin(30, Level.Game.GameDifficulty * 8));
    else
        Sleep(30);
    Goto('Respawn');
Begin:
    Sleep( GetReSpawnTime() - RespawnEffectTime );
Respawn:
    RespawnEffect();
    Sleep(RespawnEffectTime);
    if (Station != None)
        HealingAmount = Station.HealthUnits;
    if (PickUpBase != None)
        PickUpBase.TurnOn();
    GotoState('Pickup');
}

DefaultProperties
{
    bHidden=True
    RespawnTime=3.0
}
