/* 
* The original Azure-Sheep version of the Beretta by Gaftherman
* Que rico te mueves Sara - By Mikk
*/


enum beretta_e
{
	BERETTA_IDLE1 = 0,
	BERETTA_IDLE2,
	BERETTA_IDLE3,
	BERETTA_SHOOT,
	BERETTA_SHOOT_EMPTY,
	BERETTA_RELOAD,
	BERETTA_RELOAD_NOT_EMPTY,
	BERETTA_DRAW,
	BERETTA_HOLSTER,
	BERETTA_ADD_SILENCER
};

namespace BERETTA
{

const string BERETTA_A_MODEL = "models/w_uzi_clip.mdl";

const int BERETTA_DEFAULT_GIVE = 15;
const int BERETTA_MAX_CARRY = 250;
const int BERETTA_MAX_CLIP = 15;
const int BERETTA_WEIGHT = 10;
const int BERETTA_AMMO_GIVE = 20;

class weapon_beretta : ScriptBasePlayerWeaponEntity
{
	private CBasePlayer@ m_pPlayer = null;
	int m_iShell;
	int m_iShotsFired;
	
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, "models/mikk/azuresheep/w_9mmberetta.mdl" );
		
		self.m_iDefaultAmmo = BERETTA_DEFAULT_GIVE;
		m_iShotsFired = 0;

		self.FallInit(); // Get ready to fall down.
	}
	
	void Precache()
	{
		//Modelos que a todos les chupa medio huevo
		g_Game.PrecacheModel( "models/mikk/azuresheep/v_9mmberetta.mdl" );
		g_Game.PrecacheModel( "models/mikk/azuresheep/w_9mmberetta.mdl" );
		g_Game.PrecacheModel( "models/mikk/azuresheep/p_9mmberetta.mdl" );
		g_Game.PrecacheModel( BERETTA_A_MODEL );
		//Balas al caer
		m_iShell = g_Game.PrecacheModel( "models/shell.mdl" );
		//Sonido de arma sin municion
		g_SoundSystem.PrecacheSound( "items/9mmclip1.wav" );
		g_SoundSystem.PrecacheSound( "items/9mmclip2.wav" );
		//Beretta Sound
		g_SoundSystem.PrecacheSound( "mikk/azuresheep/beretta_fire1.wav" );
		//Beretta Sound ( Solo para asegurarme )
		g_Game.PrecacheGeneric( "sound/mikk/azuresheep/beretta_fire1.wav" );
		
		g_SoundSystem.PrecacheSound( "hl/weapons/357_cock1.wav" );
		
		
		g_Game.PrecacheGeneric( "sprites/test/weapon_beretta.txt" );
	}
	
	float WeaponTimeBase()
	{
		return g_Engine.time; //g_WeaponFuncs.WeaponTimeBase();
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
	
	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1 	= BERETTA_MAX_CARRY;
		info.iMaxAmmo2 	= -1;
		info.iMaxClip 	= BERETTA_MAX_CLIP;
		info.iSlot 		= 1;
		info.iPosition 	= 7;
		info.iFlags 	= 0;
		info.iWeight 	= BERETTA_WEIGHT;
		
		return true;
	}
	
	bool Deploy()
	{
		bool fResult = self.DefaultDeploy( self.GetV_Model( "models/mikk/azuresheep/v_9mmberetta.mdl" ), self.GetP_Model( "models/mikk/azuresheep/p_9mmberetta.mdl" ), BERETTA_DRAW, "onehanded" ); // Modelos V y P del arma
		
		float deployTime = 0.93f;
		self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = g_Engine.time + deployTime;
		
		return fResult;
	}
	
	void PrimaryAttack()
	{
		GlockFire( 0.01, 0.30 );
		
		m_iShotsFired++;
		if( m_iShotsFired > 1 )
		{
			return;
		}
	}
	
	void GlockFire( float& in flSpread, float& in flCycleTime )
	{
		if ( self.m_iClip <= 0 )
		{
			if ( self.m_bFireOnEmpty )
			{
				PlayEmptySound();
				self.m_flNextPrimaryAttack = g_Engine.time + 0.2;
			}
			
			return;
		}
		
		self.m_iClip--;
		
		m_pPlayer.pev.effects |= EF_MUZZLEFLASH;
		
		if ( self.m_iClip != 0 )
			self.SendWeaponAnim( BERETTA_SHOOT );
		else
			self.SendWeaponAnim( BERETTA_SHOOT_EMPTY );
		
		// La animacion de disparo del jugador
		m_pPlayer.SetAnimation( PLAYER_ATTACK1 );
		
		g_EngineFuncs.MakeVectors( m_pPlayer.pev.v_angle + m_pPlayer.pev.punchangle );
		
		Vector vecShellVelocity = m_pPlayer.pev.velocity + g_Engine.v_right * Math.RandomFloat( 50.0, 70.0 ) + g_Engine.v_up * Math.RandomFloat( 100.0, 150.0 ) + g_Engine.v_forward * 25;
		g_EntityFuncs.EjectBrass( self.pev.origin + m_pPlayer.pev.view_ofs + g_Engine.v_up * -12 + g_Engine.v_forward * 32 + g_Engine.v_right * 6, vecShellVelocity, self.pev.angles.y, m_iShell, TE_BOUNCE_SHELL );
		
		// Arma con silenciador (no hay xd)
		if ( self.pev.body == 1 )
		{
		
		}
		else
		{
			// non-silenced
			m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
			m_pPlayer.m_iWeaponFlash = NORMAL_GUN_FLASH;
			g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "mikk/azuresheep/beretta_fire1.wav", Math.RandomFloat( 0.92, 1.0 ), ATTN_NORM, 0, 98 + Math.RandomLong( 0, 3 ) );
		}
		
		Vector vecSrc = m_pPlayer.GetGunPosition();
		Vector vecAiming;
		
		vecAiming = g_Engine.v_forward;
		
		int m_iBulletDamage = Math.RandomLong( 15, 18 );
		m_pPlayer.FireBullets( 1, vecSrc, vecAiming, Vector( flSpread, flSpread, flSpread ), 8192, BULLET_PLAYER_CUSTOMDAMAGE, 2, m_iBulletDamage );
		
		self.m_flNextPrimaryAttack = WeaponTimeBase() + flCycleTime;
		
		self.m_flTimeWeaponIdle = WeaponTimeBase() + Math.RandomFloat( 10.0, 15.0 );
		
		m_pPlayer.pev.punchangle.x -= 2;
		
		// Decal
		TraceResult tr;
		float x, y;
		
		g_Utility.GetCircularGaussianSpread( x, y );
		
		Vector vecSpread = Vector( flSpread, flSpread, flSpread );
		Vector vecDir = vecAiming + x * vecSpread.x * g_Engine.v_right + y * vecSpread.y * g_Engine.v_up;
		Vector vecEnd = vecSrc + vecDir * 4096;
		
		g_Utility.TraceLine( vecSrc, vecEnd, dont_ignore_monsters, m_pPlayer.edict(), tr );
		
		if( tr.flFraction < 1.0 )
		{
			if( tr.pHit !is null )
			{
				CBaseEntity@ pHit = g_EntityFuncs.Instance( tr.pHit );
				
				if( pHit is null || pHit.IsBSPModel() )
					g_WeaponFuncs.DecalGunshot( tr, BULLET_PLAYER_9MM );
			}
		}
	}
	
	void Reload()
	{
		if( self.m_iClip < BERETTA_MAX_CLIP  )
		{
			BaseClass.Reload();
			m_iShotsFired = 0;
		}

		( self.m_iClip == 0 ) ? self.DefaultReload( BERETTA_MAX_CLIP, BERETTA_RELOAD, 2.366, 0 ) : self.DefaultReload( BERETTA_MAX_CLIP, BERETTA_RELOAD_NOT_EMPTY, 2.366, 0 ); // Velocidad de recarga del arma 
	}

	void WeaponIdle()
	{
		self.ResetEmptySound();
		
		if ( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;
		
		// only idle if the slid isn't back
		if( self.m_iClip != 0 )
		{
			int iAnim;
			float flRand = Math.RandomFloat( 0.0, 1.0 );
			if ( flRand <= 0.3 + 0 * 0.75 )
			{
				iAnim = BERETTA_IDLE3;
				self.m_flTimeWeaponIdle = WeaponTimeBase() + 49.0 / 16.0;
			}
			else if ( flRand <= 0.6 + 0 * 0.875 )
			{
				iAnim = BERETTA_IDLE1;
				self.m_flTimeWeaponIdle = WeaponTimeBase() + 60.0 / 16.0;
			}
			else
			{
				iAnim = BERETTA_IDLE2;
				self.m_flTimeWeaponIdle = WeaponTimeBase() + 40.0 / 16.0;
			}
			self.SendWeaponAnim( iAnim );
		}
	}
}

class RicosaraAmmo : ScriptBasePlayerAmmoEntity // Nombre de la municion
{
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, BERETTA_A_MODEL );
		BaseClass.Spawn();
	}

	void Precache()
	{
		g_Game.PrecacheModel( BERETTA_A_MODEL );
		g_SoundSystem.PrecacheSound( "items/9mmclip1.wav" );
	}

	bool AddAmmo( CBaseEntity@ pOther )
	{
		int iGive;

		iGive = BERETTA_AMMO_GIVE;

		if( pOther.GiveAmmo( iGive, "ammo_ricosara", BERETTA_MAX_CARRY ) != -1 )
		{
			g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM );
			return true;
		}
		return false;
	}
}

string GetBerettaName() // Registrar el arma y su nombre
{
	return "weapon_beretta";
}

string GetBerettaAmmoName() // Registrar la municion y su nombre
{
	return "ammo_ricosara";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "BERETTA::weapon_beretta", GetBerettaName() ); // Register el arma como entidad
	g_CustomEntityFuncs.RegisterCustomEntity( "BERETTA::RicosaraAmmo", GetBerettaAmmoName() ); // Register la municion como entidad
	g_ItemRegistry.RegisterWeapon( GetBerettaName(), "test", GetBerettaAmmoName(), "", GetBerettaAmmoName() ); // Register el arma y la municion que tira. "test" = carpeta donde estan los .spr
}

}
