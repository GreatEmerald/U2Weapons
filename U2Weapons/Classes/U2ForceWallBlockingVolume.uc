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
class U2ForceWallBlockingVolume extends U2DynamicBlockingVolume;

simulated function EnableCollision()
{
	KSetBlockKarma(true);
	SetPhysics(PHYS_Karma);
	SetCollision(true,true,true);
}

simulated function DisableCollision()
{
	KSetBlockKarma(false);
	SetPhysics(PHYS_None);
	SetCollision(false,false,false);
}

function TakeDamage( int Damage, Pawn DamageInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType )
{
	log(self@"TAKE DAMAGE:"@Damage);
	U2ForceWall(Owner).XTakeDamage(Damage,DamageInstigator,HitLocation,Momentum,DamageType, none);
}

function Touch( Actor Other )
{
	log(self@"TOUCH");
	U2ForceWall(Owner).Touch(Other);
}

function UsedBy(Pawn User)
{
	log(self@"USED BY");
	U2ForceWall(Owner).UsedBy(User);
}

defaultproperties
{
     bBlockProjectiles=True
     bProjTarget=True
     bBlockZeroExtentTraces=True
}
