class Border extends FBox {

  Border(float x, float y, float w, float h, float ang) {
    super(w, h);

    this.setPosition(x, y);
    this.setRotation(radians(ang));
    this.setStatic(true);
    this.setFriction(0);
    this.setNoStroke();
    this.setDensity(10);
    this.setFill(100);
    
    this.setRestitution(1); 
  }
}