// Anti-Rush by Outerbeast
#include "anti_rush"
//Classic Mode
#include "HLSPClassicMode"
// CheckPoint
#include "point_checkpoint"

void MapInit() 
{
	RegisterAntiRushEntity();

	ClassicModeMapInit();

	RegisterPointCheckPointEntity();
 
	g_EngineFuncs.CVarSetFloat( "mp_hevsuit_voice", 1 );
}