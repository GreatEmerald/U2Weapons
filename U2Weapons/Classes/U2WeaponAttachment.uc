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
// XMPWeaponAttachment.uc
// 2004 jasonyu
// 23 May 2004
//-----------------------------------------------------------

class U2WeaponAttachment extends xWeaponAttachment
	abstract;

#EXEC OBJ LOAD FILE=..\Animations\Weapons3rdPK.ukx

var byte OldSpawnHitCount;
var class<xEmitter>     mMuzFlashClass;
var class<xEmitter>     mMuzFlashAltClass;
var xEmitter            mMuzFlash3rd;
var xEmitter            mMuzFlash3rdAlt;

var vector	mOldHitLocation;

// alex ---

var class<Emitter>     EpicMuzFlashClass;
var class<Emitter>     EpicMuzFlashAltClass;
var Emitter            EpicMuzFlash3rd;
var Emitter            EpicMuzFlash3rdAlt;
//var name			'xMuzzleFlash';
var bool			bNeverSpawnMultipleEmitters;

// --- alex // because xEmitters suck

simulated function Destroyed()
{
    if (mMuzFlash3rd != None)
        mMuzFlash3rd.Destroy();
    if (mMuzFlash3rdAlt != None)
        mMuzFlash3rdAlt.Destroy();
    if (EpicMuzFlash3rd != None)
        EpicMuzFlash3rd.Destroy();
    if (EpicMuzFlash3rdAlt != None)
        EpicMuzFlash3rdAlt.Destroy();
    Super.Destroyed();
}

simulated event ThirdPersonEffects()
{
    local rotator r;

    if ( Level.NetMode != NM_DedicatedServer )
	{
        if (FiringMode == 0 && mMuzFlashClass!=none)
        {
			WeaponLight();

			if (mMuzFlash3rd == None )
            {
                mMuzFlash3rd = Spawn(mMuzFlashClass);
                AttachToBone(mMuzFlash3rd, 'xMuzzleFlash');
            }
            mMuzFlash3rd.mStartParticles++;
            r.Roll = Rand(65536);
            SetBoneRotation('xMuzzleFlash', r, 0, 1.f);
        }
        else if (FiringMode == 1 && mMuzFlashAltClass!=none)
        {
			WeaponLight();

            if (mMuzFlash3rdAlt == None)
            {
                mMuzFlash3rdAlt = Spawn(mMuzFlashAltClass);
                AttachToBone(mMuzFlash3rdAlt, 'xMuzzleFlash');
            }
            mMuzFlash3rdAlt.mStartParticles++;
            r.Roll = Rand(65536);
            SetBoneRotation('xMuzzleFlash', r, 0, 1.f);
        }
	  else if (FiringMode == 1 && EpicMuzFlashClass != None )
	  {

            if (EpicMuzFlash3rdAlt == None || bNeverSpawnMultipleEmitters == false)
            {
                EpicMuzFlash3rdAlt = Spawn(EpicMuzFlashAltClass);
                AttachToBone(EpicMuzFlash3rdAlt, 'xMuzzleFlash');
            }

	  }
	  else if (FiringMode == 0 && EpicMuzFlashClass != None )
	  {

            if (EpicMuzFlash3rd == None || bNeverSpawnMultipleEmitters == false)
            {
                EpicMuzFlash3rd = Spawn(EpicMuzFlashClass);
                AttachToBone(EpicMuzFlash3rd, 'xMuzzleFlash');
            }

	  }

    }

	mOldHitLocation = mHitLocation;

    Super.ThirdPersonEffects();
}

simulated function Vector GetTipLocation()
{
    local Coords C;
    C = GetBoneCoords('xMuzzleFlash');
    return C.Origin;
}

defaultproperties
{
}
