class GameConfig {
  
  
  // ############################################################################################
  // Game Configuration Parameters:
  // ############################################################################################
  
  // Micro:Bit(s):
  
  final int MB_SERIAL_INDEX = 4; // Index in Serial.list() corresponding to Micro:Bit(s).
  final int MB_BAUD_RATE = 115200; // USB Baud Rate.
  final String MB_MSG_DELIM = ":"; // Message delimiter for comms with Micro:Bit(s).
  
  final color MB_CONNECTED_COL = color(0, 255, 0); // Colour representing connected Micro:Bit(s).
  final color MB_DISCONNECTED_COL = color(255, 0, 0); // Colour representing disconnected Micro:Bit(s).
  
  // CANVAS:
  
  final int FPS = 60; // Frame rate to use.
  
  final int CANVAS_WIDTH = displayWidth; // Width of canvas; screen width.
  final int CANVAS_HEIGHT = displayHeight; // Height of canvas; screen height.
  final color CANVAS_COLOR = color(0, 0, 0); // Background colour; black.
  
  final int TITLE_TEXT_SIZE = 24; // Default size of on-screen title text.
  final color TITLE_TEXT_COL_FILL = color(255, 255, 255); // Default colour of on-screen titles fill.
  final color TITLE_TEXT_COL_STROKE = color(0, 0, 0); // Default colour of on-screen titles stroke.
  
  // HUD:
  
  final color HUD_REG_COLOR = color(50, 50, 50, 150); // Colour of HUD background per player.
  final color HUD_DEATH_COLOR = color(200, 0, 0, 150); // Colour of HUD when player is dead.
  
  // PHYSICS:
  
  final float SPRING_COEFF = 0.001; // Defines springiness when objects bounce off each other.
  
  // PLAYERS:
  
  final int PLAYER_MAX_HEALTH = 100; // Maximum amount of player health.
  
  final int PLAYER_VEL_MULT = 30; // Multiplier determining player speed (lower is slower).
  
  final int PLAYER_SIZE = min(CANVAS_WIDTH, CANVAS_HEIGHT) / 30; // Size of players on screen.
  final color PLAYER_COLOR = color(255, 255, 255); // Colour of the players on screen.
  
  final int PLAYER_MAX_SHIELDS = 3; // Maximum amount of shields a player can have at once.
  final int PLAYER_SHIELD_TIMER = FPS * 3; // Duration used for a player being shielded.
  final int PLAYER_SHIELD_SIZE = PLAYER_SIZE * 2; // How big a shield appears on the screen.
  final color PLAYER_SHIELD_COLOR = color(0, 0, 255); // Colour to use for shield.
  
  final int PLAYER_MAX_DISRUPTS = 3; // Maximum number of disruptors a player can have at once.
  final int PLAYER_DISRUPT_TIMER = FPS * 3; // Duration used for a player being disrupted.
  final int PLAYER_DISRUPT_SIZE = PLAYER_SIZE * 2; // How big a disruption appears on the screen.
  final color PLAYER_DISRUPT_COLOR = color(255, 0, 0); // Colour to use for disrupt.
  
  // ASTEROIDS:
  
  final int AST_MIN_NUM = 25; // Minimum number of asteroids.
  final int AST_MAX_NUM = 50; // Maximum number of asteroids.
  final int AST_BOUNCE_NUM = 3; // The amount of times an asteroid can bounce off canvas boundaries before despawning.
  final float AST_HEALTH_PEN = 0.75; // Amount of player health (per frame) lost due to being hit by an asteroid.
  
  final float AST_INIT_VEL_FACT = 0.0005; // Factor used for limiting asteroid initial speed (per frame).
  final float AST_SCORE_VEL_INCR_FACT = 0.25; // Affects increase in asteroid speed with increasing score.
  
  final float AST_SPLIT_PROB = 0.001; // Probability that a given asteroid will split.
  final float AST_SPLIT_SIZE_FACT = 0.8; // Factor used to reduce asteroid size when a split occurs.
  
  final int AST_MIN_SIZE = min(CANVAS_WIDTH, CANVAS_HEIGHT) / 20; // Minimum size of asteroids.
  final int AST_MAX_SIZE = AST_MIN_SIZE * 3; // Maximum size of asteroids.
  final color AST_COLOR = color(100, 90, 60); // Colour of the asteroids.
  final color AST_SPLIT_COLOR = color(70, 63, 42); // Colour of the asteroids that have split (slightly darker).
  
  // SPACE JUNK:
  
  final int JUNK_NUM = 1; // How many pieces of space junk to spawn at once.
  final int JUNK_SCORE_PER = 1; // Score recorded as simply number of space junk collected.
  final float JUNK_HEALTH_PER = PLAYER_MAX_HEALTH / 20; // Health restored by collection of a piece of space junk.
  
  final float JUNK_SHIELD_PROB = 0.2; // Probability that a space junk will give a shield.
  final float JUNK_DISRUPT_PROB = 0.2; // Probability that a space junk will give a disrupt.
  
  final float JUNK_MOV_PROB = 0.7; // Probability of piece of junk moving (as opposed to stationary).
  final float JUNK_INIT_VEL_MULT = 0.8; // Multiplier to define junk initial speed (per frame).
  final float JUNK_SCORE_VEL_INCR_FACT = 0.1; // Affects increase in junk speed with increasing score.
  
  final int JUNK_SIZE = min(CANVAS_WIDTH, CANVAS_HEIGHT) / 75; // Size of space junk.
  final color JUNK_DEF_COLOR = color(180, 180, 180); // Default colour of the space junk.
  final color JUNK_SHIELD_COLOR = color(0, 0, 255); // Colour of space junk granting a shield.
  final color JUNK_DISRUPT_COLOR = color(255, 0, 0); // Colour of space junk granting a disrupt.
  
  // DISRUPTION:
  
  final int DISRUPT_RADIUS_FACT = 3; // How much larger is disrupt visual 'ripple' compared to object size.
  final int DISRUPT_NUM_CIRCLES = DISRUPT_RADIUS_FACT; // Number of circles used to form disruption 'ripple'.
  final float DISRUPT_STRENGTH_MULT = 0.025; // Strength by which asteroids are repelled by disruption.
  
  final color DISRUPT_COLOR = color(255, 0, 0, 150); // Disruption colour.
  final int DISRUPT_STROKE_WEIGHT = 7; // Weight of disruption 'ripple' lines.
  
  // SOUNDS:
  
  final String GAME_MUSIC_SND_LOC = "data/sounds/game_music.mp3"; // Relative path to the game music.
  final String GAME_OVER_SND_LOC = "data/sounds/game_over.mp3"; // Relative path to the game over sound.
  final String PLAYER_CONN_SND_LOC = "data/sounds/player_conn.mp3"; // Relative path to the player connection sound.
  final String COLLECT_JUNK_SND_LOC = "data/sounds/junk_collect.wav"; // Relative path to the collected junk sound.
  final String ACTIVE_SHIELD_SND_LOC = "data/sounds/active_shield.wav"; // Relative path to the activated shield sound.
  final String ACTIVE_DISRUPT_SND_LOC = "data/sounds/active_disrupt.wav"; // Relative path to the activated disrupt sound.
  final String HIT_AST_SND_LOC = "data/sounds/hit_asteroid.wav"; // Relative path to the asteroid hit sound.
  final String PLAYER_DEATH_SND_LOC = "data/sounds/player_death.mp3"; // Relative path to the player death sound.
  
  
} // GameConfig{}.
