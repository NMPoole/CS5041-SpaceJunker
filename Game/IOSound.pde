// ########################################################################
// GAME SOUND:
// ########################################################################

// Imports:
import ddf.minim.*;

class IOSound {
  
  
  // ########################################################################
  // Sound Attributes:
  // ########################################################################
  
  private AudioSample sndGameMusic; // Overall game music.
  private float sndGameMusic_Vol = -25; // Volume of sound.
  private boolean sndGameMusic_isPlaying = false; // Whether sound is playing.
  
  private AudioSample sndGameOver; // Sound played when game is over.
  private float sndGameOver_Vol = -20;
  private boolean sndGameOver_isPlaying = false;
  
  private AudioSample sndPlayerConn; // Player connected.
  private float sndPlayerConn_Vol = -10;
  
  private AudioSample sndCollectJunk; // Player collected junk.
  private float sndCollectJunk_Vol = -10;
  
  private AudioSample sndActiveShield; // Player activated shield.
  private float sndActiveShield_Vol = -10;
  
  private AudioSample sndActiveDisrupt; // Player activated disruptor.
  private float sndActiveDisrupt_Vol = -10;
  
  private AudioSample sndHitAsteroid; // Player htting asteroid.
  private float sndHitAsteroid_Vol = -25;
  
  private AudioSample sndPlayerDeath; // Player died.
  private float sndPlayerDeath_Vol = -10;
  
  
  // ########################################################################
  // Sound Constructors:
  // ########################################################################
  
  public IOSound() {
    
    // Pre-load Sound Files:
    
    // Game Music.
    this.sndGameMusic = minim.loadSample(gameConfig.GAME_MUSIC_SND_LOC);
    this.sndGameMusic.setGain(this.sndGameMusic_Vol);
    
    // Game Over Chime.
    this.sndGameOver = minim.loadSample(gameConfig.GAME_OVER_SND_LOC);
    this.sndGameOver.setGain(this.sndGameOver_Vol);
    
    // Player Connected Chime.
    this.sndPlayerConn = minim.loadSample(gameConfig.PLAYER_CONN_SND_LOC);
    this.sndPlayerConn.setGain(this.sndPlayerConn_Vol);
    
    // Player Collected Junk Chime.
    this.sndCollectJunk = minim.loadSample(gameConfig.COLLECT_JUNK_SND_LOC);
    this.sndCollectJunk.setGain(this.sndCollectJunk_Vol);
    
    // Player Activated Shield Chime.
    this.sndActiveShield = minim.loadSample(gameConfig.ACTIVE_SHIELD_SND_LOC);
    this.sndActiveShield.setGain(this.sndActiveShield_Vol);
    
    // Player Activated Disrupt Chime.
    this.sndActiveDisrupt = minim.loadSample(gameConfig.ACTIVE_DISRUPT_SND_LOC);
    this.sndActiveDisrupt.setGain(this.sndActiveDisrupt_Vol);
    
    // Player Is Hitting Asteroid Chime.
    this.sndHitAsteroid = minim.loadSample(gameConfig.HIT_AST_SND_LOC);
    this.sndHitAsteroid.setGain(this.sndHitAsteroid_Vol);
    
    // Player Died Chime.
    this.sndPlayerDeath = minim.loadSample(gameConfig.PLAYER_DEATH_SND_LOC);
    this.sndPlayerDeath.setGain(this.sndPlayerDeath_Vol);
    
  } // IOSound().
  
  
  // ########################################################################
  // Sound Methods:
  // ########################################################################
  
  public void toggleSndGameMusic(boolean play) {
    
    if (play && !this.sndGameMusic_isPlaying) {
      this.sndGameMusic.trigger();
      this.sndGameMusic_isPlaying = true;
    } else if (!play) {
      this.sndGameMusic.stop();
      this.sndGameMusic_isPlaying = false;
    }
    
  } // toggleSndGameMusic().
  
  public void toggleSndGameOver(boolean play) {
    
    if (play && !this.sndGameOver_isPlaying) {
      this.sndGameOver.trigger();
      this.sndGameOver_isPlaying = true;
    } else if (!play) {
      this.sndGameOver.stop();
      this.sndGameOver_isPlaying = false;
    }
    
  } // toggleSndGameOver().
  
  public void toggleSndPlayerConn(boolean play) {
    
    if (play) this.sndPlayerConn.trigger();
    else this.sndPlayerConn.stop();
    
  } // toggleSndPlayerConn().
  
  public void toggleSndCollectJunk(boolean play) {
    
    if (play) this.sndCollectJunk.trigger();
    else this.sndCollectJunk.stop();
    
  } // toggleSndCollectJunk().
  
  public void toggleSndActiveShield(boolean play) {
    
    if (play) this.sndActiveShield.trigger();
    else this.sndActiveShield.stop();
    
  } // toggleSndActiveShield().
  
  public void toggleSndActiveDisrupt(boolean play) {
    
    if (play) this.sndActiveDisrupt.trigger();
    else this.sndActiveDisrupt.stop();
    
  } // toggleSndActiveDisrupt().
  
  public void toggleSndHitAsteroid(boolean play) {
    
    if (play) this.sndHitAsteroid.trigger();
    else this.sndHitAsteroid.stop();
    
  } // toggleSndHitAsteroid().
  
  public void toggleSndPlayerDeath(boolean play) {
    
    if (play) this.sndPlayerDeath.trigger();
    else this.sndPlayerDeath.stop();
    
  } // toggleSndPlayerDeath().
  
  
} // IOSOund{}.
