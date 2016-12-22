class BlackObstacle extends FSVGO {

  float x, y;

  BlackObstacle() {
    super();
  }

  BlackObstacle(int id, float x, float y) {
    super();

    this.x = x;
    this.y = y;

    this.setGroupIndex(-id * 100);
    this.setPosition(x, y);
    this.setStatic(true);
    this.setFill(0);
    this.setFriction(0);
    this.setRestitution(1);
    this.setNoStroke();
    
    this.setNoFill();

    this.setRotation(120);
  }
}