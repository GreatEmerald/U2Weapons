//-----------------------------------------------------------------------------
// U2WeaponGrenadeLauncherMedium.uc
// Weapon class of Hydra (medium)
// A copy-paste.
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2WeaponGrenadeLauncherMedium extends XMPGrenadeLauncherMedium;

defaultproperties
{
     ClipSize=5
     FireModeClass(0)=Class'U2Weapons.U2FireEMPGrenade'
     FireModeClass(1)=Class'U2Weapons.U2FireToxicGrenade'
     Description="The M406 Hydra Grenade Launcher is an amazingly versatile and effective piece of military hardware, perhaps the best all-around portable weapon in the Terran arsenal. It uses universal Grenades that can be used for all types of Grenade Launchers."
     Priority=31
     GroupOffset=1
     PickupClass=Class'U2Weapons.U2PickupGrenadeLauncherMedium'
     BobDamping=2.200000
     AttachmentClass=Class'U2Weapons.U2AttachmentGrenadeLauncher'
     IconMaterial=Texture'U2343T.HUD.U2HUD'
     IconCoords=(X1=203,Y1=120,X2=246,Y2=135)
     ItemName="Hydra Grenade Launcher Medium"
}
