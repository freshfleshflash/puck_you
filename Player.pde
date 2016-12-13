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

  LeftRacket left;
  RightRacket right;
  
  int score = 0;
  ArrayList<String> loserStorage = new ArrayList<String>();
  
  Player(int[] pins, int player) {
    this.pin_mic = pins[0];
    this.pin_b1 = pins[1];
    this.pin_b2 = pins[2];
    this.pin_left = pins[3];
    this.pin_right = pins[4];

    this.player = player;
    this.x = width/2 + xGap * player;
    this.ballSlot = height/2 - ballSlot * player;

    left = new LeftRacket(pin_left, player, 1, x, y);
    world.add(left);
    right = new RightRacket(pin_right, player, -1, x, y);
    world.add(right);
  }

  void method() {
    this.controlWithVoice();
    this.drawPortal();
    this.objectSomething();
    if(player == -1) this.generateTestingBall();
    detectWin();
  }

  int levelId = 0;
  int realLevel;
  int defaultCount = 0;

  int defaultLevel;
  boolean defaultSet = false;

  void controlWithVoice() {

    level = arduino.analogRead(pin_mic);

    levels[levelId++] = level;
    if (levelId == levels.length) levelId = 0;
    int sum = 0;
    for (int i = 0; i < levels.length; i++) sum += levels[i];
    realLevel = (int)sum / levels.length;

    if (!defaultSet) {
      defaultLevel = realLevel;     
      defaultCount++;
      if (defaultCount > 100) defaultSet = true;
    }

    realLevel = constrain(-realLevel + defaultLevel, 0, 180);

    //println(realLevel);

    left.rotate_(realLevel); // 0이 들어간다 
    right.rotate_(realLevel);
  }

  int hmm = 0;

  void objectSomething() {
  }

  void drawPortal() {
    if (portal) {
      fill(0);
      ellipse(x, ballSlot, 50, 50);
    }
  }

  int bId = 0;
  void generateTestingBall() {
    if (keyPressed && key == ENTER) {
      //String[] msg = {"시발"};

      //wordsStorage.add(msg);
      balls.add(new Ball(bId++, x, ballSlot, new PVector(player * -500, 0), "슈발"));
      world.add((balls.get(balls.size() - 1)));
    }
  }
  
  
  void detectWin() {
    if(this.score <= -5) {
      text(sumString(loserStorage), x, y);  
    }
  }
}