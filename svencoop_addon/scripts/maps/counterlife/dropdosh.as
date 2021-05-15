#include "droplist"

namespace DROPDOSH
{

CScheduledFunction@ MonsterDropDosh = null;
dictionary MonsterList;
int UniqueID = 0;

class MonsterSave
{ 
	edict_t@ ent;
	float health;
	Vector lastpos, lastang;
};

void Starters()
{
	CBaseEntity@ pMonster = g_EntityFuncs.FindEntityByClassname( null, "monster_*" );
	while( pMonster !is null )
	{
		string szClass = pMonster.GetClassname();
		if( !pMonster.IsPlayerAlly() && !( NoDropDosh.find( pMonster.GetClassname().ToLowercase() ) >= 0 ) )
		{
			MonsterSave data;
			@data.ent = pMonster.edict();
			data.health = pMonster.pev.health;
			data.lastpos = pMonster.pev.origin;
			data.lastang = pMonster.pev.angles;
			MonsterList[ szClass + formatInt( UniqueID ) ] = data;
			UniqueID++;	
		}
		@pMonster = g_EntityFuncs.FindEntityByClassname( pMonster, "monster_*" );		
	}
}

void DropDoshThink()
{
	array<string> m_Monsters = MonsterList.getKeys();

	for( uint uiIndex = 0; uiIndex < m_Monsters.length(); ++uiIndex )
	{
		string szName = m_Monsters[ uiIndex ];
		MonsterSave data = cast<MonsterSave>( MonsterList[ szName ] );
		CBaseEntity@ pMonster = g_EntityFuncs.Instance( data.ent );
		if( pMonster is null )
			MonsterList.delete( szName );

		else
		{
			if( pMonster.pev.deadflag >= DEAD_DYING )
			{ // always includes registered monsters when they are gibbed? nope! find a way to do it
				if( TierOne.find( pMonster.GetClassname().ToLowercase() ) >= 0 )
				{
					int iAmount = Math.RandomLong( 1, 3 );
					for( int i = 0; i < iAmount; i++ )
					{
						Vector vecAiming = Vector( Math.RandomFloat( 0, 360 ), Math.RandomFloat( 0, 360 ), Math.RandomFloat( 0, 360 ) );
						CBaseEntity@ cash = g_EntityFuncs.Create( "item_cash", pMonster.pev.origin, Vector( 0, Math.RandomFloat( 0, 360 ), 0 ), false, null );
						Math.MakeVectors( vecAiming );
						cash.pev.velocity = vecAiming.Normalize() + g_Engine.v_forward * Math.RandomLong( 256, 512 );
						if( cash !is null )
						{
							g_EngineFuncs.DropToFloor( cash.edict() );
							cash.KeyValue( "m_flCustomRespawnTime", "-1" );
							cash.KeyValue( "should_despawn", "1" );
						}
						MonsterList.delete( szName );
					}
				}
				else if( TierTwo.find( pMonster.GetClassname().ToLowercase() ) >= 0 )
				{
					int iAmount = Math.RandomLong( 3, 5 );
					for( int i = 0; i < iAmount; i++ )
					{
						Vector vecAiming = Vector( Math.RandomFloat( 0, 360 ), Math.RandomFloat( 0, 360 ), Math.RandomFloat( 0, 360 ) );
						CBaseEntity@ cash = g_EntityFuncs.Create( "item_cash", pMonster.pev.origin, Vector( 0, Math.RandomFloat( 0, 360 ), 0 ), false, null );
						Math.MakeVectors( vecAiming );
						cash.pev.velocity = vecAiming.Normalize() + g_Engine.v_forward * Math.RandomLong( 512, 1024 );
						if( cash !is null )
						{
							g_EngineFuncs.DropToFloor( cash.edict() );
							cash.KeyValue( "m_flCustomRespawnTime", "-1" );
							cash.KeyValue( "should_despawn", "1" );
						}
						MonsterList.delete( szName );
					}
				}
				else if( TierThree.find( pMonster.GetClassname().ToLowercase() ) >= 0 )
				{
					int iAmount = Math.RandomLong( 10, 50 );
					for( int i = 0; i < iAmount; i++ )
					{
						Vector vecAiming = Vector( Math.RandomFloat( 0, 360 ), Math.RandomFloat( 0, 360 ), Math.RandomFloat( 0, 360 ) );
						CBaseEntity@ cash = g_EntityFuncs.Create( "item_cash", pMonster.pev.origin, Vector( 0, Math.RandomFloat( 0, 360 ), 0 ), false, null );
						Math.MakeVectors( vecAiming );
						cash.pev.velocity = vecAiming.Normalize() + g_Engine.v_forward * Math.RandomLong( 1024, 2048 );
						if( cash !is null )
						{
							g_EngineFuncs.DropToFloor( cash.edict() );
							cash.KeyValue( "m_flCustomRespawnTime", "-1" );
							cash.KeyValue( "should_despawn", "1" );
						}
						MonsterList.delete( szName );
					}
				}
				else
				{
					int iAmount = Math.RandomLong( 1, 10 );
					for( int i = 0; i < iAmount; i++ )
					{
						Vector vecAiming = Vector( Math.RandomFloat( 0, 360 ), Math.RandomFloat( 0, 360 ), Math.RandomFloat( 0, 360 ) );
						CBaseEntity@ cash = g_EntityFuncs.Create( "item_cash", pMonster.pev.origin, Vector( 0, Math.RandomFloat( 0, 360 ), 0 ), false, null );
						Math.MakeVectors( vecAiming );
						cash.pev.velocity = vecAiming.Normalize() + g_Engine.v_forward * Math.RandomLong( 256, 2048 );
						if( cash !is null )
						{
							g_EngineFuncs.DropToFloor( cash.edict() );
							cash.KeyValue( "m_flCustomRespawnTime", "-1" );
							cash.KeyValue( "should_despawn", "1" );
						}
						MonsterList.delete( szName );
					}
				}
			}
			else
			{
				MonsterSave ndata;
				@ndata.ent = pMonster.edict();
				float nhealth = data.health;
				if( nhealth < pMonster.pev.health )
					nhealth = pMonster.pev.health;

				ndata.health = nhealth;
				ndata.lastpos = pMonster.pev.origin;
				ndata.lastang = pMonster.pev.angles;
				MonsterList[ szName ] = ndata;
			}
			//g_Game.AlertMessage( at_console, "LOOPED AND GOT THIS BAD BOY: %1\n", data.ent.GetClassname() );
		}
	}
}

HookReturnCode MapChange()
{
	g_Scheduler.RemoveTimer( MonsterDropDosh );
	@MonsterDropDosh = null;

	MonsterList.deleteAll();

	return HOOK_CONTINUE;
}

HookReturnCode EntityCreated( CBaseEntity@ pMonster )
{
	string szClass = pMonster.GetClassname();
	if( szClass.Find( "monster_" ) != String::INVALID_INDEX )
	{
		if( !pMonster.IsPlayerAlly() && !( NoDropDosh.find( pMonster.GetClassname().ToLowercase() ) >= 0 ) )
		{
			MonsterSave data;
			@data.ent = pMonster.edict();
			data.health = pMonster.pev.health;
			data.lastpos = pMonster.pev.origin;
			data.lastang = pMonster.pev.angles;
			MonsterList[ szClass + formatInt( UniqueID ) ] = data;
			UniqueID++;
		}
	}
	return HOOK_CONTINUE;
}

}

void DropDoshInit()
{
	@DROPDOSH::MonsterDropDosh = g_Scheduler.SetInterval( "DropDoshThink", 0.1, g_Scheduler.REPEAT_INFINITE_TIMES);

	g_Hooks.RegisterHook( Hooks::Game::MapChange, @DROPDOSH::MapChange );
	g_Hooks.RegisterHook( Hooks::Game::EntityCreated, @DROPDOSH::EntityCreated );
}

void DropDoshActivate()
{
	DROPDOSH::Starters();
}
