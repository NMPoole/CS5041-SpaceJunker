class ObjAsteroid extends ObjGameGeneric {

  
  // ########################################################################
  // Asteroid Attributes:
  // ########################################################################
  
  // Asteroid Attributes: position, velocity, size, and colour.
  
  private boolean inScreen; // Whether this asteroid is within the canvas or not.
  private int numBounces; // The number of bounces an asteroid can endure before despawning.
  
  
  // ########################################################################
  // Asteroid Constructors:
  // ########################################################################
  
  ObjAsteroid(float initPosX, float initPosY, float initVelX, float initVelY, 
          int meteorSize, color meteorColor, int numBounces) {
              
    // Init game object w/ velocity.
    super(initPosX, initPosY, initVelX, initVelY, meteorSize, meteorColor);
    
    this.inScreen = false; // Asteroids start off the screen.
    this.numBounces = numBounces; // Set num bounces asteroid can endure.
    
  } // ObjAsteroid().
  
  
  // ########################################################################
  // Asteroid State Methods:
  // ########################################################################
  
  public boolean update() {
    
    // Update position using velocity.
    PVector forceAcc = this.getVelocity();
    this.setPosition(this.getPosition().add(forceAcc));
    
    this.hitDetection(); // Hit detection with other game objects.
    this.confineMovement(); // Confine asteroid movement.
    
    // If this asteroid is expired, indicate it should be removed.
    return !this.hasBounces();
    
  } // update().
  
  private void hitDetection() {
    
    // Only apply hit detection with asteroids on screen...
    // ...simplifies making sure all asteroids make it to the screen.
    if (inScreen) {
      
      // Apply hit detection with other game object types.
      this.hitAsteroids();
      this.hitJunk();
      this.hitDisruptions();
    
      // Asteroid hitting players done in player class - does not have to be two-way checked.
      // i.e., player hitting asteroid = asteroid hitting player (for expected behaviour).
      
    }
    
  } // hitDetection().
  
  private void hitAsteroids() {
    
    // Check if this asteroid has hit any other asteroids: bounce off them.
    for (ObjAsteroid currAsteroid : gameState.getAsteroids()) {
      this.bounce(currAsteroid);
    }
    
  } // hitAsteroids().
  
  private void hitJunk() {
    
    // Check if this asteroid has hit any junk: bounce off them.
    for (ObjSpaceJunk currJunk : gameState.getSpaceJunk()) {
      this.bounce(currJunk);
    }
    
  } // hitJunk().
  
  private void hitDisruptions() {
    
    // Check if this asteroid has hit a disruption: repelled.
    for (ObjDisruption currDisrupt : gameState.getDisruptions()) {
      
      // Check for a collision.
      boolean collided = this.collide(currDisrupt);
      
      // Repel the asteroid if asteroid hit by disruptor.
      if (collided) {
        
        // Repel asteroid away from player like there is an outwards burst pushing it away.
        float repelVelX = this.getPosX() - currDisrupt.getPosX();
        float repelVelY = this.getPosY() - currDisrupt.getPosY();
        PVector repelVel = new PVector(repelVelX, repelVelY);
        
        // Apply weighting from configuration to determine strength of the repulsion.
        repelVel = repelVel.mult(gameConfig.DISRUPT_STRENGTH_MULT);
        
        // Apply calculated velocity to this asteroid.
        this.setVelocity(repelVel);
        
      }
      
    }
    
  } // hitDisruptions().
  
  private void confineMovement() {
    
    // Confine moveable area to the canvas.
    // Do not apply canvas boundary constraints on asteroids heading into screen.
    if (inScreen) {
      
      // Size is the diameter - the geometry needs the radius.
      int radius = this.getSize() / 2;
      
      // Keep asteroid within canvas width bounds.
      // Size forgiving (waits for whole shape to leave screen); looks better for replacing asteroids.
      if (this.getPosX() > (gameConfig.CANVAS_WIDTH + radius)) {
        this.setVelX(-this.getVelX());
        this.decrementBounces();
      } else if (this.getPosX() < (0 - radius)) {
        this.setVelX(-this.getVelX());
        this.decrementBounces();
      }
      
      // Keep asteroid within canvas height bounds.
      // Size forgiving (waits for whole shape to leave screen); looks better for replacing asteroids.
      if (this.getPosY() > (gameConfig.CANVAS_HEIGHT + radius)) {
        this.setVelY(-this.getVelY());
        this.decrementBounces();
      } else if (this.getPosY() < (0 - radius)) {
        this.setVelY(-this.getVelY());
        this.decrementBounces();
      }
      
    } else if (this.getPosX() > 0 && this.getPosX() < gameConfig.CANVAS_WIDTH &&
               this.getPosY() > 0 && this.getPosY() < gameConfig.CANVAS_HEIGHT) {
         
      // Currently tracked as being off-screen, checked if still the case and updated.
      this.inScreen = true;
          
    }
    
  } // confineMovement().
  
  public void decrementBounces() {
    
    this.numBounces -= 1; // Decrement the number of bounces remaining.
    
  } // decrementBounces().
  
  public boolean hasBounces() {
    
    return (this.numBounces > 0); // Whether this asteroid still has bounces remaining.
    
  } // hasBounces().
  
  
  // ########################################################################
  // Asteroid Render/Display Methods:
  // ########################################################################
  
  public void display() {
    
    this.displayModel(); // Display this asteroid on the screen.
    
  } // display().
  
  private void displayModel() {
    
    // Asteroid displayed as simple circle.
    fill(this.getColour());
    stroke(this.getColour());
    ellipse(this.getPosX(), this.getPosY(), this.getSize(), this.getSize());
    
  } // displayModel().
  
  
  // ########################################################################
  // Asteroid Utility Methods:
  // ########################################################################
  
  public int getNumBounces() {
    
    return this.numBounces; // Return the number of bounces this asteroid has left.
    
  } // getNumBounces().


} // Asteroid{}.
