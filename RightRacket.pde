class RightRacket extends FSVG {

  int pin, player, dir;

  float test;

  RightRacket(int pin, int player, int dir, float px, float py) {
    super(player, dir);

    this.pin = pin;
    this.player = player;
    this.dir = dir;

    this.setStatic(true);
    this.setPosition(px, py);
    //this.adjustRotation(radians(-90));
    this.adjustPosition(100 * player, 135 * dir);
    this.setFriction(0);    
    

    this.setRestitution(1);
  }

  
  int llevel;
  void rotate_(int level) {
    //println("right ", level);
    //level = 180;
    this.setRotation(radians(llevel++));  
    arduino.servoWrite(pin, (int)map(level, 0, 180, 180, 0));
  }
}