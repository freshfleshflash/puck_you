/*
rightPinNum = 8
 */

boolean arduinoOn = false;
float levelThreshold = 400;

import muthesius.net.*;
import org.webbitserver.*;
import processing.serial.*;
import cc.arduino.*;
import processing.sound.*;

Amplitude amp;
AudioIn in;
Arduino arduino;
WebSocketP5 socket;

ArrayList<String> wordsStorage = new ArrayList<String>();
String ballMsg = "Say some words!";
boolean served = false;
PFont font;
PImage handle;

Ball b;
Player p1;

void setup() {
  size(displayWidth, displayHeight);
  smooth();

  socket = new WebSocketP5(this, 8080);

  b = new Ball(width/2, height/2);
  p1 = new Player(0, height/2, 7, 8);

  fill(0);
  font = createFont("Arial-Black-32.vlw", 24);
  textFont(font);

  handle = loadImage("handle.png");

  if (arduinoOn) {
    println(Arduino.list());
    arduino = new Arduino(this, Arduino.list()[2], 57600);
    arduino.pinMode(7, Arduino.SERVO);
    arduino.pinMode(8, Arduino.SERVO);
  }

  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);
}

void draw() {
  background(255);

  println(amp.analyze() * 10000);

  pushStyle();
  stroke(0, 0, 255);
  //line(0, height/2, width, height/2);
  popStyle();

  b.display();
  p1.display();
  p1.voiceControl();
  p1.keyControl();

  for (int i = 1; i < wordsStorage.size(); i++) {
    text(wordsStorage.get(i), width * 0.75, i * 30);
  }
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

void connectArduino() {
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[2], 57600);
  arduino.pinMode(7, Arduino.SERVO);
  arduino.pinMode(8, Arduino.SERVO);
}

void websocketOnOpen(WebSocketConnection con) {
  println("A client joined");
}

void websocketOnClosed(WebSocketConnection con) {
  println("A client left");
}