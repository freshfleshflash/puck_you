class Racket {

  float w = 200;
  float h = 20;
  int dir;
  float default_ang = 225;  
  
  float imageW;
  float imageH;
    
  Racket(int dir) {
    this.dir = dir;
  }

  void display(float racket_ang) {
    pushMatrix();
    translate(width/8, 0);
    translate(100, 100 * dir);
    rotate(radians(default_ang * dir));
    rotate(radians(racket_ang * dir));

    //pushStyle();
    //stroke(0);
    //strokeWeight(10);
    //line(0, 0, -w, 0);
    //popStyle();
    
    image(handle, -handle.width/17.4 * dir, -handle.height/2 * dir);

    popMatrix();
  }
}