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
// U2DecoyShield.uc
// A decoy for attracting bots
//-----------------------------------------------------------
class U2DecoyShield extends ShieldPickup;

var U2PowerStation Station;
var float DesireabilityMod; //GE: Percentage to increase or decrease the desireability.

//GE: Disable respawn effect.
function RespawnEffect();

function Take(Pawn P)
{
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


//GE: Disable picking up.
auto state Pickup
{
	function Touch( actor Other );
	/*{
        local Pawn P;

        if ( ValidTouch(Other) )
        {
            P = Pawn(Other);
            P.HandlePickup(self);
        }

	} */
}

event float BotDesireability(Pawn Bot)
{
    local float result;
    local Bot B;

    if (Station != None && Station.PowerUpOwner != None && Station.PowerUpOwner != Bot) //GE: if already in use
       return 0.0;

    B = Bot(Bot.Controller);
    if (B == None || B.Enemy == None || (B.Enemy != None && !B.EnemyVisible() )) //GE: Don't attempt to take it while under fire, duh.
       return 0;

    DesireabilityMod = ShieldAmount/50;
    result = (0.013 * DesireabilityMod * MaxDesireability * Bot.CanUseShield(ShieldAmount)); //GE: 0.013 * MaxDesireability = 0.2 const.
    //if (result < 1.0) //GE: Don't bother if it's less than 50.
    //   result = 0;
    //log("U2Stations.DecoyShield: BotDesireability is"@result@"and CanUseShield"@Bot.CanUseShield(ShieldAmount)$", ID"@PickUpBase);
    return result;
}

/*function float DetourWeight(Pawn Other,float PathWeight) //GE: This function is, for all intents and purposes, useless.
{
    local float Need, result;

    //MaxDesireability = ShieldAmount/100;

    Need = Other.CanUseShield(ShieldAmount);
    if ( Need <= 0 )
        return 0;
    if ( AIController(Other.Controller).PriorityObjective() && (Need < 0.4 * Other.GetShieldStrengthMax()) )
        result = (0.00017 * MaxDesireability * Need)/PathWeight;  //0.005
    else
        result = (0.013 * MaxDesireability * Need)/PathWeight;
    return result;
    log("U2Stations.DecoyShield: Detour Weight is"@result@"and CanUseShield"@Need@", ID"@PickUpBase);
} */

//GE: Adjusted so that on respawn it would readjust health/shield units
State Sleeping
{
    ignores Touch;

    function bool ReadyToPickup(float MaxWait)
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
    }

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
        ShieldAmount = Station.EnergyUnits;
    if (PickUpBase != None)
        PickUpBase.TurnOn();
    GotoState('Pickup');
}

DefaultProperties
{
    bHidden=True
    RespawnTime=3.0
    //DesireabilityMod=1.0
}
