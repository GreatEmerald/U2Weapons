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

class U2WeaponRocketTurret extends U2DeployableInventory;

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
    return true;
}

defaultproperties
{
     AutoSwitchPriority=2
     FireModeClass(0)=Class'U2FireDeployRocketTurret'
     FireModeClass(1)=Class'U2FireDeployRocketTurret'
     SelectSound=Sound'U2XMPA.RocketTurret.RT_Select'
     Priority=1
     AIRating=0.670000
     CurrentRating=0.670000
     BobDamping=1.8
     InventoryGroup=3
     GroupOffset=1
     AttachmentClass=Class'U2TurretAttachment'
     ItemName="Rocket Turret"
     Mesh=SkeletalMesh'WeaponsK.Turret'
     PickupClass=class'U2PickupRocketTurret'
     IconMaterial=Texture'U2343T.HUD.U2HUD'
     IconCoords=(X1=334,Y1=210,X2=359,Y2=240)
     IdleAnim=""
     Description="The Rocket Turret is an automated deployable, used as field support or as an automated defence. It has a dual mounted Rocket Launcher that fires rockets similar to those of the Shark Rocket Launcher."
}
