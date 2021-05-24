/*  
* The original Azure-Sheep version of the 9mmm41a by Gaftherman
* Que rico te mueves Sara - By Mikk
*/

enum Mp5Animation
{
	T9MMM41A_LONGIDLE = 0,
	T9MMM41A_IDLE1,
	T9MMM41A_LAUNCH,
	T9MMM41A_RELOAD,
	T9MMM41A_DEPLOY,
	T9MMM41A_FIRE1,
	T9MMM41A_FIRE2,
	T9MMM41A_FIRE3,
};

namespace T9MM41A
{

const string T9MMM41A_A_MODEL = "models/w_uzi_clip.mdl";

const int T9MMM41A_DEFAULT_GIVE = 50;
const int T9MMM41A_MAX_AMMO		= 250;
const int T9MMM41A_MAX_AMMO2 	= 10;
const int T9MMM41A_MAX_CLIP 	= 50;
const int T9MMM41A_WEIGHT 		= 5;
const int T9MMM41A_AMMO_GIVE 	= 20;

class weapon_9mmm41a : ScriptBasePlayerWeaponEntity
{
	private CBasePlayer@ m_pPlayer = null;
	
	float m_flNextAnimTime;
	int m_iShell;
	int	m_iSecondaryAmmo;
	int m_iBulletDamage = Math.RandomLong( 19, 20 );
	
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, "models/mikk/azuresheep/w_9mmm41a.mdl" );

		self.m_iDefaultAmmo = T9MMM41A_DEFAULT_GIVE;

		self.m_iSecondaryAmmoType = 0;
		self.FallInit();
	}

	void Precache()
	{
		self.PrecacheCustomModels();
		g_Game.PrecacheModel( "models/mikk/azuresheep/v_9mmm41a.mdl" );
		g_Game.PrecacheModel( "models/mikk/azuresheep/w_9mmm41a.mdl" );
		g_Game.PrecacheModel( "models/mikk/azuresheep/p_m16a2.mdl" );
		g_Game.PrecacheModel( T9MMM41A_A_MODEL );
		
		m_iShell = g_Game.PrecacheModel( "models/shell.mdl" );

		g_Game.PrecacheModel( "models/grenade.mdl" );

		g_Game.PrecacheModel( "models/w_9mmARclip.mdl" );
		g_SoundSystem.PrecacheSound( "items/9mmclip1.wav" );              

		//These are played by the model, needs changing there
		g_SoundSystem.PrecacheSound( "hl/items/clipinsert1.wav" );
		g_SoundSystem.PrecacheSound( "hl/items/cliprelease1.wav" );

		g_SoundSystem.PrecacheSound( "mikk/azuresheep/m41ahks1.wav" );
		g_SoundSystem.PrecacheSound( "mikk/azuresheep/m41ahks2.wav" );

		g_SoundSystem.PrecacheSound( "mikk/azuresheep/m41aglauncher.wav" );
		g_SoundSystem.PrecacheSound( "mikk/azuresheep/m41aglauncher2.wav" );

		g_SoundSystem.PrecacheSound( "hl/weapons/357_cock1.wav" );
		
		g_Game.PrecacheGeneric( "sprites/test/320hud1.spr" );
		g_Game.PrecacheGeneric( "sprites/test/320hud3.spr" );
		g_Game.PrecacheGeneric( "sprites/test/320hudas1.spr" );
		g_Game.PrecacheGeneric( "sprites/test/320hudas2.spr" );
		g_Game.PrecacheGeneric( "sprites/test/640hud1.spr" );
		g_Game.PrecacheGeneric( "sprites/test/640hud4.spr" );
		g_Game.PrecacheGeneric( "sprites/test/640hud5.spr" );
		g_Game.PrecacheGeneric( "sprites/test/640hudas1.spr" );
		g_Game.PrecacheGeneric( "sprites/test/640hudas2.spr" );
		g_Game.PrecacheGeneric( "sprites/test/640hudas3.spr" );
		g_Game.PrecacheGeneric( "sprites/test/640hudas4.spr" );
		g_Game.PrecacheGeneric( "sprites/test/640hudas5.spr" );
		g_Game.PrecacheGeneric( "sprites/test/640hudas6.spr" );
		g_Game.PrecacheGeneric( "sprites/test/640hudas7.spr" );
		g_Game.PrecacheGeneric( "sprites/test/crosshairs.spr" );
		g_Game.PrecacheGeneric( "sprites/test/crosshairsas.spr" );
		g_Game.PrecacheGeneric( "sprites/test/muzzleflash1.spr" );
		g_Game.PrecacheGeneric( "sprites/test/weapon_9mmm41a.txt" );
		
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1 	= T9MMM41A_MAX_AMMO;
		info.iMaxAmmo2 	= T9MMM41A_MAX_AMMO2;
		info.iMaxClip 	= T9MMM41A_MAX_CLIP;
		info.iSlot 		= 2;
		info.iPosition 	= 4;
		info.iFlags 	= 0;
		info.iWeight 	= T9MMM41A_WEIGHT;

		return true;
	}

	bool AddToPlayer( CBasePlayer@ pPlayer )
	{
		if( BaseClass.AddToPlayer( pPlayer ) )
		{
			NetworkMessage message( MSG_ONE, NetworkMessages::WeapPickup, pPlayer.edict() );
				message.WriteLong( self.m_iId );
			message.End();
			
			@m_pPlayer = pPlayer;
			
			return true;
		}
		
		return false;
	}
	
	bool PlayEmptySound()
	{
		if( self.m_bPlayEmptySound )
		{
			self.m_bPlayEmptySound = false;
			
			g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "hl/weapons/357_cock1.wav", 0.8, ATTN_NORM, 0, PITCH_NORM );
		}
		
		return false;
	}

	bool Deploy()
	{
		bool fResult = self.DefaultDeploy( self.GetV_Model( "models/mikk/azuresheep/v_9mmm41a.mdl" ), self.GetP_Model( "models/mikk/azuresheep/p_m16a2.mdl" ), T9MMM41A_DEPLOY, "mp5" );
		
		float deployTime = 1.15f;
		self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + deployTime;
		
		return fResult;
	}
	
	void Holster(int skiplocal)
	{
		
		self.m_fInReload = true;
		
		BaseClass.Holster( skiplocal );
	}
	
	float WeaponTimeBase()
	{
		return g_Engine.time; //g_WeaponFuncs.WeaponTimeBase();
	}

	void PrimaryAttack()
	{
		// don't fire underwater
		if( m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD )
		{
			self.PlayEmptySound( );
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.15;
			return;
		}

		if( self.m_iClip <= 0 )
		{
			self.PlayEmptySound();
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.15;
			return;
		}

		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = NORMAL_GUN_FLASH;

		--self.m_iClip;
		
		switch ( g_PlayerFuncs.SharedRandomLong( m_pPlayer.random_seed, 0, 2 ) )
		{
		case 0: self.SendWeaponAnim( T9MMM41A_FIRE1, 0, 0 ); break;
		case 1: self.SendWeaponAnim( T9MMM41A_FIRE2, 0, 0 ); break;
		case 2: self.SendWeaponAnim( T9MMM41A_FIRE3, 0, 0 ); break;
		}
		
		g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "mikk/azuresheep/m41ahks1.wav", 1.0, ATTN_NORM, 0, 95 + Math.RandomLong( 0, 10 ) );

		// Player "shoot" animation
		m_pPlayer.SetAnimation( PLAYER_ATTACK1 );

		Vector vecSrc	 = m_pPlayer.GetGunPosition();
		Vector vecAiming = m_pPlayer.GetAutoaimVector( AUTOAIM_5DEGREES );
		
		m_pPlayer.FireBullets( 1, vecSrc, vecAiming, VECTOR_CONE_6DEGREES, 8192, BULLET_PLAYER_CUSTOMDAMAGE, 2, m_iBulletDamage );
		
		// Optimized multiplayer. Widened to make it easier to hit a moving player
		if( self.m_iClip == 0 && m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			// HEV suit - indicate out of ammo condition
			m_pPlayer.SetSuitUpdate( "!HEV_AMO0", false, 0 );
			
		m_pPlayer.pev.punchangle.x = Math.RandomLong( -2, 2 );

		self.m_flNextPrimaryAttack = self.m_flNextPrimaryAttack + 0.1;
		if( self.m_flNextPrimaryAttack < WeaponTimeBase() )
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.1;

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed,  10, 15 );
		
		TraceResult tr;
		
		float x, y;
		
		g_Utility.GetCircularGaussianSpread( x, y );
		
		Vector vecDir = vecAiming 
						+ x * VECTOR_CONE_6DEGREES.x * g_Engine.v_right 
						+ y * VECTOR_CONE_6DEGREES.y * g_Engine.v_up;

		Vector vecEnd	= vecSrc + vecDir * 4096;

		g_Utility.TraceLine( vecSrc, vecEnd, dont_ignore_monsters, m_pPlayer.edict(), tr );
		
		if( tr.flFraction < 1.0 )
		{
			if( tr.pHit !is null )
			{
				CBaseEntity@ pHit = g_EntityFuncs.Instance( tr.pHit );
				
				if( pHit is null || pHit.IsBSPModel() )
					g_WeaponFuncs.DecalGunshot( tr, BULLET_PLAYER_MP5 );
			}
		}
	}

	void SecondaryAttack()
	{
		// don't fire underwater
		if( m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD )
		{
			self.PlayEmptySound();
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.15;
			return;
		}
		
		if( m_pPlayer.m_rgAmmo(self.m_iSecondaryAmmoType) <= 0 )
		{
			self.PlayEmptySound();
			return;
		}


		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		m_pPlayer.m_iExtraSoundTypes = bits_SOUND_DANGER;
		m_pPlayer.m_flStopExtraSoundTime = WeaponTimeBase() + 0.2;

		m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType ) - 1 );

		m_pPlayer.pev.punchangle.x = -10.0;

		self.SendWeaponAnim( T9MMM41A_LAUNCH );

		// player "shoot" animation
		m_pPlayer.SetAnimation( PLAYER_ATTACK1 );

		if ( g_PlayerFuncs.SharedRandomLong( m_pPlayer.random_seed, 0, 1 ) != 0 )
		{
			// play this sound through BODY channel so we can hear it if player didn't stop firing MP3
			g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "mikk/azuresheep/m41aglauncher.wav", 0.8, ATTN_NORM, 0, PITCH_NORM );
		}
		else
		{
			// play this sound through BODY channel so we can hear it if player didn't stop firing MP3
			g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "mikk/azuresheep/m41aglauncher2.wav", 0.8, ATTN_NORM, 0, PITCH_NORM );
		}
	
		Math.MakeVectors( m_pPlayer.pev.v_angle + m_pPlayer.pev.punchangle );

		// we don't add in player velocity anymore.
		if( ( m_pPlayer.pev.button & IN_DUCK ) != 0 )
		{
			g_EntityFuncs.ShootContact( m_pPlayer.pev, 
								m_pPlayer.pev.origin + g_Engine.v_forward * 16 + g_Engine.v_right * 6, 
								g_Engine.v_forward * 900 ); //800
		}
		else
		{
			g_EntityFuncs.ShootContact( m_pPlayer.pev, 
								m_pPlayer.pev.origin + m_pPlayer.pev.view_ofs * 0.5 + g_Engine.v_forward * 16 + g_Engine.v_right * 6, 
								g_Engine.v_forward * 900 ); //800
		}
		self.m_flNextPrimaryAttack = WeaponTimeBase() + 1;
		self.m_flNextSecondaryAttack = WeaponTimeBase() + 1;
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 5;// idle pretty soon after shooting.

		if( m_pPlayer.m_rgAmmo(self.m_iSecondaryAmmoType) <= 0 )
			// HEV suit - indicate out of ammo condition
			m_pPlayer.SetSuitUpdate( "!HEV_AMO0", false, 0 );
	}

	void Reload()
	{
		self.DefaultReload( T9MMM41A_MAX_CLIP, T9MMM41A_RELOAD, 1.645, 0 );

		//Set 3rd person reloading animation -Sniper
		BaseClass.Reload();
	}

	void WeaponIdle()
	{
		self.ResetEmptySound();

		m_pPlayer.GetAutoaimVector( AUTOAIM_5DEGREES );

		if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;

		int iAnim;
		switch( g_PlayerFuncs.SharedRandomLong( m_pPlayer.random_seed,  0, 1 ) )
		{
		case 0:	
			iAnim = T9MMM41A_LONGIDLE;	
			break;
		
		case 1:
			iAnim = T9MMM41A_IDLE1;
			break;
			
		default:
			iAnim = T9MMM41A_IDLE1;
			break;
		}

		self.SendWeaponAnim( iAnim );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed,  10, 15 );// how long till we do this again.
	}
}

class RicosaraAmmo : ScriptBasePlayerAmmoEntity // Nombre de la municion
{
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, T9MMM41A_A_MODEL );
		BaseClass.Spawn();
	}

	void Precache()
	{
		g_Game.PrecacheModel( T9MMM41A_A_MODEL );
		g_SoundSystem.PrecacheSound( "items/9mmclip1.wav" );
	}

	bool AddAmmo( CBaseEntity@ pOther )
	{
		int iGive;

		iGive = T9MMM41A_AMMO_GIVE;

		if( pOther.GiveAmmo( iGive, "ammo_ricosara", T9MMM41A_MAX_AMMO ) != -1 )
		{
			g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM );
			return true;
		}
		return false;
	}
}

string Get9mmm41aName()
{
	return "weapon_9mmm41a";
}

string Get9mmm41aAmmoName() // Registrar la municion y su nombre
{
	return "ammo_ricosara";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "T9MM41A::weapon_9mmm41a", Get9mmm41aName() ); // Register el arma como entidad
	g_CustomEntityFuncs.RegisterCustomEntity( "T9MM41A::RicosaraAmmo", Get9mmm41aAmmoName() ); // Register la municion como entidad
	g_ItemRegistry.RegisterWeapon( Get9mmm41aName(), "test", Get9mmm41aAmmoName(), "ARgrenades", Get9mmm41aAmmoName() ); // Register el arma y la municion que tira. "test" = carpeta donde estan los .spr
}

}