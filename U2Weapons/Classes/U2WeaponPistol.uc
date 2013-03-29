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
// U2WeaponPistol.uc
// Weapon class of Magnum
// Bam-bam-bang!
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2WeaponPistol extends U2Weapon;

defaultproperties
{
     AutoSwitchPriority=7
     ReloadSound=Sound'WeaponsA.Pistol.P_Reload'
     ReloadUnloadedSound=Sound'WeaponsA.Pistol.P_ReloadUnloaded'
     ClipSize=9
     ReloadTime=1.888000
     ReloadUnloadedTime=1.330000
     SelectSound=Sound'WeaponsA.Pistol.P_Select'
     AIRating=0.400000
     //CurrentRating=0.680000
     bUseOldWeaponMesh=True
     CustomCrosshair=57
     CustomCrossHairTextureName="KA_XMP.U2.uPistol"
     PlayerViewOffset=(X=13.000000,Y=4.000000,Z=-25.000000)  //10,1,-22  X-const, Y-increase, Z-decrease
     Mesh=SkeletalMesh'WeaponsK.P_FP'

     FireModeClass(0)=Class'U2Weapons.U2FirePistol'
     FireModeClass(1)=Class'U2Weapons.U2FireAltPistol'
     Description="The Magnum is the most powerful sidearm out there. Best for medium range targets, when you’re too far away for the shotgun, but too close for the sniper rifle.|The pistol uses special 0.50 caliber explosive bullets that are quite rare, but powerful. They explode a few miliseconds after hitting the target, effectively incinerating its internal organs."
     Priority=50
     InventoryGroup=4
     PickupClass=Class'U2Weapons.U2PickupPistol'
     BobDamping=1.575000
     AttachmentClass=Class'U2Weapons.U2AttachmentPistol'
     IconMaterial=Texture'U2343T.HUD.U2HUD'
     IconCoords=(X1=216,Y1=190,X2=245,Y2=206)
     ItemName="Magnum Pistol"
     Skins(1)=Shader'U2WeaponFXT.Pistol.P_Skin1FX'

    RangeMinFire=0.000000
    RangeIdealFire=512.000000
    RangeMaxFire=1536.000000
    RangeLimitFire=32767.000000
    RatingRangeMinFire=0.250000
    RatingRangeIdealFire=0.450000
    RatingRangeMaxFire=0.100000
    RatingRangeLimitFire=0.001000
    AIRatingFire=0.400000
    RangeMinAltFire=0.000000
    RangeIdealAltFire=384.000000
    RangeMaxAltFire=1536.000000
    RangeLimitAltFire=32767.000000
    RatingRangeMinAltFire=0.100000
    RatingRangeIdealAltFire=0.200000
    RatingRangeMaxAltFire=0.100000
    AIRatingAltFire=0.350000

}
