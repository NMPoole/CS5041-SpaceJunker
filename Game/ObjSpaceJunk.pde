class ObjSpaceJunk extends ObjGameGeneric {
  
    
  // ########################################################################
  // Space Junk Attributes:
  // ########################################################################
  
  // Space Junk Attributes: position, velcity, size, and colour.
  
  boolean givesShield; // Whether this piece of space debris gives a shield or not.
  boolean givesDisrupt; // Whether this piece of space debris gives a disrupt or not.
  
  
  // ########################################################################
  // Space Junk Constructors:
  // ########################################################################
  
  public ObjSpaceJunk(float posX, float posY, float initVelX, float initVelY,
                   int junkSize, color junkColor) {
    
    super(posX, posY, initVelX, initVelY, junkSize, junkColor);
    
    // Initialise whether this space junk gives either shields or disrupts or neither.
    if (random(0, 1) < gameConfig.JUNK_SHIELD_PROB) {
      this.givesShield = true;
    } else if (random(0, 1) < gameConfig.JUNK_DISRUPT_PROB) {
      this.givesDisrupt = true;
    } else { // Gives no status effectors.
      this.givesShield = false;
      this.givesDisrupt = false;
    }
    
  } // ObjSpaceJunk().
  
  
  // ########################################################################
  // Space Junk State Methods:
  // ########################################################################
  
  public void update() {
     
    // Update position using velocity. //<>// //<>// //<>// //<>// //<>//
    PVector forceAcc = this.getVelocity();
    this.setPosition(this.getPosition().add(forceAcc));
  
    this.confineMovement(); // Space Junk is confined to the canvas.
    
  } // update().
  
  private void confineMovement() {
    
    // Confine moveable area to the canvas:
    
    // Keep space junk within canvas width bounds.
    if (this.getPosX() > gameConfig.CANVAS_WIDTH) {
      this.setPosX(gameConfig.CANVAS_WIDTH);
      this.setVelX(-this.getVelX());
    } else if (this.getPosX() < 0) {
      this.setPosX(0);
      this.setVelX(-this.getVelX());
    }
    
    // Keep space junk within canvas height bounds.
    if (this.getPosY() > gameConfig.CANVAS_HEIGHT) {
      this.setPosY(gameConfig.CANVAS_HEIGHT);
      this.setVelY(-this.getVelY());
    } else if (this.getPosY() < 0) {
      this.setPosY(0);
      this.setVelY(-this.getVelY());
    }
    
  } // confineMovement().
  
  
  // ########################################################################
  // Space Junk Draw/Render Methods:
  // ########################################################################
  
  public void display() {
    
    this.displayModel();
    
  } // display().
  
  private void displayModel() {
    
    // Draw model: Simple circle representing space junk.
    
    // Colour assigned based on whether this junk gives any status effectors.
    color colour = this.getColour();
    if (this.givesShield) {
      colour = gameConfig.JUNK_SHIELD_COLOR;
    } else if (this.givesDisrupt){
      colour = gameConfig.JUNK_DISRUPT_COLOR;
    }
    
    fill(colour);
    stroke(colour);
    ellipse(this.getPosX(), this.getPosY(), this.getSize(), this.getSize());
    
  } // displayModel().
  
  
  // ########################################################################
  // Space Junk Utility Methods:
  // ########################################################################
  
  public boolean givesShield() {
    
    return this.givesShield; // Return if this junk gives a shield.
    
  } // givesShield().
  
  public boolean givesDisrupt() {
    
    return this.givesDisrupt; // Return if this junk gives a disrupt.
    
  } // givesDisrupt().
  
  
} // ObjSpaceJunk{}.
