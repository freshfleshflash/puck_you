class Charger {

  color c = normalColor;
  float x, y;
  float size = 27;

  Charger(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void display() {
    pushMatrix();
    translate(x, y);
    //rotate(radians(ang));
    noStroke();
    fill(c);
    ellipse(0, 0, size, size);
    popMatrix();
  }
}