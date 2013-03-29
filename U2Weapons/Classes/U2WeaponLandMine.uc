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

class U2WeaponLandMine extends U2DeployableInventory;

defaultproperties
{
     FireModeClass(0)=Class'U2FireDeployLandMine'
     FireModeClass(1)=Class'U2FireDeployLandMine'
     SelectSound=Sound'U2XMPA.LandMines.M_Select'
     Priority=7
     GroupOffset=1
     InventoryGroup=0
     AttachmentClass=Class'U2AttachmentLandMine'
     ItemName="Land Mine"
     Mesh=SkeletalMesh'WeaponsK.Mine'
     PickupClass=Class'U2PickupLandMine'
     IconMaterial=Texture'UIResT.HUD.U2HUD'
     IconCoords=(X1=263,Y1=203,X2=285,Y2=226)
     CustomCrossHairTextureName="KA_XMP.U2.uLeechGun"
     IdleAnim=""
     AIRating=0.20 //GE: Bots tend to get killed while using this.
     CurrentRating=0.20
     BobDamping=1.8

     Description="Land Mines are explosives that detonate when anyone trips over them. They are extremely lethal - there is almost no chance of surviving the blast if you trip on one. Be very cautious, because friendly mines are almost as dangerous as enemy mines."
}
