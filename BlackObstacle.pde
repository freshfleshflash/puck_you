class BlackObstacle extends FCircle {

  float x, y;

  BlackObstacle() {
    super(0);
  }

  BlackObstacle(int id, float x, float y) {
    super(100);

    this.x = x;
    this.y = y;

    this.setGroupIndex(-id);
    this.setPosition(x, y);
    this.setStatic(true);
    this.setNoFill();
    this.setFriction(0);

    this.setRestitution(1);
  }
}