class ObjPlayer extends ObjGameGeneric {
  
  
  // ########################################################################
  // Player Attributes:
  // ########################################################################
  
  // Player Attributes: position, velcity, size, and colour.
  
  private String ID; // Unique identifier for this player.
  
  private int score; // The score of this player.
  private float health; // The amount of health of this player.
  
  // Note: Player uses shields, which affects themself (shield themself).
  private int shieldsNum; // The number of shields this player has available.
  private int shieldTimer; // Whether this player is shielded (duration left).
  
  // Note: Player uses disrupts, which affects other players (disrupt other players/asteroids).
  private int disruptsNum; // The number of disruptors this player has available.
  private int disruptTimer; // Whether this player is disrupted (duration left).
  
  
  // ########################################################################
  // Player Constructors:
  // ########################################################################
  
  public ObjPlayer(float posX, float posY, float initVelX, float initVelY,
                   int playerSize, color playerColor, String playerID) {
    
    super(posX, posY, initVelX, initVelY, playerSize, playerColor);
    
    // Give ID, mostly just to make labelling players convenient.
    this.ID = playerID;
    
    // Player initially has no score.
    this.score = 0;
    
    // Assign player health initially with maximum player health.
    this.health = gameConfig.PLAYER_MAX_HEALTH;
    
    // Player starts with no shields, no disrupts, and is unaffected by these affects.
    this.shieldsNum = 0;
    this.shieldTimer = 0;
    this.disruptsNum = 0;
    this.disruptTimer = 0;
    
  } // ObjPlayer().
  
  
  // ########################################################################
  // Player State Methods:
  // ########################################################################
  
  public void update() {
    
    // Update player position if able to do so.
    // Disrupted players are forced to be stationary for a short period.
    if (!this.isDisrupted()) {
      
      // Update position using velocity.
      PVector forceAcc = this.getVelocity();
      this.setPosition(this.getPosition().add(forceAcc));
    
      this.hitDetection(); // Player interaction with other game objects.
      this.confineMovement(); // Player is confined to the canvas.
      
    }
    
    // Decrease the timer for any applied status effects.
    if (this.isShielded()) this.decrementShieldTimer();
    if (this.isDisrupted()) this.decrementDisruptTimer();
    
    // Check if player alive: send death message to the MB.
    if (!this.hasHealth()) {
      sendMsgPlayerDeath(this.ID);
      gameSound.toggleSndPlayerDeath(true);
    }
    
  } // update().
  
  private void hitDetection() {
    
    // Check interaction with other game object types.
    this.hitPlayers();
    this.hitAsteroids();
    this.hitJunk();
    this.hitDisruptions();
    
  } // hitDetection().
  
  private void hitPlayers() {
    
    // Check if player has hit any other players: bounce off them.
    for (HashMap.Entry<String, ObjPlayer> currPlayerEntry : gameState.getPlayers()) {
      ObjPlayer currPlayerObj = currPlayerEntry.getValue();
      this.bounce(currPlayerObj);
    }
    
  } // hitPlayers().
  
  private void hitAsteroids() {
    
    // Check if player has hit any asteroids: bounce off them and take damage.
    for (ObjAsteroid currAsteroid : gameState.getAsteroids()) {
      
      // Asteroids bounce off player.
      boolean bounced = this.bounce(currAsteroid);
      
      // Player not shielded and bounce/hit occurred.
      // i.e., player cannot be disrupted if they are shielded.
      if (!this.isShielded() && bounced) {
          this.applyAsteroidDamage(); // Apply affects of hitting asteroid.
          sendMsgRumble(this.ID, "AST"); // Send message to player Micro:Bit w/ hit type.
          gameSound.toggleSndHitAsteroid(true); // Play sound to show getting hit.
        }
      
    }
    
  } // hitAsteroids();
  
  private void hitJunk() {
    
    // Check if player hit space junk: retrieve score, health, possible status effectors, and reset junk.
    for (int currJunkIndex = 0; currJunkIndex < gameState.getNumSpaceJunk(); currJunkIndex++) {
      
      ObjSpaceJunk currJunk = gameState.getSpaceJunk().get(currJunkIndex);
      
      boolean collected = this.bounce(currJunk);
      
      if (collected) {
        
        // Apply effects of junk collection to the player.
        this.collectedJunk(currJunk.givesShield(), currJunk.givesDisrupt());
        
        // Replace the collected junk.
        gameState.replaceSpaceJunk(currJunkIndex);
        
      }
      
    }
    
  } // hitJunk().
  
  private void hitDisruptions() {
     
    // Check if player has hit any disruptions: player becomes disrupted.
    for (ObjDisruption currDisrupt : gameState.getDisruptions()) {

      // Player that triggered the disrupt is immune.
      if (!currDisrupt.getPlayerTriggered().equals(this.ID)) {
        
        // Check for a collisions.
        boolean collided = this.collide(currDisrupt);
        
        // This player becomes disrupted if not shielded.
        if (!this.isShielded() && collided) {
          this.setDisrupted();
          sendMsgRumble(this.ID, "DISR"); // Send message to player Micro:Bit w/ hit type.
        }
        
      }
        
    }
    
  } // hitDisruptions().
  
  private void confineMovement() {
    
    // Confine moveable area to the canvas:
    
    // Check within canvas width bounds.
    if (this.getPosX() > gameConfig.CANVAS_WIDTH) {
      this.setPosX(gameConfig.CANVAS_WIDTH);
    } else if (this.getPosX() < 0) {
      this.setPosX(0);
    }
    
    // Check within canvas height bounds.
    if (this.getPosY() > gameConfig.CANVAS_HEIGHT) {
      this.setPosY(gameConfig.CANVAS_HEIGHT);
    } else if (this.getPosY() < 0) {
      this.setPosY(0);
    }
    
  } // confineMovement().
  
  private void collectedJunk(boolean givenShield, boolean givenDisrupt) {
    
    gameSound.toggleSndCollectJunk(true); // Play alert that junk collected.
    
    // Add score to this player.
    this.score += gameConfig.JUNK_SCORE_PER;
    
    // Add to player health and confine health to the maximum.
    this.health += gameConfig.JUNK_HEALTH_PER;
    if (this.health > gameConfig.PLAYER_MAX_HEALTH) this.health = gameConfig.PLAYER_MAX_HEALTH;
    
    // Add to shields and disrupts if given by the junk collected.
    if (givenShield) this.incrementNumShields();
    if (givenDisrupt) this.incrementNumDisrupts();
    
  } // incrementScore().
  
  private void applyAsteroidDamage() {
    
    // Reduce player health (must remain positive).
    this.health -= gameConfig.AST_HEALTH_PEN;
    if (this.health < 0) this.health = 0;
    
  } // applyAsteroidDamage().
  
  public void activateShield() {
    
    // Player cannot activate shields if they themselves are disrupted.
    if (!this.isDisrupted()) {
      
      // Reduce number of shields this player has by 1.
      this.shieldsNum -= 1;
      
      // Set the shield timer for duration to be shielded for.
      this.shieldTimer = gameConfig.PLAYER_SHIELD_TIMER;
      
    }
    
  } // activateShield().
  
  public void decrementShieldTimer() {
    
    // Decrement shield timer (must remain positive).
    this.shieldTimer -= 1;
    if (this.shieldTimer < 0) this.shieldTimer = 0;
    
  } // decrementShieldTimer().
  
  public void incrementNumShields() {
    
    this.shieldsNum += 1; // Increment number of shields.
    if (this.shieldsNum > gameConfig.PLAYER_MAX_SHIELDS) this.shieldsNum = gameConfig.PLAYER_MAX_SHIELDS;
    
  } // incrementNumShields().
  
  private void activateDisrupt() {
    
    // Player cannot activate disrupts if they themselves are disrupted.
    if (!this.isDisrupted()) {
      
      // Reduce number of shields this player has by 1.
      this.disruptsNum -= 1;
    
      // Add disrupt to game state.
      gameState.addDisruption(this.getPosX(), this.getPosY(), this.getSize() * 2, this.ID);
      
    }
    
  } // activateDisrupt().
  
  private void setDisrupted() {
    
    // Set the disrupt timer for duration to be disrupted for.
    this.disruptTimer = gameConfig.PLAYER_DISRUPT_TIMER;
    
  } // setDisrupted().
  
  private void decrementDisruptTimer() {
    
    // Decrement disrupt timer (must remain positive).
    this.disruptTimer -= 1;
    if (this.disruptTimer < 0) this.disruptTimer = 0;
    
  } // decrementDisruptCnt().
  
  public void incrementNumDisrupts() {
    
    this.disruptsNum += 1; // Increment number of disrupts.
    if (this.disruptsNum > gameConfig.PLAYER_MAX_DISRUPTS) this.disruptsNum = gameConfig.PLAYER_MAX_DISRUPTS;
    
  } // incrementNumDisrupts().
  
  
  // ########################################################################
  // Player Draw/Render Methods:
  // ########################################################################
  
  public void display() {
    
    this.displayModel();
    
  } // display().
  
  private void displayModel() {
    
    // Drawing shield and disrupted status effects.
    if (this.isShielded()) {
      
      fill(gameConfig.PLAYER_SHIELD_COLOR);
      stroke(gameConfig.PLAYER_SHIELD_COLOR);
      ellipse(this.getPosX(), this.getPosY(), gameConfig.PLAYER_SHIELD_SIZE, gameConfig.PLAYER_SHIELD_SIZE);
      
    } else if (this.isDisrupted()) {
      
      fill(gameConfig.PLAYER_DISRUPT_COLOR);
      stroke(gameConfig.PLAYER_DISRUPT_COLOR);
      ellipse(this.getPosX(), this.getPosY(), gameConfig.PLAYER_DISRUPT_SIZE, gameConfig.PLAYER_DISRUPT_SIZE);
      
    }
    
    // Draw model: Simple circle representing player (whom may be disrupted).
    color playerColour = this.getColour();
    fill(playerColour);
    stroke(playerColour);
    ellipse(this.getPosX(), this.getPosY(), this.getSize(), this.getSize());
    
    // Label drawn player with player ID for player identification ease:
    int strX = int(this.getPosX());
    int strY = int(this.getPosY() - (0.7 * this.getSize()));
    text(this.ID, strX, strY);
    
  } // displayModel().
  
  
  // ########################################################################
  // Player Utility Methods:
  // ########################################################################
  
  public int getScore() {
    
    return this.score; // Return this player's score.
    
  } // getScore().
  
  public boolean hasHealth() {
    
    return (this.health > 0); // Return whether player has health remaining.
    
  } // hasHealth().
  
  public float getHealth() {
    
    return this.health; // Return this player's current amount of health.
    
  } // getHealth().
  
  public boolean hasShields() {
    
    return (this.shieldsNum > 0); // Whether there are shields available.
    
  } // hasShields().
  
  public boolean isShielded() {
    
    return (this.shieldTimer > 0); // Return whether this player is currently shielded.
    
  } // isShielded().
  
  public int getNumShields() {
    
    return this.shieldsNum; // Return this player's current amount of shields.
    
  } // getNumShields().
  
  public boolean hasDisrupts() {
    
    return (this.disruptsNum > 0); // Whether there are disrupts available.
    
  } // hasDisrupts().
  
  public boolean isDisrupted() {
    
    return (this.disruptTimer > 0); // Return whether this player is currently disrupted.
    
  } // isDisrupted().
  
  public int getNumDisrupts() {
    
    return this.disruptsNum; // Return this player's current amount of disrupts.
    
  } // getNumDisrupts().
  
  
} // ObjPlayer{}.
