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
// U2ProjectileAltFlameThrower.uc
// Napalm projectile class of the Vulcan
// This will stick to surfaces.
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2ProjectileAltFlameThrower extends U2Projectile;

#EXEC OBJ LOAD FILE=..\Sounds\U2AmbientA.uax

var Emitter Effect;
var bool bExploded;
var bool bDeployed;
var int loop;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    SetTimer(0.20, false);
}

simulated function Timer()
{
    /*if( loop < 3)
        loop++;
    else
        SetTimer(0.0,false); */
    if (Physics != PHYS_None) //GE: Only set this if falling.
        SetDrawType(DT_Sprite);
}

simulated function XExplode(vector HitLocation, vector HitNormal, actor HitActor)
{
	//local Actor Explosion;
    Spawn( class'U2FX_FlameBit' );

    if(bExploded)
      return;

	bExploded = true;

//	super.XExplode(HitLocation,HitNormal,HitActor);

	if( Role == ROLE_Authority )
	{
		MakeNoise( 1.0 );
        XHurtRadius( Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation, bNoFalloff );
	}

	PlaySound(Sound'U2AmbientA.Fire.Fizzle5',
				SLOT_Interact,
				RandRange(0.5,0.7),,
				RandRange(100,200),
				RandRange(0.5,1.5));

	Destroy();
}

simulated function XTakingDamage( Pawn Victim, vector HitLocation )
{
	local U2FlameDamager FD;

    if (Victim == None)
        return;

    FD = Spawn(class'U2FlameDamager');
    if (FD != None)
        FD.BeginDamaging(Victim, MyDamageType, HitLocation);
}

simulated event Destroyed()
{
	if( !bExploded)
		XExplode( Location, -normal(Velocity), none );

	if(Effect != None)
    {
       Effect.Destroy();
       Effect = none;
    }

	Super.Destroyed();
}

simulated event Touch( Actor Other)
{
    super.Touch(Other);

    if( ( Pawn(Other) != None ) && ( bDeployed == True && loop >= 3 ) )
    {
        XExplode(Location, Location, Other);
    }
}

simulated function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
//    if(Effect != None)

    if (DamageType != MyDamageType && DamageType.default.bDetonatesGoop)
        XExplode(Location, Location, self);
}

simulated function HitWall (vector HitNormal, actor Wall)
{
    local rotator FXRot;

	SetPhysics( PHYS_None );
	Velocity = Vect(0,0,0);

    FXRot = rotator(-HitNormal);
    FXRot.pitch -= 16384;

    SetDrawType(DT_None);
    Effect = Spawn(class'U2FX_NapalmEffect',,, Location + Vect(0,0,-45), FXRot); //,,,, rotator(-HitNormal)); // because projectors suck
	bDeployed=true;

}

defaultproperties
{
     MaxSpeed=1000.000000
     MomentumTransfer=10000.000000
     MyDamageType=Class'U2Weapons.U2DamTypeNapalm'
     LifeSpan=20.000000
     DrawScale=0.600000

     bHydrophobic=True
     Speed=500.000000
     DamageRadius=220.000000
     DrawType=DT_None
     Texture=Material'U2WeaponFXT.FlameThrower.Napalm'

     bNetTemporary=False
     Physics=PHYS_Falling
     CollisionRadius=55.000000
     CollisionHeight=50.000000
     bNetNotify=True
     bBounce=True
     Damage=2.75
}
