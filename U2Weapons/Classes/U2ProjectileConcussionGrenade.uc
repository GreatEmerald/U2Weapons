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
// U2ProjectileConcussionGrenade.uc
// Projectile class of Concussion Grenade
// ..is there?
// Credits go to meowcat and UT2004Addict for parts of this class.
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2ProjectileConcussionGrenade extends U2Grenade;

var float FlashbangTimer, CustomLifeSpan;
var sound FlashbangHum; //GE: Beep, actually.
var array<Controller> FlashbangVictims;
var bool bDie; //GE: Used to prevent death until necessary.
var bool bTicking; //GE: If true, the Tick() function is doing something worthwhile.
var bool bNetFlashbang; //GE: Networking - if true, the client goes to Flashbang() immediately
//var float NetTime;
var enum EFlashbangMode
{
    FM_None,
    FM_Directional,
    FM_DistanceBased
} FlashbangMode;

replication
{
    reliable if (Role == ROLE_Authority)
        bNetFlashbang;//, NetTime;
}

simulated function XExplode(vector HitLocation, vector HitNormal, actor HitActor)
{

	local Pawn P1;
	local float Incidence1;
	local float MaxDist1;
	local vector Diff1;

	Super.XExplode(HitLocation,HitNormal,HitActor);

	Spawn(class'U2Weapons.U2HurterProxy_Conc', Self,,HitLocation + vect(0,0,16) );

    if (FlashbangMode == FM_None)
        return;

	//if (Role == ROLE_Authority)
	//{
		MaxDist1 = DamageRadius * 10.0;
		foreach VisibleCollidingActors( class'Pawn', P1, MaxDist1, HitLocation )
		{
			//GE: continue statement is broken. And I mean broken like you wouldn't believe.
            if (P1.Controller != None)
			{
                Diff1 = HitLocation - P1.Location;
    			switch(FlashbangMode)
    			{
    			    case (FM_Directional):
    			        Incidence1 = normal(Diff1) dot vector(P1.GetViewRotation());
    			        if ( Incidence1 > 0  )
    				        Flashbang(P1.Controller, Blend( 9.0, 1.0, ABlend( 0.0, (PI/2.0), acos(Incidence1) ) ) * ABlend( MaxDist1, 0.0, VSize(Diff1) ));
    				    break;
    				case (FM_DistanceBased):
    				    //GE: Continue to Default.
    				default:
    				    if ( VSize(Diff1) < MaxDist1  )
    				        Flashbang(P1.Controller, 9.0 * ABlend( MaxDist1, 0.0, VSize(Diff1) ));

    			}
                //GE: Enable this for view-based incidence.
                //Incidence1 = normal(Diff1) dot vector(P1.GetViewRotation());
    			//Incidence1 = 1.0;
                //P1.ClientMessage(self$": Incidence is"@Incidence1);
                //if ( /*Incidence1 > 0*/ VSize(Diff1) < MaxDist1  )
    				//Flashbang(P1.Controller, /*Blend( 9.0, 1.0, ABlend( 0.0, (PI/2.0), acos(Incidence1) ) )*/9.0 * ABlend( MaxDist1, 0.0, VSize(Diff1) ));
            }
		}
	//}
}

//GE: This is executed before Destroy() in XExplode. Simulate destroyed.
simulated function bool DestroyOverride()
{
    //log(self$": DestroyOverride call.");
    if ( Trail != None )
        Trail.mRegen = false; // stop the emitter from regenerating

	if(Role == ROLE_Authority)
    {
        if(MyMarker != None)
        {
            MyMarker.Destroy();
            MyMarker = none;
        }
    }

    AmbientSound = None;
    SetPhysics(PHYS_None);
    SetCollision(false, false, false);
    SetDrawType(DT_None);
    return true;
}

simulated function ConcRadius( float DamageRadius, vector HitLocation )
{
	local actor Victims;
	local float dist;
	local vector dir;
	local vector AdjustedMomentum;

	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if( (Victims != self) && (Victims.Role == ROLE_Authority) && (!Victims.IsA('FluidSurfaceInfo')) )
		{
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;

			AdjustedMomentum = 4000 * dir;
			AdjustedMomentum.Z += 25;

			Victims.TakeDamage
			(
				1,
				Instigator,
				Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				AdjustedMomentum,
				MyDamageType
			);
		}
	}
}

//GE: Commence flashbang!
simulated function Flashbang(Controller Victim, float Time)
{
     local int i;
     local bool bAlreadyExists;


     //if (Role < ROLE_Authority && !bExplode) //GE: play all the destruction and hiding things on the client if not done already
     //   XExplode( Location, -normal(Velocity), none );

     Time = class'GEUtilities'.static.FPositive(Time);
     if (Role == ROLE_Authority)
     {
        bNetFlashbang = True;
        //NetTime = Time;
     }
     /*else if (NetTime > 0) //GE: Client.
     {
        Time = NetTime;
     } */
     //Victim.Pawn.ClientMessage(self$": Flashbang for"@Victim);

     //GE: Populate the FlashbangVictims array.
     for (i=0; i<FlashbangVictims.Length; i++)
     {
        //log(self$": FlashbangVictims["$i$"] ="@FlashbangVictims[i]);
        if (FlashbangVictims[i] == Victim)
        {
            bAlreadyExists = true;
            break;
        }
     }
     if (!bAlreadyExists)
     {
         //log(self$": FlashbangVictims["$FlashbangVictims.Length$"] ="@Victim);
         FlashbangVictims.Length = FlashbangVictims.Length+1;
         FlashbangVictims[FlashbangVictims.Length-1] = Victim;
         //log(self$": FlashbangVictims["$FlashbangVictims.Length-1$"] ="@FlashbangVictims[FlashbangVictims.Length-1]);

     }

     if (PlayerController(Victim) != None)
         HandleOverlays(PlayerController(Victim), Time);

     //GE: Mostly shared controller code goes here.
     FlashbangTimer = Time;
     //log(self$": FlashbangTimer before Tick is"@FlashbangTimer);
     bTicking = True;
     Enable('Tick');
      if (Victim.Pawn != None)
          Victim.Pawn.AmbientSound = FlashbangHum;


}

//GE: This part handles everything that concerns PlayerControllers.
simulated function HandleOverlays(PlayerController Victim, float Time)
{
    local U2OverlayConcussion Overlay;
    local int i;

    if (Victim.myHUD == None)
        return;

     //log(self$": myHUD exists!");

     //GE: If the player already has an overlay, utilise it instead.
     for (i=0; i<Victim.myHUD.Overlays.Length; i++)
     {
        if (U2OverlayConcussion(Victim.myHUD.Overlays[i]) != None)
        {
            //log(self$": Using existing overlay!");
            Overlay = U2OverlayConcussion(Victim.myHUD.Overlays[i]);
            break;
        }
     }

     if (Overlay == None)
     {
        Overlay = Spawn(class'U2OverlayConcussion', Victim.myHUD);
        Victim.myHUD.AddHUDOverlay(Overlay);
        //log(self$": Added a new overlay!");
     }
     if (Overlay == None) //GE: If Fail
        return;
     //log(self$": Overlay exists for"@Time);
     Overlay.Countdown = Time;
     Overlay.Enable('Tick');

}

simulated function Tick(float DeltaTime)
{
    local int i;

    //GE: Custom life span - explode timed grenades manually, but don't destroy them
    CustomLifeSpan -= DeltaTime;
    if (CustomLifeSpan <= 0.0 && !bExploded)
        XExplode( Location, -normal(Velocity), none );

    if (Role < ROLE_Authority && bNetFlashbang && !bExploded)
    {
        XExplode( Location, -normal(Velocity), none );
        //log(self$": Client flashbang initiated!");
    }

    if (!bTicking)
        return;

    FlashbangTimer -= DeltaTime;
	for (i=0; i<FlashbangVictims.Length; i++)
	{
        if (FlashbangVictims[i] != None && FlashbangVictims[i].Pawn != None)
            FlashbangVictims[i].Pawn.SoundVolume = class'U2OverlayConcussion'.static.FlashbangAlpha(FlashbangTimer);
    }
	if( FlashbangTimer < 0 )
	{
		//log(self@"Flashbang timer at"@FlashbangTimer@"and there are"@FlashbangVictims.Length@"victims");
        for (i=0; i<FlashbangVictims.Length; i++)
		{
            //PlayerController(FlashbangVictims[i]).ClientMessage("Tick!");
            if (FlashbangVictims[i] != None && FlashbangVictims[i].Pawn != None)
            {
                FlashbangVictims[i].Pawn.AmbientSound = None;
        	    SoundVolume = 128;
		    }
		}
		FlashbangTimer = 0;
		FlashbangVictims.Length = 0;
		//Destroy();
        Disable('Tick');//GE: Not really needed but better safe than sorry.
		//bDie = True;
	}

    //GE: AI code goes here.
	if ( FlashBangTimer > 1 )
	{
		for (i=0; i<FlashbangVictims.Length; i++)
		{
		    if ( Bot(FlashbangVictims[i])!= None && Bot(FlashbangVictims[i]).Pawn.Health > 0 )
		    {
                Bot(FlashbangVictims[i]).StopFiring();
            	Bot(FlashbangVictims[i]).Focus = None;
            	Bot(FlashbangVictims[i]).Enemy = None;
            	Bot(FlashbangVictims[i]).Target = None;
            	Bot(FlashbangVictims[i]).bIgnoreEnemyChange = False;
            	Bot(FlashbangVictims[i]).EnemyNotVisible();
            	Bot(FlashbangVictims[i]).SetAttractionState();
            	Bot(FlashbangVictims[i]).Reset();
        	}
		}
	}
}

simulated function Destroyed()
{
    if (FlashbangTimer > 0)
        warn("Destroyed"@self@"prematurely!");
    //log(self$": Died while FlashbangTimer is"@FlashbangTimer);
    //if (bDie)
    //log(self$": Destroyed when bTicking is"@bTicking);
    Super.Destroyed();
}

static function SetFlashbangMode(string ModeString)
{
    switch(ModeString)
    {
        case "FM_None":
            class'U2ProjectileConcussionGrenade'.default.FlashbangMode = FM_None;
            break;
        case "FM_Directional":
            class'U2ProjectileConcussionGrenade'.default.FlashbangMode = FM_Directional;
            break;
        case "FM_DistanceBased":
        default:
            class'U2ProjectileConcussionGrenade'.default.FlashbangMode = FM_DistanceBased;
    }
}

defaultproperties
{
     ExplosionEffect=Class'U2FX_FlashbangFX'
     ExplosionSound=Sound'WeaponsA.GrenadeLauncher.GL_ExplodeConcussion'
     MomentumTransfer=200000.000000
     Damage=8.250000
     DamageRadius=1024.000000
     MyDamageType=Class'U2Weapons.U2DamTypeConcussionGrenade'
     FlashbangHum=Sound'XMPA.Effects.Flashbang'
     bAlwaysRelevant=True
     bNetTemporary=False
     LifeSpan=0.0
     CustomLifeSpan=3.0
     FlashbangMode=FM_DistanceBased
}
