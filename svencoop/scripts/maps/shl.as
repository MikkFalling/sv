#include "point_checkpoint"
#include "shl/trigger_suitcheck"
#include "shl/trigger_once_mp"
#include "shl/polling_check_players"
#include "leveldead_loadsaved"
#include "shl/HLSPClassicMode2"

void MapInit()
{
	RegisterPointCheckPointEntity();
	RegisterTriggerSuitcheckEntity();
	RegisterTriggerOnceMpEntity();
	ClassicModeMapInit();
	
	g_EngineFuncs.CVarSetFloat( "mp_classic_mode", 1 );
	g_EngineFuncs.CVarSetFloat( "mp_hevsuit_voice", 1 );
	
  poll_check();
}

void ActivateSurvival(CBaseEntity@ pActivator,CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	g_SurvivalMode.Activate();
}

