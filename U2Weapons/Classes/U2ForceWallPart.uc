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
class U2ForceWallPart extends Actor;

var U2ForceWallPart FirstSegment, PrevSegment, NextSegment;

function UsedBy(Pawn User)
{
    if(FirstSegment == self)
        U2ForceWall(Owner).UsedBy(User);
    else
        GetMaster().UsedBy(User);
}

function TakeDamage( int Damage, Pawn DamageInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType )
{
    if(FirstSegment == self)
        U2ForceWall(Owner).XTakeDamage(Damage,DamageInstigator,HitLocation,Momentum,DamageType, self);
    else
        GetMaster().TakeDamage(Damage,DamageInstigator,HitLocation,Momentum,DamageType);
}

function Touch( Actor Other )
{
    if(FirstSegment == self)
        U2ForceWall(Owner).Touch(Other);
    else
        GetMaster().Touch(Other);
}

event Bump(Actor Other)
{
    if(FirstSegment == self)
        U2ForceWall(Owner).Bump(Other);
    else
        GetMaster().Bump(Other);
}

event Attach (Actor Other)
{
    if (FirstSegment != self)
    {
        Super.Attach(Other);
        GetMaster().Attach(Other);
        return;
    }

    if (Pawn(Other) != None && Owner != None && U2ForceWall(Owner).StartFG != None && !U2ForceWall(Owner).StartFG.SameTeam(Pawn(Other)))
    {
        Super.Attach(Other);
        TakeDamage( (1-Pawn(Other).Velocity.Z/400)* Pawn(Other).Mass/Mass, Pawn(Other),Pawn(Other).Location,0.5 * Pawn(Other).Velocity , class'Crushed');
        Pawn(Other).JumpOffPawn();
    }
    else if (Pawn(Other) != None && Owner != None && U2ForceWall(Owner).StartFG != None && U2ForceWall(Owner).StartFG.SameTeam(Pawn(Other)))
        Touch(Other);
}

event bool EncroachingOn( Actor Other )
{
    if(FirstSegment == self)
        return(U2ForceWall(Owner).EncroachingOn(Other));
    else
        return(GetMaster().EncroachingOn(Other));
}

simulated function U2ForceWallPart GetMaster()
{
    return(U2ForceWallPart(Owner));
}

simulated function bool CreateBeam(int SegmentCount, rotator Direction)
{
    local vector NewLoc, Dir;
    local int i;
    local U2ForceWallPart tempFW;

  	Dir = vect(1,0,0) >> Direction;

   	FirstSegment = self;

    for(i=0; i <= SegmentCount; i++)
    {
		NewLoc = Location + (i * (default.CollisionRadius * 2.0) * Dir);
		tempFW = spawn(class'U2ForceWallPart',self,,NewLoc);

        if(tempFW == none)
            return false;

		tempFW.PrevSegment = FirstSegment;
        if(FirstSegment.NextSegment != none)
            FirstSegment.NextSegment.PrevSegment = tempFW;
		tempFW.NextSegment = FirstSegment.NextSegment;
        FirstSegment.NextSegment = tempFW;
    }
    return true;
}

simulated function DestroyBeam()
{
    local U2ForceWallPart Head, NextSeg;

    Head = FirstSegment;
    while(Head != None)
    {
        NextSeg = Head.NextSegment;
        Head.Destroy();
        Head = NextSeg;
    }

    if(!bDeleteMe)
        Destroy();
}

simulated function EnableCollision()
{
    if(FirstSegment != self)
        SetCollision(true,true,true);

    if(NextSegment != None)
        NextSegment.EnableCollision();

}

simulated function DisableCollision()
{
    SetCollision(false,false,false);
    if(NextSegment != None)
        NextSegment.DisableCollision();

}

simulated function string GetDescription ( Controller User )
{
	if(FirstSegment == self)
		return U2ForceWall(Owner).GetDescription(User);
	else
		return GetMaster().GetDescription(User);
}

defaultproperties
{
     DrawType=DT_None
     StaticMesh=StaticMesh'XMPM.items.MCDBX_force_col'
     bHidden=True
     RemoteRole=ROLE_None
     CollisionRadius=16.000000
     CollisionHeight=16.000000
     bProjTarget=True
     bUseCylinderCollision=True
     bBlockKarma=True
}
