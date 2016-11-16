class Racket {

  float w = 200;
  float h = 20;
  int dir;
  int default_ang = 225;  

  float imageW;
  float imageH;

  Racket(int dir) {
    this.dir = dir;
  }

  void display(int pin) {
    pushMatrix();
    translate(width/8, 0);
    translate(100, 100 * dir);
    //rotate(radians(default_ang * dir));
    rotate(radians(racket_ang));

    image(handle, -handle.width/17.4 * dir, -handle.height/2 * dir);

    popMatrix();

    if (arduinoOn) {
      if (dir == 1) arduino.servoWrite(pin, racket_ang);
      else if (dir == -1) arduino.servoWrite(pin, (int)map(racket_ang, 0, 180, 180, 0));
    }
  }
}