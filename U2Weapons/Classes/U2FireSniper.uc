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
// U2FireSniper.uc
// Fire class of the Widowmaker
// Where did all the slow Gunners go? Oh, they're now Juggernauts.
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2FireSniper extends U2InstantFire;

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
        //else
        //        HitLocation = HitLocation + 2.0 * HitNormal;
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

function SpawnBeamEffect(Vector Start, Rotator Dir, Vector HitLocation, Vector HitNormal, int ReflectNum)
{
	//local ShockBeamEffect Tracer;
    local U2Tracer Tracer;

    if (Weapon != None)
    {
		if ( Instigator.GetTeamNum() == 1 )
			Tracer = Weapon.Spawn(class'U2TracerBlue', Instigator,, Start, Dir);
		else
			Tracer = Weapon.Spawn(class'U2TracerRed'/*class'ShockBeamEffect'*/, Instigator,, Start, Dir);

		//Tracer.Instigator = None;
        Tracer.HitLocation = HitLocation;
		Tracer.SetHitLocation();
		//Tracer.AimAt(HitLocation, HitNormal);
    }
}

defaultproperties
{
     HeadShotDamageMult=3.000000
     DamageTypeHeadShot=Class'U2Weapons.U2DamTypeSniperHeadshot'
     DamageType=Class'U2Weapons.U2DamTypeSniper'
     DamageMin=44
     DamageMax=44
     FireRate=1.400000
     AmmoClass=Class'U2Weapons.U2AmmoSniper'
     FlashEmitterClass=Class'U2Weapons.U2ASMuzFlash1st'

     TraceRange=65536.000000
     Momentum=10000.000000
     FireLastRoundSound=Sound'WeaponsA.SniperRifle.SR_FireLastRound'
     FireLastReloadTime=2.530000
     FireLastRoundTime=2.270000
     FireLastDownAnimRate=4.5703125
     FireLoopAnim=
     FireEndAnim=
     FireSound=Sound'WeaponsA.SniperRifle.SR_Fire'
     FireForce="AssaultRifleFire"
     ShakeRotMag=(X=0.000000,Y=0.000000,Z=0.000000)
     ShakeRotRate=(X=0.000000,Y=0.000000,Z=0.000000)
     ShakeOffsetMag=(X=-20.000000,Y=0.000000,Z=0.000000)
     ShakeOffsetRate=(X=-1000.000000,Y=0.000000,Z=0.000000)
     BotRefireRate=0.990000
     aimerror=800.000000
}
