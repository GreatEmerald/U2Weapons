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
//
//-----------------------------------------------------------
class U2Tracer extends Emitter;

var Vector HitLocation;

replication
{
	unreliable if ( Role == ROLE_Authority )
		HitLocation;
}

simulated event PostNetReceive()
{
	SetHitLocation();
}

simulated function PostNetBeginPlay()
{
    if (Role < ROLE_Authority || Level.NetMode != NM_DedicatedServer)
        SpawnEffects();
}

simulated function SetHitLocation()
{
	BeamEmitter(Emitters[0]).BeamDistanceRange.Max = VSize(HitLocation - Location);
	BeamEmitter(Emitters[0]).BeamDistanceRange.Min = VSize(HitLocation - Location);
	SetRotation(rotator(HitLocation - Location));
}


simulated function SpawnEffects()
{
    //local xWeaponAttachment Attachment;
    //local vector X,Y,Z;

    if (Instigator != None /*&& !Instigator.IsFirstPerson()*/ ) //GE: Enabling first person view.
    {
        //Attachment = xPawn(Instigator).WeaponAttachment;
        //if (Attachment != None && (Level.TimeSeconds - Attachment.LastRenderTime) < 1 /*&& !Instigator.IsFirstPerson()*/)
        //    SetLocation(Attachment.GetTipLocation());
        //else
        //{
            SetLocation(Instigator.Weapon.GetEffectStart());
            SetRotation(rotator(HitLocation - Location));
                //Instigator.Weapon.GetFireStart(X, Y, Z);
                //SetLocation(Instigator.Location + Instigator.EyeHeight*Vect(0,0,1) + Y*10 + Normal(Instigator.Location) * 25.0);
        //}
    }
}

defaultproperties
{
     bReplicateInstigator=True
     bNetInitialRotation=True
     RemoteRole=ROLE_SimulatedProxy
     bNetNotify=True
}
