class Ball extends FBox {

  float size;

  Ball(float size) {
    super(size, size);
    
    this.setPosition(width/2, height/2);
    this.setRotation(PI/4);
    this.setRestitution(1);  
    this.setVelocity(-100, -400);
    this.setFriction(0);
    this.addTorque(50);
    this.setDamping(0);
  }
}