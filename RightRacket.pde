class RightRacket extends FSVG {

  int pin, player, dir;

  float test;

  RightRacket(int pin, int player, int dir, float px, float py) {
    super("handle.svg", player, dir);

    this.pin = pin;
    this.player = player;
    this.dir = dir;

    this.setStatic(true);
    this.setPosition(px, py);
    //this.adjustRotation(radians(-90));
    this.adjustPosition(0, 190 * dir);
    this.setStroke(0, 0, 0);
    this.setFriction(0);    

    this.setRestitution(1);
  }


  void rotate_(int level) {
    //println("right ", level);
    //level = 180;
    this.setRotation(radians(level));  
    arduino.servoWrite(pin, (int)map(level, 0, 180, 180, 0));
  }
}