#include "op4/weapon_hlpython"
#include "op4/weapon_ofm249"
#include "op4/weapon_ofsniperrifle"
#include "op4/weapon_ofshockrifle"
#include "op4/weapon_hlmp5"
#include "op4/weapon_hl9mmhandgun"
#include "op4/weapon_knife"
#include "op4/nvision"

#include "beast/anti_rush"

#include "mikk/checkpoint_spawner"

const bool blClassicWeaponsEnable = true;
const bool blOldHalfLifeEnabled = true;
const bool blNightVisionEnabled = true;
const bool blAntiRushEnabled = true;
//const bool blAllyNpcGodmode = true; //Mi otis en godmode :/ -Gafth  // Enable this and the MapActivate to prevent otis die.-

array<ItemMapping@> g_ClassicWeapons = 
{ 
    ItemMapping( "weapon_m16", GetHLMP5Name() ),
    ItemMapping( "weapon_357", GetHLPythonName() ),
    ItemMapping( "weapon_m249", GetOFM249Name() ),
    ItemMapping( "weapon_shockrifle", GetOFShockName() ),
    ItemMapping( "weapon_sniperrifle", GetOFSniperName() ),
    ItemMapping( "weapon_9mmAR", GetHLMP5Name() ),
    ItemMapping( "weapon_9mmhandgun", GetHL9mmhandgunName() ),
    ItemMapping( "weapon_crowbar", GetKnifeName() ) 
};

void MapInit()
{
    RegisterCheckPointSpawnerEntity();

    if( blNightVisionEnabled )
        g_nv.MapInit(); 

    if( blClassicWeaponsEnable )
        RegisterClassicWeapons();

    if( blAntiRushEnabled )
        RegisterAntiRushEntity();
}

void RegisterClassicWeapons()
{
	RegisterKnife();
	RegisterHLPython();
	RegisterOFM249();
	RegisterOFSniper();
	RegisterOFShock();

    if( blOldHalfLifeEnabled )
        RegisterHalfLifeWeapons();

	g_ClassicMode.SetItemMappings( @g_ClassicWeapons );
    
    //g_ClassicMode.ForceItemRemap( true );
	
	g_ClassicMode.EnableMapSupport();
}

void RegisterHalfLifeWeapons()
{
    RegisterHLMP5();
    RegisterHL9mmhandgun();
}

/*
void MapActivate()
{
    CBaseEntity@ pGodModeEffect;

    if( !blAllyNpcGodmode )
    {
        while( ( @pGodModeEffect = g_EntityFuncs.FindEntityByTargetname( pGodModeEffect, "otis_god" ) ) !is null )
            g_EntityFuncs.Remove( pGodModeEffect );
    }
}
*/