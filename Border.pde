class Border extends FBox {

  Border(float x, float y, float w, float h) {
    super(w, h);

    this.setStatic(true);
    this.setFriction(0);
    this.setDensity(10);
    this.setRestitution(1);

    this.setPosition(x, y);

    this.setNoFill();
    this.setNoStroke();
  }

  Border(float x, float y, float w, float h, float ang, boolean rotated) {
    super(w, h);

    this.setStatic(true);
    this.setFriction(0);
    this.setDensity(10);
    this.setRestitution(1);

    this.setPosition(x, y);
    this.setRotation(radians(ang));

    this.setNoFill();
    this.setNoStroke();
  }

  // goalPost
  Border(int id, float x, float y, float w, float h) {
    super(w, h);

    this.setGroupIndex(id); 
    this.setStatic(true);
    this.setFriction(0);

    this.setPosition(x, y);
    this.setDensity(10);
    this.setRestitution(1);

    this.setFill(0, 255, 0);
    //this.setNoFill();  
    this.setNoStroke();
  }
}