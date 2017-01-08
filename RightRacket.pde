class RightRacket extends FSVG {

  int player, pin, dir;

  RightRacket(Player player, int dir) {
    super(player.player, dir);

    this.player = player.player;
    this.pin = player.pin_right;
    this.dir = dir;

    this.setStatic(true);
    this.setFriction(0);    
    this.setRestitution(1);
    this.setPosition(player.x, player.y);
    this.adjustPosition(100 * player.player, 135 * dir * player.player);
    //this.adjustRotation(30);
    //this.setNoFill();
    this.setNoStroke();
  }

  void rotate_(int ang) {
    this.setRotation(radians(ang));  
    arduino.servoWrite(pin, (int)map(ang, 30, 120, 120, 30));
    
    //testRotate();
  }

  int testLevel = 0;
  void testRotate() {
    testLevel++;

    this.setRotation(radians(testLevel));  
    arduino.servoWrite(pin, (int)map(testLevel, 0, 180, 180, 0));
  }
}