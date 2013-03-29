/*
 * Copyright (c) 2008, 2009, 2013 Dainius "GreatEmerald" Masiliūnas
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
// U2FireEnergyRifle.uc
// Fire class of the Shock Lance
// Projectile's aren't dual here :(
// GreatEmerald, 2008, 2009
//-----------------------------------------------------------------------------

class U2FireEnergyRifle extends U2ProjectileFire;

var int ProjectileOffset; //Half the distance between each spawned projectile

function PlayFiring()
{
  Super.PlayFiring();
    FireEffect = spawn(FireEffectClass);
    Weapon.AttachToBone(FireEffect, 'xAltFireMuzzleFlash');
}

/*function DoFireEffect() //GE: spawn 2 projectiles.
{
    local Vector StartProj, StartProj2, StartTrace, X,Y,Z;
    local Rotator Aim, Aim2, Dir, Dir2;
    local Vector HitLocation, HitNormal;
    local Actor Other;
    local int SpawnCount;

    Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X,Y,Z);

    StartTrace = Instigator.Location + Instigator.EyePosition();
    StartProj = StartTrace + X*ProjSpawnOffset.X;
    if ( !Weapon.WeaponCentered() )
        StartProj = StartProj + Weapon.Hand * Y*ProjSpawnOffset.Y + Z*ProjSpawnOffset.Z;

    // check if projectile would spawn through a wall and adjust start location accordingly
    Other = Weapon.Trace(HitLocation, HitNormal, StartProj, StartTrace, false);
    if (Other != None)
    {
        StartProj = HitLocation;
    }

    Aim = AdjustAim(StartProj, AimError);

    SpawnCount = Max(1, ProjPerFire * int(Load));

    Dir2 = Aim;
    Dir2.Yaw = Aim2.Yaw + 16384;
    StartProj2 = StartProj + (ProjectileOffset * vector(Dir2));
    Dir = Aim;
    Dir.Yaw = Aim.Yaw - 16384;
    StartProj = StartProj + (ProjectileOffset * vector(Dir));
    SpawnProjectile(StartProj, Dir);
    SpawnProjectile(StartProj2, Dir2);

} */

/*function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;
    local Projectile p2;

    if( ProjectileClass != None )
    {
        p = Weapon.Spawn(ProjectileClass,,, Start + vect(0,10,0), Dir);
        p2 = Weapon.Spawn(ProjectileClass,,, Start - vect(0,10,0), Dir);
    }

    if( p == None )
        return None;

    p.Damage *= DamageAtten;
    p2.Damage *= DamageAtten;
    return p;
} */

function DoFireEffect() //GE: spawn 2 projectiles.
{
	local Vector StartProj, StartTrace, X,Y,Z;
	local Rotator Aim;
	local Vector HitLocation, HitNormal;
	local Actor Other;
	local int SpawnCount;

	Instigator.MakeNoise(1.0);
	Weapon.GetViewAxes(X,Y,Z);

	StartTrace = Instigator.Location + Instigator.EyePosition();// + X*Instigator.CollisionRadius;
	StartProj = StartTrace + X*ProjSpawnOffset.X;
	if ( !Weapon.WeaponCentered() )
		StartProj = StartProj + Weapon.Hand * Y*ProjSpawnOffset.Y + Z*ProjSpawnOffset.Z;

	// check if projectile would spawn through a wall and adjust start location accordingly
	Other = Weapon.Trace(HitLocation, HitNormal, StartProj, StartTrace, false);
	if (Other != None)
		StartProj = HitLocation;

	Aim = AdjustAim(StartProj, AimError);

	SpawnCount = Max(1, ProjPerFire * int(Load));
	SpawnProjectile(StartProj, Aim);
//	SpawnCount = Max(1, ProjPerFire * int(Load));
	SpawnProjectile(StartProj+Y*10, Aim);
}

defaultproperties
{
     ProjSpawnOffset=(Y=7.500000,Z=-7.000000)
     FireLastRoundSound=Sound'WeaponsA.EnergyRifle.ER_FireLastRound'
     FireLastRoundTime=1.440000
     FireEffectClass=Class'U2FX_ShockFlare'
     FireSound=Sound'WeaponsA.EnergyRifle.ER_Fire'
     FireRate=0.300000
     FireLastReloadTime=2.812000
     FireLastReloadAnimRate=0.924563
     FireLastDownAnimRate=0.944977
     AmmoClass=Class'U2Weapons.U2AmmoEnergyRifle'
     ProjectileClass=Class'U2Weapons.U2ProjectileEnergyRifle'
     ProjectileOffset=10
}
