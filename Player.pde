int racket_ang = 0;

class Player {

  float x, y;
  int leftPin, rightPin;

  Racket leftRacket = new Racket(-1);
  Racket rightRacket = new Racket(1);

  float level;
  float preLevel = 0;

  Player(float x, float y, int leftPin, int rightPin) {
    this.x = x;
    this.y = y;
    this.leftPin = leftPin;
    this.rightPin = rightPin;
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
  }

  void display() {
    pushMatrix();
    translate(x, y);

    //leftRacket.display(leftPin);
    rightRacket.display(rightPin);

    popMatrix();
  }

  void keyControl() {
    if (keyPressed) {
      if (key == 'z' || key == 'Z') racket_ang--;
      if (key == 'x' || key == 'X') racket_ang++;
    }
  }
}