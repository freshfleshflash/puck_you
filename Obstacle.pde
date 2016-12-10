class Obstacle extends FCircle {
  float x, y;

  Obstacle() {
    super(0);
  }

  Obstacle(int id, float x, float y) {
    super(100);

    this.x = x;
    this.y = y;

    this.setGroupIndex(-id);
    this.setPosition(x, y);
    this.setStatic(true);
    this.setFill(255);
    this.setFriction(0);
    this.setRestitution(1);
  }
}