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
// U2WeaponRocketLauncher.uc
// Weapon class of Shark
// Drunken rockets aren't drunk :(
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2WeaponRocketLauncher extends U2Weapon;

var Projectile LastFiredRocket;
var Projectile AltRockets[4];
var Vector	RocketLocation1,
			RocketLocation2,
			RocketLocation3,
			RocketLocation4;

//var enum EFireMode { FM_None, FM_Fire, FM_AltFire } FireMode;

var float AltFireMinIneffectiveRange;		// distance within which altfire will likely pass through/miss target
var float AltFireReallyIneffectiveRange;	// generally AltFireReallyIneffectiveRange/X preset for speed
var float PreferAltFireRange;				// distance at which skilled NPCs will prefer altfire

var bool bTargetting;

var() sound PaintSound;

var Actor PaintedTargets[4];	// also used for painted targets before rockets are fired.

var enum EFireMode { FM_None, FM_Fire, FM_AltFire } XFireMode;


replication
{
//	reliable if( Role<ROLE_Authority )
	reliable if ( Role==ROLE_Authority )
		StopTargetting,
		StartTargetting;
	unreliable if( Role==ROLE_Authority )
		ClientSetPaintedTargetA,
		ClientSetPaintedTargetB,
		ClientSetPaintedTargetC,
		ClientSetPaintedTargetD;
}

/*
 * GE: This is how the crosshair in Unreal II works:
 * If all your rockets are in the rocket launcher, the four are not glowing and in the centre.
 * If they are seeking a target, all of them will be on the target, if it's alive.
 * If not, they will be on the rockets instead.
 * Works for both the quad rocket and individual ones.
 */
simulated function UpdateCrosshair(Canvas Canvas)
{
    local plane OldModulate;
	local Vector Center;

	Super.UpdateCrosshair(Canvas);

	OldModulate = Canvas.ColorModulate;
	Canvas.ColorModulate.X = 255;
    Canvas.ColorModulate.Y = 255;
	Canvas.ColorModulate.Z = 255;
	Canvas.ColorModulate.W = 255;

	Canvas.Style = ERenderStyle.STY_Normal;

	Center.X = Canvas.ClipX * 0.5;
	Center.Y = Canvas.ClipY * 0.5;

	// Ring
	Canvas.SetPos((Center.X) - 32,(Center.Y) - 24);
	Canvas.DrawTile(Texture'UIResT.Crosshairs.RL_Cross',64,48,0,0,64,48);

	//Canvas.Style = ERenderStyle.STY_Alpha;
    //log(self@": XFireMode is"@XFireMode);

	Canvas.SetPos( Center.X + RocketLocation1.X - 8, Center.Y + RocketLocation1.Y - 8 );
	Canvas.DrawTile(Texture'UIResT.Crosshairs.RL_Cross',16,16,0,48,16,16);
	Canvas.SetPos( Center.X + RocketLocation2.X - 8, Center.Y + RocketLocation2.Y - 8 );
	Canvas.DrawTile(Texture'UIResT.Crosshairs.RL_Cross',16,16,16,48,-16,16);
	Canvas.SetPos( Center.X + RocketLocation3.X - 8, Center.Y + RocketLocation3.Y - 8 );
	Canvas.DrawTile(Texture'UIResT.Crosshairs.RL_Cross',16,16,16,64,-16,-16);
	Canvas.SetPos( Center.X + RocketLocation4.X - 8, Center.Y + RocketLocation4.Y - 8 );
	Canvas.DrawTile(Texture'UIResT.Crosshairs.RL_Cross',16,16,0,64,16,-16);

	if ( XFireMode == FM_Fire )
	{
		Canvas.SetPos( Center.X + RocketLocation1.X - 12, Center.Y + RocketLocation1.Y - 8 );
		Canvas.DrawTile(Texture'UIResT.Crosshairs.RL_Cross',24,16,16,48,24,16);

		Canvas.SetPos( Center.X + RocketLocation2.X - 12, Center.Y + RocketLocation2.Y - 8 );
		Canvas.DrawTile(Texture'UIResT.Crosshairs.RL_Cross',24,16,40,48,-24,16);

		Canvas.SetPos( Center.X + RocketLocation3.X - 12, Center.Y + RocketLocation3.Y - 8 );
		Canvas.DrawTile(Texture'UIResT.Crosshairs.RL_Cross',24,16,40,64,-24,-16);

		Canvas.SetPos( Center.X + RocketLocation4.X - 12, Center.Y + RocketLocation4.Y - 8 );
		Canvas.DrawTile(Texture'UIResT.Crosshairs.RL_Cross',24,16,16,64,24,-16);
	}
	if ( XFireMode == FM_AltFire )
	{
		Canvas.SetPos( Center.X + RocketLocation1.X - 12, Center.Y + RocketLocation1.Y - 8 );
		Canvas.DrawTile(Texture'UIResT.Crosshairs.RL_Cross',24,16,40,48,24,16);

		Canvas.SetPos( Center.X + RocketLocation2.X - 12, Center.Y + RocketLocation2.Y - 8 );
		Canvas.DrawTile(Texture'UIResT.Crosshairs.RL_Cross',24,16,64,48,-24,16);

		Canvas.SetPos( Center.X + RocketLocation3.X - 12, Center.Y + RocketLocation3.Y - 8 );
		Canvas.DrawTile(Texture'UIResT.Crosshairs.RL_Cross',24,16,64,64,-24,-16);

		Canvas.SetPos( Center.X + RocketLocation4.X - 12, Center.Y + RocketLocation4.Y - 8 );
		Canvas.DrawTile(Texture'UIResT.Crosshairs.RL_Cross',24,16,40,64,24,-16);
	}

	Canvas.ColorModulate = OldModulate;
}

simulated function bool GetRocketStatus( int i )
{
	return (AltRockets[i] != None && (!AltRockets[i].bPendingDelete));
}

simulated function HandleTargetDetails( Actor A, Canvas Canvas, vector ViewLoc, rotator ViewRot )
{
	local Vector RocketLocation;
	local bool bAltRocket;
	local vector dummyloc;

	RocketLocation.X = 0;
	RocketLocation.Y = 0;

	bAltRocket = (GetRocketStatus(0) || GetRocketStatus(1) || GetRocketStatus(2) || GetRocketStatus(3));

	if( /*IsInState('Targetting')*/ bTargetting || bAltRocket )
	{
		if( XFireMode!=FM_AltFire )
		{
			XFireMode = FM_AltFire;
			//SendEvent("RL_AltFire");
		}
	}
	else if( LastFiredRocket!=None && !LastFiredRocket.bPendingDelete )
	{
		if (class'U2Util'.static.ActorLookingAt(Instigator,LastFiredRocket,cos(Instigator.Controller.FOVAngle/57.2958)))
		{RocketLocation = GetProjectedLocation( LastFiredRocket.Location, Canvas );} else {RocketLocation = GetProjectedLocation( dummyloc, Canvas, true );}
		if( XFireMode!=FM_Fire )
		{
			XFireMode = FM_Fire;
			//SendEvent("RL_Fire");
		}
	}
	else
	{
		if( XFireMode!=FM_None )
		{
			XFireMode = FM_None;
			//SendEvent("RL_Default");
		}
	}

	RocketLocation1.X = RocketLocation.X;
	RocketLocation2.X = RocketLocation.X;
	RocketLocation3.X = RocketLocation.X;
	RocketLocation4.X = RocketLocation.X;
	RocketLocation1.Y = RocketLocation.Y;
	RocketLocation2.Y = RocketLocation.Y;
	RocketLocation3.Y = RocketLocation.Y;
	RocketLocation4.Y = RocketLocation.Y;

	if( /*IsInState('Targetting')*/ bTargetting )
	{
		if( CheckTargetValidity(PaintedTargets[0]) )
			if (class'U2Util'.static.ActorLookingAt(Instigator,PaintedTargets[0],cos (Instigator.Controller.FOVAngle/57.2958)))
			{RocketLocation1 = GetProjectedLocation( PaintedTargets[0].Location, Canvas );} else {RocketLocation1 = GetProjectedLocation( dummyloc, Canvas, true );}
		if( CheckTargetValidity(PaintedTargets[1]) )
			if (class'U2Util'.static.ActorLookingAt(Instigator,PaintedTargets[1],cos (Instigator.Controller.FOVAngle/57.2958)))
			{RocketLocation2 = GetProjectedLocation( PaintedTargets[1].Location, Canvas );}else {RocketLocation2 = GetProjectedLocation( dummyloc, Canvas, true );}
		if( CheckTargetValidity(PaintedTargets[2]) )
			if (class'U2Util'.static.ActorLookingAt(Instigator,PaintedTargets[2],cos (Instigator.Controller.FOVAngle/57.2958)))
			{RocketLocation3 = GetProjectedLocation( PaintedTargets[2].Location, Canvas );}else {RocketLocation3 = GetProjectedLocation( dummyloc, Canvas, true );}
		if( CheckTargetValidity(PaintedTargets[3]) )
			if (class'U2Util'.static.ActorLookingAt(Instigator,PaintedTargets[3],cos (Instigator.Controller.FOVAngle/57.2958)))
			{RocketLocation4 = GetProjectedLocation( PaintedTargets[3].Location, Canvas );}else {RocketLocation4 = GetProjectedLocation( dummyloc, Canvas, true );}
	}
	else if (bAltRocket)
	{
		if( (GetRocketStatus(0))&&(class'U2Util'.static.ActorLookingAt(Instigator,AltRockets[0],cos (Instigator.Controller.FOVAngle/57.2958))) )
		{RocketLocation1 = GetProjectedLocation( AltRockets[0].Location, Canvas );}
		else {RocketLocation1 = GetProjectedLocation( dummyloc, Canvas, true );}
		if( (GetRocketStatus(1))&&(class'U2Util'.static.ActorLookingAt(Instigator,AltRockets[1],cos (Instigator.Controller.FOVAngle/57.2958))) )
		{RocketLocation2 = GetProjectedLocation( AltRockets[1].Location, Canvas );}
		else {RocketLocation2 = GetProjectedLocation( dummyloc, Canvas, true );}
		if( (GetRocketStatus(2))&&(class'U2Util'.static.ActorLookingAt(Instigator,AltRockets[2],cos (Instigator.Controller.FOVAngle/57.2958))) )
		{RocketLocation3 = GetProjectedLocation( AltRockets[2].Location, Canvas );}
		else {RocketLocation3 = GetProjectedLocation( dummyloc, Canvas, true );}
		if( (GetRocketStatus(3))&&(class'U2Util'.static.ActorLookingAt(Instigator,AltRockets[3],cos (Instigator.Controller.FOVAngle/57.2958))) )
		{RocketLocation4 = GetProjectedLocation( AltRockets[3].Location, Canvas );}
		else {RocketLocation4 = GetProjectedLocation( dummyloc, Canvas, true );}
		if( CheckTargetValidity(PaintedTargets[0]) )
			if (class'U2Util'.static.ActorLookingAt(Instigator,PaintedTargets[0],cos (Instigator.Controller.FOVAngle/57.2958)))
			{RocketLocation1 = GetProjectedLocation( PaintedTargets[0].Location, Canvas );} else {RocketLocation1 = GetProjectedLocation( dummyloc, Canvas, true );}
		if( CheckTargetValidity(PaintedTargets[1]) )
			if (class'U2Util'.static.ActorLookingAt(Instigator,PaintedTargets[1],cos (Instigator.Controller.FOVAngle/57.2958)))
			{RocketLocation2 = GetProjectedLocation( PaintedTargets[1].Location, Canvas );}else {RocketLocation2 = GetProjectedLocation( dummyloc, Canvas, true );}
		if( CheckTargetValidity(PaintedTargets[2]) )
			if (class'U2Util'.static.ActorLookingAt(Instigator,PaintedTargets[2],cos (Instigator.Controller.FOVAngle/57.2958)))
			{RocketLocation3 = GetProjectedLocation( PaintedTargets[2].Location, Canvas );}else {RocketLocation3 = GetProjectedLocation( dummyloc, Canvas, true );}
		if( CheckTargetValidity(PaintedTargets[3]) )
			if (class'U2Util'.static.ActorLookingAt(Instigator,PaintedTargets[3],cos (Instigator.Controller.FOVAngle/57.2958)))
			{RocketLocation4 = GetProjectedLocation( PaintedTargets[3].Location, Canvas );}else {RocketLocation4 = GetProjectedLocation( dummyloc, Canvas, true );}
	}

	RocketLocation1.X-=8;RocketLocation1.Y-=4;
	RocketLocation2.X+=8;RocketLocation2.Y-=4;
	RocketLocation3.X+=8;RocketLocation3.Y+=4;
	RocketLocation4.X-=8;RocketLocation4.Y+=4;
}

simulated function bool CheckTargetValidity(Actor Target)
{
    if (Target == None || Target.bDeleteMe || Target.bPendingDelete)
        return false;                                     //GE: Needs something else that would define dead... You could regenerate health even if you died
    if (Pawn(Target) != None && (Pawn(Target).Health <= 0 ) )
        return false;
    return true;
}

simulated function Vector GetProjectedLocation( vector Loc, Canvas Canvas, optional bool returnbad)
{
	local vector RocLoc;
	local Vector Pt;

	Pt.X=Canvas.SizeX+8;
	Pt.Y=Canvas.SizeY+8;
	if (returnbad)
		return Pt;

	RocLoc = Canvas.WorldToScreen( Loc );
	if
	(	RocLoc.X >= 0  && RocLoc.X <= Canvas.SizeX
	&&	RocLoc.Y >= 0  && RocLoc.Y <= Canvas.SizeY
	)
	{
		Pt.X = RocLoc.X - Canvas.SizeX/2;
		Pt.Y = RocLoc.Y - Canvas.SizeY/2;
	}

	return Pt;
}

simulated function Vector GetRocketLocation01(){ return RocketLocation1; }
simulated function Vector GetRocketLocation02(){ return RocketLocation2; }
simulated function Vector GetRocketLocation03(){ return RocketLocation3; }
simulated function Vector GetRocketLocation04(){ return RocketLocation4; }

simulated function StartTargetting()
{
	bTargetting=true;
}

simulated function StopTargetting()
{
	bTargetting=false;
}

simulated function ClientSetPaintedTargetA(Actor A)
{
	PaintedTargets[0]=A;
//	PlayOwnedSound(PaintSound,SLOT_Interface);
    PlayerController(Instigator.Controller).ClientPlaySound(PaintSound,,,SLOT_Interface);
//	Instigator.ClientMessage("A Painted: "$A);
}
simulated function ClientSetPaintedTargetB(Actor A)
{
	PaintedTargets[1]=A;
//	PlayOwnedSound(PaintSound,SLOT_Interface);
    PlayerController(Instigator.Controller).ClientPlaySound(PaintSound,,,SLOT_Interface);

//	Instigator.ClientMessage("B Painted: "$A);
}
simulated function ClientSetPaintedTargetC(Actor A)
{
	PaintedTargets[2]=A;
//	PlayOwnedSound(PaintSound,SLOT_Interface);
    PlayerController(Instigator.Controller).ClientPlaySound(PaintSound,,,SLOT_Interface);
//	Instigator.ClientMessage("C Painted: "$A);
}
simulated function ClientSetPaintedTargetD(Actor A)
{
	PaintedTargets[3]=A;
//	PlayOwnedSound(PaintSound,SLOT_Interface);
    PlayerController(Instigator.Controller).ClientPlaySound(PaintSound,,,SLOT_Interface);
//	Instigator.ClientMessage("D Painted: "$A);
}

/*
function float GetProjSpeed( bool bAlt )
{
	if( bAlt )
		return 1200;
	else
		return Super.GetProjSpeed( bAlt );
}
*/


// AI Interface
function bool BotFire(bool bFinished, optional name FiringMode) //GE: Bots lock on enemies automatically.
{
    local Bot B;

    B = Bot(Instigator.Controller);

    if (B.bAltFire == 1 && B.bFire == 0) {
      if (FRand() < (0.20*B.Skill) ) //GE: Willingness to lock on decreases per rocket
        PaintedTargets[0] = B.Enemy;
      if (FRand() < (0.15*B.Skill) )
        PaintedTargets[1] = B.Enemy;
      if (FRand() < (0.10*B.Skill) )
        PaintedTargets[2] = B.Enemy;
      if (FRand() < (0.05*B.Skill) )
        PaintedTargets[3] = B.Enemy;
    }
	return Super.BotFire(bFinished, FiringMode);
}

function float SuggestAttackStyle()
{
	local float EnemyDist;

	// recommend backing off if target is too close
	EnemyDist = VSize(Instigator.Controller.Enemy.Location - Owner.Location);
	if ( EnemyDist < 750 )
	{
		if ( EnemyDist < 500 )
			return -1.5;
		else
			return -0.7;
	}
	else if ( EnemyDist > 1600 )
		return 0.5;
	else
		return -0.1;
}

// tell bot how valuable this weapon would be to use, based on the bot's combat situation
// also suggest whether to use regular or alternate fire mode
function float GetAIRating()
{
	local Bot B;
	local float EnemyDist, Rating, ZDiff;
	local vector EnemyDir;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return Super.GetAIRating();

	// if standing on a lift, make sure not about to go around a corner and lose sight of target
	// (don't want to blow up a rocket in bot's face)
	if ( (Instigator.Base != None) && (Instigator.Base.Velocity != vect(0,0,0))
		&& !B.CheckFutureSight(0.1) )
		return Super.GetAIRating()*0.133333;

	EnemyDir = B.Enemy.Location - Instigator.Location;
	EnemyDist = VSize(EnemyDir);
	Rating = Super.GetAIRating();

	// rockets are good if higher than target, bad if lower than target
	ZDiff = Instigator.Location.Z - B.Enemy.Location.Z;
	if ( ZDiff > 120 )
		Rating += 0.25;
	else if ( ZDiff < -160 )
		Rating -= 0.35;
	else if ( ZDiff < -80 )
		Rating -= 0.05;
	if ( (B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon && (EnemyDist < 2500) )
		Rating += 0.25;

	return Rating;
}

/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode() //GE: Taken from U2's PostModifyRatings.
{
    // mdf-tbd: how to expose range of skills to rest of code
    local float OwnerSkill, DistanceToEnemy;  //U2: 0-1, UT2004: 1-7
    local Bot B;

    B = Bot(Instigator.Controller);
    if( B.Enemy != None )
        DistanceToEnemy = VSize(B.Enemy.Location - Instigator.Location);

    // if no Target or either mode disabled, base class picks based on raw ratings
    if( B.Enemy != None )
    {
        // has Target and both weapons are enabled (could still have RatingIneffective..RatingDangerous though)
        // consider skill
        OwnerSkill = B.Skill;

        // mdf-tbd: ideally, all of these cutoffs should be somewhat fuzzy
        // mdf-tbd: generalize this approach to other weapons? Any applicable?
        if( OwnerSkill < 2.33 )
        {
            // pretty dumb -- use altfire sometimes even if inside effective range
            if( FRand() < 0.50 )
            {
                return 0;
            }
            else
            {
                return 1;
            }
        }
        else if( OwnerSkill < 4.69 ) // <=4
        {                         //GE: Thanks, Carlson :)
            // fairly skilled bot -- avoid using altfire if target inside min effective range
            if( DistanceToEnemy <= AltFireReallyIneffectiveRange )
            {
                // really close
                return 0;
            }
            else if( DistanceToEnemy <= AltFireMinIneffectiveRange )
            {
                // in AltFireReallyIneffectiveRange..AltMinEffectiveRange --> odds of filtering in 1.0..0.0
                if( FRand() < (AltFireMinIneffectiveRange - DistanceToEnemy)/(AltFireMinIneffectiveRange-AltFireReallyIneffectiveRange) )
                {
                    // filter out alt fire
                    return 0;
                }
            }
            else
            {
                // only highly skilled bots know how to use primary/alt fire most
                // effectively outside this range -- dumb down ratings

                // make either mode just as likely
                if( FRand() < 0.50 )
                {
                    return 0;
                }
                else
                {
                    return 1;
                }
            }
        }
        else // >=5
        {
            // skilled bot -- encourange primary fire unless target far away
            // mdf-tbd: scale odds with distance from PreferAltFireRange?
            if( DistanceToEnemy <= AltFireMinIneffectiveRange )
            {
                return 0;
            }
            else if( DistanceToEnemy < PreferAltFireRange )
            {
                // tend to prefer pri fire up to this distance
                if( FRand() < (0.5 + 0.45*0.14*OwnerSkill + 0.35*(PreferAltFireRange - DistanceToEnemy)/PreferAltFireRange) )
                    return 0;
            }
            else
            {
                // tend to prefer alt fire at long distances (low odds either way)
                if( FRand() < (0.5 - 0.45*0.14*OwnerSkill) )
                    return 1;
                else return 0;
            }
        }
    }

}
// end AI Interface


defaultproperties
{
     //bAllowCustomCrosshairs=True
     AltFireMinIneffectiveRange=512.000000
     AltFireReallyIneffectiveRange=256.000000
     PreferAltFireRange=1280.000000
     ReloadTime=3.500000
     ReloadAnimRate=0.571428
     FireModeClass(0)=Class'U2Weapons.U2FireRocket'
     FireModeClass(1)=Class'U2Weapons.U2FireAltRocket'
     Description="Nothing beats the primary fire mode of the Shark Rocket Launcher for accurate, long-range devastation with significant splash damage. The alt-fire drunken missiles are wildly unpredictable, but are good for saturating an area or providing suppressing fire."
     Priority=47
     //CustomCrosshair=58
     //CustomCrossHairTextureName="KA_XMP.U2.uRocketLauncher"
     InventoryGroup=8
     PickupClass=Class'U2Weapons.U2PickupRocketLauncher'
     BobDamping=2.200000
     AttachmentClass=Class'U2Weapons.U2AttachmentRocketLauncher'
     IconMaterial=Texture'U2343T.HUD.U2HUD'
     IconCoords=(X1=78,Y1=176,X2=124,Y2=198)
     ItemName="Shark Rocket Launcher"
     IdleAnim=""

     PaintSound=Sound'WeaponsA.RocketLauncher.RL_Paint'
     bAllowCustomCrosshairs=False
     AutoSwitchPriority=14
     ReloadSound=Sound'WeaponsA.RocketLauncher.RL_Reload'
     ReloadUnloadedSound=Sound'WeaponsA.RocketLauncher.RL_ReloadUnloaded'
     ClipSize=5
     ReloadUnloadedTime=2.000000
     SelectSound=Sound'WeaponsA.RocketLauncher.RL_Select'
     AIRating=0.750000
     //CurrentRating=0.780000
     bUseOldWeaponMesh=True
     CustomCrosshair=7
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Dot"
     PlayerViewOffset=(X=13.000000,Y=-0.500000,Z=-33.000000) //15,0,-30
     Mesh=SkeletalMesh'WeaponsK.RL_FP'
     Skins(0)=Shader'U2WeaponFXT.RocketLauncher.RL_FP_Skin1FX'

    RangeMinFire=192.000000
    RangeIdealFire=512.000000
    RangeMaxFire=2048.000000
    RangeLimitFire=32767.000000
    RatingInsideMinFire=-20.000000
    RatingRangeMinFire=-0.500000
    RatingRangeIdealFire=0.800000
    RatingRangeMaxFire=0.200000
    RatingRangeLimitFire=0.100000
    AIRatingFire=0.750000
    RangeMinAltFire=80.000000
    RangeIdealAltFire=1024.000000
    RangeMaxAltFire=1400.000000
    RangeLimitAltFire=1400.000000
    RatingInsideMinAltFire=-20.000000
    RatingRangeMinAltFire=-0.500000
    RatingRangeIdealAltFire=0.750000
    RatingRangeMaxAltFire=0.100000
    RatingRangeLimitAltFire=0.010000
    AIRatingAltFire=0.700000
}
