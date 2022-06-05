class ObjDisruption extends ObjGameGeneric {
  
  
  // ########################################################################
  // Disruption Attributes:
  // ########################################################################
  
  // Disruption Attributes: position, size, and colour.
  
  private int maxSize; // Maximum size of the disruption.
  private int sizeInterval; // Amount to increase disruption 'ripple' circle size by each frame.
  
  private String playerIDTriggered; // Player who triggered the disruption and is immune to it.
  
  
  // ########################################################################
  // Disruption Constructors:
  // ########################################################################
  
  ObjDisruption(float initPosX, float initPosY, int initDisruptSize, color initDisruptColour, String playerID) {
              
    super(initPosX, initPosY, initDisruptSize, initDisruptColour); // Init game object.
    
    // Maximum size of the disruption determined by game configuration.
    this.maxSize = initDisruptSize * gameConfig.DISRUPT_RADIUS_FACT;
    
    // Degree of increase in explosion radius (determined by num circles representing explosion).
    this.sizeInterval = (this.maxSize - initDisruptSize) / gameConfig.DISRUPT_NUM_CIRCLES;
    
    // Keep track of player that set off the disruption for immunity.
    this.playerIDTriggered = playerID;
    
  } // ObjDisruption().
  
  
  // ########################################################################
  // Disruption State Methods:
  // ########################################################################
  
  public boolean update() {
    
    // Disruption represented as an expanding circle; so expand size of disruption.
    this.setSize(this.getSize() + this.sizeInterval);
    
    // Disruption needs to be removed when its maximum size has been reached.
    return (this.getSize() >= this.maxSize);
    
  } // update().
  
  
  // ########################################################################
  // Disruption Render/Display Methods:
  // ########################################################################
  
  public void display() {
    
    this.displayModel();
    
  } // display().
    
  private void displayModel() {
    
    // Disruption shown as simple expanding circle.
    
    noFill();
    stroke(this.getColour());
    strokeWeight(gameConfig.DISRUPT_STROKE_WEIGHT);
    
    circle(this.getPosX(), this.getPosY(), this.getSize());
    
    strokeWeight(1); // Reset stroke weight to default when done.
    
  } // displayModel().
  
  
  // ########################################################################
  // Disruption Utility Methods:
  // ########################################################################
  
  public String getPlayerTriggered() {
    
    return this.playerIDTriggered; // Return player ID that triggered this disruption.
    
  } // getPlayerTriggered().
  
  
} // ObjDisruption{}.
