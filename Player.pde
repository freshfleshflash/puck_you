// pins {mic, button1, button2, left, right}

class Player {

  //int pin_mic;
  int pin_b1;
  int pin_b2;
  int pin_left;
  int pin_right;

  int player;
  String name;
  float x;
  float xGap = 400;
  float y = height/2;
  //int level;
  //int preLevel = 0;
  float ballSlot = -287;
  int prePressed = 0;

  boolean portal = false;
  //int[] levels = new int[30];

  LeftRacket left;
  RightRacket right;

  int score = 0;
  ArrayList<String> loserStorage = new ArrayList<String>();

  boolean lost = false;
  String insult = "";

  int charged = 0;
  boolean charging = false;

  Charger[] chargers = new Charger[6];

  Player(int[] pins, int player, String name) {
    //this.pin_mic = pins[0];
    this.pin_b1 = pins[1];
    this.pin_b2 = pins[2];
    this.pin_left = pins[3];
    this.pin_right = pins[4];

    this.player = player;
    this.name = name;
    this.x = width/2 + xGap * player;
    this.ballSlot = height/2 - ballSlot * player;

    left = new LeftRacket(pin_left, player, 1, x, y);
    world.add(left);
    right = new RightRacket(pin_right, player, -1, x, y);
    world.add(right);

    for (int i = 0; i < chargers.length; i++) {
      chargers[i] = new Charger(width/2+612*player - player * i * 19, ballSlot);
    }
  }

  void method() {
    this.controlWithButton();
    this.detectWin();
    this.displayLoserStorage();
    this.generateTestingBall();
    this.insulted();
    this.charging();
  }

  void charging() {
    charged++;
    for (int i = 0; i < chargers.length; i++) {
      this.chargers[i].display();

      if (charging) {
        if (charged >= (i) * 50) {
          chargers[i].c = chargingColor;
        } else {
          chargers[i].c = normalColor;
        }
      } else {
        chargers[i].c = normalColor;
      }
    }
    if (charged > 6*350) charged = 0;
  }

  int levelId = 0;
  int realLevel;
  int defaultCount = 0;

  int defaultLevel;
  boolean defaultSet = false;

  int preFrameCount = frameCount;

  void controlWithButton() {
    //level = arduino.analogRead(pin_mic);

    //levels[levelId++] = level;
    //if (levelId == levels.length) levelId = 0;
    //int sum = 0;
    //for (int i = 0; i < levels.length; i++) sum += levels[i];
    //realLevel = (int)sum / levels.length;

    //if (!defaultSet) {
    //  defaultLevel = realLevel;     
    //  defaultCount++;
    //  if (defaultCount > 100) defaultSet = true;
    //}

    //realLevel = constrain(-realLevel + defaultLevel, 60, 120);  

    if (arduino.digitalRead(pin_b2) == 1) {      
      hi += 10;
    } else hi = 0;

    left.rotate_(constrain(hi, 30, 120)); // 0이 들어간다 
    right.rotate_(constrain(hi, 30, 120));
  }

  int hi;

  int bId = 0;
  void generateTestingBall() {
    if (keyPressed && key == ENTER) {
      balls.add(new Ball(bId++, width/2+568*player, ballSlot, new PVector(player * random(100, 300), 0), "Stupid"));
      println(bId);
      world.add((balls.get(balls.size() - 1)));
    }
  }

  float angle;
  void detectWin() {
    if (this.score <= -5) {
      pushMatrix();
      translate(width/2, height/2);
      rotate(radians(angle));
      angle++;
      fill(255, 0, 0);
      textSize(25);
      textAlign(CENTER, CENTER);
      text(this.name + " is " + sumString(loserStorage), 0, 0);
      p1.lost = true;
      p2.lost = true;
      finished = true;
      world.clear();
      popMatrix();
    }
  }

  void displayLoserStorage() {
    textSize(30);
    pushMatrix();
    translate(width/2 + player * 400, y);
    rotate(radians(-90) * player);
    popMatrix();
  }

  void insulted() {
    if (!lost) {
      if (frameCount > preFrameCount + 90) {
        insult = "";
      }

      textSize(30);
      pushMatrix();
      translate(width/2 + player * 400, y);
      rotate(radians(-90) * player);
      fill(255);
      text(insult, 0, 0);
      popMatrix();
    }
  }
}