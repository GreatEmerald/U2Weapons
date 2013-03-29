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
// U2AssaultRifleAttachment.uc
// 3rd person attachment class of the M32 Duster
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2AssaultRifleAttachment extends U2WeaponAttachment;

//GE: No tracer, because it looks bad and not true to Unreal II!

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
	local PlayerController PC;

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
     mMuzFlashClass=Class'U2Weapons.U2AssaultMuzFlash3rd'
     mMuzFlashAltClass=Class'U2Weapons.U2AssaultAltMuzFlash3rd'
     bHeavy=True
     Mesh=SkeletalMesh'U2Weapons3rdPK.AR_TP'
     RelativeRotation=(Yaw=49151,Roll=98302)
     DrawScale=0.300000
     bRapidFire=True
}
