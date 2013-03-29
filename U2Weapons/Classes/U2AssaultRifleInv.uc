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
// U2AssaultRifleInv.uc
// Inventory class of the M32 Duster
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2AssaultRifleInv extends U2Weapon;

#EXEC OBJ LOAD FILE=..\UTXMP\Textures\UIResT.utx

var Emitter ReloadDustA,ReloadDustB,ReloadDustC;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if( bPendingDelete )
		return;

	if( Level.NetMode != NM_DedicatedServer )
	{
		ReloadDustA = Spawn(class'U2FX_AssaultRifleExhaust');
		AttachToBone(ReloadDustA, 'xVent1');

		ReloadDustB = Spawn(class'U2FX_AssaultRifleExhaust');
		AttachToBone(ReloadDustB, 'xVent2');

		ReloadDustC = Spawn(class'U2FX_AssaultRifleExhaust');
		AttachToBone(ReloadDustC, 'xVent3');
	}
}

simulated function PlayReloading()
{
	Super.PlayReloading();
	if (ReloadDustA!=none) ReloadDustA.Trigger(self,Instigator);
	if (ReloadDustB!=none) ReloadDustB.Trigger(self,Instigator);
	if (ReloadDustC!=none) ReloadDustC.Trigger(self,Instigator);
}

function float GetAIRating()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( B == None )
		return Super.GetAIRating();

	if ( !B.EnemyVisible() )
		return Super.GetAIRating() - 0.15;

	return Super.GetAIRating();
}

function byte BestMode()
{
	local bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return Super.BestMode();

	if ( VSize(B.Enemy.Velocity) < 200 )
		return 1;
	return Super.BestMode();
}

defaultproperties
{
     FireModeClass(0)=Class'U2Weapons.U2AssaultRifleFire'
     FireModeClass(1)=Class'U2Weapons.U2AssaultRifleAltFire'
     bUseOldWeaponMesh=False
     Description="The M32 Duster Comber Assault Rifle is the standard infantry weapon for the Terran Military grunt. Very effective overall - you can hose down an area using the primary fire mode or deliver a lethal single punch with the alternate fire."
     Priority=52
     InventoryGroup=6
     PickupClass=Class'U2Weapons.U2AssaultRiflePickup'
     BobDamping=2.250000
     AttachmentClass=Class'U2Weapons.U2AssaultRifleAttachment'
     IconMaterial=Texture'U2343T.HUD.U2HUD'
     IconCoords=(X1=13,Y1=168,X2=55,Y2=187)
     ItemName="Duster Combat Assault Rifle"

     AutoSwitchPriority=15
     ReloadSound=Sound'WeaponsA.AssaultRifle.AR_Reload'
     ReloadUnloadedSound=Sound'WeaponsA.AssaultRifle.AR_ReloadUnloaded'
     ClipSize=75
     ReloadTime=2.166666
     ReloadUnloadedTime=1.830000
     SelectSound=Sound'WeaponsA.AssaultRifle.AR_Select'
     AIRating=0.800000
     //CurrentRating=0.710000
     CustomCrosshair=51
     CustomCrossHairTextureName="KA_XMP.U2.uAssaultRifle"
     PlayerViewOffset=(X=12.000000,Y=1.000000,Z=-30.000000)//20,4,-30; 12,4,-30
     Mesh=SkeletalMesh'WeaponsK.AR_FP'
     Skins(0)=Shader'U2WeaponFXT.CAR.AR_Skin1FX'
     SoundRadius=400.000000

    RangeMinFire=0.000000
    RangeIdealFire=2048.000000
    RangeMaxFire=4096.000000
    RangeLimitFire=32767.000000
    RatingRangeMinFire=0.800000
    RatingRangeIdealFire=0.800000
    RatingRangeMaxFire=0.200000
    RatingRangeLimitFire=0.010000
    AIRatingFire=0.800000
    RangeMinAltFire=196.000000
    RangeIdealAltFire=512.000000
    RangeMaxAltFire=2048.000000
    RangeLimitAltFire=32767.000000
    RatingRangeMinAltFire=0.900000
    RatingRangeIdealAltFire=0.900000
    RatingRangeMaxAltFire=0.100000
    RatingRangeLimitAltFire=0.010000
    AIRatingAltFire=0.700000

}
