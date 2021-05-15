
namespace REPLACE
{

array<string> ToDosh =
{
	//ammo
	"ammo_9mmclip",
	"ammo_glockclip",
	"ammo_357",
	"ammo_uziclip",
	"ammo_9mmuziclip",
	"ammo_9mmAR",
	"ammo_9mmar",
	"ammo_mp5clip",
	"ammo_ARgrenades",
	"ammo_argrenades",
	"ammo_mp5grenades",
	"ammo_buckshot",
	"ammo_crossbow",
	"ammo_556clip",
	"ammo_rpgclip",
	"ammo_gaussclip",
	"ammo_egonclip",
	"ammo_762",
	"ammo_556",
	"ammo_spore",
	"ammo_sporeclip",
	"ammo_9mmbox",
	//weapons
	"weapon_357",
	"weapon_python",
	"weapon_eagle",
	"weapon_uzi",
	"weapon_uziakimbo",
	"weapon_9mmAR",
	"weapon_9mmar",
	"weapon_mp5",
	"weapon_shotgun",
	"weapon_crossbow",
	"weapon_m16",
	"weapon_rpg",
	"weapon_gauss",
	"weapon_egon",
	"weapon_hornetgun",
	"weapon_handgrenade",
	"weapon_satchel",
	"weapon_tripmine",
	"weapon_snark",
	"weapon_sniperrifle",
	"weapon_m249",
	"weapon_saw",
	"weapon_sporelauncher",
	"weapon_displacer",
	"weapon_minigun",
	"weapon_shockrifle"
};

array<ItemMapping@> ToReplace =
{
	//ammo
	ItemMapping( "ammo_9mmclip", "item_cash" ),
	ItemMapping( "ammo_glockclip", "item_cash" ),
	ItemMapping( "ammo_357", "item_cash" ),
	ItemMapping( "ammo_uziclip", "item_cash" ),
	ItemMapping( "ammo_9mmuziclip", "item_cash" ),
	ItemMapping( "ammo_9mmAR", "item_cash" ),
	ItemMapping( "ammo_9mmar", "item_cash" ),
	ItemMapping( "ammo_mp5clip", "item_cash" ),
	ItemMapping( "ammo_ARgrenades", "item_cash" ),
	ItemMapping( "ammo_argrenades", "item_cash" ),
	ItemMapping( "ammo_mp5grenades", "item_cash" ),
	ItemMapping( "ammo_buckshot", "item_cash" ),
	ItemMapping( "ammo_crossbow", "item_cash" ),
	ItemMapping( "ammo_556clip", "item_cash" ),
	ItemMapping( "ammo_rpgclip", "item_cash" ),
	ItemMapping( "ammo_gaussclip", "item_cash" ),
	ItemMapping( "ammo_egonclip", "item_cash" ),
	ItemMapping( "ammo_762", "item_cash" ),
	ItemMapping( "ammo_556", "item_cash" ),
	ItemMapping( "ammo_spore", "item_cash" ),
	ItemMapping( "ammo_sporeclip", "item_cash" ),
	ItemMapping( "ammo_9mmbox", "item_cash" ),
	//weapon
	ItemMapping( "weapon_crowbar", "weapon_csknife" ),
	ItemMapping( "weapon_pipewrench", "weapon_csknife" ),
	ItemMapping( "weapon_9mmhandgun", "weapon_usp" ),
	ItemMapping( "weapon_glock", "weapon_usp" ),
	ItemMapping( "weapon_357", "item_cash" ),
	ItemMapping( "weapon_python", "item_cash" ),
	ItemMapping( "weapon_eagle", "weapon_csdeagle" ),
	ItemMapping( "weapon_uzi", "item_cash" ),
	ItemMapping( "weapon_uziakimbo", "item_cash" ),
	ItemMapping( "weapon_9mmAR", "item_cash" ),
	ItemMapping( "weapon_9mmar", "item_cash" ),
	ItemMapping( "weapon_mp5", "item_cash" ),
	ItemMapping( "weapon_shotgun", "item_cash" ),
	ItemMapping( "weapon_crossbow", "item_cash" ),
	ItemMapping( "weapon_m16", "item_cash" ),
	ItemMapping( "weapon_rpg", "item_cash" ),
	ItemMapping( "weapon_gauss", "item_cash" ),
	ItemMapping( "weapon_egon", "item_cash" ),
	ItemMapping( "weapon_hornetgun", "item_cash" ),
	ItemMapping( "weapon_handgrenade", "item_cash" ),
	ItemMapping( "weapon_satchel", "item_cash" ),
	ItemMapping( "weapon_tripmine", "item_cash" ),
	ItemMapping( "weapon_snark", "item_cash" ),
	ItemMapping( "weapon_sniperrifle", "item_cash" ),
	ItemMapping( "weapon_m249", "item_cash" ),
	ItemMapping( "weapon_saw", "item_cash" ),
	ItemMapping( "weapon_sporelauncher", "item_cash" ),
	ItemMapping( "weapon_displacer", "item_cash" ),
	ItemMapping( "weapon_minigun", "item_cash" ),
	ItemMapping( "weapon_shockrifle", "item_cash" ),
	//items
	ItemMapping( "weaponbox", "weapon_c4" )
};

void ReplaceItem()
{
	CBaseEntity@ pItem = g_EntityFuncs.FindEntityByClassname( null, "*" );
	if( pItem !is null )
	{
		if( ToDosh.find( pItem.GetClassname().ToLowercase() ) >= 0 )
		{
			CBaseEntity@ pDosh = g_EntityFuncs.Create( "item_cash", pItem.pev.origin, pItem.pev.angles, false );
			if( pDosh !is null )
			{
				g_EntityFuncs.SetModel( pDosh, pItem.pev.model );
				g_EntityFuncs.Remove( pItem );

				g_Scheduler.SetTimeout( "ReplaceItem", 0.001 );
			}
		}
	}
}

HookReturnCode Materialize( CBaseEntity@ pOldItem )
{
	if( pOldItem is null ) 
		return HOOK_CONTINUE;

	for( uint i = 0; i < ToReplace.length(); ++i )
	{
		if( pOldItem.GetClassname() == ToReplace[i].get_From() )
		{
			CBaseEntity@ pNewItem = g_EntityFuncs.Create( ToReplace[i].get_To(), pOldItem.GetOrigin(), pOldItem.pev.angles, false );
			if( pNewItem is null ) 
				return HOOK_CONTINUE;

			pNewItem.pev.movetype = pOldItem.pev.movetype;

			if( pOldItem.GetTargetname() != "" )
				g_EntityFuncs.DispatchKeyValue( pNewItem.edict(), "targetname", pOldItem.GetTargetname() );

			if( pOldItem.pev.target != "" )
				g_EntityFuncs.DispatchKeyValue( pNewItem.edict(), "target", pOldItem.pev.target );

			if( pOldItem.pev.netname != "" )
				g_EntityFuncs.DispatchKeyValue( pNewItem.edict(), "netname", pOldItem.pev.netname );

			g_EntityFuncs.DispatchKeyValue( pNewItem.edict(), "m_flCustomRespawnTime", "-1" );
			g_EntityFuncs.DispatchKeyValue( pNewItem.edict(), "should_despawn", "1" );

			g_EntityFuncs.Remove( pOldItem );
		}
	}
	return HOOK_CONTINUE;
}

}

void ReplaceItemInit()
{
	g_ClassicMode.SetItemMappings( @REPLACE::ToReplace );
	g_ClassicMode.ForceItemRemap( true );

	g_Hooks.RegisterHook( Hooks::PickupObject::Materialize, @REPLACE::Materialize );
}

void ReplaceItemActivate()
{
	REPLACE::ReplaceItem();
}
