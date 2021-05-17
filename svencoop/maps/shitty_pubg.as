// shitty_pubg.as for shitty_pubg.bsp
// Disclaimer: I've never played PUBG
// I hope you die a painful death getting smashed in a func_vehicle_custom
// --incognico

#include "func_vehicle_custom"

array<int> userIDs;
//array<Vector> spawnpoints;
uint timer = 35;
bool g_active = false;
string g_winsound = "tu3sday/wingame.wav";
CScheduledFunction@ g_hpr = null;
CScheduledFunction@ g_pc = null;

const array<string> g_trees = {
	"hunger/vegitation/tree1.mdl",
	"hunger/vegitation/tree2.mdl",
	"hunger/vegitation/arc_xer_tree1.mdl",
	"hunger/vegitation/arc_xer_tree2.mdl",
	"hunger/vegitation/zalec_tree1.mdl",
	"sc_tetris/mushroom_red_large.mdl"
};

void MapInit()
{
	for( uint i = 0; i < g_trees.length() ; ++i ) {
		g_Game.PrecacheModel( "models/" + g_trees[i] );
	}
	g_Game.PrecacheModel( "sprites/rope.spr" );
	g_SoundSystem.PrecacheSound( g_winsound );

	g_Hooks.RegisterHook( Hooks::Player::ClientDisconnect, @ClientDisconnect );
	g_Hooks.RegisterHook( Hooks::Player::PlayerSpawn, @PlayerSpawn );
	g_Hooks.RegisterHook( Hooks::Player::PlayerKilled, @PlayerKilled );

	VehicleMapInit( true, true );

	g_Scheduler.SetTimeout( "Timer", 1 );
}

void TriggerAmbient()
{
	g_EntityFuncs.FireTargets( "wind", g_EntityFuncs.Instance(0), g_EntityFuncs.Instance(0), USE_ON, 0.0f, 0.0f );
}

void Timer()
{
	if ( timer > 2 )
	{
		g_Scheduler.SetTimeout( "Timer", 1 );
		g_PlayerFuncs.ClientPrintAll( HUD_PRINTCENTER, "Last Man Standing starts in: " + timer + " sec.\n" );
		timer--;
	}
	else
	{
		if ( g_PlayerFuncs.GetNumPlayers() < 2 ) 
			GameEnd();

		CreateSpawns();
		CreateVehicles();
		CreateTrees();
		TriggerAmbient();
		SpawnTrigger();
		@g_pc = g_Scheduler.SetInterval( "PanChecker", 0.5f );
	}
}

void SpawnTrigger()
{
	userIDs.resize(0);

	g_EntityFuncs.FireTargets( "spawn", g_EntityFuncs.Instance(0), g_EntityFuncs.Instance(0), USE_ON, 0.0f, 0.0f );

	uint pc = 0;
	
	for ( int i = 1; i <= g_Engine.maxClients; ++i )
	{
		if ( pc > 12 )
		{
			g_PlayerFuncs.ClientPrintAll( HUD_PRINTTALK, "[PvP] Maximum player slots reached :(\n" );
			break;
		}

		CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( i );
		
		if ( pPlayer !is null && pPlayer.IsConnected() && !pPlayer.IsAlive() )
		{
			g_PlayerFuncs.RespawnPlayer( pPlayer, true, true );
			pc++;
		}
	} // PvP prefab thingy only so or so much classifications

	g_active = true;
	
	g_EntityFuncs.FireTargets( "spawn", g_EntityFuncs.Instance(0), g_EntityFuncs.Instance(0), USE_OFF, 0.0f, 0.0f );

	for( uint i = 1; i <= 4; ++i )
	{
		g_EntityFuncs.FireTargets( "t" + i, g_EntityFuncs.Instance(0), g_EntityFuncs.Instance(0), USE_ON, 0.0f, 0.0f );
	}
}

void CreateSpawns()
{
	dictionary keyvalues = {
		{ "targetname", "spawn" },
		{ "spawnflags", "6" }
	};
	
	uint num = 0;

	for ( int i = 1; i <= g_Engine.maxClients; ++i )
	{
		CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( i );
		
		if ( pPlayer !is null && pPlayer.IsConnected() )
			num++;
	}
	
	for( uint i = 0; i < num; ++i )
	{
		Vector point = GeneratePoint();
		
		if ( point.z > -400 )
		{
			--i;
			continue;
		}

		if( ( point.x > -9000 && point.x < 9000 ) || ( point.y > -9000 && point.y < 9000 ) ) // not inner area
		{
			--i;
			continue;
		}

		if( ( point.x < -14000 || point.x > 14000 ) || ( point.y < -14000 || point.y > 14000 ) ) // not in very outer area
		{
			--i;
			continue;
		}
		
		//spawnpoints.insertLast( point );

		string originStr = "" + point.x + " " + point.y + " " + ( point.z + 200 );
		keyvalues["origin"] = originStr;

		g_EntityFuncs.CreateEntity( "info_player_deathmatch", keyvalues );
		
		CreateVehicle( Vector( point.x, point.y, point.z + 32 ) );
	}
}

void CreateVehicle( Vector origin )
{
	dictionary keyvalues = {
		{ "-width", "56" },
		{ "-volume", "6" },
		{ "targetname", "vehiclecreator2" },
		{ "-startspeed", "50" },
		{ "-speed", "768" },
		{ "-sounds", "2" },
		{ "m_iszCrtEntChildClass", "func_vehicle_custom" },
		{ "-length", "100" },
		{ "-height", "16" },
		{ "-bank", "0" },
		{ "-acceleration", "50" },
		{ "+model", "v2" }
	};

	string originStr = "" + origin.x + " " + origin.y + " " + origin.z;
	keyvalues["origin"] = originStr;
	
	g_EntityFuncs.CreateEntity( "trigger_createentity", keyvalues );
}

void CreateVehicles()
{
	g_EntityFuncs.FireTargets( "vehiclecreator",  g_EntityFuncs.Instance(0), g_EntityFuncs.Instance(0), USE_ON, 0.0f, 0.0f ); // big/fast v1 map center
	g_EntityFuncs.FireTargets( "vehiclecreator2", g_EntityFuncs.Instance(0), g_EntityFuncs.Instance(0), USE_ON, 0.0f, 0.0f ); // small/slow v2 for spawns
}

void CreateTrees()
{
	dictionary keyvalues = {
		{ "movetype", "0" },
		{ "angles", "0 " + Math.RandomLong( -180, 180 ) + " 0" },
		{ "spawnflags", "1024" }
	};

	for( uint i = 0; i < 256; ++i )
	{
		Vector point = GeneratePoint();
		
		/* for( uint j = 0; j < spawnpoints.length(); ++j ) {
		
			if( ( point.x > spawnpoints[j].x -256 && point.x < spawnpoints[j].x + 256 ) || ( point.y > spawnpoints[j].y -256 && point.y < spawnpoints[j].y + 256 ) ) // not near spawn
			{
				--i;
				break;
			}
		} */

		string originStr = "" + point.x + " " + point.y + " " + point.z;
		keyvalues["origin"] = originStr;

		keyvalues["model"] = "models/" + g_trees[Math.RandomLong( 0, g_trees.length() - 1 )];

		//CBaseEntity@ pNewEnt = g_EntityFuncs.CreateEntity( "cycler", keyvalues );
		CBaseEntity@ pNewEnt = g_EntityFuncs.CreateEntity( "item_generic", keyvalues );
	}
}

HookReturnCode PlayerKilled( CBasePlayer@ pPlayer, CBaseEntity@ pAttacker, int iGib )
{
	const int uid = g_EngineFuncs.GetPlayerUserId( pPlayer.edict() );

	int id = userIDs.find( uid );
	
	if( id >= 0 )
		userIDs.removeAt( id );

	string originStr = "" + pPlayer.pev.origin.x + " " + pPlayer.pev.origin.y + " " + pPlayer.pev.origin.z;
	
	dictionary keyvalues = {
		{ "movetype", "0" },
		{ "origin", originStr },
		{ "bullet357", "36" },
		{ "m40a1", "20" },
		{ "spawnflags", "1152" }
	};

	g_EntityFuncs.CreateEntity( "weaponbox", keyvalues );

	WinnerCheck();

	return HOOK_HANDLED;
}

HookReturnCode PlayerSpawn( CBasePlayer@ pPlayer )
{
	if ( g_active )
		return HOOK_CONTINUE;

	const int uid = g_EngineFuncs.GetPlayerUserId( pPlayer.edict() );

	userIDs.insertLast( uid );

	return HOOK_HANDLED;
}

HookReturnCode ClientDisconnect( CBasePlayer@ pPlayer )
{
	const int uid = g_EngineFuncs.GetPlayerUserId( pPlayer.edict() );

	int id = userIDs.find( uid );

	if( id >= 0 )	
		userIDs.removeAt( id );
		
	WinnerCheck();

	return HOOK_HANDLED;
}

Vector GeneratePoint()
{
	float a = -16000.0f;
	float b = 16000.0f;

	Vector randompoint = Vector( Math.RandomFloat( a, b ), Math.RandomFloat( a, b ), 1744 );
	
	TraceResult tr;

	g_Utility.TraceLine( randompoint, randompoint + Vector( 0, 0, -4000 ), ignore_monsters, null, tr );

	return tr.vecEndPos;
}

void Winner( CBasePlayer@ pPlayer )
{
	pPlayer.AddPoints( 1000, false );

	g_SoundSystem.PlaySound( g_EntityFuncs.IndexEnt(0), CHAN_STATIC, g_winsound, 1.0f, ATTN_NONE, 0, 100 );

	WinnerVote( pPlayer.pev.netname );
}

void WinnerVote( string pname )
{
	Vote@ EndVote = Vote( 'Winner!', "[WINNER!] " + pname + " WON!", 10.0f, 51.0f );

	EndVote.SetYesText( 'Play again' );
	EndVote.SetNoText( 'Next map' );
	EndVote.SetVoteBlockedCallback( @EndVoteBlocked );
	EndVote.SetVoteEndCallback( @EndVoteEnd );
	EndVote.Start();
}

void EndVoteEnd( Vote@ pVote, bool fResult, int iVoters )
{
    if ( fResult )
    {
		Intermission();

		g_Scheduler.SetTimeout( "RestartMap", 6 );
    }
    else
    {
		Intermission();
	
		g_Scheduler.SetTimeout( "GameEnd", 6 );
    }
}

void EndVoteBlocked( Vote@ pVote, float flTime )
{
	Intermission();

	g_Scheduler.SetTimeout( "GameEnd", 6 );
}

void WinnerCheck()
{
	if( g_active && userIDs.length() == 1 )
	{
	
		g_Scheduler.RemoveTimer( g_hpr );
		g_Scheduler.RemoveTimer( g_pc );
	
		for ( int i = 1; i <= g_Engine.maxClients; ++i )
		{
			CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( i );

			if ( pPlayer is null )
				continue;
			
			const int uid = g_EngineFuncs.GetPlayerUserId( pPlayer.edict() );

			if ( uid == userIDs[0] )
			{
				Winner( pPlayer );
				break;
			}
		}
	}
}

void PanChecker()
{
	for ( int i = 1; i <= g_Engine.maxClients; ++i )
	{
		CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( i );
		
		if ( pPlayer !is null && pPlayer.IsAlive() )
		{
			if( pPlayer.m_hActiveItem.GetEntity() !is null )
			{
				CBasePlayerWeapon@ pWeapon = cast<CBasePlayerWeapon@>( pPlayer.m_hActiveItem.GetEntity() );

				if( pWeapon !is null && pWeapon.GetClassname() == "weapon_crowbar" )
				{
					pPlayer.TakeArmor( 2.0f, DMG_GENERIC, 2.0f );
				}
				else
				{
					if( pPlayer.pev.armorvalue > 0.0f )
						pPlayer.TakeArmor( -2.0f, DMG_GENERIC, 0.0f );
				}
			}
		}
	}
}

void HPReduce( CBaseEntity@, CBaseEntity@, USE_TYPE, float )
{
	if( g_hpr is null )
	{
		g_PlayerFuncs.ClientPrintAll( HUD_PRINTCENTER, "SLOWLY REDUCING PLAYER HEALTH TO 0!\n" );

		@g_hpr = g_Scheduler.SetInterval( "TakeHealth", 3.75f );
	}
}

void TakeHealth()
{
	for( int i = 1; i <= g_Engine.maxClients; ++i )
	{
		CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( i );

		if ( pPlayer !is null && pPlayer.IsAlive() )
			pPlayer.TakeHealth( -1.0f, DMG_GENERIC, pPlayer.m_iMaxHealth );
	}
}

void GameEnd()
{
	g_EntityFuncs.FireTargets( "gameend", g_EntityFuncs.Instance(0), g_EntityFuncs.Instance(0), USE_ON, 0.0f, 0.0f );
}

void RestartMap()
{
	g_EngineFuncs.ChangeLevel( g_Engine.mapname );
}

void Intermission()
{
	NetworkMessage message( MSG_ALL, NetworkMessages::SVC_INTERMISSION, null );
	message.End();
}

