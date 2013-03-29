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
// U2FireAltRocket.uc
// Fire class of a drunken Rocket
// *Hiccup!*
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2FireAltRocket extends U2ProjectileFire;

var float CheckTargetTimer;
var() float CheckTargetInterval;
var int RocketCounter;

var() sound PaintSound;

//var Actor PaintedTargets[4];	// also used for painted targets before rockets are fired.

var float RocketContinueNotifyTimer;


function ModeHoldFire()
{
    GotoState('Targetting');
}

function StopFiring()
{
	U2WeaponRocketLauncher(Weapon).StopTargetting();
}


simulated state Targetting
{
	simulated event BeginState()
	{
		RocketCounter=4;
		U2WeaponRocketLauncher(Weapon).PaintedTargets[0]=None;
		U2WeaponRocketLauncher(Weapon).PaintedTargets[1]=None;
		U2WeaponRocketLauncher(Weapon).PaintedTargets[2]=None;
		U2WeaponRocketLauncher(Weapon).PaintedTargets[3]=None;

		U2WeaponRocketLauncher(Weapon).StartTargetting();
	}

    function ModeTick(float DeltaSeconds)
    {
		if( (Weapon.Role == ROLE_Authority) && (RocketCounter > 0) && (Level.TimeSeconds >= CheckTargetTimer) )
		{
			CheckTargets();
		}
		if (!bIsFiring || U2Weapon(Weapon).bIsReloading)
        {
            StopFiring();
        }
    }

	function CheckTargets()
	{
		local Pawn PaintedTarget;
		local int OtherTeam;
		if (Instigator.Controller == None || U2Weapon(Weapon).PlayerSees( 28800, 0.0 ) == None) return;
        if(U2Weapon(Weapon).PlayerSees( 28800, 0.0 ).IsA('Pawn'))
			PaintedTarget = Pawn(U2Weapon(Weapon).PlayerSees( 28800, 0.0 ));
		if (PaintedTarget==none || PaintedTarget.Health <= 0) return;
		OtherTeam = PaintedTarget.GetTeamNum();
		if (!Level.Game.IsA('TeamGame') || OtherTeam != Instigator.GetTeamNum())
			PaintTarget(PaintedTarget);
	}

	function PaintTarget( Pawn PaintedTarget )
	{
		local PlayerController PC;
		CheckTargetTimer = Level.TimeSeconds + CheckTargetInterval;
		--RocketCounter;
		U2WeaponRocketLauncher(Weapon).PaintedTargets[RocketCounter] = PaintedTarget;
		PC = PlayerController(PaintedTarget.Controller);
		switch(RocketCounter)
		{
		  case 0: U2WeaponRocketLauncher(Weapon).ClientSetPaintedTargetA(PaintedTarget); break;
		  case 1: U2WeaponRocketLauncher(Weapon).ClientSetPaintedTargetB(PaintedTarget); break;
		  case 2: U2WeaponRocketLauncher(Weapon).ClientSetPaintedTargetC(PaintedTarget); break;
		  case 3: U2WeaponRocketLauncher(Weapon).ClientSetPaintedTargetD(PaintedTarget); break;
		}
	}

    function StopFiring()
    {
    	U2WeaponRocketLauncher(Weapon).StopTargetting();
        GotoState('');
    }
}

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;
	local U2ProjectileAltRocket R;

	p = Super.SpawnProjectile(Start, Dir);
	R = U2ProjectileAltRocket(P);
	if (R!=none)
	{
		R.PaintedTargets[0] = U2WeaponRocketLauncher(Weapon).PaintedTargets[0];
		R.PaintedTargets[1] = U2WeaponRocketLauncher(Weapon).PaintedTargets[1];
		R.PaintedTargets[2] = U2WeaponRocketLauncher(Weapon).PaintedTargets[2];
		R.PaintedTargets[3] = U2WeaponRocketLauncher(Weapon).PaintedTargets[3];
	}
	return P;
}

defaultproperties
{
     AmmoClass=Class'U2Weapons.U2AmmoRocketLauncher'
     ProjectileClass=Class'U2Weapons.U2ProjectileAltRocket'

     CheckTargetInterval=0.150000
     ProjSpawnOffset=(X=10.000000,Y=19.000000,Z=4.000000)
     AnimFireLastRound="AltFireLastRound"
     AnimFireLastDown="AltFireLastDown"
     AnimFireLastReload="AltFireLastReload"
     FireLastRoundSound=Sound'WeaponsA.RocketLauncher.RL_AltFireLastRound'
     FireLastReloadTime=4.000000
     FireLastReloadAnimRate=1.0625
     FireLastRoundTime=2.170000
     FireLastDownAnimRate=4.6875
     bFireOnRelease=True
     FireAnim="AltFire"
     FireSound=Sound'WeaponsA.RocketLauncher.RL_AltFire'
     FireRate=1.080000
}
