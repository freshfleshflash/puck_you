class Obstacle extends FBox {
  float x, y;
  String msg;

  Obstacle(String msg, float x, float y) {
    super(100, 100);

    this.msg = msg;
    this.x = x;
    this.y = y;

    this.setGroupIndex(1);
    this.setPosition(x, y);
    this.setStatic(true);
    this.setNoFill();
    this.setFriction(0);

    this.setRestitution(1); 
  }
}

//class Obstacle extends FPoly {

  //Obstacle(float x, float y) {
  //  super();
    
  //  this.vertex(0, 0);
  //  this.vertex(50, 100);
  //  this.vertex(100, 200);
  //  this.vertex(0, 0);
  //}
//}