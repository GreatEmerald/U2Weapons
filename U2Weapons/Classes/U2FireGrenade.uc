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
// XMPGrenadeFire.uc
// 2004 jasonyu
// 24 May 2004
//-----------------------------------------------------------

class U2FireGrenade extends U2ProjectileFire;

var() float TimedGrenadeChargeThreshold;
var bool bLastGrenadeTimed;

/*simulated function bool HasAmmo()
{
	return Weapon.HasAmmo();
}

event ModeDoFire()
{

	Super(WeaponFire).ModeDoFire();

	if ( HasAmmo() )
	{
		U2Weapon(Weapon).Ammo_Reload();
	}
}  */

function DoFireEffect()
{
	local Vector StartProj, StartTrace, X,Y,Z;
	local Rotator Aim;
	local Vector HitLocation, HitNormal;
	local Actor Other;
	local U2Projectile P;

	Instigator.MakeNoise(1.0);
	Weapon.GetViewAxes(X,Y,Z);

	StartTrace = Instigator.Location + Instigator.EyePosition();// + X*Instigator.CollisionRadius;
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
	P = U2Projectile(SpawnProjectile(StartProj, Aim));
	if ( (HoldTime >= TimedGrenadeChargeThreshold && Bot(Instigator.Controller) == None) || (Bot(Instigator.Controller) != None && !Bot(Instigator.Controller).EnemyVisible()) )
	{
		P.bBounce = true;
		P.bDelayedExplosion = true;
	}
	else
	{
		P.bBounce = false;
		P.bDelayedExplosion = false;
	}
}

/*function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;

    if( ProjectileClass != None )
        p = Weapon.Spawn(ProjectileClass,,, Start, Dir);

    if( p == None )
        return None;

    p.Damage *= DamageAtten;
    return p;
} */

simulated function SwitchAmmo(int Type)
{
    switch(Type)
    {
        case 0:
            bSplashJump=False;
            ProjectileClass=Class'U2Weapons.U2ProjectileFragGrenade';
            bLeadTarget=False;
            break;
        case 1:
            bSplashJump=False;
            ProjectileClass=Class'U2Weapons.U2ProjectileToxicGrenade';
            bLeadTarget=False;
            break;
        case 2:
            bSplashJump=False;
            ProjectileClass=Class'U2Weapons.U2ProjectileIncendiaryGrenade';
            bLeadTarget=False;
            break;
        case 3:
            bSplashJump=False;
            ProjectileClass=Class'U2Weapons.U2ProjectileSmokeGrenade';
            bLeadTarget=True;
            break;
        case 4:
            bSplashJump=True;
            ProjectileClass=Class'U2Weapons.U2ProjectileConcussionGrenade';
            bLeadTarget=False;
            break;
        case 5:
            bSplashJump=False;
            ProjectileClass=Class'U2Weapons.U2ProjectileEMPGrenade';
            bLeadTarget=False;
            break;
        default:
            bSplashJump=False;
            ProjectileClass=Class'U2Weapons.U2ProjectileFragGrenade';
            bLeadTarget=False;
            break;
    }
}

defaultproperties
{
     TimedGrenadeChargeThreshold=0.500000
     FireLastRoundSound=Sound'WeaponsA.GrenadeLauncher.GL_FireLastRound'
     FireLastReloadTime=2.615000
     FireLastRoundTime=2.615000
     FireLastDownAnimRate=0.874792
     FireLastReloadAnimRate=0.529489
     bSplashDamage=True
     bRecommendSplashDamage=True
     bTossed=True
     bFireOnRelease=True
     FireSound=Sound'WeaponsA.GrenadeLauncher.GL_Fire'
     FireRate=1.200000
     AmmoClass=Class'U2AmmoGrenadeLauncher'
     BotRefireRate=0.050000
     WarnTargetPct=0.900000
     ProjectileClass=Class'U2Weapons.U2ProjectileFragGrenade';
}
