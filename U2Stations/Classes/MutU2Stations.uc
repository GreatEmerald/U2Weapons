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
//------------------------------------------------------------------------------
// MutU2Stations.uc
// GreatEmerald, 2008
// Mutator for replacing Health/Shield Chargers with Health/Energy stations
//------------------------------------------------------------------------------

class MutU2Stations extends Mutator;

/* Plan:
 *
 * Chargers are not replaced - they are instead used for spawning decoy health
 * so that bots would feel compelled to go there without the need for changing
 * the stock AI code. Furthermore, the code in TournamentHealth handles all the
 * desireability issues.
 *
 * 1. Replace all Health Chargers with Health Stations
 * 2. Replace all Shield Chargers with Energy Stations
 * 3. Replace all Super Shield Chargers with Super Energy Stations
 * 4. Replace all Super Health Chargers with Super Health Stations
 * 5. Dynamically get the HealingAmount and ShieldAmount from the to-be-replaced chargers
 * 6. Make the Energy Station up the shields to 50 only and the Super Health Station to 199
 * 7. Maybe add ambient light?
 */

var class<U2PowerStation> HealthStationClass, ShieldStationClass, SuperHealthStationClass, SuperShieldStationClass;
var class<Pickup> DecoyHealthClass, DecoyShieldClass;
//var bool bDebug;

/*
 * BeginPlay - here we change the health chargers before they spawn the pickups.
 */
/*simulated function BeginPlay()
{
    local xPickupBase P;

    foreach AllActors(class'xPickupBase', P)
    {
        if (HealthCharger(P) != None || ShieldCharger(P) != None || SuperHealthCharger(P) != None ||
           SuperShieldCharger(P) != None)
        {
           P.bHidden = true;
           if (P.myEmitter != None)
              P.myEmitter.Destroy();
        }
    }
} */


/*replication
{
    reliable if (Role == ROLE_Authority)
        HideCharger;
} */

/*
 * CheckReplacement - here we hide the health charger, change health pickups to
 * decoys and spawn the stations.
 * This starts before the chargers can spawn anything
 */
simulated function BeginPlay()
{
    local xPickupBase Other;
//log(self$": CheckReplacement!");
 ForEach AllActors(class'xPickupBase', Other)
 {

     if ( SuperHealthCharger(Other) != None ||
        SuperShieldCharger(Other) != None ||
        HealthCharger(Other) != None ||
        ShieldCharger(Other) != None )
      HideCharger(Other);

      /*Other.SetDrawType(DT_None);
    if (Other.myEmitter != None)
        Other.myEmitter.Destroy();
         */
      /*if ( SuperHealthCharger(Other) != None)
      HideCharger(xPickupBase(Other), SuperHealthStationClass);

     else if ( SuperShieldCharger(Other) != None)
      HideCharger(xPickupBase(Other), SuperShieldStationClass);

     else if ( HealthCharger(Other) != None)
      HideCharger(xPickupBase(Other), HealthStationClass);

     else if ( ShieldCharger(Other) != None)
      HideCharger(xPickupBase(Other), ShieldStationClass); */
 }
 Super.PostBeginPlay();
}

function bool CheckReplacement(actor Other, out byte bSuperRelevant)
{
    /*if (!bDebug)
    PreNetBeginPlay(); */

    if ( SuperHealthCharger(Other) != None)
      SpawnStation(xPickupBase(Other), SuperHealthStationClass);

     else if ( SuperShieldCharger(Other) != None)
      SpawnStation(xPickupBase(Other), SuperShieldStationClass);

     else if ( HealthCharger(Other) != None)
      SpawnStation(xPickupBase(Other), HealthStationClass);

     else if ( ShieldCharger(Other) != None)
      SpawnStation(xPickupBase(Other), ShieldStationClass);

    return Super.CheckReplacement(Other, bSuperRelevant);
}


/*
 * GE: SpawnStation() - spawns a Power Station.
 * Server-side only. Everything the client needs is in BeginPlay().
 */
function SpawnStation(xPickupBase Charger, class<U2PowerStation> StationClass)
{
  local U2PowerStation Station;
  local vector AdditiveHeight;

  //GE: Don't do this again if we have already did this.
  //if (Charger.bHidden)
  //    return;

  //GE: Calculate needed height
  AdditiveHeight.Z = StationClass.Default.CollisionHeight - 4; //GE: 4 is for compensating the outrageous xPickupBase collision cylinder

  //GE: Spawn a station
  Station = Spawn(StationClass, , , Charger.Location+AdditiveHeight, Charger.Rotation);

  //GE: Unfortunately, not enough space to spawn the station. Ah well, returning.
  if (Station == None)
  {
      warn("Could not spawn the Unreal II power station!");
      return;
  }

  //log(self$": The charger is hidden:"@Charger.bHidden);
  //GE: Hide the charger
  /*Charger.SetDrawType(DT_None);//bHidden = True;
  if (Charger.myEmitter != None)
     Charger.myEmitter.Destroy(); */

  //GE: Get the power of the charger and adjust the station, then spawn a decoy
  if (ClassIsChildOf(Charger.Powerup, class'TournamentHealth'))
  {
     //log("MutU2Stations: found TournamentHealth!");
     Station.HealthUnits = class<TournamentHealth>(Charger.PowerUp).default.HealingAmount;
     Charger.Powerup = DecoyHealthClass;
  }
  else if (ClassIsChildOf(Charger.Powerup, class'ShieldPickup'))
  {
     //log("MutU2Stations: found ShieldPickup!");
     Station.EnergyUnits = class<ShieldPickup>(Charger.PowerUp).default.ShieldAmount;
     Charger.Powerup = DecoyShieldClass;
  }

  //GE: Make the station aware of the parent charger
  Station.RegisterCharger(Charger);

  //GE: Adapt the charger's properties.
  Station.SetCollisionSize(Charger.CollisionRadius, Station.CollisionHeight);
  if (Charger.StaticMesh == StaticMesh'HealthChargerMESH-DS'
  || Charger.StaticMesh == StaticMesh'XGame_rc.HealthChargerMesh') //GE: if health
     Station.SetDrawScale(Charger.DrawScale*0.8);
  else if (Charger.StaticMesh == StaticMesh'XGame_rc.ShieldChargerMesh') //GE: if shield
     Station.SetDrawScale(Charger.DrawScale*0.6);

}

/*
 * HideCharger - hides the PickupBase and does everything else the client needs
 */
simulated function HideCharger(xPickupBase Charger)
{
    Charger.SetDrawType(DT_None);
    //Charger.bHidden = True;
    if (Charger.myEmitter != None)
        Charger.myEmitter.Destroy();
}

//=============================================================================
defaultproperties
{
     GroupName="Stations"
     FriendlyName="Unreal II Power Stations"
     Description="Replaces Health Chargers with Health Stations and Shield Chargers with Energy Stations from Unreal II."
     HealthStationClass=class'U2HealthStation'
     ShieldStationClass=class'U2EnergyStation'
     SuperHealthStationClass=class'U2SuperHealthStation'
     SuperShieldStationclass=class'U2SuperEnergyStation'
     DecoyHealthClass=class'U2DecoyHealth'
     DecoyShieldClass=class'U2DecoyShield'

     RemoteRole=ROLE_DumbProxy//ROLE_SimulatedProxy //GE: Enable the client to execute simulated code. Needed for hiding the bases.
     bAlwaysRelevant=True //GE: Since we are a Simulated Proxy now, we have to worry about being relevant. And since we can't see the mutator, it should always be relevant.
     bAddToServerpackages=True //GE: Automatically add to ServerPackages. Saves those lazy admins from adding it themselves.
     bNetTemporary=True
}
