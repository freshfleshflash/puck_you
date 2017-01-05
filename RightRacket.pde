class RightRacket extends FSVG {

  int pin, player, dir;

  RightRacket(int pin, int player, int dir, float px, float py) {
    super(player, dir);

    this.pin = pin;
    this.player = player;
    this.dir = dir;

    this.setStatic(true);
    this.setPosition(px, py);
    //this.adjustRotation(30);

    this.adjustPosition(100 * player, 135 * dir * player);
    this.setFriction(0);    
    //this.setFill(0);
    this.setRestitution(1);

    this.setNoFill();
    this.setNoStroke();
  }

  void rotate_(int level) {
    this.setRotation(radians(level));  
    arduino.servoWrite(pin, (int)map(level, 30, 120, 120, 30));
  }

  int testLevel = 0;
  void testRotate() {
    testLevel ++;

    this.setRotation(radians(testLevel));  
    arduino.servoWrite(pin, (int)map(testLevel, 0, 180, 180, 0));
  }
}