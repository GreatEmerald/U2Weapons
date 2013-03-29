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
// U2WeaponFlameThrower.uc
// Inventory class of the Vulcan
// Looking for the pickup? It's in U2PickupFlameThrower!
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2WeaponFlameThrower extends U2Weapon;

var U2FX_PilotLight PilotA, PilotB;
var U2FT_Light FireLight[3];

var float Pct;
var int CrossX,CrossY;
var() int MinCrossX,MinCrossY;
var() int MaxCrossX,MaxCrossY;


simulated function Point GetCrossPosA(){ local Point P; P.X=-CrossX; P.Y=-CrossY; return P; }
simulated function Point GetCrossPosB(){ local Point P; P.X= CrossX; P.Y=-CrossY; return P; }
simulated function Point GetCrossPosC(){ local Point P; P.X=-CrossX; P.Y= CrossY; return P; }
simulated function Point GetCrossPosD(){ local Point P; P.X= CrossX; P.Y= CrossY; return P; }

simulated function HandleTargetDetails( Actor A, Canvas Canvas, vector ViewLoc, rotator ViewRot )
{
	local float DesiredPct;
	local float Dist;

	DesiredPct = 0.5;

	if( A!=none && LevelInfo(A)==none )
	{
		Dist = VSize(A.Location - ViewLoc);
		if( Dist < 768 )
		{
			DesiredPct = ABlend( 768, 256, Dist );
			DesiredPct = FClamp( DesiredPct, 0, 1 );
		}
	}

	Pct += (DesiredPct - Pct) * 0.1;	//!!arl framerate dependant

	CrossX = Blend( MinCrossX, MaxCrossX, Pct );
	CrossY = Blend( MinCrossY, MaxCrossY, Pct );
}


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if( bPendingDelete )
		return;

	if( Level.NetMode != NM_DedicatedServer )
	{
		PilotA = spawn(class'U2FX_PilotLight');
		AttachToBone(PilotA, 'xFlamejet1');

		PilotB = spawn(class'U2FX_PilotLight');
		AttachToBone(PilotB, 'xFlamejet2');
	}
}

simulated function PilotsOff()
{
	if ( PilotA != none )
		PilotA.SetEmitterStatus(false);
	if ( PilotB != none )
		PilotB.SetEmitterStatus(false);
}

simulated function PilotsOn()
{
	if ( PilotA != none )
		PilotA.SetEmitterStatus(true);
	if ( PilotB != none )
		PilotB.SetEmitterStatus(true);
}

simulated function CreateEffects()
{
	local int i;
	for( i=0; i<ArrayCount(FireLight); i++ )
	{
		FireLight[i] = Spawn( class'U2FT_Light', Self );
		if(i==0) FireLight[i].Offset.X=300; else
		if(i==1) FireLight[i].Offset.X=600; else
		if(i==2) FireLight[i].Offset.X=900;
	}
}

simulated function TriggerLights()
{
	local int i;
	if( Level.NetMode == NM_DedicatedServer )
		return;
	if( FireLight[0] == None )
		CreateEffects();
	for( i=0; i<ArrayCount(FireLight); i++ )
		FireLight[i].Trigger(self,Instigator);
}

simulated function Destroyed()
{
	local int i;
	for( i=0; i<ArrayCount(FireLight); i++ )
	{
		if( FireLight[i]!=none )
		{
			FireLight[i].Destroy();
			FireLight[i] = None;
		}
	}

	if (PilotA != none)
	{
		PilotA.Destroy();
		PilotA = None;
	}
	if (PilotB != none)
	{
		PilotB.Destroy();
		PilotB = None;
	}
	Super.Destroyed();
}

simulated function PlayAnimEx( name Sequence, optional float Rate )
{
	Super.PlayAnimEx(Sequence);
	switch (Sequence)
	{
	case 'Fire':
		if (FireMode[0].bIsFiring)
		{
			TriggerLights();
		}
		else
		{
			PilotsOff();
		}
		break;
	};
}

simulated function PlayIdle()
{
	super.PlayIdle();
	PilotsOn();
}


simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir;
	local U2FlameDamager FD;

	if( bHurtEntry )
		return;

	bHurtEntry = true;
	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if(	(Victims != Instigator) && (Victims.Role == ROLE_Authority) && (!Victims.IsA('FluidSurfaceInfo') && ((!Victims.PhysicsVolume.bWaterVolume) || (Pawn(Victims) != none && !Pawn(Victims).HeadVolume.bWaterVolume))))
		{   //GE: (Victims != self) - presumes a victim is a weapon. It can't be!
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
			Victims.TakeDamage
			(
				damageScale * DamageAmount,
				Instigator,
				Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				(damageScale * Momentum * dir),
				DamageType
			);
			FD = Spawn(class'U2FlameDamager');
            if (FD != None && Pawn(Victims) != None )
                FD.BeginDamaging(Pawn(Victims), U2InstantFire(FireMode[0]).DamageType, HitLocation);

			if (Instigator != None && Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
				Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, Instigator.Controller, DamageType, Momentum, HitLocation);
		}
	}
	bHurtEntry = false;
}



// AI Interface
function float GetAIRating()
{
	local Bot B;
	local float EnemyDist;
	local vector EnemyDir;

	B = Bot(Instigator.Controller);
	if ( B == None )
		return Super.GetAIRating();

	if ( (B.Target != None) && (Pawn(B.Target) == None) && (VSize(B.Target.Location - Instigator.Location) <= RangeMaxFire) )
		return Super.GetAIRating()+0.65;

	if ( B.Enemy == None )
		return Super.GetAIRating();

	EnemyDir = B.Enemy.Location - Instigator.Location;
	EnemyDist = VSize(EnemyDir);
	if ( (EnemyDist < RangeIdealFire) && (EnemyDist > RangeMinFire) && (B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon )
		return (Super.GetAIRating() + 0.65);
	return Super.GetAIRating();
}

function float SuggestAttackStyle()
{
	if ( (AIController(Instigator.Controller) != None)
		&& (AIController(Instigator.Controller).Skill < 3) )
		return 0.4;
    return 0.8;
}

function float SuggestDefenseStyle()
{
    return -0.4;
}
// End AI Interface

defaultproperties
{
     ClipSize=40
     ReloadTime=2.600000
     ReloadAnimRate=0.769230
     FireModeClass(0)=Class'U2Weapons.U2FireFlameThrower'
     FireModeClass(1)=Class'U2Weapons.U2FireAltFlameThrower'
     bUseOldWeaponMesh=False
     Description="The UA69 Vulcan Flamethrower is the most lethal short-range weapon in the Terran arsenal - you can incinerate entire squads of enemies at close quarters."
     Priority=41
     InventoryGroup=3
     PickupClass=Class'U2Weapons.U2PickupFlameThrower'
     BobDamping=2.200000
     AttachmentClass=Class'U2Weapons.U2AttachmentFlameThrower'
     IconMaterial=Texture'U2343T.HUD.U2HUD'
     IconCoords=(X1=46,Y1=188,X2=77,Y2=206)
     ItemName="Vulcan Flamethrower"

     MinCrossX=24
     MinCrossY=12
     MaxCrossX=128
     MaxCrossY=64
     AutoSwitchPriority=4
     ReloadSound=Sound'WeaponsA.Flamethrower.FT_Reload'
     ReloadUnloadedSound=Sound'WeaponsA.Flamethrower.FT_ReloadUnloaded'
     ReloadUnloadedTime=2.000000
     DownUnloadedTime=0.800000
     PutDownTime=0.800000
     SelectSound=Sound'WeaponsA.Flamethrower.FT_Select'
     AIRating=0.250000
     //CurrentRating=0.550000
     //bMeleeWeapon=True
     DisplayFOV=90.000000
     CustomCrosshair=53
     CustomCrossHairTextureName="KA_XMP.U2.uFlameThrower"
     PlayerViewOffset=(X=-4.000000,Y=11.000000,Z=-52.000000) //-4,-5,-49
     Mesh=SkeletalMesh'WeaponsK.FT_FP'

    RangeMinFire=30.000000
    RangeIdealFire=600.000000
    RangeMaxFire=925.000000
    RangeLimitFire=3500.0
    RatingInsideMinFire=-20.000000
    RatingRangeMinFire=0.300000
    RatingRangeIdealFire=0.700000
    RatingRangeMaxFire=0.400000
    RatingRangeLimitFire=0.2
    AIRatingFire=0.250000
    AIRatingAltFire=0.200000

}
