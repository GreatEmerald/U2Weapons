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
// U2AssaultRifleProjAlt.uc
// Alternative projectile class of the M32 Duster
// What's that slug doing?
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2AssaultRifleProjAlt extends U2Projectile;

var Emitter Sal;
var actor Glow;

simulated event PostBeginPlay()
{
	if (bPendingDelete)
		return;

	if (Level.NetMode == NM_DedicatedServer)
		return;

	Sal = spawn(class'U2FX_NewAssaultAltFireFX');
	Sal.SetRotation( Rotation );
	Sal.SetBase( Self );
}

simulated event Destroyed()
{
	if( Sal != None )
	{
		Sal.Destroy();
		Sal = None;
	}
	if ( glow != None )
		Glow.Destroy();
	Super.Destroyed();
}

simulated function XExplode(vector HitLocation, vector HitNormal, actor HitActor)
{
	local vector start;
    local rotator rot;
    local int i;
    local vector tempv;
    local rotator tempr;
    local Vector VNorm;

	if( (Role == ROLE_Authority) && Pawn(HitActor)==None )	// don't bounce off pawns.
	{
		start = Location + 10 * HitNormal;
		tempr.pitch = 2000;
		tempv = Vector(tempr);
		vnorm = (Velocity dot HitNormal) * HitNormal * (-2.0) + Velocity;
		for (i=0; i<5; i++)
		{
			tempr = Rotator(vnorm);
			tempr.Roll = 13107 * i;
			rot = Rotator(tempv >> tempr);
			Spawn(class'U2ProjectileASExplAlt',Self,, Start, rot );
		}
	}
	Super.XExplode(HitLocation,HitNormal,HitActor);
}

defaultproperties
{
     Speed=3000.000000
     MaxSpeed=3000.000000
     Damage=44.000000
     MomentumTransfer=40000.000000
     MyDamageType=Class'U2Weapons.U2DamTypeAssaultSlug'
     DrawScale=0.600000

     DamageRadius=64.000000
     DrawType=DT_None
}
