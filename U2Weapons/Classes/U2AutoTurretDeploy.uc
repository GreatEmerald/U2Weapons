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
// 25 July 2004
//-----------------------------------------------------------

class U2AutoTurretDeploy extends U2DeployableInventory;

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
                return 1.1; //hackish - don't want higher priority than anything that can heal objective

            return 1.5;
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
    return false;
}

defaultproperties
{
     AutoSwitchPriority=3
     FireModeClass(0)=Class'U2AutoTurretDeployFire'
     FireModeClass(1)=Class'U2AutoTurretDeployFire'
     SelectSound=Sound'U2XMPA.AutoTurret.AT_Select'
     Priority=19
     GroupOffset=1
     InventoryGroup=7
     AIRating=0.660000
     CurrentRating=0.660000
     AttachmentClass=Class'U2TurretAttachment'
     ItemName="Auto Turret"
     Mesh=SkeletalMesh'WeaponsK.Turret'
     PickupClass=class'U2PickupAutoTurret'
     IconMaterial=Texture'U2343T.HUD.U2HUD'
     IconCoords=(X1=292,Y1=212,X2=318,Y2=240)
     BobDamping=1.8
     IdleAnim=""
     Description="The Automatic Turret is an automated deployable, used as field support or as an automated defence. It has a dual mounted chaingun that has properties similar to the ones of Combat Assault Rifle."
}
