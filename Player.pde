import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;

class Player {

  float x, y;
  int leftPin, rightPin;

  Racket leftRacket = new Racket(-1);
  Racket rightRacket = new Racket(1);
  int racket_ang = 90;

  float level;
  float f = 0;
  float preF = 0;

  Player(float x, float y, int leftPin, int rightPin) {
    this.x = x;
    this.y = y;
    this.leftPin = leftPin;
    this.rightPin = rightPin;
  }

  void display() {
    pushMatrix();
    translate(x, y);

    leftRacket.display(racket_ang);
    rightRacket.display(racket_ang);

    popMatrix();
  }

  void voiceControl() {

  }

  void keyControl() {
    if (keyPressed) {
      if (key == 'z' || key == 'Z') racket_ang--;
      if (key == 'x' || key == 'X') racket_ang++;
    }
  }
}