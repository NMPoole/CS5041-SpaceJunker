class ObjGameGeneric {
  
  
  // ########################################################################
  // Generic Game Object Attributes:
  // ########################################################################
  
  private PVector position; // All game objects have a position.
  private PVector velocity; // All game objects have a velocity.
  
  private int size; // All game objects have an associated size (i.e., diameter).
  private color colour; // All game objects have a colour (for displaying simple geometry).
  
  
  // ########################################################################
  // Generic Game Object Constructors:
  // ########################################################################
  
  ObjGameGeneric(float posXInit, float posYInit, int size, color colour) {
    
    this.position = new PVector(posXInit, posYInit); // Position initialisation.
    this.velocity = new PVector(0, 0); // No velocity for this object - stationary.
    
    this.size = size; // Size of object.
    this.colour = colour; // Colour of object.
    
  } // ObjGameGeneric().
  
  ObjGameGeneric(float posXInit, float posYInit, float velXInit, float velYInit,
                  int size, color colour) {
    
    this.position = new PVector(posXInit, posYInit); // Position initialisation.
    this.velocity = new PVector(velXInit, velYInit); // Velocity initialisation.
    
    this.size = size; // Size of object.
    this.colour = colour; // Color of object.
    
  } // ObjGameGeneric().
  
  
  // ########################################################################
  // Generic Game Object Collision Methods:
  // ########################################################################
  
  public float distance(ObjGameGeneric other) {
    
    // Calculate difference in x and y co-ordinates.
    float dx = other.getPosX() - this.getPosX();
    float dy = other.getPosY() - this.getPosY();
    
    // Calculate Pythagorean distance between object positions.
    float distance = sqrt(dx * dx + dy * dy);
    
    // Return the Pythagorean Distance.
    return distance;
    
  } // distance().
  
  public boolean collide(ObjGameGeneric other) {
    
    // Calculate Pythagorean distance between object positions.
    float distance = this.distance(other);
    
    // Calculate minimum distance between objects to be touching.
    // Size is the diameter, so ensure to use radius.
    float minDist = (other.getSize() / 2) + (this.getSize() / 2);
    
    // If the distance is <= the minimum distance, then they are intersecting.
    return (distance <= minDist);
    
  } // collide().
  
  public boolean bounce(ObjGameGeneric other) {
  
    // Calculate difference in x and y co-ordinates.
    float dx = other.getPosX() - this.getPosX();
    float dy = other.getPosY() - this.getPosY();
    
    // Calculate Pythagorean distance between object positions.
    // Don't use dist(); need the dx and dy values.
    float distance = sqrt(dx * dx + dy * dy);
    
    // Calculate minimum distance between objects to be touching.
    // Size is the diameter, so ensure to convert to radius.
    float minDist = (other.getSize() / 2) + (this.getSize() / 2);
    
    // If the distance is <= the minimum distance, then they are intersecting.
    if (distance <= minDist) {
      
      // If objects intersecting, then calculate their 'bounce' velocities:
      
      float angle = atan2(dy, dx);
      
      float targetX = this.getPosX() + cos(angle) * minDist;
      float targetY = this.getPosY() + sin(angle) * minDist;
      
      float ax = (targetX - other.getPosX()) * gameConfig.SPRING_COEFF;
      float ay = (targetY - other.getPosY()) * gameConfig.SPRING_COEFF;
      
      // Adjust object velocities to bounce off each other.
      this.velocity.x -= ax;
      this.velocity.y -= ay;
      other.velocity.x += ax;
      other.velocity.y += ay;
      
      return true; // There was a bounce.
      
    } else {
      
      return false; // There was not a bounce.
      
    }
    
  } // bounce().
  
  
  // ########################################################################
  // Generic Game Object Getters:
  // ########################################################################
  
  // POSITION:
  
  public PVector getPosition() {
    
    return this.position;
    
  } // getPosition().
  
  public float getPosX() {
    
    return this.position.x;
    
  } // getPosX().
  
  public float getPosY() {
    
    return this.position.y;
    
  } // getPosY().
  
  // VELOCITY:
  
  public PVector getVelocity() {
    
    return this.velocity;
    
  } // getVelocity().
  
  public float getVelX() {
    
    return this.velocity.x;
    
  } // getVelX().
  
  public float getVelY() {
    
    return this.velocity.y;
    
  } // getVelY().
  
  // SIZE:
  
  public int getSize() {
    
    return this.size;
    
  } // getSize().
  
  // COLOUR:
  
  public color getColour() {
    
    return this.colour;
    
  } // getColour().
  
  
  // ########################################################################
  // Generic Game Object Setters:
  // ########################################################################
  
  // POSITION:
  
  public void setPosition(PVector position) {
    
    this.position = position;
    
  } // setPosition().
  
  public void setPosX(float x) {
    
    this.position.x = x;
    
  } // setPosX().
  
  public void setPosY(float y) {
    
    this.position.y = y;
    
  } // setPosY().
  
  // VELOCITY:
  
  public void setVelocity(PVector velocity) {
    
    this.velocity = velocity;
    
  } // setVelocity().
  
  public void setVelX(float x) {
    
    this.velocity.x = x;
    
  } // setVelX().
  
  public void setVelY(float y) {
    
    this.velocity.y = y;
    
  } // setVelY().
  
  // SIZE:
  
  public void setSize(int size) {
    
    this.size = size;
    
  } // setSize().
  
  // COLOUR:
  
  public void setColour(color colour) {
    
    this.colour = colour;
    
  } // setColour().
  
  
} // ObjGameGeneric{}.
