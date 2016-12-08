class Obstacle extends FCircle {
  float x, y;
  
  Obstacle(float x, float y) {
    super(100);
    
    this.x = x;
    this.y = y;

    this.setGroupIndex(1);
    this.setPosition(x, y);
    this.setStatic(true);
    //this.setNoFill();
    this.setFill(0); //////// black object
    this.setFriction(0);
  }
}