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
// ShieldReward.uc
// The Shield pack dropped when the user dies with shields.
// Greatemerald and Infernus, 2010
//-----------------------------------------------------------
class ShieldReward extends ShieldPack
    notplaceable;

//var int ShieldStrength;
var pawn JustDied;
var() float DecayFrequency, DecayAmount;
var bool bNavigating;

/*function SetShieldStrength(int Strength)
{
    ShieldAmount = Strength;
} */

//GE: InitDroppedPickupFor()->InitDrop() from UDamageReward
function InitDrop( int RemainingCharge )
{
    // This is when the original UDamage time will expire
    //FadeTime = RemainingCharge + Level.TimeSeconds;
    ShieldAmount = RemainingCharge;

    // We're falling
    SetPhysics(PHYS_Falling);
    //GotoState('FallingPickup');

    // Only need to know about me if I'm in your area
    bAlwaysRelevant = false;

    // set this flag to indicate that this pickup is not on a pickup base (and thus should be destroyed when picked up)
    bDropped = true;

    bIgnoreEncroachers = false; // handles case of dropping stuff on lifts etc
    bIgnoreVehicles = true;

    // Bots care less about pickups with less time remaining
    //MaxDesireability *= (RemainingCharge / 30);

    // TODO - what does these do (or why do we need them in dropped pickups)
    NetUpdateFrequency = RemainingCharge;
    bUpdateSimulatedPosition = true;
    bOnlyReplicateHidden = false;
    //LifeSpan = float(RemainingCharge) * DecayFrequency / DecayAmount;
}


auto state Pickup
{
	function Touch(actor Other)
	{
		if (!ValidTouch(Other) || Pawn(Other) == JustDied)
	        return;
		Pawn(Other).AddShieldStrength(ShieldAmount);
        AnnouncePickup(Pawn(Other));
        SetRespawn();
	}

	function BeginState()
    {
        SetTimer(DecayFrequency, true);
    }

    function Timer()
    {
        if (!bDropped)
            return;

        ShieldAmount -= DecayAmount;

        if (( float(ShieldAmount) * DecayFrequency / DecayAmount) <= 1.0)
            GoToState('FadeOut');
        if (!bNavigating)
        {
            AddToNavigation();
            bNavigating = true;
        }
    }

}

static function string GetLocalString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2
    )
{
    return Super(Pickup).GetLocalString(Switch, RelatedPRI_1, RelatedPRI_2);
}

DefaultProperties
{
    ShieldAmount=0
    DecayFrequency=0.5
    DecayAmount=1.0
    PickupMessage="You picked up a Shield Pack."
    //bOnlyReplicateHidden=False //GE: Replicate skin changes.
    //bOnlyDirtyReplication=False
}
