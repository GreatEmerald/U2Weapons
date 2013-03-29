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
// XMPProximitySensorDeployable.uc
// 2004 jasonyu
// 25 July 2004
//-----------------------------------------------------------

class U2ProximitySensorDeploy extends U2DeployableInventory;

function float GetAIRating()
{
    local Bot B;

    if ( AmmoAmount(0) <= 0 )
        return 0;

    B = Bot(Instigator.Controller);
    if (B == None)
        return AIRating;
    if (B.Enemy == None)
    {
        if (B.Formation() && B.Squad.SquadObjective != None && B.Squad.SquadObjective.BotNearObjective(B))
        {
            if ( DestroyableObjective(B.Squad.SquadObjective) != None && B.Squad.SquadObjective.TeamLink(B.Squad.Team.TeamIndex)
                 && DestroyableObjective(B.Squad.SquadObjective).Health < DestroyableObjective(B.Squad.SquadObjective).DamageCapacity )
                return 0.9; //hackish - don't want higher priority than anything that can heal objective

            return 1.3;
        }

        return AIRating;
    }
    return AIRating;
}

defaultproperties
{
     FireModeClass(0)=Class'U2ProximitySensorDeployFire'
     FireModeClass(1)=Class'U2ProximitySensorDeployFire'
     SelectSound=Sound'U2XMPA.ProximitySensor.PS_Select'
     Priority=4
     GroupOffset=2
     InventoryGroup=1
     ItemName="Proximity Sensor"
     BobDamping=1.8
     PickupClass=Class'U2PickupProximitySensor'
     AttachmentClass=Class'U2AttachmentProximitySensor'
     IconMaterial=Texture'UIResT.HUD.U2HUD'
     IconCoords=(X1=402,Y1=170,X2=418,Y2=201)
     CustomCrossHairTextureName="KA_XMP.U2.uLeechGun"
     IdleAnim=""
     Mesh=SkeletalMesh'WeaponsK.FieldGenerator'
     AIRating=0.30 //GE: bad rating because might interfere with player schemes online
     CurrentRating=0.30 //And overall annoying and useless vs players
     Description="Proximity Sensors are small devices made entirely for scanning the area for any activity. When in the area, scanned by radio waves, a living object appears, it has to have the team's identification badge, otherwise the Proximity Sensor automatically sets off an alarm."
}
