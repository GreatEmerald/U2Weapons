/*
 * Copyright (c) 2008, 2013 Dainius "GreatEmerald" Masiliūnas
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
//-----------------------------------------------------------------------------
// U2WeaponShotgun.uc
// Weapon class of the Crowd Pleaser
// ..or M700 12G Semiautomatic Riot Shotgun.
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2WeaponShotgun extends U2Weapon;

#EXEC OBJ LOAD FILE=..\UTXMP\Textures\UIResT.utx


// AI Interface
function float GetAIRating()
{
	local Bot B;
	local float EnemyDist;
	local vector EnemyDir;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return Super.GetAIRating();

	EnemyDir = B.Enemy.Location - Instigator.Location;
	EnemyDist = VSize(EnemyDir);
	if ( (EnemyDist < RangeIdealFire) && (EnemyDist > RangeMinFire) && (B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon )
		return (Super.GetAIRating() + 0.35);
	return Super.GetAIRating();
}

/* BestMode()
choose between regular or alt-fire
*/
/*function byte BestMode()
{
	local vector EnemyDir;
	local float EnemyDist;
	local bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return 0;

	EnemyDir = B.Enemy.Location - Instigator.Location;
	EnemyDist = VSize(EnemyDir);
	if ( EnemyDist > 750 )
		return 0;
	else if (U2ProjectileFire(FireMode[1]).ProjectileClass != None && EnemyDist < U2ProjectileFire(FireMode[1]).ProjectileClass.default.DamageRadius )
	    return 0;
    else if ( EnemyDist < 400 )
		return 1;
	else if ( FRand() < 0.35 )
		return 1;
	return 0;
}*/

function float SuggestAttackStyle()
{
	if ( (AIController(Instigator.Controller) != None)
		&& (AIController(Instigator.Controller).Skill < 3) )
		return 0.4;
    return 0.8;
}

function float SuggestDefenseStyle()
{
    return -0.4;
}
// End AI Interface

defaultproperties
{
     ClipSize=8
     ReloadTime=2.930000
     ReloadAnimRate=0.755728
     FireModeClass(0)=Class'U2Weapons.U2FireShotgun'
     FireModeClass(1)=Class'U2Weapons.U2FireAltShotgun'
     bUseOldWeaponMesh=False
     Description="The M700 12G Semiautomatic Riot 'Crowd Pleaser' Shotgun is absolutely devastating at close range - perfect for clearing a room or taking out an enemy (or small group of enemies) right in front of you. Don't use it at long distances, the effectiveness drops off quickly as the pellets scatter."
     Priority=53
     InventoryGroup=5
     PickupClass=Class'U2Weapons.U2PickupShotgun'
     BobDamping=2.400000
     AttachmentClass=Class'U2Weapons.U2AttachmentShotgun'
     IconMaterial=Texture'U2343T.HUD.U2HUD'
     IconCoords=(X1=178,Y1=202,X2=219,Y2=217)
     ItemName="Crowd Pleaser Shotgun"

     AutoSwitchPriority=10
     ReloadSound=Sound'WeaponsA.Shotgun.S_Reload'
     ReloadUnloadedSound=Sound'WeaponsA.Shotgun.S_ReloadUnloaded'
     ReloadUnloadedTime=2.210000
     SelectSound=Sound'WeaponsA.Shotgun.S_Select'
     AIRating=0.550000
     //CurrentRating=0.750000
     CustomCrosshair=60
     CustomCrossHairTextureName="KA_XMP.U2.uShotgun"
     PlayerViewOffset=(X=16.000000,Y=3.000000,Z=-35.000000)//20,4,-32
     Mesh=SkeletalMesh'WeaponsK.S_FP'
     IdleAnim=""
     Skins(0)=Shader'U2WeaponFXT.Shotgun.S_FP_Skin1FX'

    RangeMinFire=0.000000
    RangeIdealFire=256.000000
    RangeMaxFire=2048.000000
    RangeLimitFire=32767.000000
    RatingRangeMinFire=0.900000
    RatingRangeIdealFire=0.900000
    RatingRangeMaxFire=0.100000
    RatingRangeLimitFire=0.010000
    AIRatingFire=0.550000
    RangeMinAltFire=128.000000
    RangeIdealAltFire=256.000000
    RangeMaxAltFire=900.000000
    RangeLimitAltFire=1000.000000
    RatingRangeMinAltFire=0.900000
    RatingRangeIdealAltFire=0.900000
    RatingRangeMaxAltFire=0.100000
    RatingRangeLimitAltFire=0.010000
    AIRatingAltFire=0.550000

}
