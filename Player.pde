int racket_ang = 0;

class Player {

  Racket leftRacket, rightRacket;
  float level;
  float preLevel = 0;

  Player(int player, float x, float y) {
    leftRacket = new Racket(player, -1, x, y);
    world.add(leftRacket);

    rightRacket = new Racket(player, 1, x, y);
    world.add(rightRacket);
  }

  void voiceControl() {
    level = amp.analyze() * 10000;

    if (level > levelThreshold) {
      if (abs(level - preLevel) > 10) {
        racket_ang = (int)map(level, levelThreshold, levelThreshold * 10, 0, 180);
      }
    }

    racket_ang--;
    racket_ang = constrain(racket_ang, 0, 180);

    leftRacket.rotate_();
    rightRacket.rotate_();
  }

  void keyControl() {
    if (keyPressed) {
      if (key == 'z' || key == 'Z') racket_ang--;
      if (key == 'x' || key == 'X') racket_ang++;
    }

    leftRacket.rotate_();
    rightRacket.rotate_();
  }
}