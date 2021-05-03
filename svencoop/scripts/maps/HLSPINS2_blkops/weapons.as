const bool p_Customizable = true; // Needed to define custom/default ammo

//assault rifles
#include "arifl/weapon_ins2akm"
#include "arifl/weapon_ins2m16a4"
//battle rifles
#include "brifl/weapon_ins2m14ebr"
//handguns
#include "handg/weapon_ins2beretta"
#include "handg/weapon_ins2m29"
#include "handg/weapon_ins2deagle"
//explosives/launchers
#include "explo/weapon_ins2mk2"
#include "explo/weapon_ins2at4"
//shotguns
#include "shotg/weapon_ins2m590"
//melees
#include "melee/weapon_ins2kabar"
#include "melee/weapon_cofaxe"
#include "melee/v_actions"
//sniper rifles
#include "srifl/weapon_ins2dragunov"

void RegisterAll()
{
	//Pistols
	INS2_M9BERETTA::Register();
	//Revolver
	INS2_M29::Register();
	//Deagle
	INS2_DEAGLE::Register();
	//Shotgun
	INS2_M590::Register();
	//Snipers
	INS2_SVD::Register();
	//M16
	INS2_AKM::Register();
	//My asval :c "Mp5"
	INS2_M16A4::Register();
	//Crossbow
	INS2_M14EBR::Register();
	//Crowbar
	INS2_KABAR::Register();
	//Pipewrench
	RegisterCoFAXE();
	//Grenade
	INS2_MK2GRENADE::Register();
	//Rpg
	INS2_AT4::Register();
	//Special
	RegisterCoFACTIONS();
	
}