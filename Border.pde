class Border extends FBox {

  Border(float x, float y, float w, float h) {
    super(w, h);

    this.setPosition(x, y);
    this.setStatic(true);
    this.setFriction(0);
    this.setNoStroke();
    this.setDensity(10);
    //this.setFill(0, 0, 255);
    this.setNoFill();
    this.setRestitution(1);
  }

  Border(float x, float y, float w, float h, float ang, boolean rotated) {
    super(w, h);

    this.setPosition(x, y);
    this.setRotation(radians(ang));
    this.setStatic(true);
    this.setFriction(0);
    this.setNoStroke();
    this.setDensity(10);
    //this.setFill(0, 0, 255);
    this.setNoFill();
    this.setRestitution(1);
  }

  Border(float x, float y, float w, float h, int id) {
    super(w, h);

    this.setGroupIndex(id); 
    this.setPosition(x, y);
    this.setStatic(true);
    this.setFriction(0);
    this.setNoStroke();
    this.setDensity(10);
    //this.setFill(0, 255, 0);
    this.setNoFill();    
    this.setRestitution(1);
  }
}