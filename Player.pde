// pins {mic, button1, button2, left, right}

class Player {

  int pin_mic;
  int pin_b1;
  int pin_b2;
  int pin_left;
  int pin_right;

  int player;
  float x;
  float xGap = 400;
  float y = height/2;
  int level;
  int preLevel = 0;
  float ballSlot = 300;
  int prePressed = 0;

  boolean portal = false;

  int[] levels = new int[30];

  Racket left, right;

  Player(int[] pins, int player) {
    this.pin_mic = pins[0];
    this.pin_b1 = pins[1];
    this.pin_b2 = pins[2];
    this.pin_left = pins[3];
    this.pin_right = pins[4];

    this.player = player;
    this.x = width/2 + xGap * player;
    this.ballSlot = height/2 - ballSlot * player;

    left = new Racket(pins[3], player, -1, x, y);
    world.add(left);
    right = new Racket(pins[4], player, 1, x, y);
    world.add(right);
  }

  void method() {
    this.controlWithVoice();
    this.drawPortal();
    this.objectSomething();
  }

  int levelId = 0;
  int realLevel;

  void controlWithVoice() {    
    level = arduino.analogRead(pin_mic);
    levels[levelId++] = level;
    //if (pin_mic == 0) printArray(levels); ////
    if (levelId == levels.length) levelId = 0;

    int sum = 0;
    for (int i = 0; i < levels.length; i++) sum += levels[i];
    realLevel = (int)sum / levels.length;

    if (pin_mic == 0) println(realLevel, level);
    
    if(arduino.digitalRead(pin_b2) == 1){  
    left.rotate_(realLevel);
    right.rotate_(realLevel);
    }
  }

  void objectSomething() {
    Obstacle o = obstacles.get(0);

    //if (keyPressed) {
    if (arduino.digitalRead(pin_b2) == 1) {      
      pushStyle();
      noStroke();
      fill(255, 0, 0);

      ellipse(o.x, o.y, 150, 150);
      popStyle();
    }
  }

  void drawPortal() {
    if (portal) {
      fill(0);
      ellipse(x, ballSlot, 50, 50);
    }
  }
}