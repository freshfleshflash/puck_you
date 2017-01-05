class LeftRacket extends FSVG {

  int pin, player, dir;

  LeftRacket(int pin, int player, int dir, float px, float py) {
    super(player, dir);

    this.pin = pin;
    this.player = player;
    this.dir = dir;

    this.setStatic(true);
    this.setPosition(px, py);
    //this.adjustRotation(30);
    this.adjustPosition(100 * player, 135 * dir * player);
    //this.setStroke(0, 0, 0);
    this.setFriction(0);    
    this.setRestitution(1);

    this.setNoFill();
    this.setNoStroke();
  }

  void rotate_(int level) {
    this.setRotation(radians(-level));  
    arduino.servoWrite(pin, level);

    //testRotate();
  }

  int testLevel = 0;
  void testRotate() {
    testLevel++;

    this.setRotation(-radians(testLevel));  
    arduino.servoWrite(pin, testLevel);
  }
}