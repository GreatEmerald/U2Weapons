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
// U2ProjectileASExplAlt.uc
// Explosion projectile (CAR) - this is the small projectile chipped from the large one
// Boom.
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2ProjectileASExplAlt extends U2Projectile;

var Emitter Trail, Dust;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	if (bPendingDelete)
		return;

    if ( Level.NetMode != NM_DedicatedServer )
    {
	Trail = spawn(class'U2FX_NewAssaultAltExplodeFX');
	Trail.SetRotation( Rotation );
	Trail.SetBase( Self );

	Dust = spawn(class'U2FX_NewAssaultAltExplodeFX_Dust');
	Dust.SetRotation( Rotation );
	Dust.SetBase( Self );
    }
}

simulated event Destroyed()
{
	if( Trail != None )
	{
		Trail.Destroy();
		Trail = None;
	}

}

defaultproperties
{
     Damage=13.750000
     MyDamageType=Class'U2Weapons.U2DamTypeAssaultSlug'
     ExplosionDecal=class'U2DecalAssaultRifle'

     Speed=3000.000000
     MaxSpeed=3000.000000
     MomentumTransfer=500.000000
     DrawType=DT_None
     LifeSpan=0.500000
     Style=STY_Alpha
}
