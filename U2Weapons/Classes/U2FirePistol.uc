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
// U2FirePistol.uc
// Fire class of the Magnum
// Almost a sniper.
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2FirePistol extends U2InstantFire;

var() float HeadShotDamageMult;
var() class<DamageType> DamageTypeHeadShot;

function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X, End, HitLocation, HitNormal;
    local Actor Other;
    local int ReflectNum;
    local Pawn HeadShotPawn;
    local actor A;


    X = Vector(Dir);
    End = Start + TraceRange * X;

    Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);

    if ( Other != None && (Other != Instigator) )
    {
        if ( !Other.bWorldGeometry )
        {
            if (Vehicle(Other) != None)
                HeadShotPawn = Vehicle(Other).CheckForHeadShot(HitLocation, X, 1.0);

            if (HeadShotPawn != None)
                HeadShotPawn.TakeDamage(DamageMax * HeadShotDamageMult, Instigator, HitLocation, Momentum*X, DamageTypeHeadShot);
            else if ( (Pawn(Other) != None) && Pawn(Other).IsHeadShot(HitLocation, X, 1.0))
                Other.TakeDamage(DamageMax * HeadShotDamageMult, Instigator, HitLocation, Momentum*X, DamageTypeHeadShot);
            else
                Other.TakeDamage(DamageMax, Instigator, HitLocation, Momentum*X, DamageType);
        }
        else
                HitLocation = HitLocation + 2.0 * HitNormal;

        A = Spawn(class'U2FX_Hit'.static.GetHitEffect(Other, HitLocation, HitNormal),,, HitLocation, Rotator(HitNormal));
		if(A != None)
            A.RemoteRole = ROLE_SimulatedProxy;
    }
        else
    {
        HitLocation = End;
        HitNormal = Normal(Start - End);
    }

	if ( Weapon.ThirdPersonActor != none )
		WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other,HitLocation,HitNormal);
    SpawnBeamEffect(Start, Dir, HitLocation, HitNormal, ReflectNum);
}

defaultproperties
{
     HeadShotDamageMult=2.000000
     DamageTypeHeadShot=Class'U2Weapons.U2DamTypeHSPistol'
     DamageType=Class'U2Weapons.U2DamTypePistol'
     DamageMin=33
     DamageMax=33
     FireLastReloadTime=3.222000
     FireLastReloadAnimRate=0.747177
     FireLastDownAnimRate=1.526162
     bWaitForRelease=False
     AmmoClass=Class'U2Weapons.U2AmmoPistol'

     TraceRange=4800.000000
     Momentum=4000.000000
     FireLastRoundSound=Sound'WeaponsA.Pistol.P_FireLastRound'
     FireLastRoundTime=2.100000
     bPawnRapidFireAnim=True
     FireAnimRate=0.75
     FireLoopAnim=
     FireEndAnim=
     FireSound=Sound'WeaponsA.Pistol.P_Fire'
     FireForce="AssaultRifleFire"
     FireRate=0.300000
     BotRefireRate=0.990000
     FlashEmitterClass=Class'U2ASMuzFlash1st'
     aimerror=800.000000
}
