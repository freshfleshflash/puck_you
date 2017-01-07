class Player {

  int pin_b1, pin_b2, pin_left, pin_right, player, displayingInsultCount;
  int score = 10;
  float x, slot;
  float y = height/2;
  float xGap = 400;
  float slotGap = 287;
  String name;
  String insult = "";
  ArrayList<String> insults = new ArrayList<String>();

  Player(int player, int[] pins, String name) {
    this.player = player;

    this.pin_b1 = pins[0];
    this.pin_b2 = pins[1];
    this.pin_left = pins[2];
    this.pin_right = pins[3];

    this.x = width/2 + xGap * player;
    this.slot = height/2 + slotGap * player;

    this.name = name;
  }

  void method() {
    displayScores();
    displayInsult();
    detectLost();
  }

  void displayScores() {
    float r = 26;

    for (int i = 0; i < score; i++) {
      pushStyle();
      fill(255);
      noStroke();
      ellipse(width/2 + (612 + i * -19) * player, height/2 + 287 * player, r, r);  
      popStyle();
    }
  }

  void displayInsult() {
    if (finished) insult = "";

    if (frameCount > displayingInsultCount + 90) {
      insult = "";
    }

    pushMatrix();
    translate(width/2 + 400 * player, y);
    rotate(radians(-90) * player);
    pushStyle();
    textAlign(CENTER, CENTER);
    textSize(30);
    fill(255);
    text(insult, 0, 0);
    popStyle();
    popMatrix();
  }

  float finalInsultAng;

  void detectLost() {
    if (score == 0) {
      world.clear();
      finished = true;

      pushMatrix();
      translate(width/2, height/2);
      rotate(radians(finalInsultAng));
      finalInsultAng++;
      pushStyle();
      textSize(25);
      textAlign(CENTER, CENTER);
      fill(255, 0, 0);
      text(this.name + " is " + sumString(insults), 0, 0);
      popStyle();
      popMatrix();
    }
  }
}