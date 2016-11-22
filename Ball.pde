class Ball {

  float x, y;
  float toX = 5;
  float toY = 5;
  float r = 200;

  Ball(float x, float y) {    
    this.x = x;
    this.y = y;
  }

  void display() {
    pushStyle();
    stroke(0);
    noFill();
    ellipse(x, y, r, r);
    popStyle();

    pushStyle();
    textAlign(CENTER, CENTER);
    text(ballMsg, x, y);
    popStyle();

    move();
  }

  void move() {
    x += toX;
    y += toY;

    bounce();
  }

  void bounce() {
    if (x < r/2 || x > width - r/2) toX = -toX;
    if (y < r/2 || y > height - r/2) toY = -toY;
  }

  void racketBounce() {
    
    
  }
}