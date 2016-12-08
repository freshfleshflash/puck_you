//int racketAng = 0;

class Player {

  //int[] pins;
  // pins {mic, button1, button2, left, right}

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
    //this.generateBall();
    this.drawPortal();
    this.objectSomething();
  }

  // arduino.analogRead(pins[0]);
  void controlWithVoice() {
    level = arduino.analogRead(pin_mic);
    //ellipse(x, y, level, level);
    //println(pin_mic, level);

    //if (abs(level - preLevel) > 10) {
    //  racketAng = (int)map(level, levelThreshold, levelThreshold * 10, 0, 180);
    //}

    //racketAng--;
    //racketAng = constrain(racketAng, 0, 180);



    left.rotate_(level);
    right.rotate_(level);
  }

  // arduino.digitalRead(pins[1]);
  void generateBall() {
    ////if (pressed - prePressed == 1) {
    ////  socket.broadcast("start");
    ////  balls.add(new Ball(x, ballSlot, 50, new PVector(-500 * player, 0)));     
    ////  prePressed = 1;
    ////} else if (pressed - prePressed == -1) {
    ////  socket.broadcast("stop");
    ////  world.add(balls.get(balls.size() - 1));
    ////  prePressed = 0;
    ////}

    //if (arduino.digitalRead(pins[1]) - prePressed == 1) {
    //  socket.broadcast("start");
    //  //balls.add(new Ball(x, ballSlot, 50, new PVector(-500 * player, 0), "hello"));
    //  prePressed = 1;
    //} else if (arduino.digitalRead(pins[1]) - prePressed == -1) {
    //  socket.broadcast("stop");

    //  //if (wordsStorage.size() != 0) {
    //  balls.add(new Ball(x, ballSlot, 50, new PVector(-500 * player, 0), wordsStorage.get(wordsStorage.size() - 1)));
    //  world.add(balls.get(balls.size() - 1));
    //  //}

    //  println(wordsStorage.size());

    //prePressed = 0;
    //}

    //for (int i = 0; i < balls.size(); i++) {
    //  balls.get(i).move();
    //}
  }

  // arduino.digitalRead(pins[2]);
  void objectSomething() {
    Obstacle o = obstacles.get(0);

    //if (keyPressed) {
      if (arduino.digitalRead(pin_b2) == 1) {      
        pushStyle();
        noStroke();
        fill(255, 0, 0);
        //Obstacle o = obstacles.get((int)random(0, obstacles.size()-1));

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