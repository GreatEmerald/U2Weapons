/*
 * Copyright (c) 2008-2010, 2013 Dainius "GreatEmerald" Masiliūnas
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
//------------------------------------------------------------------------------
// U2PowerStation.uc
// GreatEmerald, 2008, 2009, 2010, thanks to meowcat for opacity code
// Based on UTXMP and Unreal II Power Stations
//------------------------------------------------------------------------------

class U2PowerStation extends xPickUpBase;

var() int       EnergyUnits;      // A pickup or station's number of EnergyUnits
var() int       HealthUnits;      // A pickup or station's number of HealthUnits
//var() int		AmmoUnits;        // Percentage of total ammunition this powerup provides !!GE: remove?
var() int       TransferRate;     // The rate at which the units are passed to the Player
							      // in terms of x units per second.
var() string    Description;	  // Popup description of this PowerUp !!GE: obsolete?
var   float     LastTransferTime; // Saves the time of the last Unit transfer
//var   XMPPowerSuit TargetPowerSuit;  // The PowerSuit that is being manipulated !!GE: remove?
var   Pawn      PowerUpOwner;     // The player using the Power Station

var() bool	  bLimited;					// If Limited, the station deactivates when units are consumed,
										// else stops working when  units are consumed, but will recharge
										// them over time.
var() float   RechargeRate;				// If !bLimited, rate at which units are recharged.
var() Sound   StationStartUsingSound;   // Pawn starts using the station
var() Sound   StationStopUsingSound;	// Pawn stops using the station
var() Sound   StationInUseSound;		// Station is being used by the pawn
var() Sound   StationErrorSound;		// Station cannot be used or stops
//var() float   TeamEnergyCost;			// Energy drained from team energy when in use by a player !!GE: remove?
var   float   DelayTime;
var   float   LastRechargeTime;
var	  int     StartingEnergyUnits;
var   int     StartingHealthUnits;
//var   int     StartingAmmoUnits; !!GE: remove?
//var   float   TouchingHeight, TouchingRadius;

var() class<Emitter> ParticleEffect;
//var() vector StationEffectOffset;
var Emitter ActiveStationEffect;

var xPickupBase Charger;
var() int MaxShield;
var() bool bSuperHealing;
var name OldState;
var int Debug;

//var constantcolor ChargeColour;
//var shader ChargeMaterial;
var() color StationColour; //GE: Unique to every station type.

//GE: Texture objects
var Combiner EffectCombiner;
var TexPanner EffectPanner;
var TexScaler EffectScaler;
var TexOscillator EffectOscillator;
var TexRotator EffectRotator;
var FinalBlend FinalSkin;
var ConstantColor EffectController; //GE: This one's important.
var() Texture BaseTexture;

//var bool bDebug1, bDebug2, bDebug3, bDebug4;

replication
{
    //GE: These are only set at the beginning. We have bandwidth to spare.
    reliable if (Role == ROLE_Authority)
        StartingHealthUnits, StartingEnergyUnits;

    //GE: These are updated in Tick(). We definitely don't have the bandwidth to spare, so drop if needed. A little choppiness is not going to kill anyone.
    unreliable if (Role == ROLE_Authority)
        HealthUnits, EnergyUnits;
    //    EffectController, StationColour, UpdateMeterOpacity;
}


//-----------------------------------------------------------------------------

simulated event PreBeginPlay()
{
	//local vector TouchLocation;

	Super.PreBeginPlay();

	if( !bLimited )
	{
		StartingHealthUnits = HealthUnits;
		StartingEnergyUnits = EnergyUnits;
	}
	//TouchingCollisionProxy = Spawn( class'XMPCollisionProxy' ); //!!SBB (mdf) Needs changing!
	//TouchingCollisionProxy.CP_SetCollision( true, false, false );

	//TouchLocation = Location;
	//TouchLocation.Z -= PrePivot.Z;

	//TouchingCollisionProxy.CP_SetLocation( TouchLocation );
	//TouchingCollisionProxy.CP_SetCollisionSize( TouchingRadius, TouchingHeight );
	//TouchingCollisionProxy.CP_SetTouchTarget( Self );
	//TouchingCollisionProxy.SetBase( Self );


    InitTextures();

}

//-----------------------------------------------------------------------------

simulated function InitTextures()
{
    //GE: init the dynamic colour system.
	/*
	 * GE: This is the actual structure of the textures used to get the desired
	 * effect:
	 * Texture -> Combiner -> TexPanner -> TexScaler -> TexOscillator -> TexRotator -> FinalBlend
	 * ConstantColor -^
	 *
	 * We change the ConstantColor and by doing so control both the color of a
	 * specific station, and the alpha channel of it so it fades out when empty.
	 * Unable to do through UEd since we can't control the ConstantColor that way.
	 * Still works as a fallback.
	 */

    EffectCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
    EffectController = ConstantColor(Level.ObjectPool.AllocateObject(class'ConstantColor'));
    EffectController.color = StationColour;

    EffectCombiner.Material1 = BaseTexture;
    EffectCombiner.Material2 = EffectController;
    EffectCombiner.FallbackMaterial = BaseTexture;
    EffectCombiner.CombineOperation = CO_AlphaBlend_With_Mask;
    EffectCombiner.AlphaOperation = AO_Multiply;

    EffectPanner = TexPanner(Level.ObjectPool.AllocateObject(class'TexPanner'));
    EffectPanner.Material = EffectCombiner;
    EffectPanner.PanRate = 2.0;
    EffectPanner.PanDirection.Yaw = 16384; //GE: Up

    EffectScaler = TexScaler(Level.ObjectPool.AllocateObject(class'TexScaler'));
    EffectScaler.Material = EffectPanner;
    EffectScaler.UScale = 0.3;
    EffectScaler.VScale = 0.5;

    EffectOscillator = TexOscillator(Level.ObjectPool.AllocateObject(class'TexOscillator'));
    EffectOscillator.Material = EffectScaler;
    EffectOscillator.UOscillationRate = 0.01;
    EffectOscillator.VOscillationRate = 0.0;
    EffectOscillator.UOscillationAmplitude = 2.0;

    EffectRotator = TexRotator(Level.ObjectPool.AllocateObject(class'TexRotator'));
    EffectRotator.Material = EffectOscillator;
    EffectRotator.Rotation.Yaw = 16384;

    FinalSkin = FinalBlend(Level.ObjectPool.AllocateObject(class'FinalBlend'));
    FinalSkin.Material = EffectRotator;
    FinalSkin.FrameBufferBlending = FB_AlphaBlend;
    FinalSkin.TwoSided = true;
    //GE: Engage!
    Skins[2] = FinalSkin;
}

//-----------------------------------------------------------------------------

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

    //if (CollisionRadius == default.CollisionRadius)
    //   SetCollisionSize(TouchingRadius, CollisionHeight);

	if( !bPendingDelete && Level.NetMode != NM_DedicatedServer )
	{
		if( ParticleEffect != none )
		{
			ActiveStationEffect = spawn(ParticleEffect, self,, Location /*+ (StationEffectOffset << Rotation)*/ );
			ActiveStationEffect.SetRotation( Rotation );
			//ActiveStationEffect.TurnOn();
		}
	}
}

//-----------------------------------------------------------------------------

simulated event Destroyed()
{
	//CleanupCollisionProxy( TouchingCollisionProxy );
	if( ActiveStationEffect != none )
		ActiveStationEffect.Destroy();

	//GE: Uninitialise all textures.
	Level.ObjectPool.FreeObject(FinalSkin);
	Level.ObjectPool.FreeObject(EffectRotator);
	Level.ObjectPool.FreeObject(EffectOscillator);
    Level.ObjectPool.FreeObject(EffectScaler);
    Level.ObjectPool.FreeObject(EffectPanner);
	Level.ObjectPool.FreeObject(EffectCombiner);
	Level.ObjectPool.FreeObject(EffectController);

	Super.Destroyed();
}

//-----------------------------------------------------------------------------

/*function CleanupCollisionProxy( XMPCollisionProxy CP ) //!!SBB (mdf) Needs changing!
{
	if( CP != None )
	{
		CP.Destroy();
		CP = None;
	}
} */

//-----------------------------------------------------------------------------

simulated function string GetDescription( Controller User ) //!!SBB (mdf) obsolete?
{
	return Description;
}

//-----------------------------------------------------------------------------

function ClearProperties()
{
	AmbientSound = None;
    if( PowerUpOwner != none )
	{
		//PowerUpOwner.AmbientSound = None;
	    HandleAI(PowerUpOwner, false);
	}
	PowerUpOwner = None;
}

//-----------------------------------------------------------------------------
// This function occurs when a station is either empty, the pawn's units are
// full or potentially if the station is damaged (no determination on this yet).

function StationError()
{
	PlaySound( StationErrorSound, SLOT_Interact );
	if( PowerUpOwner != None )
	    HandleAI(PowerUpOwner, false);
	ClearProperties();
	LastRechargeTime = Level.TimeSeconds;
//DM( "%%% " $ Self $ ".PowerStation.StationError() LastRechargeTime = " $ LastRechargeTime );
}

//-----------------------------------------------------------------------------
// Turn station off and set texture back to active

function SetStationActiveOff()
{
	ClearProperties();
	LastRechargeTime = Level.TimeSeconds;
//DM( "%%% " $ Self $ ".PowerStation.SetStationActiveOff() LastRechargeTime = " $ LastRechargeTime );
}

//-----------------------------------------------------------------------------
// Play in use sound, set ambient sound, change skin to in use and set the
// transfer time for the powerup calculation code.

function SetStationInUse()
{
	PlaySound( StationStartUsingSound, SLOT_Interact );
	/*PowerUpOwner.*/AmbientSound = StationInUseSound;
	LastTransferTime = Level.TimeSeconds;
    if (PowerUpOwner != None)
    {
	    HandleAI(PowerUpOwner, true);
	    //PowerUpOwner.ClientMessage("AI is engaged.");
    }
}

//-----------------------------------------------------------------------------

function MakeStationEmpty()
{
	StationError();
}

//-----------------------------------------------------------------------------

function StopStation()
{
	SetStationActiveOff();
	StationError();
	if( PowerUpOwner != None )
	    HandleAI(PowerUpOwner, false);
}

//-----------------------------------------------------------------------------

function bool StationCanBeUsed( Pawn P )//xPawn doesn't work here
{
/*  local int ShieldAmount, MaxShieldAmount;

  ShieldAmount = PowerUpOwner.ShieldStrength;
  MaxShieldAmount = P.default.ShieldStrengthMax;*/

  local xPawn ShieldOwner;
  ShieldOwner = xPawn(PowerUpOwner);

  if ( ShieldOwner != None ){
	 return (  (HealthUnits > 0 && !bSuperHealing && P.Health < P.HealthMax)
	        || (HealthUnits > 0 && bSuperHealing && P.Health < P.SuperHealthMax)
			|| (EnergyUnits > 0 && MaxShield > 0 && ShieldOwner.GetShieldStrengthMax() > Min(ShieldOwner.GetShieldStrength(), MaxShield))
            || (EnergyUnits > 0 && MaxShield <= 0 && ShieldOwner.GetShieldStrengthMax() > ShieldOwner.GetShieldStrength()));

	}
}

//-----------------------------------------------------------------------------
// Set up station for use

function ActivateStation( Pawn P )
{
	//TargetPowerSuit = XMPPowerSuit(class'XMPUtil'.static.GetInventoryItem( P, class'XMPPowerSuit' ));
	PowerUpOwner = P;

	/*if( !bLimited )
	{
		HealthUnits = StartingHealthUnits;
		EnergyUnits = StartingEnergyUnits;
	}*/

	if( StationCanBeUsed(P) )
	{
		SetStationInUse();
	}
	else // Container is full
	{
		StationError();
	}
}

//-----------------------------------------------------------------------------
// Resets a stations sounds and textures

function DeactivateStation()
{
	if( PowerUpOwner != None )
	{
		if( StationCanBeUsed(PowerUpOwner) )
		{
			SetStationActiveOff();
			PlaySound( StationStopUsingSound, SLOT_Interact );
		}
		HandleAI(PowerUpOwner, false);
	}
}

//-----------------------------------------------------------------------------

function int CalcRecharge( int CalcUnits )
{
	local int ToTransfer;

	if( RechargeRate == 0 )
	{
		//recharge all
		ToTransfer = CalcUnits;
	}
	else
	{
		if( LastRechargeTime != 0 )
		{
			ToTransfer = RechargeRate * (Level.TimeSeconds - LastRechargeTime);
			if( ToTransfer > CalcUnits )
			{
				ToTransfer = CalcUnits;
			}
		}
		else
			ToTransfer = 0;
	}

	return ToTransfer;
}

//-----------------------------------------------------------------------------

event Touch( Actor Other )
{
	if( PowerUpOwner != None )	// can't be used while in use (so don't turn off, etc.)
		return;
	if( xPawn(Other) != None ) //!!Does xPawn work here?
		ActivateStation( xPawn(Other) );

}

//-----------------------------------------------------------------------------

event UnTouch( Actor Other )
{
	if( PowerUpOwner != None && PowerUpOwner != Other )	// can't be used while in use (so don't turn off, etc.)
		return;
	if( xPawn(Other) != None )
		DeActivateStation();
}


//-----------------------------------------------------------------------------
// Determines the amount of units to be transfered during this cycle

function float CalcPowerUp( int CalcUnits )
{
	local float ToTransfer;

	if( TransferRate == 0 )
	{
		//transfer all
		ToTransfer = CalcUnits;
	}
	else
	{
//DM( "@@@ " $ TransferRate $ " * " $ Level.TimeSeconds $ " - " $ LastTransferTime );
		if( LastTransferTime != 0 )
		{
			ToTransfer = TransferRate * (Level.TimeSeconds - LastTransferTime);
//DM( "@@@ ToTransfer = " $ ToTransfer );
			if( ToTransfer > CalcUnits )
			{
				ToTransfer = CalcUnits;
			}
		}
		else
			ToTransfer = 0;
	}
	return ToTransfer;
}

//-----------------------------------------------------------------------------

simulated function TickPowerUp( out int UnitsAvailable, int MaxUnits, out int TargetsCurrentUnits, optional bool bShield )
{
	local int OldUnits;
	local float ToTransferPct;
	local int ToTransferUnits;

    if (bShield && MaxShield != 0)
        MaxUnits = Min(MaxUnits, MaxShield);
	OldUnits = TargetsCurrentUnits;
//	Super.TickPowerUp( UnitsAvailable, MaxUnits, TargetsCurrentUnits );

	CheckUserFulfulled( MaxUnits, TargetsCurrentUnits );

	// Calculate
	ToTransferPct = CalcPowerUp( UnitsAvailable );

	// Convert the percentage of the max, into raw units
	ToTransferUnits = int(ToTransferPct * MaxUnits / 100.0);
	ToTransferUnits = Clamp( ToTransferPct, 0, MaxUnits - TargetsCurrentUnits );

	// PowerUp units are ints, so wait until at least one unit can be resupplied
	if( ToTransferUnits > 0 )
	{
        // Transfer the power
		if (!bShield)
            TargetsCurrentUnits += ToTransferUnits;
        else
            PowerUpOwner.AddShieldStrength(ToTransferUnits);
		// Remove power from powerup
		UnitsAvailable -= ToTransferPct;
		LastTransferTime = Level.TimeSeconds;
	}

	CheckPowerUpEmpty( UnitsAvailable );
}

//-----------------------------------------------------------------------------
// Manages the dispersal of powerup units

simulated function Tick(float DeltaTime)
{
	local int /*Current, Previous, Max,*/ ShieldAmount;
	local float NewRechargeTime;

	Super.Tick( DeltaTime );

        if( !bLimited )
        {
            //if (!bDebug1) { log(self$": !bLimited"); bDebug1 = True;}
            if( StartingEnergyUnits > 0 )
            {
                //if (!bDebug2) { log(self$": Starting energy units"@StartingEnergyUnits); bDebug2 = True;}
                if( EnergyUnits < StartingEnergyUnits && PowerUpOwner == None )
                {
                    //if (!bDebug3) { log(self$": Current energy units"@EnergyUnits); bDebug3 = True;}
                    NewRechargeTime = Level.TimeSeconds;
                    if( NewRechargeTime - LastRechargeTime >= DelayTime )
                    {
    //DM( "### " $ Self $ " " $ StartingEnergyUnits $ " - " $ EnergyUnits $ " = " $ StartingEnergyUnits - EnergyUnits );
                        EnergyUnits += CalcRecharge( StartingEnergyUnits - EnergyUnits );
    //DM( "### " $ Self $ ".EnergyUnits = " $ EnergyUnits );
                        LastRechargeTime = NewRechargeTime;
                        //if (!bDebug4) { log(self$": W00t!"); bDebug4 = True;}
                        UpdateMeterOpacity();
                    }
                }
            }
            else if( StartingHealthUnits > 0 )
            {
                if( HealthUnits < StartingHealthUnits && PowerUpOwner == None )
                {
                    NewRechargeTime = Level.TimeSeconds;
                    if( NewRechargeTime - LastRechargeTime >= DelayTime )
                    {
    //DM( "### " $ Self $ " " $ StartingHealthUnits $ " - " $ HealthUnits $ " = " $ StartingHealthUnits - HealthUnits );
                        HealthUnits += CalcRecharge( StartingHealthUnits - HealthUnits );
    //DM( "### " $ Self $ ".HealthUnits = " $ HealthUnits );
                        LastRechargeTime = NewRechargeTime;
                        UpdateMeterOpacity();
                    }
                }
            }
        }


    if ( PowerUpOwner != none )
	{

    	ShieldAmount = PowerUpOwner.GetShieldStrength();

    //	if ( class'xPawn'.static.ValidPawn(PowerUpOwner) )//xPawn won't work - is this necessary?

    		/*if( EnergyUnits > 0 )
    		{
    			if( TargetPowerSuit != None )
    			{
    				Max = int(TargetPowerSuit.MaxPower);
    				Current = int(TargetPowerSuit.GetPower());
    				TickPowerUp( EnergyUnits, Max, Current );
    				TargetPowerSuit.SetPower( Current );
    			}
    		}*/
    	if( HealthUnits > 0 )
    	{
    		if (bSuperHealing)
    		    TickPowerUp( HealthUnits, PowerUpOwner.SuperHealthMax, PowerUpOwner.Health );
    		else
            	TickPowerUp( HealthUnits, PowerUpOwner.HealthMax, PowerUpOwner.Health );
     	     UpdateMeterOpacity();
        }
    	if( EnergyUnits > 0 )
    	{
    			TickPowerUp( EnergyUnits, PowerUpOwner.GetShieldStrengthMax(), ShieldAmount, true );
    			UpdateMeterOpacity();
        }
        //HandleAI(PowerUpOwner, false);
	}

	UpdateCharger(); //GE: Update decoy information.

/*		if( AmmoUnits > 0 )
		{
			if( PowerUpOwner != None && PowerUpOwner.PlayerReplicationInfo != None )
			{
				Max = 100;
				Current = XMPPRI(PowerUpOwner.PlayerReplicationInfo).AmmoEquipedPct * 100;
				Previous = Current;
				TickPowerUp( AmmoUnits, Max, Current );
				// scale powerup speed by # of ammo types that need ammo
				Rate = class'XMPUtil'.static.ScaleAmmoResupplyRate( PowerupOwner, float(Current - Previous) / 100.0 );
				class'XMPUtil'.static.AddAllAmmoPercent( PowerUpOwner, Rate );
			}
		}*/

}

//-----------------------------------------------------------------------------

//GE: Stub for updating the opacity of the charge bars to indicate how full the station is
simulated function UpdateMeterOpacity();

//-----------------------------------------------------------------------------

function CheckPowerUpEmpty( int UnitsAvailable )
{
	if( UnitsAvailable <= 0 )
		HandlePowerUpEmpty();
}

//-----------------------------------------------------------------------------

function CheckUserFulfulled( int MaxUnits, int TargetsCurrentUnits )
{
	if( TargetsCurrentUnits >= MaxUnits )
		HandleUserFulfilled();
}
//-----------------------------------------------------------------------------

function HandleUserFulfilled()
{
	StopStation();
}

//-----------------------------------------------------------------------------

//GE: Gets called when the station runs out of juice.
function HandlePowerUpEmpty()
{


    MakeStationEmpty();
}

//-----------------------------------------------------------------------------

function RegisterCharger(xPickupBase NewCharger)
{
    //GE: Set the global Charger and update the decoys with desireability information
    Charger = NewCharger;
    if (U2DecoyHealth(Charger.myPickup) != None)
    {
        U2DecoyHealth(Charger.myPickup).HealingAmount = HealthUnits;
        U2DecoyHealth(Charger.myPickup).Station = self;
    }
    else if (U2DecoyShield(Charger.myPickup) != None)
    {
        U2DecoyShield(Charger.myPickup).ShieldAmount = EnergyUnits;
        U2DecoyShield(Charger.myPickup).Station = self;
    }
}

function UpdateCharger()
{
    //GE: Update the decoys with new information.
    if (U2DecoyHealth(Charger.myPickup) != None)
    {
        U2DecoyHealth(Charger.myPickup).HealingAmount = HealthUnits;
        if (U2DecoyHealth(Charger.myPickup).Station == None)
            U2DecoyHealth(Charger.myPickup).Station = self;
    }
    else if (U2DecoyShield(Charger.myPickup) != None)
    {
        U2DecoyShield(Charger.myPickup).ShieldAmount = EnergyUnits;
        if (U2DecoyShield(Charger.myPickup).Station == None)
            U2DecoyShield(Charger.myPickup).Station = self;
    }
}

//-----------------------------------------------------------------------------

function HandleAI(Pawn P, bool bHold)
{
    local Bot B;

    if ( P == None || P.Controller == None || Bot(P.Controller) == None)
        return;

    B = Bot(P.Controller);

    //GE: Tell the bot to stand still if there is no enemy; shield itself if there is an enemy.
    if (bHold && (B.Enemy == None || (B.Enemy != None && !B.EnemyVisible() )) /*&& Debug < 5*/ )
    {
        SetTimer(0.5, true);
        /*if ( B.Enemy != None )
        {
            if ( B.EnemyVisible() )
                B.GotoState('ShieldSelf','Begin');
            else
                B.DoStakeOut();
        }
        else */
        //OldState = B.GetStateName();
            B.GotoState('RestFormation','Pausing');
            //Debug++;
    }
    else
    {
        SetTimer(0.0, false);
        //GE: Tell bots to stop standing around - there's nothing else to be gained here.
    if (U2DecoyHealth(Charger.myPickup) != None)
        U2DecoyHealth(Charger.myPickup).Take(PowerUpOwner);
    else if (U2DecoyShield(Charger.myPickup) != None)
        U2DecoyShield(Charger.myPickup).Take(PowerUpOwner);
        //Debug = 0;
        //B.GoToState(OldState);
        //B.WhatToDoNext(11);
    }

}

//-----------------------------------------------------------------------------

//GE: The sole purpose of Timer here is to make it less costly for AI than Tick, and more reliable.
function Timer()
{
    Super.Timer();
    if (PowerUpOwner != None)
        HandleAI(PowerUpOwner, true);
}

defaultproperties
{
     RechargeRate=99999.000000
     DelayTime=1.000000
     //TouchingHeight=36.000000
     //TouchingRadius=32.000000
     //StationEffectOffset=(X=-20.000000)
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'U2StationsM.Stations.Station_TD_001'
     bStatic=false
     RemoteRole=ROLE_SimulatedProxy
     NetUpdateFrequency=5.000000
     NetPriority=0.5 //GE: Make sure we are not eating people's bandwidth.
     PrePivot=(X=-20.000000)
     //GE: Collision ---------
     CollisionRadius=32.000000
     CollisionHeight=36.000000
     bCollideWorld=False
     bCollideActors=True
     bBlockActors=False
     bBlockKarma=False
     bBlockNonZeroExtentTraces=True
     bBlockPlayers=False
     bBlockZeroExtentTraces=False
     //GE: -------------------
     bFixedRotationDir=True
     SoundVolume=255
     LightBrightness=255 //GE: believe it or not, this is in fact a *sound* option!
     TransientSoundVolume=1.5
     Skins(2)=Material'U2StationsT.Stations.StationFinal'
     BaseTexture=Texture'U2StationsT.Stations.Station_FX'//GE: The ugly grey texture.
     Physics=PHYS_None
}
