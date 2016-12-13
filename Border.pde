class Border extends FBox {

  Border(float x, float y, float w, float h, int id) {
    super(w, h);

    this.setGroupIndex(id);
  
    this.setPosition(x, y);

    this.setStatic(true);
    this.setFriction(0);
    this.setNoStroke();
    this.setDensity(10);
    this.setFill(100);
    
    this.setRestitution(1); 
  }
}