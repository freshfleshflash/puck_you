class WhiteObstacle extends FSVGO {
  float x, y;

  WhiteObstacle() {
    super();
  }

  WhiteObstacle(int id, float x, float y) {
    super();

    this.x = x;
    this.y = y;

    this.setGroupIndex(-id);
    this.setPosition(x, y);
    this.setStatic(true);
    this.setFill(255);
    this.setFriction(0);
    this.setRestitution(1);

    this.setNoFill();


    this.setNoStroke();
  }
}