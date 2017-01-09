class Player {

  int pin_b1, pin_b2, pin_left, pin_right, player, displayingInsultCount;
  int score = 3;
  float x, slot;
  float y = height/2;
  float xGap = 400;
  float slotGap = 288;
  String name;
  String insult = "";
  ArrayList<Insult> insults = new ArrayList<Insult>();

  LeftRacket left;
  RightRacket right;
  Charger charger;

  Player(int player, int[] pins, String name) {
    this.player = player;
    this.pin_b1 = pins[0];
    this.pin_b2 = pins[1];
    this.pin_left = pins[2];
    this.pin_right = pins[3];
    this.x = width/2 + xGap * player;
    this.slot = height/2 + slotGap * player;
    this.name = name;

    left = new LeftRacket(this, 1);
    world.add(left);
    right = new RightRacket(this, -1);
    world.add(right);

    charger = new Charger(this);
  }

  void method() {
    controlFlippers();
    displayScores();
    displayInsult();
    detectLost();
    charger.display();
  }

  int flipperAng;

  void controlFlippers() {
    if (arduino.digitalRead(pin_b2) == 3 || (keyPressed && key == ENTER)) flipperAng += 10;
    else flipperAng = 0;

    left.rotate_(constrain(flipperAng, 30, 120));  
    right.rotate_(constrain(flipperAng, 30, 120));
  }

  void displayScores() {
    float r = 26;

    for (int i = 0; i < score; i++) {
      pushStyle();
      fill(0, 120, 131);
      noStroke();
      ellipse(width/2 + (612 + i * -19) * player, height/2 + slotGap * player, r, r);  
      popStyle();
    }
  }

  void displayInsult() {
    if (finished) insult = "";

    if (frameCount > displayingInsultCount + 90) insult = "";

    pushMatrix();
    translate(width/2 + 400 * player, y);
    rotate(radians(-90) * player);
    pushStyle();
    textAlign(CENTER, CENTER);
    textSize(30);
    fill(255, 233, 212);
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
      //rotate(radians(finalInsultAng));
      finalInsultAng++;
      pushStyle();
      textSize(25);
      textAlign(CENTER, CENTER);
      fill(229, 71, 70);

      String finalInsult = "";
      for (int i = 0; i < insults.size(); i++) {
        finalInsult += insults.get(i).words;
      }

      text(this.name + " is " + finalInsult, 0, 0);
      popStyle();
      popMatrix();

      int trackId = 0;  
      while (trackId < insults.size()) {
        if (insults.get(trackId).audio.isPlaying()) {
          insults.get(trackId).audio.pause();
        } else if (insults.get(trackId).audio.position() == insults.get(trackId).audio.length()) {
          insults.get(trackId).audio.rewind();
          trackId++;
        } else {
          insults.get(trackId).audio.play();
        }
      }
    }
  }
}