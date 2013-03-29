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
// 2004 jasonyu
// 28 July 2004
// UT2004 implementation by GreatEmerald, 2009
//-----------------------------------------------------------

class U2WeaponFieldGenerator extends U2DeployableInventory;

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
                return 1.0; //hackish - don't want higher priority than anything that can heal objective

            return 1.4;
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

simulated function float GetSpecialSwitchPriority( Weapon OldWeapon )
{
    local float MaxAmmoPrimary;
    local float CurAmmoPrimary;

	GetAmmoCount(MaxAmmoPrimary,CurAmmoPrimary);

	if( (U2WeaponRocketTurret(OldWeapon) != None || U2WeaponAutoTurret(OldWeapon) != None) && CurAmmoPrimary > 0 )
		return float(AutoSwitchPriority);
	else
		return Super.GetSpecialSwitchPriority( OldWeapon );
}

defaultproperties
{
     AutoSwitchPriority=1
     FireModeClass(0)=Class'U2FireFieldGenerator'
     FireModeClass(1)=Class'U2FireFieldGenerator'
     SelectSound=Sound'U2XMPA.FieldGenerator.FG_Select'
     Priority=14
     GroupOffset=2
     InventoryGroup=2
     AttachmentClass=Class'U2AttachmentFieldGenerator'
     PickupClass=Class'U2PickupFieldGenerator'
     IconMaterial=Texture'UIResT.HUD.U2HUD'
     IconCoords=(X1=388,Y1=168,X2=401,Y2=201)
     CustomCrossHairTextureName="KA_XMP.U2.uLeechGun"
     IdleAnim=""
     ItemName="Field Generator"
     Description="The Field Generator is a small device that, when within proximity of another Field Generator, creates a strong force field that stops enemies from going through."
     Mesh=SkeletalMesh'WeaponsK.FieldGenerator'
     AIRating=0.35
     CurrentRating=0.35
     BobDamping=1.8
}
