#include "point_checkpoint"
#include "HLSPClassicMode"
#include "hlsp/trigger_suitcheck"
#include "hl_weapons/weapon_hlshotgun"
#include "hl_weapons/weapon_hlmp5"
#include "cubemath/trigger_once_mp"
#include "cubemath/polling_check_players"
#include "blkopnvision"

void MapInit()
{
	RegisterPointCheckPointEntity();
	RegisterTriggerSuitcheckEntity();
	RegisterTriggerOnceMpEntity();
	//RegisterWeaponDebug();
	
	g_EngineFuncs.CVarSetFloat( "mp_hevsuit_voice", 1 );
	
	ClassicModeMapInit();
  poll_check();
  g_nv.MapInit();
}
