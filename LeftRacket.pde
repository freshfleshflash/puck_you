class LeftRacket extends FSVG {

  int pin, player, dir;


  LeftRacket(int pin, int player, int dir, float px, float py) {
    super("handle.svg", player, dir);

    this.pin = pin;
    this.player = player;
    this.dir = dir;

    this.setStatic(true);
    this.setPosition(px, py);
    this.adjustPosition(0, 190 * dir);
    this.setStroke(0, 0, 0);
    this.setFriction(0);    

    this.setRestitution(1);
  }

  
  int testLevel = 0;
  void rotate_(int level) {        
    //println("left ", level);   
    //level = 180;
    this.setRotation(radians(-level));  
    arduino.servoWrite(pin, level);
  }
}