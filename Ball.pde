class Ball {

  float x, y;
  float toX = 5;
  float toY = 5;

  Ball(float x, float y) {    
    this.x = x;
    this.y = y;
  }
  
  void display() {
    text(msg, x, y);
    //ellipse(x, y, 100, 100);
    
    move();
  }
  
  void move() {
    x += toX;
    y += toY;
    
    bounce();
    racketBounce();
  }
  
  void bounce() {
    if(x < 0 || x > width) toX = -toX;
    if(y < 0 || y > height) toY = -toY;
  }
  
  void racketBounce() {

  }
}