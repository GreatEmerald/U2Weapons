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
// U2AttachmentFlameThrower.uc
// Attachment class of the Vulcan
// Hopefully will work correctly.
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2AttachmentFlameThrower extends U2WeaponAttachment;

var Emitter PrimaryFire, SecondaryFire;

var U2FT_Light FireLight[3];

var vector EffectLocation;
var rotator EffectRotation;
var bool bAltFire;

var float Time;

replication
{
	unreliable if( bNetDirty && !bNetOwner && (Role==ROLE_Authority) )
		EffectLocation, EffectRotation;

	reliable if( bNetDirty && !bNetOwner && (Role==ROLE_Authority) )
		bAltFire;
}

simulated event ThirdPersonEffects()
{
    if ( Level.NetMode != NM_DedicatedServer && Instigator != none && !Instigator.IsLocallyControlled() )
	{
		if ( PrimaryFire == none )
			PrimaryFire = spawn(class'U2FX_FlameEffect');

		if (SecondaryFire == none)
			SecondaryFire = spawn(class'U2FX_FlameAltEffect');

		if (FiringMode==0)
		{
			//if ( PrimaryFire != none )
			//	PrimaryFire.Trigger(Self,Instigator);
			TriggerLights();
		}
		else
			SecondaryFire.Trigger(Self,Instigator);

		Fire();
    }

    Super.ThirdPersonEffects();
}

simulated function Fire()
{
	Time = 0.2;
	GotoState('Firing');
}

simulated state Firing
{
	simulated event BeginState()
	{
		Enable('Tick');
	}
	simulated event EndState()
	{
		Disable('Tick');
	}
	simulated event Tick( float DeltaTime )
	{
		Time -= DeltaTime;
		if( Time <= 0 )
		{
			GotoState('');
			return;
		}

		if (FiringMode==0)
		{
			if ( PrimaryFire != none )
			{
				PrimaryFire.SetLocation( EffectLocation );
				PrimaryFire.SetRotation( EffectRotation );
			}
		}
		else
		{
			if ( SecondaryFire != none )
			{
				SecondaryFire.SetLocation( EffectLocation );
				SecondaryFire.SetRotation( EffectRotation );
			}
		}
	}
}

simulated function CreateEffects()
{
	local int i;
	for( i=0; i<ArrayCount(FireLight); i++ )
	{
		FireLight[i] = Spawn( class'U2FT_Light', Self );
		if(i==0) FireLight[i].Offset.Z=-300; else
		if(i==1) FireLight[i].Offset.Z=-600; else
		if(i==2) FireLight[i].Offset.Z=-900;
	}
}

simulated function TriggerLights()
{
	local int i;
	if( Level.NetMode == NM_DedicatedServer )
		return;
	if( FireLight[0] == None )
		CreateEffects();
	for( i=0; i<ArrayCount(FireLight); i++ )
		FireLight[i].Trigger(self,Instigator);
}

simulated function Destroyed()
{
	local int i;
	for( i=0; i<ArrayCount(FireLight); i++ )
	{
		if( FireLight[i] != none )
		{
			FireLight[i].Destroy();
			FireLight[i] = None;
		}
	}
	if (PrimaryFire != none)
	{
		U2FX_FlameEffect(PrimaryFire).Deactivate();
		PrimaryFire = None;
	}
	if (SecondaryFire != none)
	{
		SecondaryFire.Destroy();
		SecondaryFire = None;
	}
	Super.Destroyed();
}

defaultproperties
{
     Mesh=SkeletalMesh'U2Weapons3rdPK.FT_TP'
     RelativeRotation=(Yaw=49151,Roll=98302)
     DrawScale=0.300000
     bRapidFire=True
     bAltRapidFire=True
}
