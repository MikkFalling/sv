//assault rifles
#include "IO_ins2/arifl/weapon_ins2akm"
#include "IO_ins2/arifl/weapon_ins2m16a4"
//handguns
#include "IO_ins2/handg/weapon_ins2usp"
#include "IO_ins2/handg/weapon_ins2m29"
#include "IO_ins2/handg/weapon_ins2python"
//lmgs
#include "IO_ins2/lmg/weapon_ins2m249"
//explosive
#include "IO_ins2/explo/weapon_ins2mk2"
//shotguns
#include "IO_ins2/shotg/weapon_ins2coach"
//melee
#include "IO_ins2/melee/weapon_ins2kabar"
//Obligatory Survival stuff
#include "point_checkpoint"

void MapInit()
{
	//assault rifles
	INS2_AKM::Register();
	INS2_M16A4::Register();
	//handguns
	INS2_USP::Register();
	INS2_M29::Register();
	INS2_PYTHON::Register();
	//lmg
	INS2_M249::Register();
	//explosive
	INS2_MK2GRENADE::Register();
	//shotgun
	INS2_COACH::Register();
	//melee
	INS2_KABAR::Register();
	//Obligatory Survival stuff
	RegisterPointCheckPointEntity();
	//Map support is enabled here by default.
	//So you don't have to add "mp_survival_supported 1" to the map config
	g_SurvivalMode.EnableMapSupport();
}

void ActivateSurvival( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	g_SurvivalMode.Activate();
}