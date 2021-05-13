/* 
* The original Half-Life version of the 9mm pistol
*/

const int GLOCK_DEFAULT_GIVE = 17;
const int _9MM_MAX_CARRY = 250;
const int _9MM_MAX_CLIP = 17;
const int GLOCK_WEIGHT = 10;

enum glock_e
{
	GLOCK_IDLE1 = 0,
	GLOCK_IDLE2,
	GLOCK_IDLE3,
	GLOCK_SHOOT,
	GLOCK_SHOOT_EMPTY,
	GLOCK_RELOAD,
	GLOCK_RELOAD_NOT_EMPTY,
	GLOCK_DRAW,
	GLOCK_HOLSTER,
	GLOCK_ADD_SILENCER
};

class weapon_9mmberetta : ScriptBasePlayerWeaponEntity
{
	private CBasePlayer@ m_pPlayer = null;
	int m_iShell;
	int m_iShotsFired;
	
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, "models/mikk/azuresheep/w_9mmhandgun.mdl" );
		
		self.m_iDefaultAmmo = GLOCK_DEFAULT_GIVE;
		m_iShotsFired = 0;

		self.FallInit(); // get ready to fall down.
	}
	
	void Precache()
	{
		g_Game.PrecacheModel( "models/mikk/azuresheep/v_9mmberetta.mdl" );
		g_Game.PrecacheModel( "models/mikk/azuresheep/w_9mmhandgun.mdl" );
		g_Game.PrecacheModel( "models/mikk/azuresheep/p_9mmhandgun.mdl" );
		
		m_iShell = g_Game.PrecacheModel( "models/shell.mdl" );
		
		g_SoundSystem.PrecacheSound( "items/9mmclip1.wav" );
		g_SoundSystem.PrecacheSound( "items/9mmclip2.wav" );

		g_SoundSystem.PrecacheSound( "mikk/azuresheep/beretta_fire1.wav" ); // silenced handgun
		g_SoundSystem.PrecacheSound( "weapons/hlclassic/pl_gun1.wav" ); // silenced handgun
		g_SoundSystem.PrecacheSound( "weapons/hlclassic/pl_gun2.wav" ); // silenced handgun
		g_SoundSystem.PrecacheSound( "weapons/hlclassic/pl_gun3.wav" ); // handgun
		
		g_Game.PrecacheGeneric( "sound/mikk/azuresheep/beretta_fire1.wav" );
		g_Game.PrecacheGeneric( "sound/weapons/hlclassic/pl_gun1.wav" );
		g_Game.PrecacheGeneric( "sound/weapons/hlclassic/pl_gun2.wav" );
		g_Game.PrecacheGeneric( "sound/weapons/hlclassic/pl_gun3.wav" );
		
		g_SoundSystem.PrecacheSound( "hl/weapons/357_cock1.wav" );
		
		g_Game.PrecacheGeneric( "sprites/hl_weapons/weapon_9mmberetta.txt" );
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
		info.iMaxAmmo1 	= _9MM_MAX_CARRY;
		info.iAmmo1Drop = _9MM_MAX_CLIP;
		info.iMaxAmmo2 	= -1;
		info.iAmmo2Drop	= -1;
		info.iMaxClip 	= _9MM_MAX_CLIP;
		info.iSlot 		= 1;
		info.iPosition 	= 7;
		info.iFlags 	= 0;
		info.iWeight 	= GLOCK_WEIGHT;
		
		return true;
	}
	
	bool Deploy()
	{
		bool fResult = self.DefaultDeploy( self.GetV_Model( "models/mikk/azuresheep/v_9mmberetta.mdl" ), self.GetP_Model( "models/mikk/azuresheep/p_9mmhandgun.mdl" ), GLOCK_DRAW, "onehanded" );
		
		float deployTime = 0.93f;
		self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + deployTime;
		
		return fResult;
	}
	
	void Holster(int skiplocal){
		
		self.m_fInReload = false;
		
		m_pPlayer.m_flNextAttack = g_Engine.time + 1.0; 
		
		BaseClass.Holster( skiplocal );
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
	
	void SecondaryAttack()
	{
		GlockFire( 0.1, 0.2 );
		
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
			self.SendWeaponAnim( GLOCK_SHOOT );
		else
			self.SendWeaponAnim( GLOCK_SHOOT_EMPTY );
		
		// player "shoot" animation
		m_pPlayer.SetAnimation( PLAYER_ATTACK1 );
		
		g_EngineFuncs.MakeVectors( m_pPlayer.pev.v_angle + m_pPlayer.pev.punchangle );
		
		Vector vecShellVelocity = m_pPlayer.pev.velocity + g_Engine.v_right * Math.RandomFloat( 50.0, 70.0 ) + g_Engine.v_up * Math.RandomFloat( 100.0, 150.0 ) + g_Engine.v_forward * 25;
		g_EntityFuncs.EjectBrass( self.pev.origin + m_pPlayer.pev.view_ofs + g_Engine.v_up * -12 + g_Engine.v_forward * 32 + g_Engine.v_right * 6, vecShellVelocity, self.pev.angles.y, m_iShell, TE_BOUNCE_SHELL );
		
		// silenced
		if ( self.pev.body == 1 )
		{
			m_pPlayer.m_iWeaponVolume = QUIET_GUN_VOLUME;
			m_pPlayer.m_iWeaponFlash = DIM_GUN_FLASH;
			
			switch( Math.RandomLong( 0, 1 ) )
			{
				case 0:
				{
					g_SoundSystem.EmitSound( m_pPlayer.edict(), CHAN_WEAPON, "weapons/hlclassic/pl_gun1.wav", Math.RandomFloat( 0.9, 1.0 ), ATTN_NORM );
					break;
				}
				case 1:
				{
					g_SoundSystem.EmitSound( m_pPlayer.edict(), CHAN_WEAPON, "weapons/hlclassic/pl_gun2.wav", Math.RandomFloat( 0.9, 1.0 ), ATTN_NORM );
					break;
				}
			}
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
		
		int m_iBulletDamage = Math.RandomLong( 13, 15 );
		m_pPlayer.FireBullets( 1, vecSrc, vecAiming, Vector( flSpread, flSpread, flSpread ), 8192, BULLET_PLAYER_CUSTOMDAMAGE, 2, m_iBulletDamage );
		
		self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + flCycleTime;
		
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
		if( self.m_iClip < _9MM_MAX_CLIP  )
		{
			BaseClass.Reload();
			m_iShotsFired = 0;
		}

		( self.m_iClip == 0 ) ? self.DefaultReload( _9MM_MAX_CLIP, GLOCK_RELOAD, 2.366, 0 ) : self.DefaultReload( _9MM_MAX_CLIP, GLOCK_RELOAD_NOT_EMPTY, 2.366, 0 );
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
				iAnim = GLOCK_IDLE3;
				self.m_flTimeWeaponIdle = WeaponTimeBase() + 49.0 / 16.0;
			}
			else if ( flRand <= 0.6 + 0 * 0.875 )
			{
				iAnim = GLOCK_IDLE1;
				self.m_flTimeWeaponIdle = WeaponTimeBase() + 60.0 / 16.0;
			}
			else
			{
				iAnim = GLOCK_IDLE2;
				self.m_flTimeWeaponIdle = WeaponTimeBase() + 40.0 / 16.0;
			}
			self.SendWeaponAnim( iAnim );
		}
	}
}

string GetHL9mmhandgunName()
{
	return "weapon_9mmberetta";
}

void RegisterHL9mmhandgun()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "weapon_9mmberetta", GetHL9mmhandgunName() );
	g_ItemRegistry.RegisterWeapon( GetHL9mmhandgunName(), "test", "9mm", "", "ammo_9mmclip", "" );
}
