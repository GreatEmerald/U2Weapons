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
// U2FireShotgun.uc
// Fire class of the Crowd Pleaser
// Cling.
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2FireShotgun extends U2InstantFire;

var() float SpawnCount;

function DoFireEffect()
{
    local Vector StartTrace;
    local Rotator R, Aim;
    local vector X;
    local int p;

    Instigator.MakeNoise(1.0);

    // the to-hit trace always starts right in front of the eye
    StartTrace = Instigator.Location + Instigator.EyePosition();
    Aim = AdjustAim(StartTrace, AimError);

    for (p = 0; p < SpawnCount; p++)
    {
		R.Pitch = 182.044 * FRand() * Spread * 0.5;
		X = Vector(R);
		Aim.Roll = 65536 * FRand();
		DoTrace(StartTrace, Rotator(X >> Aim));
    }


    FireEffect = spawn(FireEffectClass);
    Weapon.AttachToBone(FireEffect, 'xMuzzleFlash');

}

function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X, End, HitLocation, HitNormal;
    local Actor Other;
    local int ReflectNum;
    local actor A;

    X = Vector(Dir);
    End = Start + TraceRange * X;

    Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);

    if ( Other != None && Other != Instigator )
    {
	   	Other.TakeDamage(DamageMin, Instigator, HitLocation, Momentum*X, DamageType);
		WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other,HitLocation,HitNormal);
		A = Spawn(class'U2FX_Hit'.static.GetHitEffect(Other, HitLocation, HitNormal),,, HitLocation, Rotator(HitNormal));
		if(A != None)
            A.RemoteRole = ROLE_SimulatedProxy;
	}
    SpawnBeamEffect(Start, Dir, HitLocation, HitNormal, ReflectNum);
}

function PlayFiring()
{
  Super.PlayFiring();
    FireEffect = spawn(FireEffectClass);
    Weapon.AttachToBone(FireEffect, 'xMuzzleFlash');
}

defaultproperties
{
     DamageType=Class'U2Weapons.U2DamTypeShotgun'
     DamageMin=8
     DamageMax=9
     AmmoClass=Class'U2Weapons.U2AmmoShotgun'

     SpawnCount=16.000000
     TraceRange=3800.000000
     Momentum=500.000000
     FireLastRoundSound=Sound'WeaponsA.Shotgun.S_FireLastRound'
     FireLastReloadTime=3.230000
     FireLastRoundTime=1.460000
     FireLastDownAnimRate=3.146853
     FireEffectClass=Class'U2FX_ShotgunMuzzleFlash'
     FireSound=Sound'WeaponsA.Shotgun.S_Fire'
     FireRate=0.930000
     ShakeRotMag=(X=0.000000,Y=0.000000,Z=0.000000)
     ShakeRotRate=(X=0.000000,Y=0.000000,Z=0.000000)
     ShakeOffsetMag=(X=-15.000000,Y=0.000000,Z=10.000000)
     ShakeOffsetRate=(X=-4000.000000,Y=0.000000,Z=4000.000000)
     ShakeOffsetTime=1.600000
     BotRefireRate=0.990000
     aimerror=800.000000
     Spread=8.000000
}
