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
// 25 July 2004
// UT2004 implementation by GreatEmerald, 2009
//-----------------------------------------------------------

class U2WeaponLaserTripMine extends U2DeployableInventory;

function float GetAIRating()
{
    return 0;
}

defaultproperties
{
     FireModeClass(0)=Class'U2FireLaserTripMine'
     FireModeClass(1)=Class'U2FireLaserTripMine'
     SelectSound=Sound'U2XMPA.LaserTripMines.LM_Select'
     Priority=6
     GroupOffset=2
     AttachmentClass=Class'U2AttachmentLaserTripMine'
     ItemName="Laser Trip Mine"
     Mesh=SkeletalMesh'WeaponsK.TripMine'
     InventoryGroup=0
     PickupClass=Class'U2PickupLaserTripMine'
     IconMaterial=Texture'UIResT.HUD.U2HUD'
     IconCoords=(X1=473,Y1=209,X2=500,Y2=231)
     CustomCrossHairTextureName="KA_XMP.U2.uLaserRifle"
     IdleAnim=""
     AIRating=0 //GE: No bot support.
     BobDamping=1.8

     Description="TG-17 anti-personnel explosive Laser Trip Mines are often useful for sealing off areas. They emit a small laser beam that helps them scan the area for any kind of movement. Once it's detected, the Laser Trip Mine detonates."
}
