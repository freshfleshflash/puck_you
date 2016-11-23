/* rightPinNum = 8 */

boolean arduinoOn = false;
float levelThreshold = 40;

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

color borderColor = color(255, 255, 0);

ArrayList<Border> borders = new ArrayList<Border>();
Ball ball;
Racket racket;

float borderW = 20;

ArrayList<String> wordsStorage = new ArrayList<String>();
String ballMsg = "Say some words!";
boolean served = false;
PFont font;

Player player1, player2;

void setup() {
  size(displayWidth, displayHeight);
  smooth();

  socket = new WebSocketP5(this, 8080);

  Fisica.init(this);
  RG.init(this);
  RG.setPolygonizer(RG.ADAPTATIVE);
  world = new FWorld();
  world.setEdges(borderColor);
  world.setEdgesFriction(0);
  world.setGravity(0, 0);

  //borders.add(new Border(640, borderW/2, 900, borderW, 0));
  //borders.add(new Border(640, 800-borderW/2, 900, borderW, 0));
  //borders.add(new Border(400, 200, borderW, 200, 45));

  ball = new Ball(50);

  player1 = new Player(-1, 200, height/2);
  player2 = new Player(1, width - 200, height/2);

  //racket = new Racket();

  world.add(ball);
  //world.add(racket);
  for (int i = 0; i < borders.size(); i++) {
    world.add(borders.get(i));
  }

  if (arduinoOn) connectArduino();

  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);
}



void draw() {
  background(255);

  player1.voiceControl();
  //player1.keyControl();

  player2.voiceControl();
  //player2.keyControl();

  world.draw();
  world.step();

  println(amp.analyze() * 10000);


  for (int i = 1; i < wordsStorage.size(); i++) {
    text(wordsStorage.get(i), width * 0.75, i * 30);
  }

  line(0, height/2, 1280, height/2);
  line(width/2, 0, width/2, 800);
}

void stop() {
  socket.stop();
}

void websocketOnMessage(WebSocketConnection con, String inputMsg) {
  println(inputMsg);

  //switch
  if (inputMsg.equals("f***")) {
    inputMsg = "fuck";
  }

  if (inputMsg.equals("b****")) {
    inputMsg = "bitch";
  } 

  if (inputMsg.equals("개**")) {
    inputMsg = "개새끼";
  } 

  wordsStorage.add(inputMsg);

  println("[wordsStorage] ");
  for (int i = 0; i < wordsStorage.size(); i++) {
    print(wordsStorage.get(i) + " ");
  }
  println();

  if (!served) {
    ballMsg = inputMsg;
    served = true;
  }
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