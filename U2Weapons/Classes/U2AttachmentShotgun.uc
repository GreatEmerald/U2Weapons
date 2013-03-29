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
// U2AttachmentShotgun.uc
// 3rd person attachment class of Crowd Pleaser
// Cyborg!
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2AttachmentShotgun extends U2WeaponAttachment;

var float SmokeOffsetZ;

/* UpdateHit
- used to update properties so hit effect can be spawn client side
*/
function UpdateHit(Actor HitActor, vector HitLocation, vector HitNormal)
{
	SpawnHitCount++;
	mHitLocation = HitLocation;
	mHitActor = HitActor;
	mHitNormal = HitNormal;
}

simulated event ThirdPersonEffects()
{
	local vector SmokeLoc, SmokeOffset;
	local coords	C;
	local PlayerController PC;

	if ( (FlashCount != 0) && (Level.NetMode != NM_DedicatedServer) )
	{
		if ( Instigator.IsFirstPerson() )
		{
			SmokeLoc = Instigator.Location + Instigator.Eyeheight * vect(0,0,1) + Instigator.CollisionRadius * vector(Instigator.Controller.Rotation);
			SmokeLoc.Z += SmokeOffsetZ;
			Spawn(class'U2FX_ShotgunSmoke',,,SmokeLoc);
		}
		else if ( Level.TimeSeconds - Instigator.LastRenderTime < 0.2 )
		{
			C = Instigator.GetBoneCoords(Instigator.GetWeaponBoneFor(Instigator.Weapon));
			SmokeOffset =  -1 * C.ZAxis * (Instigator.CollisionRadius + 35);
			SmokeLoc = C.Origin + SmokeOffset;
			Spawn(class'U2FX_ShotgunSmoke',,,SmokeLoc);
		}
	}

    if ( Level.NetMode != NM_DedicatedServer )
	{
        if (FiringMode == 0)
        {
			if ( OldSpawnHitCount != SpawnHitCount )
			{
				OldSpawnHitCount = SpawnHitCount;
				GetHitInfo();
				PC = Level.GetLocalPlayerController();
				if ( ((Instigator != None) && (Instigator.Controller == PC)) || (VSize(PC.ViewTarget.Location - mHitLocation) < 4000) )
				{
					Spawn(class'U2FX_Hit'.static.GetHitEffect(mHitActor, mHitLocation, mHitNormal),,, mHitLocation, Rotator(mHitNormal));
					CheckForSplash();
				}
			}
        }
    }
	Super.ThirdPersonEffects();
}

defaultproperties
{
     Mesh=SkeletalMesh'U2Weapons3rdPK.S_TP'
     RelativeRotation=(Yaw=49151,Roll=98302)
     DrawScale=0.300000

     EpicMuzFlashClass=Class'U2FX_ShotgunMuzzleFlash'
     EpicMuzFlashAltClass=Class'U2FX_ShotgunMuzzleFlash'
}
