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
// XMPDeployableInventory.uc
// 2004 jasonyu
// 25 July 2004
//-----------------------------------------------------------

class U2DeployableInventory extends U2Weapon;

const DeployDropHeight		= 32.0;
const DeployHorizontalFudge =  8.0;

var class<Actor> DeployClass;
var Sound DeployFailedSound;
var float MinDUSeparation, MinPawnSeparation;
var float MaxDeployDistance;

var float DeploySkillCost;
var bool bTossProjectiles;
var bool bIgnoreOwnerYaw;				// hack to spawn meshes with particle attachments with their default orientation
var bool bCanIntersectDUs;				// allow deployed unit CCs to intersect
var bool bCanIntersectPawns;			// allow deployed unit CCs to intersect

var() Sound ActivateSound;				//
var() Sound DeActivateSound;			//
var() Sound EffectSound;				//


//-----------------------------------------------------------------------------

simulated function bool ConsumeAmmo(int Mode, float load, optional bool bAmountNeededIsMax)
{
	local float FireLastReloadTime;

	if ( Load > ClipRoundsRemaining )
		return false;
    if( Super(Weapon).ConsumeAmmo(Mode, Load, bAmountNeededIsMax) )
    {
		ClipRoundsRemaining -= load;
        NetUpdateTime = Level.TimeSeconds - 1;
		if ( HasAmmo() && ReloadRequired() && ROLE==ROLE_Authority)
		{
			StopFire(0);
			StopFire(1);
			//bPendingReload = true;
			FireLastReloadTime = U2WeaponFire(FireMode[Mode]).default.FireLastReloadTime;
			ReloadUnloadedTime = FireLastReloadTime - FireMode[Mode].FireRate;
			Reload();
			//SetTimer(FireMode[Mode].FireRate - 0.5, False); // reload after completing fire
		}
    	Ammo_NotifyAmmoChanged();
        return true;
    }
    return false;
}

function bool AddAmmo(int AmmoToAdd, int Mode)
{
	if ( super.AddAmmo(AmmoToAdd, Mode) )
	{
		if ( ReloadRequired() )
			Reload();
		Ammo_NotifyAmmoChanged();
		return true;
	}
	return false;
}

function Reload()
{
	/*local float AmmoMax,AmmoCount;

	if( HasAmmo() && CanReload() )
	{
		//bPendingReload = false;
		GetAmmoCount(AmmoMax,AmmoCount);
		Ammo_SetClipRoundsRemaining(Min(ClipSize,AmmoCount));
	}*/
	Ammo_Reload();
}

//-----------------------------------------------------------------------------

static function bool IsValidDefaultInventory( pawn PlayerPawn )
{
	return true;
}

//-----------------------------------------------------------------------------

simulated function BringUp(optional Weapon PrevWeapon)
{
	if ( HasAmmo() && ReloadRequired() && ROLE==ROLE_Authority)
		Reload();
	Super.BringUp( PrevWeapon );
}

// AI Interface
function float GetAIRating()
{
    local Bot B;
    local float EnemyDist;
    local vector EnemyDir;

    if ( AmmoAmount(0) <= 0 )
        return 0;

    B = Bot(Instigator.Controller);
    if (B == None)
        return AIRating;
    if (B.Enemy == None)
    {
        if (B.Formation() && B.Squad.SquadObjective != None && B.Squad.SquadObjective.BotNearObjective(B))
        {
            if ( DestroyableObjective(B.Squad.SquadObjective) != None && B.Squad.SquadObjective.TeamLink(B.Squad.Team.TeamIndex)
                 && DestroyableObjective(B.Squad.SquadObjective).Health < DestroyableObjective(B.Squad.SquadObjective).DamageCapacity )
                return 0.8; //hackish - don't want higher priority than anything that can heal objective

            return 1.2;
        }

        return AIRating;
    }

    // if retreating, favor this weapon
    EnemyDir = B.Enemy.Location - Instigator.Location;
    EnemyDist = VSize(EnemyDir);
    if ( EnemyDist > 1500 )
        return 0.1;
    if ( B.IsRetreating() )
        return (AIRating + 0.4);
    if ( -1 * EnemyDir.Z > EnemyDist )
        return AIRating + 0.1;
    if ( (B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon )
        return (AIRating + 0.3);
    if ( EnemyDist > 1000 )
        return 0.35;
    return AIRating;
}

function float SuggestAttackStyle()
{
    local Bot B;
    local float EnemyDist;

    B = Bot(Instigator.Controller);
    if ( (B == None) || (B.Enemy == None) )
        return 0.4;

    EnemyDist = VSize(B.Enemy.Location - Instigator.Location);
    if ( EnemyDist > 1500 )
        return 1.0;
    if ( EnemyDist > 1000 )
        return 0.4;
    return -0.4;
}

function float SuggestDefenseStyle()
{
    local Bot B;

    B = Bot(Instigator.Controller);
    if ( (B == None) || (B.Enemy == None) )
        return 0;

    if ( VSize(B.Enemy.Location - Instigator.Location) < 1600 )
        return -0.6;
    return 0;
}

function bool ShouldFireWithoutTarget()
{
    local ONSPowerCore OPC;
    if ( ShootTarget(Instigator.Controller.Target) != None )
    {
        OPC = ONSPowerCore(Instigator.Controller.Target.Owner);
        if ( (OPC != None) && !OPC.Shield.bHidden )
        {
            Instigator.Controller.Target = OPC.PathList[Rand(OPC.PathList.Length)].End;
            return ( Instigator.Controller.Target != None );
        }
    }
    return true;
}

defaultproperties
{
     DeployFailedSound=Sound'U2A.Suits.NoEnergy'
     MinDUSeparation=16.000000
     MinPawnSeparation=1.000000
     MaxDeployDistance=60.000000
     DeploySkillCost=0.004000
     ReloadTime=0.000000
     DownUnloadedTime=0.600000
     FireModeClass(0)=Class'U2DeployableFire'  //XMPDeployableFire
     FireModeClass(1)=Class'U2DeployableFire'
     PutDownTime=0.600000
     AIRating=-1.000000
     bUseOldWeaponMesh=True
     Priority=17
     CustomCrosshair=7
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross1"
     InventoryGroup=4
     PlayerViewOffset=(X=22.000000,Y=7.000000,Z=-45.000000)
     ItemName="Deployable Item"
}
