class Racket extends FSVG {

  int player, dir;

  Racket(int player, int dir, float px, float py) {
    super("handle.svg", player, dir);
    this.dir = dir;
    this.player = player;

    this.setStatic(true);
    this.setPosition(px, py);
    this.adjustPosition(0, 200 * dir);
    this.setStroke(255, 0, 0);
  }

  void rotate_() {
    this.setRotation(radians(racket_ang * dir));

    if (arduinoOn) {
      if (dir == -1) arduino.servoWrite(7, (int)map(racket_ang, 0, 180, 180, 0));
      else if (dir == 1) arduino.servoWrite(8, racket_ang);
    }
  }
}