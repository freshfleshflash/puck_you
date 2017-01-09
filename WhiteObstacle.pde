class WhiteObstacle extends FSVGO {

  float x, y;
  boolean squareDisplayed = false;
  int displayingSquareTime = 0;
  float ang = 0;

  WhiteObstacle() {
    super();
  }

  WhiteObstacle(int id, float x, float y) {
    super();

    this.x = x;
    this.y = y;

    this.setGroupIndex(-id);   
    this.setStatic(true);
    this.setFriction(0);
    this.setRestitution(1);
    this.setPosition(x, y);
    this.setRotation(ang);
    this.setFill(255);
    //this.setNoFill();
    this.setNoStroke();
  }

  void displaySquare() {
    float w = 107;
    float h = 72;

    if (!finished && squareDisplayed) {
      pushMatrix();
      translate(x, y);
      rotate(ang);
      pushStyle();
      fff.disableStyle();
      strokeWeight(20);
      stroke(229, 71, 70);
      noFill();
      shape(fff, 0, 0, w, h);
      popStyle();      
      popMatrix();
      if (frameCount - displayingSquareTime == 10) squareDisplayed = false;
    }
  }
}