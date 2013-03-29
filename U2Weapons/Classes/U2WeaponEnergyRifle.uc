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
// U2WeaponEnergyRifle.uc
// Inventory class of the Shock Lance
// To hell with the fancy new naming system, I'll use the usual one.
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2WeaponEnergyRifle extends U2Weapon;

function float GetAIRating()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return Super.GetAIRating();

	if (Vehicle(B.Enemy) != none || U2DeployedUnit(B.Enemy) != none)
		return Super.GetAIRating()+0.55;

	return Super.GetAIRating();
}

function byte BestMode()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return Super.BestMode();

	if ( U2DeployedUnit(B.Enemy) != none && VSize(B.Enemy.Location - Instigator.Location) <= RangeMaxAltFire)
		return 1;

	return Super.BestMode();
}

defaultproperties
{
     ReloadSound=Sound'WeaponsA.EnergyRifle.ER_Reload'
     ReloadUnloadedSound=Sound'WeaponsA.EnergyRifle.ER_ReloadUnloaded'
     ReloadUnloadedTime=1.500000
     SelectSound=Sound'WeaponsA.EnergyRifle.ER_Select'
     AIRating=0.450000
     //CurrentRating=0.400000
     bUseOldWeaponMesh=True
     CustomCrosshair=59
     CustomCrossHairTextureName="KA_XMP.U2.uShockLance"
     PlayerViewOffset=(X=16.000000,Y=5.000000,Z=-35.000000) //22,1,-34
     Mesh=SkeletalMesh'WeaponsK.ER_FP'
     AutoSwitchPriority=6
     ClipSize=34
     ReloadTime=2.187000
     ReloadAnimRate=1.070336
     FireModeClass(0)=Class'U2Weapons.U2FireEnergyRifle'
     FireModeClass(1)=Class'U2Weapons.U2FireAltEnergyRifle'
     Description="The Shock Lance Energy Rifle is the favourite weapon of the Izarians, the strike force of one of the Skaarj clans. The Izarians use the weapon mainly for frightening enemies, as a beacon for Skaarj or to fry electronics. Therefore it isn't at all effective against enemies, but extremely effective against vehicles and deployables."
     Priority=27
     InventoryGroup=2
     PickupClass=Class'U2Weapons.U2PickupEnergyRifle'
     BobDamping=1.800000
     AttachmentClass=Class'U2Weapons.U2AttachmentEnergyRifle'
     IconMaterial=Texture'U2343T.HUD.U2HUD'
     IconCoords=(X1=205,Y1=72,X2=252,Y2=83)
     ItemName="Shock Lance"
     Skins(0)=Shader'U2WeaponFXT.EnergyRifle.ER_Skin1FX'

    RangeMinFire=0.000000
    RangeIdealFire=512.000000
    RangeMaxFire=1536.000000
    RangeLimitFire=32767.000000
    RatingRangeMinFire=0.450000
    RatingRangeIdealFire=0.450000
    RatingRangeMaxFire=0.450000
    RatingRangeLimitFire=0.001000
    AIRatingFire=0.450000
    RangeMinAltFire=512.000000
    RangeIdealAltFire=1024.000000
    RangeMaxAltFire=1700.000000
    RatingInsideMinAltFire=-20.000000
    RatingRangeMinAltFire=0.100000
    RatingRangeIdealAltFire=0.350000
    RatingRangeMaxAltFire=0.550000
    AIRatingAltFire=0.450000

}
