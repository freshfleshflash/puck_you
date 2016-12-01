class Obstacle extends FCircle {

  Obstacle(float x, float y) {
    super(100);

    this.setGroupIndex(1);
    this.setPosition(x, y);
    this.setStatic(true);
    //this.setNoStroke();
    this.setNoFill();
    //this.setFill(oColor);
    this.setFriction(0);
    
    
    //this.setRestitution(1);  
  }
}