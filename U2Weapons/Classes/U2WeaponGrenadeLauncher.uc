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
// U2WeaponGreandeLauncher.uc
// The full Grenade Launcher (a la U2)
// 2009, GreatEmerald
//-----------------------------------------------------------
class U2WeaponGrenadeLauncher extends U2Weapon;

#EXEC OBJ LOAD FILE=..\Textures\UIResT.utx

var class<WeaponFire> GrenadeTypes[6];
var localized string GrenadeNames[6];
var int iGrenade;
var int SwitchAttempts;

replication
{
    reliable if (Role==ROLE_Authority)
        iGrenade, SwitchAttempts;
}

// Three letter grenade type abreviations for the hud.
simulated function string GetGrenadeTypeStr()
{
    switch(iGrenade)
    {
    case 0: return "FRG";
    case 1: return "TOX";
    case 2: return "INC";
    case 3: return "SMK";
    case 4: return "CON";
    case 5: return "EMP";
    }
    return "ERR";
}

simulated function bool StartFire(int mode)
{
    if (mode == 1)
        SwitchAmmo();
    return Super.StartFire(mode);
}

simulated function SwitchAmmo()
{

     iGrenade++;

     if (iGrenade >= 6)
        iGrenade = 0;


    if (U2FireGrenade(FireMode[0]) != None)
        U2FireGrenade(FireMode[0]).SwitchAmmo(iGrenade);
}
simulated event RenderOverlays(Canvas Canvas)
{
     Super.RenderOverlays(Canvas);
     Canvas.Style = ERenderStyle.STY_Normal;
     Canvas.DrawColor = class'HUD'.Default.WhiteColor;
     Canvas.Font = Canvas.MedFont;
     Canvas.DrawScreenText(GetGrenadeTypeStr(), 0.5, 0.47, DP_MiddleMiddle);
}

// AI Interface
function float GetAIRating()
{
	local Bot B;
	local float EnemyDist;
	local vector EnemyDir;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return Super.GetAIRating();

	// if retreating, favor this weapon
	EnemyDir = B.Enemy.Location - Instigator.Location;
	EnemyDist = VSize(EnemyDir);
	if (Vehicle(B.Enemy) != none || U2DeployedUnit(B.Enemy) != none)
		return (Super.GetAIRating() + 0.44);
    if ( B.IsRetreating() )
		return (Super.GetAIRating() + 0.4);
	if ( -1 * EnemyDir.Z > EnemyDist )
		return Super.GetAIRating() + 0.1;
	return Super.GetAIRating();
}

/* BestMode()
choose between regular or alt-fire

places bots would use different grenades:
Frag - one enemy, close enough (0)
Toxic - many enemies, far away  (1)
Incendiary - several enemies, far away, not objectives (2)
Smoke - having the flag and enemy is a player (3)
Concussion - having the flag, attacking near spawning enemies, attacking defenders, conc jumping (4)
EMP - vehicles/objectives near you (5)
*/
function byte BestMode()
{
	local Bot B;
	local float EnemyDist;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return 0;

    EnemyDist = VSize(B.Enemy.Location - Instigator.Location);

    if (B.bWasNearObjective && iGrenade == 4) //Near objective, blast away enemies with conc
        return 0;
    else if (Vehicle(B.Enemy) != None && iGrenade == 5) //Enemy is in a vehicle, EMP em
        return 0;
    else if (B.bPursuingFlag && iGrenade == 2) //Enemy has the flag, we don't want to help them so incinerate
        return 0;
    else if (B.PlayerReplicationInfo.HasFlag != None && iGrenade == 4) //We have the flag, so concussion everyone out of our path
        return 0;
    else if (B.PlayerReplicationInfo.HasFlag != None && iGrenade == 3 && B.Enemy.Controller.IsA('PlayerController')) //Or if it's a player, blind with smoke
        return 0;
    else if (Level.DefaultGravity < -200 && iGrenade == 4)
        return 0;
    else if (EnemyDist > 3000 && iGrenade == 3) //Enemy is far - gas is effective, because we won't get hit and it spreads widely
        return 0;
    else if (EnemyDist >= 1000 && iGrenade == 2) //Enemy is in a middle range - Incendiary is effective, we won't burn but enemies will
        return 0;
    else if (EnemyDist < 1000 && (iGrenade == 0 || iGrenade == 4)) //Enemy is in short range - Frag is effective, because it doesn't last, and conc is effective, because it's mild damage
        return 0;

    else
    {
        if (SwitchAttempts > 2) //GE: Give up switching.
        {
            SwitchAttempts = 0;
            return 0;
        }
        SwitchAttempts++;
        return 1;
    }

    return 0;
}

function float SuggestAttackStyle()
{
	local Bot B;
	local float EnemyDist;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return 0.4;

	EnemyDist = VSize(B.Enemy.Location - Instigator.Location);
	if ( EnemyDist > 1500 )
		return 1.0;
	if ( EnemyDist > 1000 )
		return 0.4;
	return -0.4;
}

function float SuggestDefenseStyle()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return 0;

	if ( VSize(B.Enemy.Location - Instigator.Location) < 1600 )
		return -0.6;
	return 0;
}

// End AI Interface

DefaultProperties
{
    GrenadeTypes[0]=U2FireFragGrenade
    GrenadeTypes[1]=U2FireToxicGrenade
    GrenadeTypes[2]=U2FireIncendiaryGrenade
    GrenadeTypes[3]=U2FireSmokeGrenade
    GrenadeTypes[4]=U2FireConcussionGrenade
    GrenadeTypes[5]=U2FireEMPGrenade
    GrenadeNames[0]="Selected Fragmentation Grenades"
    GrenadeNames[1]="Selected Toxic Grenades"
    GrenadeNames[2]="Selected Incendiary Grenades"
    GrenadeNames[3]="Selected Smoke Grenades"
    GrenadeNames[4]="Selected Concussion Grenades"
    GrenadeNames[5]="Selected EMP Grenades"
    AutoSwitchPriority=13
     ReloadSound=Sound'WeaponsA.GrenadeLauncher.GL_Reload'
     ReloadUnloadedSound=Sound'WeaponsA.GrenadeLauncher.GL_ReloadUnloaded'
     ReloadTime=2.2
     ReloadAnimRate=0.626959
     ReloadUnloadedTime=1.380000
     DownUnloadedTime=1.615000
     PutDownTime=0.539000
     SelectSound=Sound'WeaponsA.GrenadeLauncher.GL_Select'
     AIRating=0.550000
     CurrentRating=0.550000
     CustomCrosshair=54
     CustomCrossHairTextureName="KA_XMP.U2.uGrenadeLauncher"
     PlayerViewOffset=(X=18.000000,Y=6.000000,Z=-33.000000) //20,6,-30
     Mesh=SkeletalMesh'WeaponsK.GL_FP'

    ClipSize=5
    FireModeClass(0)=U2FireGrenade
    FireModeClass(1)=U2FireChangeAmmo
    bUseOldWeaponMesh=False
    Description="The M406 Hydra Grenade Launcher is an amazingly versatile and effective piece of military hardware, perhaps the best all-around portable weapon in the Terran arsenal. It uses universal Grenades that explode in various ways."
    Priority=30
    InventoryGroup=7
    PickupClass=Class'U2Weapons.U2PickupGrenadeLauncher'
    BobDamping=2.200000
    AttachmentClass=Class'U2Weapons.U2AttachmentGrenadeLauncher'
    IconMaterial=Texture'U2343T.HUD.U2HUD'
    IconCoords=(X1=203,Y1=120,X2=246,Y2=135)
    ItemName="Hydra Grenade Launcher"
    Skins(0)=Shader'U2WeaponFXT.Grenade.GL_FP_Skin1FX'

    RangeMinFire=384.000000
    RangeIdealFire=512.000000
    RangeMaxFire=2500.000000
    RangeLimitFire=2750.000000
    RatingInsideMinFire=-20.000000
    RatingRangeMinFire=0.500000
    RatingRangeIdealFire=0.800000
    RatingRangeMaxFire=0.600000
    RatingRangeLimitFire=0.200000
    AIRatingFire=0.700000
    RatingInsideMinAltFire=-1.000000
    AIRatingAltFire=-50.000000
}
