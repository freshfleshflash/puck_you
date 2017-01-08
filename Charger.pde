class Charger {

  int dir;
  float x, y;
  boolean charging = false;
  int chargingTime = 0;

  Charger(Player player) {
    this.dir = player.player;
    this.x = width/2 - 470 * -dir;
    this.y = height/2 - player.slotGap * -dir;
  }

  void display() {    
    float w = 10;
    float h = 15;

    int num = 18;
    int step = 0;
    int duration = 20;

    if (charging) {
      step = ((int)(frameCount - chargingTime) / duration) % num;
    }

    pushMatrix();
    translate(x, y);
    pushStyle();
    noStroke();

    scale(-dir, -dir);

    for (int i = 0; i < num; i++) {
      pushMatrix();
      reCoordinate(i);
      shearX(-PI/5);
      if (charging && i <= step) fill(0);
      else fill(255, 233, 212); 
      rect(0, 0, w, h);
      popMatrix();
    }

    for (int i = 0; i < num; i++) {    
      pushMatrix();
      reCoordinate(i);
      shearX(PI/5);      
      if (charging && i <= step) fill(0);
      else fill(255, 233, 212); 
      rect(0, 0, w, -h);
      popMatrix();
    }

    popStyle();
    popMatrix();
  }

  void reCoordinate(int id) {
    float a = 0;
    float b = 0;
    float ang = 0;

    if (id == 14) {
      a = 3;
      ang = 10;
    } else if (id == 15) {
      a = 4;
      b = 14;
      ang = 30;
    } else if (id == 16) {
      a = -12;
      b = 47;
      ang = 53;
    } else if (id == 17) {
      a = -47;
      b = 87;
      ang = 90;
    } 

    translate(id * 44 + a, b);
    rotate(radians(ang));
  }
}