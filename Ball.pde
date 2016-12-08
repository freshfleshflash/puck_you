class Ball extends FBox {
  
  String msg;
  int id;

  Ball(String msg, float w, float h, float x, float y, PVector velocity, int id) {
    super(w, h);
    
    this.msg = msg;
    this.id = id;

    this.setPosition(x, y);
    this.setRestitution(1);  
    this.setVelocity(velocity.x, velocity.y);
    this.setFriction(0);
    this.addTorque(50);
    this.setDamping(0);
    
    this.setNoFill();
    this.setNoStroke();
  }

  void move() {
    fill(0);
    pushMatrix();
    translate(this.getX(), this.getY());
    //rotate(radians(45));
    rotate(this.getRotation());
    text(msg, -textWidth(msg)/2, 0);
    popMatrix();
  }
  
  void erase() {
    this.setFill(255);
  }
}