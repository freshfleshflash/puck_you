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
    this.setStatic(true);

    this.setFriction(0);
    this.setRestitution(1);

    this.setPosition(x, y);
    this.setRotation(120);

    this.setFill(0);
    //this.setNoFill();
    this.setNoStroke();
  }
}