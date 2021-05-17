#include "point_checkpoint"
#include "hlsp/trigger_suitcheck"
#include "Eshq_custom/HLSPClassicMode"
#include "cubemath/trigger_once_mp"
#include "cubemath/polling_check_players"

void MapInit()
{
	RegisterPointCheckPointEntity();
	RegisterTriggerSuitcheckEntity();
	RegisterTriggerOnceMpEntity();
	
	g_EngineFuncs.CVarSetFloat( "mp_hevsuit_voice", 1 );
	
	ClassicModeMapInit();
  poll_check();
}
