class LeftRacket extends FSVG {

  int pin, player, dir;

  LeftRacket(int pin, int player, int dir, float px, float py) {
    super(player, dir);
    
    //super(50, 100);

    this.pin = pin;
    this.player = player;
    this.dir = dir;

    this.setStatic(true);
    this.setPosition(px, py);
    this.adjustPosition(100 * player, 135 * dir);
    this.setStroke(0, 0, 0);
    this.setFriction(0);    
    
    //this.setFill(229, 71, 70);

    this.setRestitution(1);
  }

  
  int testLevel = 0;
  void rotate_(int level) {        
    //println("left ", level);   
    //level = 180;
    this.setRotation(radians(-testLevel++));  
    arduino.servoWrite(pin, level);
  }
}