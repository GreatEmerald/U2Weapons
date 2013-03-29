//-----------------------------------------------------------------------------
// U2PickupGrenadeLauncherLight.uc
// Pickup class of Hydra
// Ow, it bites.
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class U2PickupGrenadeLauncherLight extends UTWeaponPickup;

#exec OBJ LOAD FILE="../StaticMeshes/U2MalekythM.usx"

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Texture'U2GLMWeaponsT.GL_TP_Skin1');
    L.AddPrecacheStaticMesh(StaticMesh'U2MalekythM.Pickups.GL_TP_W');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Texture'U2GLMWeaponsT.GL_TP_Skin1');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
     MaxDesireability=0.700000
     InventoryType=Class'U2Weapons.U2WeaponGrenadeLauncherLight'
     PickupMessage="You got a Light Grenade Launcher."
     PickupSound=Sound'U2WeaponsA.GrenadeLauncher.GL_Pickup'
     PickupForce="U2PickupGrenadeLauncherLight"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'U2MalekythM.Pickups.GL_TP_W'
     DrawScale=0.500000
}
