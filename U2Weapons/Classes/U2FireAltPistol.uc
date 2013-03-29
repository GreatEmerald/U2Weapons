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
// U2FireAltPistol.uc
// Alternative fire class of the Magnum
// 33, 33, 33... Argh, 1hp!
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2FireAltPistol extends U2InstantFire;

var() float HeadShotDamageMult;
var() class<DamageType> DamageTypeHeadShot;

function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X, End, HitLocation, HitNormal;
    local Actor Other;
    local int ReflectNum;
    local Pawn HeadShotPawn;
    local Actor A;


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
     DamageTypeHeadShot=Class'U2Weapons.U2DamTypeAltHSPistol'
     DamageType=Class'U2Weapons.U2DamTypeAltPistol'
     DamageMin=66 //GE: Don't ask me why it's twice, not three times the normal damage.
     DamageMax=66
     FireLastReloadTime=2.607000
     FireLastReloadAnimRate=0.923439
     FireLastDownAnimRate=4.620535
     AmmoClass=Class'U2Weapons.U2AmmoPistol'
     TraceRange=4800.000000
     Momentum=8000.000000
     AnimFireLastRound="AltFireLastRound"
     AnimFireLastDown="AltFireLastDown"
     AnimFireLastReload="AltFireLastReload"
     FireLastRoundSound=Sound'WeaponsA.Pistol.P_AltFireLastRound'
     FireLastRoundTime=2.100000
     FireAnim="AltFire"
     FireAnimRate=0.9
     FireLoopAnim=
     FireEndAnim=
     FireSound=Sound'WeaponsA.Pistol.P_AltFire'
     FireForce="AssaultRifleFire"
     FireRate=1.100000
     AmmoPerFire=3
     BotRefireRate=0.990000
     FlashEmitterClass=Class'U2ASMuzFlash1st'
     aimerror=800.000000
     Spread=0.150000
}
