class LeftRacket extends FSVG {

  int player, dir, pin;

  LeftRacket(int player, int dir, int pin, float px, float py) {
    super(player, dir);

    this.player = player;
    this.dir = dir;
    this.pin = pin;

    this.setStatic(true);
    this.setFriction(0);    
    this.setRestitution(1);
    this.setPosition(px, py);
    this.adjustPosition(100 * player, 135 * dir * player);
    //this.adjustRotation(30);
    //this.setNoFill();
    this.setNoStroke();
  }

  void rotate_(int ang) {
    this.setRotation(radians(-ang));  
    arduino.servoWrite(pin, ang);

    //testRotate();
  }

  int testLevel = 0;
  void testRotate() {
    testLevel++;

    this.setRotation(-radians(testLevel));  
    arduino.servoWrite(pin, testLevel);
  }
}