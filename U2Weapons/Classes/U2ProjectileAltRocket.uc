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
// U2ProjectileAltRocket.uc
// Projectile class of a Rocket Warhead
// Woah! No DefaultProperties changes!
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2ProjectileAltRocket extends U2Projectile;

var actor PaintedTargets[4];
var int i;

var() float SpreadOffset;


simulated event PreBeginPlay()
{
	Super.PreBeginPlay();
	if(Role==ROLE_Authority)
	{
		Velocity.Z += 0.75 * Speed;
		SetTimer( 0.5, false );
	}
}

function Timer()
{
	local U2ProjectileRocketDrunken RD;
	local U2ProjectileRocketSeeking RS;
	local vector OffsetDir;

	if( PaintedTargets[i]!=None )
	{
        RS = Spawn( class'U2ProjectileRocketSeeking', Owner,, Location, Rotation );
		if (RS != None)
		{
            RS.Index=i;
		    RS.SetTarget(PaintedTargets[i]);
		    if (U2WeaponRocketLauncher(Instigator.Weapon) != None)
		        U2WeaponRocketLauncher(Instigator.Weapon).AltRockets[i] = RS;
		}
	}
	else
	{
		switch(i)
		{
		case 0: OffsetDir.X=1.0; OffsetDir.Y= SpreadOffset; OffsetDir.Z= SpreadOffset; break;
		case 1: OffsetDir.X=1.0; OffsetDir.Y=-SpreadOffset; OffsetDir.Z= SpreadOffset; break;
		case 2: OffsetDir.X=1.0; OffsetDir.Y=-SpreadOffset; OffsetDir.Z=-SpreadOffset; break;
		case 3: OffsetDir.X=1.0; OffsetDir.Y= SpreadOffset; OffsetDir.Z=-SpreadOffset; break;
		}

		RD = Spawn( class'U2ProjectileRocketDrunken', Owner,, Location, rotator(OffsetDir >> Rotation) );
		if (RD != None)
        {
            RD.Index=i;
		    RD.SetupData();
		    RD.SetCorrectLocation();
		    if (U2WeaponRocketLauncher(Instigator.Weapon) != None)
		        U2WeaponRocketLauncher(Instigator.Weapon).AltRockets[i] = RD;
		    Enable('Tick');
		}
	}

	if (++i < ArrayCount(PaintedTargets))
		SetTimer( 0.12, false );
}

defaultproperties
{
     SpreadOffset=0.040000
     Speed=250.000000
     MaxSpeed=250.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'343M.Projectiles.Rocket_Shell'
     Physics=PHYS_Falling
     LifeSpan=15.000000
     AmbientGlow=96
     bCollideActors=False
     bBounce=True
}
