#include "mikk/checkpoint_spawner"
#include "hlsp/trigger_suitcheck"
#include "AzureSheep/HLSPClassicMode"
#include "cubemath/trigger_once_mp"
#include "cubemath/polling_check_players"

void MapInit()
{
	RegisterCheckPointSpawnerEntity();
	RegisterTriggerSuitcheckEntity();
	RegisterTriggerOnceMpEntity();
	
	g_EngineFuncs.CVarSetFloat( "mp_hevsuit_voice", 1 );
	
	ClassicModeMapInit();
  poll_check();
}
