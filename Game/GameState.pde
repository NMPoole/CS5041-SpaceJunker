// Imports:
import java.util.HashMap;
import java.util.Set;
import java.util.Iterator;


class GameState {
  
  
  // ########################################################################
  // Game State Attributes:
  // ########################################################################
  
  private HashMap<String, ObjPlayer> players; // Map Player IDs to player objects.
  private ArrayList<ObjAsteroid> asteroids; // Asteroid objects.
  private ArrayList<ObjSpaceJunk> spaceJunk; // Space Junk objects.
  private ArrayList<ObjDisruption> disruptions; // Active disruptions.
  
  
  // ########################################################################
  // Game State Constructors:
  // ########################################################################
  
  public GameState() {
    
    this.init(); // Initialise game state objects.
    
  } // GameState().
  
  
  // ########################################################################
  // General Game State Methods:
  // ########################################################################
  
  public void init() {
    
    // Initialising the games state means to initialise all game objects.
    this.initPlayers();
    this.initAsteroids();
    this.initSpaceJunk();
    this.initDisruptions();
    
  } // init().
  
  public void update() {
    
    // Updating the game state means updating all game objects.
    this.updatePlayers();
    this.updateAsteroids();
    this.updateSpaceJunk();
    this.updateDisruptions();
    
  } // update();
  
  public void display() {
    
    // Displaying the game state means display all game objects.
    this.displayPlayers();
    this.displayAsteroids();
    this.displaySpaceJunk();
    this.displayDisruptions();
    
    // Display HUD: player health, score, numShields, numDisrupts.
    this.displayHUD();
    
  } // display();
  
  private void displayHUD() {
    
    // Loop over all players, and display their relevant HUD.
    int playerNum = 1;
    for (String playerID : gameState.getPlayerIDs()) {
      
      ObjPlayer currPlayer = gameState.getPlayer(playerID);
      
      // Get positions of the HUDS:
      // Evenly distribute HUDS across the width of the screen.
      int posX = (playerNum * gameConfig.CANVAS_WIDTH) / (gameState.getNumPlayers() + 1);
      int posY = 15; // Display HUD at top of the screen.
      
      // Outline HUDs with semi-transparent rectangle so they are more readable.
      rectMode(CENTER);
      
      if (currPlayer.hasHealth()) fill(gameConfig.HUD_REG_COLOR);
      else fill(gameConfig.HUD_DEATH_COLOR);
      
      stroke(gameConfig.TITLE_TEXT_COL_FILL);
      rect(posX, posY, 200, 120);
      
      // Display HUD Text: Relevant information required by the player.
      String hudStr = "ID: " + playerID + "     " + "HEALTH: " + int(currPlayer.getHealth()) + "\n" +
                         "SCORE: " + currPlayer.getScore() + "\n" +
                         "SHIELDS: " + currPlayer.getNumShields() + "     " + "DISRUPTS: " + currPlayer.getNumDisrupts();
      fill(gameConfig.TITLE_TEXT_COL_FILL);
      stroke(gameConfig.TITLE_TEXT_COL_FILL);
      textAlign(CENTER);
      textSize(gameConfig.TITLE_TEXT_SIZE * 0.7);
      text(hudStr,posX, posY);
      
      playerNum += 1;
      
    }
    
  } // displayHUD().
  
  
  // ########################################################################
  // Win Condition Method:
  // ########################################################################
  
  public boolean gameEndCondition() {
    
    // The game is over when all players have ran out of health.
    boolean gameEnd = true;
    
    for (HashMap.Entry<String, ObjPlayer> currPlayerEntry : this.getPlayers()) {
      
      ObjPlayer currPlayerObj = currPlayerEntry.getValue();
      if (currPlayerObj.hasHealth()) gameEnd = false;
      
    }
    
    return gameEnd;
    
  } // gameEndCondition().
  
  // ########################################################################
  // Players Methods:
  // ########################################################################
  
  private void initPlayers() {
    
    // Players added by a connection process, so simply create the empty list.
    this.players = new HashMap<String, ObjPlayer>();
    
  } // initPlayers().
  
  public boolean addPlayer(String playerID) {
    
    // If the player is not already registered, then do so.
    if (!players.containsKey(playerID)) {
      
      // Player starts at center of the canvas.
      float initPosX = gameConfig.CANVAS_WIDTH / 2;
      float initPosY = gameConfig.CANVAS_HEIGHT / 2;
      
      // Add new player with given ID.
      players.put(playerID, new ObjPlayer(initPosX, initPosY, 0, 0, 
        gameConfig.PLAYER_SIZE, gameConfig.PLAYER_COLOR, playerID));
      
      return true; // Indicate player has been registered.
      
    } else {
      
      return false; // Indicate player did not have to be registered.
      
    }
    
  } // addPlayer().
  
  public void updatePlayers() {
    
    // Iterate over all players and update them.
    for (String currPlayerID : this.players.keySet()) {
      
      ObjPlayer currPlayer = this.players.get(currPlayerID);
      
      // Player is updated only if they are alive!
      if (currPlayer.hasHealth()) currPlayer.update();
      
    }
    
  } // updatePlayers().
  
  public void displayPlayers() {
    
    // Iterate over all players and display them.
    for (String currPlayerID : this.players.keySet()) {
      
      ObjPlayer currPlayer = this.players.get(currPlayerID);
      
      // Player is displayed only if they are alive!
      if (currPlayer.hasHealth()) currPlayer.display();
      
    }
    
  } // displayPlayers().
  
  public int getNumPlayers() {

    return this.players.size(); // Return the number of players.
    
  } // getNumPlayers().
  
  public Set<String> getPlayerIDs() {
    
    return this.players.keySet(); // Return the set of player IDs.
    
  } // getPlayerIDs().
  
  public Set<HashMap.Entry<String, ObjPlayer>> getPlayers() {
    
    return this.players.entrySet(); // Return the HashMap.
    
  } // getPlayers().
  
  public ObjPlayer getPlayer(String playerID) {
    
    return this.players.get(playerID); // Return player object for requested player ID.
    
  } // getPlayer().
  
  private int getHighestScore() {
    
    // Find the current highest score of all the players.
    // This affects the difficulty of the game.
    
    int highestScore = 0;
    
    for (HashMap.Entry<String, ObjPlayer> currPlayerEntry : this.getPlayers()) {
      
      ObjPlayer currPlayerObj = currPlayerEntry.getValue();
      
      int currPlayerScore = currPlayerObj.getScore();
      if (currPlayerScore > highestScore) highestScore = currPlayerScore;
      
    }
    
    return highestScore;
    
  } // getHighestScore().
  
  
  // ########################################################################
  // Asteroid Methods:
  // ########################################################################
  
  public void initAsteroids() {
    
    this.asteroids = new ArrayList<ObjAsteroid>();

    // Create as many asteroids as specified.
    for (int i = 0; i < gameConfig.AST_MIN_NUM; i++) this.addAsteroid(-1, -1);
    
  } // initAsteroids().
  
  public void addAsteroid(float posX, float posY) {
    
    // Determine asteroid size: some random size determined by the game config.
    int asteroidSize = int(random(gameConfig.AST_MIN_SIZE, gameConfig.AST_MAX_SIZE));
  
    // If valid posX and posY given, then initialise asteroid there, otherwise...
    if (posX == -1 && posY == -1) {
      
      // Change posX and posY: Start off-screen somewhere randomly at any side.
      float chosenProb = random(0, 1);
      
      // Choose a side of the screen to spawn the asteroid at.
      // Spawn the asteroid slightly off screen.
      if (chosenProb < 0.25) { // Left-side.
        posX = -asteroidSize;
        posY = random(0, gameConfig.CANVAS_HEIGHT);
      } else if (chosenProb >= 0.25 && chosenProb < 0.5) { // Top-side.
        posX = random(0, gameConfig.CANVAS_WIDTH);
        posY = -asteroidSize;
      } else if (chosenProb >= 0.5 && chosenProb < 0.75) { // Right-side.
        posX = gameConfig.CANVAS_WIDTH + asteroidSize;
        posY = random(0, gameConfig.CANVAS_HEIGHT);
      } else if (chosenProb >= 0.75) { // Bottom-side.
        posX = random(0, gameConfig.CANVAS_WIDTH);
        posY = gameConfig.CANVAS_HEIGHT + asteroidSize;
      }
      
    }
    
    // Find screen center point to make sure all asteroids move towards the screen.
    float centerPosX = gameConfig.CANVAS_WIDTH / 2;
    float centerPosY = gameConfig.CANVAS_HEIGHT / 2;
    
    // Velocity of asteroids will be increased with score.
    int scoreMult = this.getHighestScore();
    if (scoreMult < 1) scoreMult = 1;
    
    // Initial speed in x- and y- direction towards the screen canvas.
    PVector initVel = new PVector(centerPosX - posX, centerPosY - posY);
    // Apply some velocity scaling as determined by the game configuration.
    initVel = initVel.mult(gameConfig.AST_INIT_VEL_FACT);
    // Apply velocity scaling based on current score, so asteroids get faster gradually.
    initVel = initVel.mult(1 + (scoreMult * gameConfig.AST_SCORE_VEL_INCR_FACT));

    // Add new asteroid to set of active asteroids.
    this.asteroids.add(new ObjAsteroid(posX, posY, initVel.x, initVel.y,
      asteroidSize, gameConfig.AST_COLOR, gameConfig.AST_BOUNCE_NUM));
    
  } // addAsteoid().
  
  public void updateAsteroids() {
    
    Iterator<ObjAsteroid> asteroidsIter = this.asteroids.iterator();
    
    // Update every asteroid.
    while (asteroidsIter.hasNext()) {
      
      ObjAsteroid currAsteroid = asteroidsIter.next();
      boolean asteroidExpired = currAsteroid.update();
      
      // Asteroid may need to be removed if bounces exceeded.
      if (asteroidExpired) asteroidsIter.remove();
      
    }
    
    // Add new asteroids when old ones expire.
    while (this.getNumAsteroids() < gameConfig.AST_MIN_NUM) this.addAsteroid(-1, -1);
    
    // Asteroids can split at random, as long as there aren't too many already.
    if (random(0, 1) < gameConfig.AST_SPLIT_PROB && this.getNumAsteroids() < gameConfig.AST_MAX_NUM) {
    
      int randAstIndex = int(random(this.getNumAsteroids())); // Pick random asteroid.
      this.splitAsteroid(randAstIndex); // Split asteroid.
    
    }
    
  } // updateAsteroids().
  
  private void splitAsteroid(int asteroidIndex) {

    ObjAsteroid asteroidToSplit = this.asteroids.get(asteroidIndex);

    // First asteroid in split.
    this.asteroids.add(new ObjAsteroid(asteroidToSplit.getPosX(), asteroidToSplit.getPosY(),
                                   asteroidToSplit.getVelX(), asteroidToSplit.getVelY(),
                                   int(asteroidToSplit.getSize() * gameConfig.AST_SPLIT_SIZE_FACT),
                                   gameConfig.AST_SPLIT_COLOR, 
                                   asteroidToSplit.getNumBounces()));
        
    // Second asteroid in split; give opposite horizontal velocity component.
    this.asteroids.add(new ObjAsteroid(asteroidToSplit.getPosX(), asteroidToSplit.getPosY(),
                                   -asteroidToSplit.getVelX(), asteroidToSplit.getVelY(),
                                   int(asteroidToSplit.getSize() * gameConfig.AST_SPLIT_SIZE_FACT),
                                   gameConfig.AST_SPLIT_COLOR, 
                                   asteroidToSplit.getNumBounces()));

    // Remove original asteroid.
    this.asteroids.remove(asteroidToSplit);
    
  } // splitAsteroid().
  
  public void displayAsteroids() {
    
    // Display every asteroid.
    for (ObjAsteroid currAsteroid : this.asteroids) currAsteroid.display();
    
  } // displayAsteroids().
  
  public int getNumAsteroids() {
    
    return this.asteroids.size(); // Return number of asteroids.
    
  } // getNumAsteroids().
  
  public ArrayList<ObjAsteroid> getAsteroids () {
    
    return this.asteroids; // Return set of asteroids.
    
  }
  
  
  // ########################################################################
  // Space Junk Methods:
  // ########################################################################
  
  private void initSpaceJunk() {
    
    this.spaceJunk = new ArrayList<ObjSpaceJunk>();
    
    // Initialise array list of space junk.
    for (int i = 0; i < gameConfig.JUNK_NUM; i++) {
      ObjSpaceJunk newJunk = createSpaceJunk(); // Create random space junk.
      this.spaceJunk.add(newJunk); // Add to list of space junk yet to be collected.
    }
    
  } // initSpaceJunk().
  
  private void replaceSpaceJunk(int spaceJunkIndex) {
    
    // Gievn the index of a junk object, replace that junk with new instance.
    // Allows for easier replacement of junk that has been collected with new junk.
    ObjSpaceJunk newJunk = createSpaceJunk();
    gameState.getSpaceJunk().set(spaceJunkIndex, newJunk);
    
  } // replaceSpaceJunk().
  
  private ObjSpaceJunk createSpaceJunk() {
    
    // Space junk is assigned a random starting position on the canvas.
    float posX = random(0, gameConfig.CANVAS_WIDTH);
    float posY = random(0, gameConfig.CANVAS_HEIGHT - 50);
    
    // Based on probability, space junk may be moving.
    float velX = 0;
    float velY = 0;
    
    // Determine whether the junk will be moving on the screen.
    if (random(0, 1) < gameConfig.JUNK_MOV_PROB) {
      
      // Highest score is used for scaling speed, and therefore difficulty.
      int scoreMult = this.getHighestScore();
      if (scoreMult < 1) scoreMult = 1;
      
      // Space junk can head in any random direction.
      float initVelX = random(-1, 1);
      float initVelY = random(-1, 1);
      PVector velocity = new PVector(initVelX, initVelY);
      
      // Apply some initial velcity scaling as determined by the game configuration.
      velocity = velocity.mult(gameConfig.JUNK_INIT_VEL_MULT);
      // Apply velocity scaling based on current score, so junk gets faster.
      velocity = velocity.mult(1 + (scoreMult * gameConfig.JUNK_SCORE_VEL_INCR_FACT));
      
      velX = velocity.x;
      velY = velocity.y;
      
    }

    // Return newly create space junk instance.
    return new ObjSpaceJunk(posX, posY, velX, velY, gameConfig.JUNK_SIZE, gameConfig.JUNK_DEF_COLOR);
    
  } // createSpaceJunk().
  
  private void updateSpaceJunk() {
    
    // Update all uncollected space junk.
    for (ObjSpaceJunk currJunk : this.spaceJunk) currJunk.update();
    
  } // updateSpaceJunk().
  
  private void displaySpaceJunk() {
    
    // Draw all uncollected space junk.
    for (ObjSpaceJunk currJunk : this.spaceJunk) currJunk.display();
    
  } // displaySpaceJunk().
  
  public ArrayList<ObjSpaceJunk> getSpaceJunk() {
    
    return this.spaceJunk; // Return the space junk list.
    
  } // getSpaceJunk().
  
  public int getNumSpaceJunk() {
    
    return this.spaceJunk.size(); // Return the amount of space junk.
    
  } // getNumSpaceJunk().
  
  
  // ########################################################################
  // Disruptions Methods:
  // ########################################################################
  
  private void initDisruptions() {
    
    // Disruptions are added with player input when they have disrupts available.
    this.disruptions = new ArrayList<ObjDisruption>();
    
  } // initDisruptions().
  
  public void addDisruption(float posX, float posY, int initSize, String playerTriggered) {
    
    // Add disruption to the game.
    this.disruptions.add(new ObjDisruption(posX, posY, initSize, gameConfig.DISRUPT_COLOR, playerTriggered));  
    
  } // addDisruption().
  
  private void updateDisruptions() {
    
    Iterator<ObjDisruption> disruptionsIter = this.disruptions.iterator();
    
    // Update all disruptions, which may involve removing expired ones.
    while (disruptionsIter.hasNext()) {
      
      ObjDisruption currDisrupt = disruptionsIter.next();
      
      // Update current disruption.
      boolean disruptFinished = currDisrupt.update();
      
      // Disruptions need to be removed if finished.
      if (disruptFinished) disruptionsIter.remove();
      
    }
    
  } // updateDisruptions().
  
  private void displayDisruptions() {
    
    // Display all disruptions.
    for (ObjDisruption currDisruption : this.disruptions) currDisruption.display();
    
  } // displayDisruptions().
  
  public ArrayList<ObjDisruption> getDisruptions() {
    
    return this.disruptions; // Return list of active disruptions.
    
  } // getDisruptions().
  
  
} // GameState{}.
