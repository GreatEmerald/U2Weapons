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
// U2DamTypeAltHSPistol.uc
// Damage Type of the Magnum Alternative (HS)
// What now?
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2DamTypeAltHSPistol extends U2DamTypeAltPistol;

var class<LocalMessage> KillerMessage;
var sound HeadHunter; // OBSOLETE

static function IncrementKills(Controller Killer)
{
    local xPlayerReplicationInfo xPRI;
    
    if ( PlayerController(Killer) == None )
        return;
        
    PlayerController(Killer).ReceiveLocalizedMessage( Default.KillerMessage, 0, Killer.PlayerReplicationInfo, None, None );
    xPRI = xPlayerReplicationInfo(Killer.PlayerReplicationInfo);
    if ( xPRI != None )
    {
        xPRI.headcount++;
        if ( (xPRI.headcount == 15) && (UnrealPlayer(Killer) != None) )
            UnrealPlayer(Killer).ClientDelayedAnnouncementNamed('HeadHunter',15);
    }
}       

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
    HitEffects[1] = class'HitFlameBig';
}

defaultproperties
{
     KillerMessage=Class'XGame.SpecialKillMessage'
     DeathString="%k put 3 incendiary bullets into %o's brains! That had to hurt!"
     FemaleSuicide="%o thoroughly incinerated herself."
     MaleSuicide="%o thoroughly incinerated himself."
     bAlwaysSevers=True
     bSpecial=True
}
