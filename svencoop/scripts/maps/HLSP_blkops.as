// Replacement Script with Insurgency Weapons
// Author: KernCore, original replacement logic from Nero

/*MAP ENTITIES

Weapons:

weapon_glock - weapon_9mmhandgun

weapon_357 - weapon_python

weapon_eagle

weapon_shotgun

weapon_sniperrifle

weapon_m16

weapon_9mmAR - weapon_mp5

weapon_crossbow

weapon_crowbar

weapon_pipewrench

weapon_handgrenade

weapon_rpg

Ammo:

ammo_357

ammo_762

ammo_9mmbox

ammo_9mmclip

ammo_ARgrenades

ammo_buckshot

ammo_crossbow

ammo_glockclip

ammo_mp5clip

ammo_mp5grenades

ammo_rpgclip

MAP CFG

*/

//Obligatory Survival stuff
#include "point_checkpoint"
//Insurgency weapons 
#include "HLSPINS2_blkops/weapons"
//Blkops NightVision
#include "blkopnvision"
//Antirush (66%)
#include "cubemath/trigger_once_mp"

namespace SC_BLKOPS
{
array<array<string>> g_9mmHandGunCandidates = {
	{ INS2_M9BERETTA::GetName(), INS2_M9BERETTA::GetAmmoName() }
};
const int i9mmChooser = Math.RandomLong( 0, g_9mmHandGunCandidates.length() - 1 );

array<array<string>> g_RevolverCandidates = {
	{ INS2_M29::GetName(), INS2_M29::GetAmmoName() }
};
const int iRevChooser = Math.RandomLong( 0, g_RevolverCandidates.length() - 1 );

array<array<string>> g_DeagleCandidates = {
	{ INS2_DEAGLE::GetName(), INS2_DEAGLE::GetAmmoName() }
};
const int iDeagChooser = Math.RandomLong( 0, g_DeagleCandidates.length() - 1 );

array<array<string>> g_ShotgunCandidates = {
	{ INS2_M590::GetName(), INS2_M590::GetAmmoName() }
};
const int iShotChooser = Math.RandomLong( 0, g_ShotgunCandidates.length() - 1 );

array<array<string>> g_SniperCandidates = {
	{ INS2_SVD::GetName(), INS2_SVD::GetAmmoName() }
};
const int iSnipChooser = Math.RandomLong( 0, g_SniperCandidates.length() - 1 );

array<array<string>> g_M16Candidates = {
	{ INS2_AKM::GetName(), INS2_AKM::GetAmmoName(), INS2_AKM::GetGLName() }
};
const int iM16Chooser = Math.RandomLong( 0, g_M16Candidates.length() - 1 );

array<array<string>> g_9mmARCandidates = {
	{ INS2_M16A4::GetName(), INS2_M16A4::GetAmmoName() }
};
const int iARChooser = Math.RandomLong( 0, g_9mmARCandidates.length() - 1 );

array<array<string>> g_CrossbowCandidates = {
	{ INS2_M14EBR::GetName(), INS2_M14EBR::GetAmmoName() }
};
const int iCrossChooser = Math.RandomLong( 0, g_CrossbowCandidates.length() - 1 );

array<string> g_CrowbarCandidates = {
	INS2_KABAR::GetName()
};
const int iCrowbChooser = Math.RandomLong( 0, g_CrowbarCandidates.length() - 1 );

array<string> g_PipewrenchCandidates = {
	CoFAXEName()
};
const int iPipewChooser = Math.RandomLong( 0, g_PipewrenchCandidates.length() - 1 );

array<string> g_GrenadeCandidates = {
	INS2_MK2GRENADE::GetName()
};
const int iGrenChooser = Math.RandomLong( 0, g_GrenadeCandidates.length() - 1 );

array<array<string>> g_RpgCandidates = {
	{ INS2_AT4::GetName(), INS2_AT4::GetName() }
};
const int iRpgChooser = Math.RandomLong( 0, g_RpgCandidates.length() - 1 );


array<ItemMapping@> g_Ins2ItemMappings = {
	//rpg
	ItemMapping( "weapon_rpg", g_RpgCandidates[iRpgChooser][0] ),
		ItemMapping( "ammo_rpgclip", g_RpgCandidates[iRpgChooser][1] ),
	//357
	ItemMapping( "weapon_357", g_RevolverCandidates[iRevChooser][0] ), ItemMapping( "weapon_python", g_RevolverCandidates[iRevChooser][0] ),
		ItemMapping( "ammo_357", g_RevolverCandidates[iRevChooser][1] ),
	//crossbow
	ItemMapping( "weapon_crossbow", g_CrossbowCandidates[iCrossChooser][0] ),
		ItemMapping( "ammo_crossbow", g_CrossbowCandidates[iCrossChooser][1] ),
	//mp5
	ItemMapping( "weapon_9mmAR", g_9mmARCandidates[iARChooser][0] ), ItemMapping( "weapon_9mmar", g_9mmARCandidates[iARChooser][0] ), ItemMapping( "weapon_mp5", g_9mmARCandidates[iARChooser][0] ),
		ItemMapping( "ammo_mp5clip", g_9mmARCandidates[iARChooser][1] ),
	//m16
	ItemMapping( "weapon_m16", g_M16Candidates[iM16Chooser][0] ),
		ItemMapping( "ammo_9mmbox", g_M16Candidates[iM16Chooser][1] ), ItemMapping( "ammo_ARgrenades", g_M16Candidates[iM16Chooser][2] ), ItemMapping( "ammo_mp5grenades", g_M16Candidates[iM16Chooser][2] ),
	//shotgun
	ItemMapping( "weapon_shotgun", g_ShotgunCandidates[iShotChooser][0] ),
		ItemMapping( "ammo_buckshot", g_ShotgunCandidates[iShotChooser][1] ),
	//glock
	ItemMapping( "weapon_9mmhandgun", g_9mmHandGunCandidates[i9mmChooser][0] ), ItemMapping( "weapon_glock", g_9mmHandGunCandidates[i9mmChooser][0] ),
		ItemMapping( "ammo_9mmclip", g_9mmHandGunCandidates[i9mmChooser][1] ), ItemMapping( "ammo_glockclip", g_9mmHandGunCandidates[i9mmChooser][1] ),
	//sniperrifle
	ItemMapping( "weapon_sniperrifle", g_SniperCandidates[iSnipChooser][0] ),
		ItemMapping( "ammo_762", g_SniperCandidates[iSnipChooser][1] ),
	//eagle
	ItemMapping( "weapon_eagle", g_DeagleCandidates[iDeagChooser][0] ), //The deagle doesn't have a ammo entity ¯\_(ツ)_/¯.
	//handgrenade
	ItemMapping( "weapon_handgrenade", g_GrenadeCandidates[iGrenChooser] ),
	//crowbar
	ItemMapping( "weapon_crowbar", g_CrowbarCandidates[iCrowbChooser] ), 
	//pipewrench
	ItemMapping( "weapon_pipewrench", g_PipewrenchCandidates[iPipewChooser] )
};

//Using Materialize hook for that one guy that thought it would be a good idea to spawn entities using squadmaker.
HookReturnCode PickupObjectMaterialize( CBaseEntity@ pEntity ) 
{
	Vector origin, angles;
	string targetname, target, netname;

	for( uint j = 0; j < g_Ins2ItemMappings.length(); ++j )
	{
		if( pEntity.pev.ClassNameIs( g_Ins2ItemMappings[j].get_From() ) )
		{
			origin = pEntity.pev.origin;
			angles = pEntity.pev.angles;
			targetname = pEntity.pev.targetname;
			target = pEntity.pev.target;
			netname = pEntity.pev.netname;

			g_EntityFuncs.Remove( pEntity );
			CBaseEntity@ pNewEnt = g_EntityFuncs.Create( g_Ins2ItemMappings[j].get_To(), origin, angles, true );

			if( targetname != "" )
				g_EntityFuncs.DispatchKeyValue( pNewEnt.edict(), "targetname", targetname );

			if( target != "" )
				g_EntityFuncs.DispatchKeyValue( pNewEnt.edict(), "target", target );

			if( netname != "" )
				g_EntityFuncs.DispatchKeyValue( pNewEnt.edict(), "netname", netname );

			g_EntityFuncs.DispatchSpawn( pNewEnt.edict() );
		}
	}
	return HOOK_HANDLED;
}

}

void MapInit()
{
	//Obligatory Survival stuff "Checkpoint entity".
	RegisterPointCheckPointEntity();
	//Anti rush "66% entity".
	RegisterTriggerOnceMpEntity();
	//Night Vision
    g_nv.MapInit();
	// Map support is enabled here by default.
	// So you don't have to add "mp_survival_supported 1" to the map config.
	g_SurvivalMode.EnableMapSupport();

	//Ins2 weapons.
	
	//Pistols.
	INS2_M9BERETTA::Register();
	//Revolver.
	INS2_M29::Register();
	//Deagle.
	INS2_DEAGLE::Register();
	//Shotgun.
	INS2_M590::Register();
	//Snipers.
	INS2_SVD::Register();
	//M16.
	INS2_AKM::Register();
	//My asval :c "Mp5".
	INS2_M16A4::Register();
	//Crossbow.
	INS2_M14EBR::Register();
	//Crowbar.
	INS2_KABAR::Register();
	//Pipewrench.
	RegisterCoFAXE();
	//Grenade.
	INS2_MK2GRENADE::Register();
	//Rpg.
	INS2_AT4::Register();
	//Special.
	RegisterCoFACTIONS();
	
	//Initialize classic mode (item mapping only).
	g_ClassicMode.SetItemMappings( @SC_BLKOPS::g_Ins2ItemMappings );
	//Replace forced weapon entities.
	g_ClassicMode.ForceItemRemap( true );
	//Idk what is this.
	g_Hooks.RegisterHook( Hooks::PickupObject::Materialize, @SC_BLKOPS::PickupObjectMaterialize );
	//Automatic set v_action weapon .
	g_Hooks.RegisterHook( Hooks::Player::PlayerPreThink, @SC_BLKOPS_PlayerPreThink );
}

void ActivateSurvival( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	g_SurvivalMode.Activate();
}

HookReturnCode SC_BLKOPS_PlayerPreThink( CBasePlayer@ pPlayer, uint& out uiFlags )
{
	if( pPlayer.m_hActiveItem.GetEntity() is null )
	{
		pPlayer.GiveNamedItem( "v_action" );
		pPlayer.SelectItem( "v_action" );
	}
	return HOOK_CONTINUE;
}