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
// XMPInstantFire.uc
// 2004 jasonyu
// 23 May 2004
//-----------------------------------------------------------

class U2InstantFire extends U2WeaponFire;

#EXEC OBJ LOAD FILE=..\System\XWeapons.u
#EXEC OBJ LOAD FILE=..\System\UTClassic.u

var class<DamageType> DamageType;
var int DamageMin, DamageMax;
var float TraceRange;
var float Momentum;

var name MuzzleFlash;



function float MaxRange()
{
    if (Instigator.Region.Zone.bDistanceFog)
        TraceRange = FClamp(Instigator.Region.Zone.DistanceFogEnd, 8000, default.TraceRange);
    else
    	TraceRange = default.TraceRange;

	return TraceRange;
}

function DoFireEffect()
{
    local Vector StartTrace;
    local Rotator R, Aim;
    local vector X;

    Instigator.MakeNoise(1.0);

    // the to-hit trace always starts right in front of the eye
    StartTrace = Instigator.Location + Instigator.EyePosition();
    Aim = AdjustAim(StartTrace, AimError);

	R.Pitch = 182.044 * FRand() * Spread * 0.5;
	X = Vector(R);
	Aim.Roll = 65536 * FRand();
	DoTrace(StartTrace, Rotator(X >> Aim));
}

function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X, End, HitLocation, HitNormal;
    local Actor Other;
    local int ReflectNum;

    X = Vector(Dir);
    End = Start + TraceRange * X;

    Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);

    if ( Other != None && Other != Instigator )
    {
	   	Other.TakeDamage(DamageMin, Instigator, HitLocation, Momentum*X, DamageType);
	}
	if ( Weapon.ThirdPersonActor != none )
		WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other,HitLocation,HitNormal);
    SpawnBeamEffect(Start, Dir, HitLocation, HitNormal, ReflectNum);
}


function SpawnBeamEffect(Vector Start, Rotator Dir, Vector HitLocation, Vector HitNormal, int ReflectNum)
{
}

// first person
function InitEffects()
{
	Super.InitEffects();
	//MuzzleFlash
	if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, 'xMuzzleFlash');
}

// 3rd person
function FlashMuzzleFlash()
{
	local rotator r;
	r.Roll = Rand(65536);
    Weapon.SetBoneRotation(MuzzleFlash, r, 0, 1.f);
	Super.FlashMuzzleFlash();
}

defaultproperties
{
     TraceRange=10000.000000
     Momentum=1.000000
     MuzzleFlash="'"
     NoAmmoSound=ProceduralSound'WeaponSounds.PReload5.P1Reload5'
}
