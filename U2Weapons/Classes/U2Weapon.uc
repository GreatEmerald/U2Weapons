/*
 * Copyright (c) 2009, 2013 Dainius "GreatEmerald" Masiliūnas
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
// U2Weapon.uc
// To make sure there are NO REFERENCES to XMPPlayer.
// 2009, GreatEmerald
//-----------------------------------------------------------
class U2Weapon extends Weapon
	abstract
    config(User);

#EXEC OBJ LOAD FILE=..\Animations\WeaponsK.ukx

var bool bAllowCustomCrosshairs;
var		float	TraceDist;		// how far instant hit trace fires go

var() array<name> TargetableTypes;	// Types of classes we can target (for crosshair glows).
//var string Crosshair;				// UI event to send when switching to the weapon to show the crosshair.
var bool bGlowing;					// Whether the crosshair is currently glowing.
var string LastTargetName;			// Last viewed target name (for TargetID).

//-----------------------------------------------------------------------------
// GE: AI variables ported from Unreal II:

//-----------------------------------------------------------------------------
// U2 Weapon AI properties
//-----------------------------------------------------------------------------

const MaxRapidFireRate      =   0.50;       // firing rates <= this are considered rapid fire
const MinSlowFireRate       =   0.51;       // firing rates >= this are considered slow fire

// special weapon rating values
const RatingFireNow         = 100.000;      // weapon wants Pawn to fire it immediately (i.e. even if no target)
const RatingHighest         =  90.000;      // weapon thinks it would be highly effective if used now
const RatingDefault         =   0.000;      // default
const RatingLow             =  -5.000;      // weapon is a poor choice but could be used if nothing better
const RatingIneffective     = -10.000;      // weapon will have no effect on target in current situation
const RatingDangerous       = -20.000;      // using weapon now will likely hurt/kill owner
const RatingNoAmmo          = -30.000;      // not enough ammo to fire/altfire
const RatingCantFire        = -40.000;      // can't actually fire weapon currently (not ready etc.)
const RatingDisabled        = -50.000;      // weapon is disabled (alt and primary fire)
const RatingNone            = -99.999;      // no rating (e.g. no weapon)

const RangeUnlimited        = 32767.0;      // no limit to effective range of weapon (limit to reasonable size for levels)

// AI !!mdf-tbd: generalize
var() bool bAimFire;                        // whether primary fire requires owner aiming (usually true)
var() bool bAimAltFire;                     // whether alt fire requires owner aiming (usually true)
var() bool bFireEnabledForOwner;            // supports disabling fire for specific weapons for specific NPCs
var() bool bAltFireEnabledForOwner;         // supports disabling altfire for specific weapons for specific NPCs

//NOTE: AIRating still used to specify the "global" rating for a weapon vs other weapons and should be set
//to Max( AIRatingFire, AIRatingAltFire );
//!!mdf-tbd: turn all of these into config vars for tweaking purposes
var() const float RangeMinFire;                   // min range to target for firing weapon (-1 = range not considered)
var() const float RangeIdealFire;                 // ideal range to target for firing weapon (-1 = range not considered)
var() const float RangeMaxFire;                   // max range to target for firing weapon (-1 = range not considered)
var() const float RangeLimitFire;                 // absolute limit of range to target for firing weapon (default is use RangeMaxFire as limit)
var() const float RatingInsideMinFire;            // rating for firing weapon inside min range
var() const float RatingRangeMinFire;             // rating for firing weapon at min range
var() const float RatingRangeIdealFire;           // rating for firing weapon at ideal range
var() const float RatingRangeMaxFire;             // rating for firing weapon at max range
var() const float RatingRangeLimitFire;           // rating for firing weapon at limit of range
var() float AIRatingFire;                   // default rating for firing weapon (used when range not considered or no target)

var() const float RangeMinAltFire;                // min range to target for alt-firing weapon (-1 = range not considered)
var() const float RangeIdealAltFire;              // ideal range to target for alt-firing weapon (-1 = range not considered)
var() const float RangeMaxAltFire;                // max range to target for alt-firing weapon (-1 = range not considered)
var() const float RangeLimitAltFire;              // absolute limit of range to target for alt-firing weapon (default is use RangeMaxAltFire as limit)
var() const float RatingInsideMinAltFire;         // rating for alt-firing weapon inside min range
var() const float RatingRangeMinAltFire;          // rating for alt-firing weapon at min range
var() const float RatingRangeIdealAltFire;        // rating for alt-firing weapon at ideal range
var() const float RatingRangeMaxAltFire;          // rating for alt-firing weapon at max range
var() const float RatingRangeLimitAltFire;        // rating for alt-firing weapon at limit of range
var() float AIRatingAltFire;                // default rating for alt-firing weapon (used when range not considered or no target

var InterpCurve RatingCurveFire, RatingCurveAltFire; //GE: Rating curves compiled from the data above.

//GE: Ported from XMPPlayer.uc
var Actor LastViewTargetActor;
var float LastViewTargetTime;

var float LastViewTargetTraceDistance;
var float LastViewTargetActualDistance;
var vector LastViewTargetLocation;
var rotator LastViewTargetRotation;
var vector LastViewTargetHitLocation;
var vector LastViewTargetHitNormal;

//-----------------------------------------------------------------------------
// Debug flags:
var globalconfig bool bUpdateCrosshair;
var              bool bUpdateLocation;
var globalconfig bool bDrawWeapon;
var globalconfig bool bClearZ;

struct Point
{
	var() public float X;
	var() public float Y;
};

var		int		AutoSwitchPriority;

//-----------------------------------------------------------------------------
// Sound Assignments
var() sound	ReloadSound,
			ReloadUnloadedSound;

//-----------------------------------------------------------------------------
var() Name ReloadAnim;
var() float ReloadAnimRate;

//-----------------------------------------------------------------------------
var() int ClipSize;
var int ClipRoundsRemaining;//, ClientRoundsRemaining;

var() float ReloadTime, ReloadUnloadedTime;
var float ReloadTimer; //Time when reload was executed

var bool bIsReloading, bPendingReload; //GE: bIsReloading == iIntVariable. Captain obvious.
var bool bServerReloading; //GE: true when the server is in the Reloading state.

var float DownUnloadedTime;
var float SelectUnloadedTime;

var name LastAnim;

var float EquipResidue;					// resuppling leftover between updates

var bool bLastRound;
var int IdleTicks;  //GE: 1 IdleTick ~= 3 seconds of DeltaTime


replication
{
	// Things the server should send to the client.
    reliable if(bNetOwner && Role == ROLE_Authority)
		ClipRoundsRemaining, bServerReloading;

    //Functions called on the client from the server.
    reliable if(Role == ROLE_Authority)
       ClientReload;

    reliable if(Role < ROLE_Authority)
        Reload;
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	ClipRoundsRemaining = ClipSize;
	//ClientRoundsRemaining = ClipSize;

	BuildInterpolationCurves();
}

/*simulated function PostNetReceive()
{
	Super.PostNetReceive();
	if ( ClientRoundsRemaining < ClipRoundsRemaining )
		ClientRoundsRemaining = ClipRoundsRemaining;
}*/

/*simulated function PostNetReceive()
{
	Super.PostNetReceive();
	switch (ServerFireMode)
	{
	   case 0: ClientStartFire(0); break;
	   case 1: ClientStartFire(1); break;
	}
}*/

simulated function Weapon NextWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
    if ( HasAmmo() )
    {
        if ( (CurrentChoice == None) )
        {
            if ( CurrentWeapon != self )
                CurrentChoice = self;
        }
		else if (InventoryGroup == CurrentWeapon.InventoryGroup && InventoryGroup == CurrentChoice.InventoryGroup) {
			if (
				( GroupOffset < CurrentChoice.GroupOffset && CurrentChoice.GroupOffset < CurrentWeapon.GroupOffset ) ||
				( CurrentWeapon.GroupOffset < GroupOffset && GroupOffset < CurrentChoice.GroupOffset ) ||
				( CurrentChoice.GroupOffset < CurrentWeapon.GroupOffset && CurrentWeapon.GroupOffset < GroupOffset)
			)
				CurrentChoice = self;
		}
		else if (
			( CurrentWeapon.InventoryGroup == InventoryGroup && CurrentWeapon.GroupOffset < GroupOffset) ||
			( CurrentWeapon.InventoryGroup == CurrentChoice.InventoryGroup && CurrentChoice.GroupOffset < CurrentWeapon.GroupOffset) ||
			( CurrentChoice.InventoryGroup == InventoryGroup && GroupOffset < CurrentChoice.GroupOffset ) ||
			( InventoryGroup < CurrentChoice.InventoryGroup && CurrentChoice.InventoryGroup < CurrentWeapon.InventoryGroup ) ||
			( CurrentWeapon.InventoryGroup < InventoryGroup && InventoryGroup < CurrentChoice.InventoryGroup ) ||
			( CurrentChoice.InventoryGroup < CurrentWeapon.InventoryGroup && CurrentWeapon.InventoryGroup < InventoryGroup)
		)
			CurrentChoice = self;
	}
	if ( Inventory == None )
		return CurrentChoice;
	else
		return Inventory.NextWeapon(CurrentChoice,CurrentWeapon);
}

simulated function Weapon PrevWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
    if ( HasAmmo() )
    {
        if ( (CurrentChoice == None) )
        {
            if ( CurrentWeapon != self )
                CurrentChoice = self;
        }
		else if (InventoryGroup == CurrentWeapon.InventoryGroup && InventoryGroup == CurrentChoice.InventoryGroup) {
			if (
				( GroupOffset > CurrentChoice.GroupOffset && CurrentChoice.GroupOffset > CurrentWeapon.GroupOffset ) ||
				( CurrentWeapon.GroupOffset > GroupOffset && GroupOffset > CurrentChoice.GroupOffset ) ||
				( CurrentChoice.GroupOffset > CurrentWeapon.GroupOffset && CurrentWeapon.GroupOffset > GroupOffset)
			)
				CurrentChoice = self;
		}
		else if (
			( CurrentWeapon.InventoryGroup == InventoryGroup && CurrentWeapon.GroupOffset > GroupOffset) ||
			( CurrentWeapon.InventoryGroup == CurrentChoice.InventoryGroup && CurrentChoice.GroupOffset > CurrentWeapon.GroupOffset) ||
			( CurrentChoice.InventoryGroup == InventoryGroup && GroupOffset > CurrentChoice.GroupOffset ) ||
			( InventoryGroup > CurrentChoice.InventoryGroup && CurrentChoice.InventoryGroup > CurrentWeapon.InventoryGroup ) ||
			( CurrentWeapon.InventoryGroup > InventoryGroup && InventoryGroup > CurrentChoice.InventoryGroup ) ||
			( CurrentChoice.InventoryGroup > CurrentWeapon.InventoryGroup && CurrentWeapon.InventoryGroup > InventoryGroup)
		)
			CurrentChoice = self;
	}
	if ( Inventory == None )
		return CurrentChoice;
	else
		return Inventory.PrevWeapon(CurrentChoice,CurrentWeapon);
}



simulated function int AmmoUsed(int mode)
{
	return FireMode[mode].AmmoPerFire;
}

simulated function int AmmoMax(int mode)
{
	if ( bNoAmmoInstances )
			return MaxAmmo(mode);
	if ( Ammo[mode] != None )
		return Ammo[mode].MaxAmmo;

	return 0;
}

simulated function int AmmoInitial(int mode)
{
	if ( bNoAmmoInstances )
		return AmmoClass[mode].default.InitialAmount;
	if ( Ammo[mode] != None )
		 return Ammo[mode].InitialAmount;
}

simulated function GetAmmoCount(out float MaxAmmoPrimary, out float CurAmmoPrimary)
{
	if ( AmmoClass[0] == None )
		return;

	if ( bNoAmmoInstances )
	{
		MaxAmmoPrimary = MaxAmmo(0);
		CurAmmoPrimary = FMax(0,AmmoCharge[0]);
		return;
	}

	if ( Ammo[0] == None )
		return;
	MaxAmmoPrimary = Ammo[0].MaxAmmo;
	CurAmmoPrimary = FMax(0,Ammo[0].AmmoAmount);
}

simulated function float ResupplyStatus()
{
	local float Amount, Max, Result;

	if ( bNoAmmoInstances )
	{
		Amount = AmmoCharge[0] - ClipRoundsRemaining;
		Max = AmmoInitial(0) - ClipSize;
	}
    else
    {
    	Amount = Ammo[0].AmmoAmount - ClipRoundsRemaining;
    	Max = AmmoInitial(0) - ClipSize;
	}

	if( Max == 0 )
		Result = ClipRoundsRemaining;
	else if( FireMode[0].AmmoPerFire == 0 )
		Result = 1.0;
	else if (Max > 0)
		Result = Amount / Max;
	else
		Result = Amount;
	if( Result > 1.0 )
		Result = 1.0;
	return Result;
}

function Resupply( float AddedPercent )
{
	Ammo_Resupply( AddedPercent );
}

function Ammo_Resupply( float AddedPercent )
{
	local int ResupplyMax;
	local float AddedAmmoAmount;
	local int Max;

	// jy -- sanity check
	if ( ResupplyStatus() >= 1 ) return;

	Max = AmmoInitial(0) - ClipSize;

	// Special handling for items that can hold only one ammo (which gets put in their clip) and therefore have a MaxAmmo of zero.
//	if( AmmoMax(0) == 0 && AmmoAmount(0) == 0 )
	if ( Max == 0 && AmmoAmount(0) == 0 )
	{
		EquipResidue += AddedPercent;
		if( EquipResidue >= 1.0 )
		{
			Ammo_SetAmmoAmount(1);
			Ammo_SetClipRoundsRemaining(1);
			//bPendingReload = false;
			EquipResidue = 0.0;
		}
		return;
	}

	// fill up all the ammo except what's in the clip
	ResupplyMax = Max - AmmoAmount(0) + ClipRoundsRemaining;

	if( ResupplyMax > 0 )
	{
		AddedAmmoAmount = AddedPercent * Max + EquipResidue;
		AddedAmmoAmount = FClamp( AddedAmmoAmount, 0,  ResupplyMax );
		Ammo_SetAmmoAmount( AmmoAmount(0) + int(AddedAmmoAmount) );
		EquipResidue = AddedAmmoAmount - int(AddedAmmoAmount);
	}
}

// Notify the player that an ammunition property has changed
function Ammo_NotifyAmmoChanged();


simulated function Ammo_SetAmmoAmount(int NewAmmoAmount)
{
	if ( bNoAmmoInstances )
	{
		if ( AmmoClass[0] != None )
			AmmoCharge[0] = NewAmmoAmount;
		if ( (AmmoClass[1] != None) && (AmmoClass[0] != AmmoClass[1]) )
			AmmoCharge[1] = NewAmmoAmount;
		Ammo_NotifyAmmoChanged();
		return;
	}
	if ( Ammo[0] != None )
		Ammo[0].AmmoAmount = NewAmmoAmount;
	if ( Ammo[1] != None )
		Ammo[1].AmmoAmount = NewAmmoAmount;
	Ammo_NotifyAmmoChanged();
}

simulated function Ammo_SetClipRoundsRemaining( int NewClipRoundsRemaining )
{
	ClipRoundsRemaining = NewClipRoundsRemaining;
	//ClientRoundsRemaining = NewClipRoundsRemaining;
	//log(self$": Ammo_SetClipRoundsRemaining("$NewClipRoundsRemaining$")");
	Ammo_NotifyAmmoChanged();
}

function Ammo_SetMaxAmmo(int NewMaxAmmo)
{
//	MaxAmmo[AmmoIndex] = NewMaxAmmo;
	Ammo_NotifyAmmoChanged();
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	Super.GiveTo(Other, PickUp);
	Ammo_NotifyAmmoChanged();
}


simulated function PlayAnimEx(name Sequence, optional float Rate)
{
	local float TweenTime;

	if (Sequence!='')
	{
		if (Rate == 0.0)
		    Rate = 1.0;

        //class'GEUtilities'.static.LogSelf(self, "Playing"@Sequence);
        if (Sequence != FireMode[0].default.FireAnim &&
			Sequence != FireMode[1].default.FireAnim)
			TweenTime = 0.1;
		PlayAnim(Sequence, Rate, TweenTime);
		LastAnim=Sequence;
	}
}

simulated function bool ReloadRequired()
{
	if ( HasAmmo() == false ) return true;

	return Ammo_ReloadRequired(FireMode[0].AmmoPerFire) &&
		Ammo_ReloadRequired(FireMode[1].AmmoPerFire);
}

simulated function bool Ammo_ReloadRequired( optional int AmountNeeded )
{
	if( AmountNeeded == 0 )
		AmountNeeded = FireMode[0].AmmoPerFire;
	return AmountNeeded > ClipRoundsRemaining;
}

function bool BotFire(bool bFinished, optional name FiringMode)
{
	if ( ReloadRequired() && HasAmmo() )
		Reload();
	return Super.BotFire(bFinished, FiringMode);
}

simulated function bool CanReload()
{
	if( bIsReloading || !ReadyToReload() )
		return false;

	return Ammo_CanReload();
}

simulated function BringUp(optional Weapon PrevWeapon)
{
	local int Mode;

	// hack to fix stupid sniper rifle unzoom bug
	if( Instigator != None && PlayerController(Instigator.Controller) != None )
	{
		PlayerController(Instigator.Controller).DesiredFOV = PlayerController(Instigator.Controller).DefaultFOV;
		PlayerController(Instigator.Controller).FOVAngle = PlayerController(Instigator.Controller).DefaultFOV;
	}
    if( Instigator != None && Instigator.Controller != None && Instigator.Controller.IsA( 'PlayerController' ) )
        PlayerController(Instigator.Controller).EndZoom();

    if ( ClientState == WS_Hidden )
    {
		Instigator.PlaySound(SelectSound,SLOT_Misc,1.0,,TransientSoundRadius*0.3);
//        PlayOwnedSound(SelectSound, SLOT_Interact,,,,, false);
		ClientPlayForceFeedback(SelectForce);  // jdf

        if ( Instigator != None && Instigator.IsLocallyControlled() )
        {
            if ( (Mesh!=None)  )
            {
            	if ( ReloadRequired() )
            	{
					PlayAnim('SelectUnloaded',SelectAnimRate,0.0);
					BringUpTime = default.SelectUnloadedTime;
				}
				else
				{
					PlayAnim('Select',SelectAnimRate,0.0);
					BringUpTime = default.BringUpTime;
				}
			}
        }

        ClientState = WS_BringUp;
        SetTimer(BringUpTime, false);
    }
    for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
	{
		FireMode[Mode].bIsFiring = false;
		FireMode[Mode].HoldTime = 0.0;
		FireMode[Mode].bServerDelayStartFire = false;
		FireMode[Mode].bServerDelayStopFire = false;
		FireMode[Mode].bInstantStop = false;
	}
	if ( (PrevWeapon != None) && PrevWeapon.HasAmmo() && !PrevWeapon.bNoVoluntarySwitch )
		OldWeapon = PrevWeapon;
	else
		OldWeapon = None;

	bIsReloading = false;
}

simulated function bool PutDown()
{
    local int Mode;

    if (ClientState == WS_BringUp || ClientState == WS_ReadyToFire)
    {
        if ( (Instigator.PendingWeapon != None) && !Instigator.PendingWeapon.bForceSwitch )
        {
            for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
            {
                if ( FireMode[Mode].bFireOnRelease && FireMode[Mode].bIsFiring )
                    return false;
                if ( FireMode[Mode].NextFireTime > Level.TimeSeconds + FireMode[Mode].FireRate*(1.f - MinReloadPct))
					DownDelay = FMax(DownDelay, FireMode[Mode].NextFireTime - Level.TimeSeconds - FireMode[Mode].FireRate*(1.f - MinReloadPct));
            }
        }

        if (Instigator.IsLocallyControlled())
        {
            for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
            {
                if ( FireMode[Mode].bIsFiring )
                    ClientStopFire(Mode);
            }

            if ( DownDelay <= 0 )
            {
				if ( ClientState == WS_BringUp )
					TweenAnim(SelectAnim,PutDownTime);
				else if ( HasAnim(PutDownAnim) && HasAmmo() )
					PlayAnim(PutDownAnim, PutDownAnimRate, 0.0);
			}
        }
        ClientState = WS_PutDown;
		DownDelay = 0;
		SetTimer(PutDownTime, false);
    }
    for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
    {
		FireMode[Mode].bServerDelayStartFire = false;
		FireMode[Mode].bServerDelayStopFire = false;
	}
    Instigator.AmbientSound = None;
    OldWeapon = None;
    return true; // return false if preventing weapon switch
}


simulated function Timer()
{
	local int Mode;
	local float OldDownDelay;

	if ( Instigator == none )
		return;

	OldDownDelay = DownDelay;
	DownDelay = 0;



    if (ClientState == WS_BringUp)
    {
		for( Mode = 0; Mode < NUM_FIRE_MODES; Mode++ )
	       FireMode[Mode].InitEffects();

		if ( ReloadRequired() && CanReload() )
			Reload();
		else
			PlayIdle();
        ClientState = WS_ReadyToFire;
    }
    else if (ClientState == WS_PutDown)
    {
        if ( OldDownDelay > 0 )
        {
            if ( HasAnim(PutDownAnim) && HasAmmo() )
                PlayAnim(PutDownAnim, PutDownAnimRate, 0.0);
			SetTimer(PutDownTime, false);
			return;
		}
		if ( Instigator.PendingWeapon == None )
		{
			if ( ReloadRequired() &&  CanReload()  )
				Reload();
			else
				PlayIdle();
			ClientState = WS_ReadyToFire;
		}
		else
		{
			ClientState = WS_Hidden;
			Instigator.ChangedWeapon();
			if ( Instigator.Weapon == self )
			{
				if ( ReloadRequired() &&  CanReload()  )
					Reload();
				else
					PlayIdle();
				ClientState = WS_ReadyToFire;
			}
			else
			{
				for( Mode = 0; Mode < NUM_FIRE_MODES; Mode++ )
					FireMode[Mode].DestroyEffects();
			}
		}
    }
}


simulated function PlayIdle()
{
	if (ReloadRequired())
    //{
	    //if (CanReload())
	    //   Reload();
		LoopAnim('AmbientUnloaded',IdleAnimRate,0.25);
    //}
	else
	{
    	LoopAnim('Ambient',IdleAnimRate,0.25);
    	IdleTicks++;
        if ((IdleTicks > (FRand()*3 + 2)) && IdleAnim != '' && IdleAnim != 'None')
        {
            PlayAnim(IdleAnim);
            IdleTicks = 0;
        }
	}
}

//Reduce ClipCount every time a bullet is fired.
simulated function bool ConsumeAmmo(int Mode, float load, optional bool bAmountNeededIsMax)
{
	if ( Load > ClipRoundsRemaining )
		return false;
    if( Super.ConsumeAmmo(Mode, Load, bAmountNeededIsMax) )
    {
		ClipRoundsRemaining -= load;
    	Ammo_NotifyAmmoChanged();
        return true;
    }
    return false;
}

//=============================================================================

simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	Super.DisplayDebug(Canvas, YL, YPos);

    Canvas.DrawText("ClipRoundsRemaining "$ClipRoundsRemaining);
	YPos += YL;
	Canvas.SetPos(4,YPos);

    //Canvas.DrawText("ClientRoundsRemaining "$ClientRoundsRemaining);
	//YPos += YL;
	//Canvas.SetPos(4,YPos);

    Canvas.DrawText("ResupplyStatus "$ResupplyStatus());
	YPos += YL;
	Canvas.SetPos(4,YPos);
}

simulated final function Actor PlayerSees( float MaxDistance, float MaxLatency )
{
	local vector TempLoc;
	local rotator TempRot;
	return PlayerSeesEx(MaxDistance,MaxLatency,TempLoc,TempRot);
}
simulated final function Actor PlayerSeesEx( float MaxDistance, float MaxLatency, out vector CameraLocation, out rotator CameraRotation )
{
	local vector HitLocation, HitNormal;
	return PlayerSeesEx2(MaxDistance,MaxLatency,CameraLocation,CameraRotation,HitLocation,HitNormal);
}
//NOTE[aleiby]: If you don't hit anything, then HitLocation,HitNormal are undefined.
simulated final function Actor PlayerSeesEx2( float MaxDistance, float MaxLatency, out vector CameraLocation, out rotator CameraRotation, out vector HitLocation, out vector HitNormal )
{
	local vector End;
	local actor Unused;

    if(Instigator.Controller == None || PlayerController(Instigator.Controller) == None || PlayerController(Instigator.Controller).Pawn == None )
        return none;

	if(	(LastViewTargetTime + MaxLatency < Level.TimeSeconds) ||
		((LastViewTargetActor == None) &&
		(MaxDistance > LastViewTargetTraceDistance)) )
	{
		LastViewTargetTime = Level.TimeSeconds;
		XPlayerCalcView( Unused, LastViewTargetLocation, LastViewTargetRotation );
		End = LastViewTargetLocation + MaxDistance * vector(LastViewTargetRotation);
		LastViewTargetActor = Instigator.Trace( HitLocation, HitNormal, End, LastViewTargetLocation, true );
		LastViewTargetTraceDistance = MaxDistance;
		LastViewTargetActualDistance = VSize(HitLocation - LastViewTargetLocation);
		LastViewTargetHitLocation = HitLocation;
		LastViewTargetHitNormal = HitNormal;
		CameraLocation = LastViewTargetLocation;
		CameraRotation = LastViewTargetRotation;
		return LastViewTargetActor;
	}
	else if ((LastViewTargetActor != None) && (MaxDistance < LastViewTargetActualDistance) )
	{
		CameraLocation = LastViewTargetLocation;
		CameraRotation = LastViewTargetRotation;
		return None;
	}
	else
	{
		CameraLocation = LastViewTargetLocation;
		CameraRotation = LastViewTargetRotation;
		HitLocation = LastViewTargetHitLocation;
		HitNormal = LastViewTargetHitNormal;
        return LastViewTargetActor;
	}
}

simulated final function XPlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
{
	local Pawn PTarget;

	// If desired, call the pawn's own special callview
	if( Instigator != None && Instigator.bSpecialCalcView )
	{
		// try the 'special' calcview. This may return false if its not applicable, and we do the usual.
		if( Instigator.SpecialCalcView(ViewActor, CameraLocation, CameraRotation) )
			return;
	}

	if ( (PlayerController(Instigator.Controller).ViewTarget == None) || PlayerController(Instigator.Controller).ViewTarget.bDeleteMe )
	{
        if ( (Instigator != None) && !Instigator.bDeleteMe )
			PlayerController(Instigator.Controller).SetViewTarget(Instigator);
        else if ( PlayerController(Instigator.Controller).RealViewTarget != None )
            PlayerController(Instigator.Controller).SetViewTarget(PlayerController(Instigator.Controller).RealViewTarget);
		else
			PlayerController(Instigator.Controller).SetViewTarget(PlayerController(Instigator.Controller));
	}

	ViewActor = PlayerController(Instigator.Controller).ViewTarget;
	CameraLocation = PlayerController(Instigator.Controller).ViewTarget.Location;

	if ( PlayerController(Instigator.Controller).ViewTarget.IsA('Pawn') )
	{
		if( PlayerController(Instigator.Controller).bBehindView ) //up and behind
			PlayerController(Instigator.Controller).CalcBehindView(CameraLocation, CameraRotation, PlayerController(Instigator.Controller).CameraDist * Instigator.Default.CollisionRadius);
		else
			PlayerController(Instigator.Controller).CalcFirstPersonView( CameraLocation, CameraRotation );
		return;
	}
	if ( PlayerController(Instigator.Controller).ViewTarget == PlayerController(Instigator.Controller) )
	{
		CameraRotation = PlayerController(Instigator.Controller).Rotation;
		return;
	}

	CameraRotation = PlayerController(Instigator.Controller).ViewTarget.Rotation;
	PTarget = Pawn(PlayerController(Instigator.Controller).ViewTarget);
	if ( PTarget != None )
	{
		if ( PTarget.IsPlayerPawn() )
			CameraRotation = PTarget.GetViewRotation();
		if ( !PlayerController(Instigator.Controller).bBehindView )
			CameraLocation += PTarget.EyePosition();
	}
	if ( PlayerController(Instigator.Controller).bBehindView )
	{
		CameraLocation = CameraLocation + (PlayerController(Instigator.Controller).ViewTarget.Default.CollisionHeight - PlayerController(Instigator.Controller).ViewTarget.CollisionHeight) * vect(0,0,1);
		PlayerController(Instigator.Controller).CalcBehindView(CameraLocation, CameraRotation, PlayerController(Instigator.Controller).CameraDist * PlayerController(Instigator.Controller).ViewTarget.Default.CollisionRadius);
	}
}

//=============================================================================
// Weapon rendering
// Draw first person view of inventory
simulated event RenderOverlays( canvas Canvas )
{
	if ( Instigator == None )
		return;

	if ( bUpdateCrosshair && PlayerController(Instigator.Controller) != None )
		UpdateCrosshair( Canvas );

	Super.RenderOverlays(Canvas);
}

simulated function UpdateCrosshair( Canvas Canvas ) //GE: HitActor is usually the enemy.
{
	local Actor HitActor;
	local vector ViewLoc;
	local rotator ViewRot;
	local Pawn Target;

	HitActor = PlayerSeesEx( TraceDist, 0.25, ViewLoc, ViewRot );
	HandleTargetDetails( HitActor, Canvas, ViewLoc, ViewRot );

	if( !bGlowing && HitActor!=none && IsTargetable(HitActor) )
	{
		Target = Pawn(HitActor);
		if( Target!=none && !Target.bPendingDelete && Target.PlayerReplicationInfo!=none
			&& Target.PlayerReplicationInfo.Team!=none && Target.PlayerReplicationInfo.Team.TeamIndex != Instigator.PlayerReplicationInfo.Team.TeamIndex )
		{
			LastTargetName = Target.PlayerReplicationInfo.PlayerName;
			//SendEvent("TargetIDOn");
		}

		bGlowing=true;
		//SendEvent("Glow");
	}
	else if( bGlowing && (HitActor==none || !IsTargetable(HitActor)) )
	{
		bGlowing=false;
		//SendEvent("UnGlow");
		//SendEvent("TargetIDOff");
	}
}

simulated function HandleTargetDetails( Actor A, Canvas Canvas, vector ViewLoc, rotator ViewRot );

simulated function bool IsTargetable( Actor A )
{
	local int i;

	if( A==Owner )
		return false;
	if( A.bHidden )
		return false;
	if( A.Physics == PHYS_None ) // don't target carcasses & such?
		return false;

	for( i=0; i<TargetableTypes.Length; i++ )
		if( A.IsA( TargetableTypes[i] ) )
			return true;

	return false;
}


static function bool IsValidDefaultInventory( pawn PlayerPawn ) { return true; }



simulated function Weapon RecommendWeapon( out float rating )
{
	local Weapon Recommended;
	local float oldRating;

	if ( Instigator.IsHumanControlled() )
		rating = SwitchPriority();
	else
	{
		rating = RateSelf();
		if ( (self == Instigator.Weapon) && (Instigator.Controller.Enemy != None) && HasAmmo() )
			rating += 0.21; // tend to stick with same weapon
			rating += Instigator.Controller.WeaponPreference(self);
	}
	if ( inventory != None )
	{
		Recommended = inventory.RecommendWeapon(oldRating);
		if ( (Recommended != None) && (oldRating > rating) )
		{
			rating = oldRating;
			return Recommended;
		}
	}
	return self;
}

// Return the switch priority of the weapon (normally AutoSwitchPriority, but may be
// modified by environment (or by other factors for bots)
simulated function float SwitchPriority()
{
	if ( !Instigator.IsHumanControlled() )
		return RateSelf();
	else if ( !HasAmmo() )
	{
		if ( Pawn(Owner).Weapon == self )
			return -0.5;
		else
			return -1;
	}
	else
		return default.AutoSwitchPriority;
}

//mdfxmp 2003.09.01 BEGIN
//-----------------------------------------------------------------------------
// Subclasses can return values > 0.0 to indicate that they should be switched
// to instead of using SwitchToBestWeapon when a SwitchAway occurs (due to out
// of ammo). e.g. when placing deployable items (turrets, fieldgenerators), we
// can force a switch to another deployable item which has ammo rather than
// switching to the best weapon (so player can place all turrets etc.).

simulated function float GetSpecialSwitchPriority( Weapon OldWeapon )
{
	return 0.0;
}

//-----------------------------------------------------------------------------
// Calls GetSpecialSwitchPriority on all weapons in Instigator's inventory, and
// switches to the weapon which returned the highest switch priority, if this
// is > 0.0. Returns true if a swich occurred, false otherwise.

simulated function bool	SpecialSwitchAway()
{
	local Inventory Inv;
	local float SwitchPriority, BestSwitchPriority;
	local U2Weapon W, BestWeapon;

	for( Inv = Instigator.Inventory; Inv != None; Inv = Inv.Inventory )
	{
		W = U2Weapon(Inv);
		if( W != None )
		{
			SwitchPriority = W.GetSpecialSwitchPriority( Self );

			if( SwitchPriority > 0.0 && SwitchPriority > BestSwitchPriority )
			{
				BestWeapon = W;
				BestSwitchPriority = SwitchPriority;
			}
		}
	}

	if( BestWeapon != None )
	{
		Instigator.PendingWeapon = BestWeapon;
		Instigator.ChangedWeapon();
		return true;
	}

	return false;
}

//-----------------------------------------------------------------------------
// Allow weapons in instigator's inventory to override switching to the best
// weapon if applicable.

simulated function SwitchAway()
{
	if( !SpecialSwitchAway() )
		Instigator.Controller.SwitchToBestWeapon();
}
//mdfxmp 2003.09.01 END

simulated function DoAutoSwitch()
{
	if( !SpecialSwitchAway() )
		Instigator.Controller.SwitchToBestWeapon();
}



static final function float Blend( float A, float B, float Pct )
{
	return A + ((B-A) * Pct);
}

static final function float Ablend( float A, float B, float Result )
{
	return (Result-A)/(B-A);
}

static final function float BlendR( Range R, float Pct )
{
	return Blend( R.Min, R.Max, Pct );
}

static final function float AblendR( Range R, float Result )
{
	return ABlend( R.Min, R.Max, Result );
}



exec function offset()
{
	Instigator.ClientMessage("X=" $ PlayerViewOffset.X);
	Instigator.ClientMessage("Y=" $ PlayerViewOffset.Y);
	Instigator.ClientMessage("Z=" $ PlayerViewOffset.Z);
}

exec function soffset()
{
	Instigator.ClientMessage("X=" $ SmallViewOffset.X);
	Instigator.ClientMessage("Y=" $ SmallViewOffset.Y);
	Instigator.ClientMessage("Z=" $ SmallViewOffset.Z);
}

exec function soffsetX(float XPos)
{
	SmallViewOffset.X = XPos;
}

exec function soffsetY(float YPos)
{
	SmallViewOffset.Y = YPos;
}

exec function soffsetZ(float ZPos)
{
	SmallViewOffset.Z = ZPos;
}

simulated function bool Ammo_CanReload()
{
	return ( (AmmoAmount(0) > ClipRoundsRemaining) && (ClipRoundsRemaining < ClipSize) );
}

simulated function bool ReadyToReload()
{
	local int Mode;

    for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
    {
        if ( FireMode[Mode].bFireOnRelease && FireMode[Mode].bIsFiring )
            return false;
        if ( FireMode[Mode].NextFireTime > Level.TimeSeconds)
			return false;
    }
    return true;
}

/*simulated*/ exec function Reload()
{
	//local int i;

    bPendingReload = false;
	if ( HasAmmo() && CanReload() )
	{
		/*if (!Ammo_ReloadRequired(1)) //if we are not completely out of ammo, then drop our current clip
		{
		}*/
		//for (i=0; i<NUM_FIRE_MODES; i++) //GE: Clearly someone over at Epic likes the C preprocessor too much
         //   ClientStopFire(i);

		//go to the state for the duration of the reload
		bServerReloading = true;
        GotoState('Reloading');
		ClientReload();
	}
}


simulated exec function ClientReload()
{
	//local int i;

    if (Role >= ROLE_Authority)
	   return;

    //for (i=0; i<NUM_FIRE_MODES; i++) //GE: Clearly someone over at Epic likes the C preprocessor too much
    //    StopFire(i);
    bServerReloading = true;
    GotoState('Reloading'); // only do this if on the client machine

    //Reload();
}

simulated state Reloading
{
ignores Fire,AltFire,Reload;
	simulated function bool PutDown()
	{
		if ( Global.PutDown() )
		{
			GotoState('Hidden');
			return true;
		}
		else
		{
			return false;
		}
	}

	simulated function PlayIdle();
	simulated event ClientStartFire(int Mode);
	event ServerStartFire(byte Mode);
	simulated function bool StartFire(int mode) {return false;}

	simulated event BeginState()
	{
		local int i;

		//ClientState = WS_BringUp;
		for (i=0; i<NUM_FIRE_MODES; i++)
		{
		  //if (FireMode[i].bIsFiring)
            StopFire(i);
        }
		bIsReloading = true;
		//log(self$": I'm inside Reloading!");

	}
	simulated event EndState()
	{
        //ClientState = WS_ReadyToFire;
		ReloadTime = default.ReloadTime;
		bLastRound = false;
		bIsReloading = false;
		if (Role == ROLE_Authority)
		      bServerReloading = false;
		//log(self$": No longer Reloading! IsFiring"@IsFiring()@"and currently it's"@Level.TimeSeconds);
	}

Begin:
	if ( Instigator.IsLocallyControlled() )
	{
		FireMode[0].NextFireTime = Level.TimeSeconds + ReloadTime;
		FireMode[1].NextFireTime = Level.TimeSeconds + ReloadTime;
	}

	PlayReloading();
	Sleep(ReloadTime);
	Ammo_Reload();

	GotoState('Hidden');
}

simulated function PlayReloading()
{
	if ( xPawn(Instigator) != none )
	{
		if (xPawn(Instigator).Species == class'XGame.SPECIES_Alien') //GE: A hackish way of determining it's an alien mesh
            xPawn(Instigator).SetAnimAction('Idle_Character01');
        else
            xPawn(Instigator).SetAnimAction('Weapon_Switch');
	}
    if( !bLastRound )
	{
		PlayAnimEx(ReloadAnim, ReloadAnimRate);
		//Instigator.PlaySound(ReloadSound,SLOT_Misc,1.0,,TransientSoundRadius*0.3);
		PlayOwnedSound(ReloadSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,,false);
	}
	else
	{
		if( LastAnim!=U2WeaponFire(FireMode[0]).default.AnimFireLastReload &&
			LastAnim!=U2WeaponFire(FireMode[1]).default.AnimFireLastReload )
		{
			//if ( Role == ROLE_Authority )
			//	Instigator.ClientMessage( "LastAnim: " $ LastAnim );

			PlayAnimEx('ReloadUnloaded');
			if( default.ReloadUnloadedTime!=0.0 )
				ReloadTime=default.ReloadUnloadedTime;
		}
		//Instigator.PlaySound(ReloadUnloadedSound,SLOT_Misc,1.0,,TransientSoundRadius*0.3);
		PlayOwnedSound(ReloadUnloadedSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,,false);
	}
}

simulated function bool ReadyToFire(int Mode)
{
    if (bServerReloading)
        return false;

    return Super.ReadyToFire(Mode);
}

//DEBUG --
/*simulated function Fire(float F)
{
    log(self$": Fire()");
}
simulated event ClientStartFire(int Mode)
{
    log(self$": ClientStartFire()");
    Super.ClientStartFire(Mode);

}
simulated event ClientStopFire(int Mode)
{
    log(self$": ClientStopFire()");
    Super.ClientStopFire(Mode);
}
function ServerStartFire(byte Mode)
{
    log(self$": ServerStartFire()");
    //if (!ReadyToFire(Mode)) return;

    Super.ServerStartFire(Mode);
}*/

/*simulated event ClientStartFire(int Mode)
{
    if ( Pawn(Owner).Controller.IsInState('GameEnded') || Pawn(Owner).Controller.IsInState('RoundEnded') )
        return;
    if (Role < ROLE_Authority)
    {
        if (ReadyToFire(Mode) && ServerFireMode == -1)
        {
            ServerStartFire(Mode);
        }
        else if (ServerFireMode != -1)
            StartFire(Mode);
    }
    else
    {
        StartFire(Mode);
    }
} */

/*event ServerStartFire(byte Mode)
{
    log(self$": ServerStartFire()");
    if ( (Instigator != None) && (Instigator.Weapon != self) )
    {
        if ( Instigator.Weapon == None )
            Instigator.ServerChangedWeapon(None,self);
        else
            Instigator.Weapon.SynchronizeWeapon(self);
        return;
    }

    if ( (FireMode[Mode].NextFireTime <= Level.TimeSeconds + FireMode[Mode].PreFireTime)
        && StartFire(Mode) )
    {
        FireMode[Mode].ServerStartFireTime = Level.TimeSeconds;
        FireMode[Mode].bServerDelayStartFire = false;
        ServerFireMode = Mode;
        ClientStartFire(Mode);
    }
    else if ( FireMode[Mode].AllowFire() )
    {
        FireMode[Mode].bServerDelayStartFire = true;
    }
    else
        ClientForceAmmoUpdate(Mode, AmmoAmount(Mode));
} */

/*function ServerStopFire(byte Mode)
{
    log(self$": ServerStopFire()");
    //ServerFireMode = -1;
    Super.ServerStopFire(Mode);
}
//StartFire below
simulated event StopFire(int Mode)
{
    log(self$": StopFire()");
    Super.StopFire(Mode);
}*/
//-- GUBED

simulated function Ammo_Reload()
{
	local float AmmoMax,AmmoCount;

	GetAmmoCount(AmmoMax,AmmoCount);
	Ammo_SetClipRoundsRemaining(Min(ClipSize,AmmoCount));
}

simulated function bool StartFire(int mode) //GE: Reload on (usually) AltFire, if costs more.
{
    //log(self$": StartFire()");
    if (U2WeaponFire(FireMode[mode]).Ammo_ReloadRequired(U2WeaponFire(FireMode[mode]).AmmoPerFire) && CanReload() )
        Reload();
    return Super.StartFire(mode);
}

//-----------------------------------------------------------------------------
//GE: AI code follows.

//GE: Modifies the AI rating. This decides what weapon to bring up.
/*
 * GE: Unreal II knows these ranges:
 * Inside minimum - always at RatingInsideMin
 * Minimum - peaks with RatingRangeMin
 * Ideal - peaks with RatingRangeIdeal
 * Maximum - peaks with RatingRangeMax
 * Limit - peaks with RatingRangeLimit, always RatingIneffective when more
 */
function float GetAIRating()
{
	local Bot B;
	local float EnemyDist;//, PrimaryResult, SecondaryResult;
	//local vector EnemyDir;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return AIRating; //GE: No enemy? Prepare your favourite.

	EnemyDist = VSize(B.Enemy.Location - Instigator.Location);

    //log("U2Weapon: AI rating for"@self@"at"@EnemyDist@"is"@Max(GetPrimaryRating(EnemyDist), GetSecondaryRating(EnemyDist)));
	return FMax(GetPrimaryRating(EnemyDist), GetSecondaryRating(EnemyDist))*Lerp(AmmoStatus(), 0.9, 1.1);
}

//GE: Choose from regular or alt fire.
function byte BestMode()
{
	local Bot B;
	local float EnemyDist;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return byte(AIRatingFire < AIRatingAltFire);//GE: No enemy? Return the higher rating.

    EnemyDist = VSize(B.Enemy.Location - Instigator.Location);
    if (GetPrimaryRating(EnemyDist) < GetSecondaryRating(EnemyDist))
        return 1;
    return 0;
}

function float GetPrimaryRating(float EnemyDist)
{
    //log("U2Weapon: Enemy distance for"@self@"is"@EnemyDist@"and ranges are"@RangeMinFire@RangeIdealFire@RangeMaxFire@RangeLimitFire);
    //log("U2Weapon: GetPrimaryRating ifs go: 1)"@EnemyDist < RangeMinFire$", 2)"@EnemyDist < RangeIdealFire$", 3)"@EnemyDist < RangeMaxFire$", 4)"@EnemyDist <= RangeLimitFire);
    //GE: Calc primary fire rating.
	if ( EnemyDist < RangeMinFire ) //GE: Inside minimum range
		return RatingInsideMinFire;
	if ( EnemyDist <= RangeLimitFire ) //GE: Inside the interpolation curve.
	   return InterpCurveEval(RatingCurveFire, EnemyDist);
    /*if ( EnemyDist < RangeIdealFire ) //GE: At minimum-ideal range
		return class'GEUtilities'.static.LinearInterpolateY(RangeMinFire, RatingRangeMinFire, RangeIdealFire, RatingRangeIdealFire, EnemyDist);
	if ( EnemyDist < RangeMaxFire ) //GE: At ideal-maximum range
		return class'GEUtilities'.static.LinearInterpolateY(RangeIdealFire, RatingRangeIdealFire, RangeMaxFire, RatingRangeMaxFire, EnemyDist);
	if ( EnemyDist <= RangeLimitFire ) //GE: At maximum-limit range
		return class'GEUtilities'.static.LinearInterpolateY(RangeMaxFire, RatingRangeMaxFire, RangeLimitFire, RatingRangeLimitFire, EnemyDist); */
	//GE: More than limit range
	return RatingIneffective;
}

function float GetSecondaryRating(float EnemyDist)
{
    //GE: Calc secondary fire rating.
	if ( EnemyDist < RangeMinAltFire ) //GE: Inside minimum range
		return RatingInsideMinAltFire;
	if ( EnemyDist <= RangeLimitAltFire ) //GE: Inside the interpolation curve.
	    return InterpCurveEval(RatingCurveAltFire, EnemyDist);
	/*if ( EnemyDist < RangeIdealAltFire ) //GE: At minimum-ideal range
		return class'GEUtilities'.static.LinearInterpolateY(RangeMinAltFire, RatingRangeMinAltFire, RangeIdealAltFire, RatingRangeIdealAltFire, EnemyDist);
	if ( EnemyDist < RangeMaxAltFire ) //GE: At ideal-maximum range
		return class'GEUtilities'.static.LinearInterpolateY(RangeIdealAltFire, RatingRangeIdealAltFire, RangeMaxAltFire, RatingRangeMaxAltFire, EnemyDist);
	if ( EnemyDist <= RangeLimitAltFire ) //GE: At maximum-limit range
		return class'GEUtilities'.static.LinearInterpolateY(RangeMaxAltFire, RatingRangeMaxAltFire, RangeLimitAltFire, RatingRangeLimitAltFire, EnemyDist);*/
	//GE: More than limit range
	return RatingIneffective;
}

//GE: Builds the interpolation curves. Call this to rebuild them?
function BuildInterpolationCurves()
{
    local InterpCurvePoint ICP;
    //local int i;

    //GE: Make sure the input is valid, and build the curve for primary fire.
    //GE: Invalid points are omitted from the curve.
    if (RangeMinFire >= 0.0)
    {
        ICP.InVal=RangeMinFire;
        ICP.OutVal=RatingRangeMinFire;
        RatingCurveFire.Points[RatingCurveFire.Points.Length]=ICP;
    }
    if (RangeIdealFire >= 0.0)
    {
        ICP.InVal=RangeIdealFire;
        ICP.OutVal=RatingRangeIdealFire;
        RatingCurveFire.Points[RatingCurveFire.Points.Length]=ICP;
    }
    if (RangeMaxFire >= 0.0)
    {
        ICP.InVal=RangeMaxFire;
        ICP.OutVal=RatingRangeMaxFire;
        RatingCurveFire.Points[RatingCurveFire.Points.Length]=ICP;
    }
    if (RangeLimitFire >= 0.0)
    {
        ICP.InVal=RangeLimitFire;
        ICP.OutVal=RatingRangeLimitFire;
        RatingCurveFire.Points[RatingCurveFire.Points.Length]=ICP;
    }

    //GE: Now the same for secondary fire.
    if (RangeMinAltFire >= 0.0)
    {
        ICP.InVal=RangeMinAltFire;
        ICP.OutVal=RatingRangeMinAltFire;
        RatingCurveAltFire.Points[RatingCurveAltFire.Points.Length]=ICP;
    }
    if (RangeIdealAltFire >= 0.0)
    {
        ICP.InVal=RangeIdealAltFire;
        ICP.OutVal=RatingRangeIdealAltFire;
        RatingCurveAltFire.Points[RatingCurveAltFire.Points.Length]=ICP;
    }
    if (RangeMaxAltFire >= 0.0)
    {
        ICP.InVal=RangeMaxAltFire;
        ICP.OutVal=RatingRangeMaxAltFire;
        RatingCurveAltFire.Points[RatingCurveAltFire.Points.Length]=ICP;
    }
    if (RangeLimitAltFire >= 0.0)
    {
        ICP.InVal=RangeLimitAltFire;
        ICP.OutVal=RatingRangeLimitAltFire;
        RatingCurveAltFire.Points[RatingCurveAltFire.Points.Length]=ICP;
    }

    //GE: Failed to provide any meaningful information? Build it as a flat line with RatingLow everywhere.
    if (RatingCurveFire.Points.Length == 0)
    {
        RatingCurveFire.Points.Length=2;
        RatingCurveFire.Points[0].InVal=0.0;
        RatingCurveFire.Points[0].OutVal=RatingLow;
        RatingCurveFire.Points[1].InVal=RangeUnlimited;
        RatingCurveFire.Points[1].OutVal=RatingLow;
    }
    if (RatingCurveAltFire.Points.Length == 0)
    {
        RatingCurveAltFire.Points.Length=2;
        RatingCurveAltFire.Points[0].InVal=0.0;
        RatingCurveAltFire.Points[0].OutVal=RatingLow;
        RatingCurveAltFire.Points[1].InVal=RangeUnlimited;
        RatingCurveAltFire.Points[1].OutVal=RatingLow;
    }
    //for (i=0; i<RatingCurveFire.Points.Length; i++)
    //    log("U2Weapon: RatingCurveFire.Points["$i$"] = (InVal="$RatingCurveFire.Points[i].InVal$",OutVal="$RatingCurveFire.Points[i].OutVal$");");
}

defaultproperties
{
     bAllowCustomCrosshairs=True
     TraceDist=10000.000000
     TargetableTypes(0)="Pawn"
     bUpdateCrosshair=True
     bUpdateLocation=True
     bDrawWeapon=True
     bClearZ=True
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     ClipSize=1
     ReloadTime=1.000000
     DownUnloadedTime=0.533000
     SelectUnloadedTime=0.600000
     SelectAnimRate=1.000000
     PutDownAnimRate=1.000000
     PutDownTime=0.533000
     BringUpTime=0.600000
     DisplayFOV=60.000000
     PlayerViewOffset=(X=30.000000,Z=-5.000000)
     PlayerViewPivot=(Yaw=-16384)
     BobDamping=0.700000
     NetUpdateFrequency=1.000000
     TransientSoundVolume=1.000000

     AmbientGlow=0

    bAimFire=true
    bAimAltFire=true
    bFireEnabledForOwner=true
    bAltFireEnabledForOwner=true

    RangeMinFire=-1.000000
    RangeIdealFire=-1.000000
    RangeMaxFire=-1.000000
    RangeLimitFire=-1.000000
    RatingInsideMinFire=-10.000000
    RatingRangeMinFire=-1.000000
    RatingRangeIdealFire=-1.000000
    RatingRangeMaxFire=-1.000000
    RatingRangeLimitFire=-1.000000
    AIRatingFire=-99.999001
    RangeMinAltFire=-1.000000
    RangeIdealAltFire=-1.000000
    RangeMaxAltFire=-1.000000
    RangeLimitAltFire=-1.000000
    RatingInsideMinAltFire=-10.000000
    RatingRangeMinAltFire=-1.000000
    RatingRangeIdealAltFire=-1.000000
    RatingRangeMaxAltFire=-1.000000
    RatingRangeLimitAltFire=-1.000000
    AIRatingAltFire=-99.999001
    //ServerFireMode=-1
}
