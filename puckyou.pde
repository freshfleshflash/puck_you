/* rightPinNum = 8 */

boolean arduinoOn = false;
float levelThreshold = 400;

import muthesius.net.*;
import org.webbitserver.*;
import fisica.*;
import geomerative.*;
import processing.serial.*;
import cc.arduino.*;
import processing.sound.*;

WebSocketP5 socket;
FWorld world;
Arduino arduino;
Amplitude amp;
AudioIn in;

ArrayList<Border> borders = new ArrayList<Border>();
Ball ball;
Racket racket;

ArrayList<String> wordsStorage = new ArrayList<String>();
String ballMsg = "Say some words!";
boolean served = false;
PFont font;

ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
static int oId = 0;

Player player1, player2;



Obstacle o;
color oColor;
String oMsg = "obstacle";

void setup() {
  size(displayWidth, displayHeight);
  smooth();

  textSize(20);

  socket = new WebSocketP5(this, 8080);

  Fisica.init(this);
  RG.init(this);
  RG.setPolygonizer(RG.ADAPTATIVE);

  world = new FWorld();
  world.setGravity(0, 0);
  world.setEdges(color(0, 0, 0, 0));
  world.setEdgesFriction(0);
  //world.setEdgesRestitution(1);

  float borderW = 600;
  float borderH = 20;

  borders.add(new Border(width/2, borderH, borderW, borderH, 0));
  borders.add(new Border(width/2, height-borderH, borderW, borderH, 0));
  borders.add(new Border(borderH, height/2, borderH, borderW, 0));
  borders.add(new Border(width-borderH, height/2, borderH, borderW, 0));

  borders.add(new Border((width-borderW)/4, (height-borderW)/4, borderH, borderW/2, 75));
  borders.add(new Border(width - (width-borderW)/4, (height-borderW)/4, borderH, borderW/2, 105));
  borders.add(new Border((width-borderW)/4, height - (height-borderW)/4, borderH, borderW/2, 105));
  borders.add(new Border(width - (width-borderW)/4, height - (height-borderW)/4, borderH, borderW/2, 75));

  for (int i = 0; i < 4; i++) {
    obstacles.add(new Obstacle(random((width-borderW)/4, width - (width-borderW)/4), random((height-borderW)/4, height - (height-borderW)/4)));
  }

  ball = new Ball(100);

  player1 = new Player(-1, 200, height/2);
  player2 = new Player(1, width - 200, height/2);

  for (int i = 0; i < borders.size(); i++) {
    world.add(borders.get(i));
  }
  for (int i = 0; i < obstacles.size(); i++) {
    world.add(obstacles.get(i));
  }
  world.add(ball);



  if (arduinoOn) connectArduino();

  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);

  font = createFont("Arial-Black-24.vlw", 24);
  textFont(font);
}

void draw() {
  background(255);
  renderButton();

  println(ball.getVelocityX(), ball.getVelocityY());



  player1.voiceControl();
  player1.keyControl();

  player2.voiceControl();
  player2.keyControl();

  world.draw();
  world.step();

  fill(0);
  pushMatrix();
  translate(ball.getX(), ball.getY());
  rotate(radians(45));
  rotate(ball.getRotation());
  text(ballMsg, -textWidth(ballMsg)/2, 0);
  popMatrix();

  //println(amp.analyze() * 10000);

  for (int i = 0; i < wordsStorage.size(); i++) {
    fill(50);
    text(wordsStorage.get(i), width * 0.75, (i + 1) * 30);
  }

  line(0, height/2, 1280, height/2);
  line(width/2, 0, width/2, 800);
}

void stop() {
  socket.stop();
}

void websocketOnMessage(WebSocketConnection con, String inputMsg) {
  println(inputMsg);

  if (inputMsg.equals("f***")) {
    inputMsg = "fuck";
  }

  if (inputMsg.equals("b****")) {
    inputMsg = "bitch";
  } 

  if (inputMsg.equals("개**")) {
    inputMsg = "개새끼";
  } 


  if (!served) {
    ballMsg = inputMsg;
    served = true;
  } else {
    wordsStorage.add(inputMsg);
  }

  println("[wordsStorage] ");
  for (int i = 0; i < wordsStorage.size(); i++) {
    print(wordsStorage.get(i) + " ");
  }
  println();
}

void websocketOnOpen(WebSocketConnection con) {
  println("A client joined");
}

void websocketOnClosed(WebSocketConnection con) {
  println("A client left");
}

void connectArduino() {
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[2], 57600);
  arduino.pinMode(7, Arduino.SERVO);
  arduino.pinMode(8, Arduino.SERVO);
}

color buttonColor = color(0, 255, 0);

void keyPressed() {
  buttonColor = color(255, 0, 0);
  socket.broadcast("start");
}

void keyReleased() {
  buttonColor = color(0, 255, 0);
  socket.broadcast("stop");
}

void renderButton() {
  noStroke();
  fill(buttonColor);
  ellipse(30, 0, 50, 50);
}

int oNum = 0;

void contactEnded(FContact c) {
  if (wordsStorage.size() > oNum) {

    if (c.getBody1().getGroupIndex() == 1 || c.getBody2().getGroupIndex() == 1) {
      ballMsg += wordsStorage.get(oNum);
      oNum++;
    }
  }
}

void mouseClicked() {
  ball.setVelocity(500, 500);
}