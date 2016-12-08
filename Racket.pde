class Racket extends FSVG {

  int pin, player, dir;

  float test;

  Racket(int pin, int player, int dir, float px, float py) {
    super("handle.svg", player, dir);

    this.pin = pin;
    this.player = player;
    this.dir = dir;

    this.setStatic(true);
    this.setPosition(px, py);
    this.adjustPosition(0, 190 * dir);
    this.setStroke(0, 0, 0);
    this.setFriction(0);    

    if (player == 1) this.setFill(0);  ////
  }

  void rotate_(int level) {    
    level = constrain(level, 0, 180);   
    this.setRotation(radians(-level * dir * player));

    if (dir == -1) arduino.servoWrite(pin, (int)map(level, 0, 180, 180, 0));
    if (dir == 1) arduino.servoWrite(pin, level);
  }
}