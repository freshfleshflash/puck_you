class LeftRacket extends FSVG {

  int pin, player, dir;

  LeftRacket(int pin, int player, int dir, float px, float py) {
    super(player, dir);

    this.pin = pin;
    this.player = player;
    this.dir = dir;

    this.setStatic(true);
    this.setPosition(px, py);
    this.adjustPosition(100 * player, 135 * dir * player);
    this.setStroke(0, 0, 0);
    this.setFriction(0);    
    this.setRestitution(1);
    
    this.setNoFill();
  }

  void rotate_(int level) {
    this.setRotation(radians(-level));  
    arduino.servoWrite(pin, level);

    //testRotate();
  }

  void testRotate() {
    testLevel += test;

    if (testLevel > 180) test = -1;
    if (testLevel < 0) test = 1;
    
    this.setRotation(radians(-testLevel));  
    arduino.servoWrite(pin, testLevel);
  }
}