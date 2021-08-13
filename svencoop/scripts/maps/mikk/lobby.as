//mapscript created to prevent the server entity overflowing when the server are empty.
//this problem just happend on linux and we dont know why. we just know this can be fixed
//when change level via NOT trigger_changelevel, Map script created by Gaftherman. Gordon MOTD Created By Outerbeast.

const int segundos = 60; // Cuantos segundos tiene un minuto p pavo. -how many seconds the minute have p pavo
const int minutos = 10.0f; // Los minutos que quieres que dure para que se reinicie el mapa. -how many minutes you want to run the map before restart
const string strWelcomeModel = "models/mikk/motd.mdl"; // Nombre del modelo. -name of the motd model

void MapInit()
{
	g_Hooks.RegisterHook( Hooks::Player::PlayerSpawn, @DrawGordonAnimation );
	g_Game.PrecacheModel( strWelcomeModel );
}

void MapActivate()
{
	g_Scheduler.SetTimeout( "ChangeMapXD", minutos * segundos );
}

void ChangeMapXD()
{
	g_EngineFuncs.ChangeLevel("campaign_vote_v1");
}

HookReturnCode DrawGordonAnimation(CBasePlayer@ pPlayer)
{
	if( pPlayer !is null )
	{
		pPlayer.pev.viewmodel = strWelcomeModel;
	}
	
	return HOOK_CONTINUE;
}