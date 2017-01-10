// pins {b1, b2, left, right}

int[] pins1 = {2, 3, 5, 6};
int[] pins2 = {9, 8, 10, 11};

import cc.arduino.*;
import processing.serial.*;
import ddf.minim.*;
import ddf.minim.ugens.*;
import guru.ttslib.*;
import muthesius.net.*;
import org.webbitserver.*;
import fisica.*;
import geomerative.*;

boolean finished = false;
Player p1, p2;
PImage bg;
PShape fff;
final int totalScore = 2;

void setup() {
  size(1280, 640);
  smooth();

  bg = loadImage("bg3.jpg");
  fff = loadShape("fff.svg");
  textFont(createFont("HelveticaNeue-Bold-48.vlw", 48));

  setArduino();
  setAudio();
  setSocket();
  setWorld();

  p1 = new Player(-1, pins1, "Sarah");
  p2 = new Player(1, pins2, "Anna");
}

void draw() {
  image(bg, 0, 0);

  //testArduino();
  controlConnection();

  world.draw();
  world.step();

  p1.method();
  p2.method();

  manageComponents();
}

// arduino
Arduino arduino;

void setArduino() {
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[2], 57600);

  for (int i = 0; i < 2; i++) {
    arduino.pinMode(pins1[i], Arduino.INPUT); 
    arduino.pinMode(pins2[i], Arduino.INPUT);
  }

  for (int i = 2; i < 4; i++) {
    arduino.pinMode(pins1[i], Arduino.SERVO); 
    arduino.pinMode(pins2[i], Arduino.SERVO);
  }
}

void testArduino() {  
  println(arduino.digitalRead(pins1[0]), arduino.digitalRead(pins1[1]), arduino.digitalRead(pins2[0]), arduino.digitalRead(pins2[1]));
}

Minim minim;
AudioInput in;
AudioRecorder recorder;
AudioPlayer bleep, goal, giggle;
TTS tts;

void setAudio() {
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 2048);
  bleep = minim.loadFile("sound/bleep.wav");
  goal = minim.loadFile("sound/goal.mp3");
  giggle = minim.loadFile("sound/giggle.wav");
  tts = new TTS();
}

// socket & ball creation
WebSocketP5 socket;
ArrayList<Ball> balls = new ArrayList<Ball>();

void setSocket() {
  socket = new WebSocketP5(this, 8080);
}

void websocketOnOpen(WebSocketConnection con) {
  println("A client joined");
}

void websocketOnClosed(WebSocketConnection con) {
  println("A client left");
}

void stop() {
  socket.stop();
}

boolean occupied = false;
boolean recorded = false;
Player occupyingPlayer;
int recordId = 0;

void controlConnection() {
  if (!occupied && (arduino.digitalRead(p1.pin_b2) - int(occupied) == 1 || arduino.digitalRead(p2.pin_b2) - int(occupied) == 1)) { 
    occupyingPlayer = (arduino.digitalRead(p1.pin_b2) - int(occupied) == 1) ? p1 : p2;
    occupied = true;
    occupyingPlayer.charger.charging = true;
    occupyingPlayer.charger.chargingTime = frameCount;
    socket.broadcast("start");
    recorder = minim.createRecorder(in, "audio/" + recordId + ".wav");
    recorder.beginRecord();
  } else if (occupied && arduino.digitalRead(occupyingPlayer.pin_b2) - int(occupied) == -1) {
    socket.broadcast("stop");
    occupied = false;
    occupyingPlayer.charger.charging = false;
    occupyingPlayer.charger.chargingTime = 0;
    recorder.endRecord();
  }
}

int ballId = 0;

void websocketOnMessage(WebSocketConnection con, String msg) {
  println("[websocketOnMessage] " + msg);

  int fuck = msg.indexOf("f***");
  int asshole = msg.indexOf("a******");
  int bitch = msg.indexOf("b****");
  int bullshit = msg.indexOf("b*******");

  if (fuck != -1) msg = msg.substring(0, fuck) + "fuck" + msg.substring(fuck+4, msg.length());
  if (asshole != -1) msg = msg.substring(0, asshole) + "asshole" + msg.substring(asshole+6, msg.length());
  if (bitch != -1) msg = msg.substring(0, bitch) + "bitch" + msg.substring(bitch+5, msg.length());
  if (bullshit != -1) msg = msg.substring(0, bullshit) + "bullshit" + msg.substring(bullshit+8, msg.length());

  if (filterWords(msg)) {
    recorder.save();
    recordId++;

    balls.add(new Ball(ballId++, occupyingPlayer, msg));
    world.add(balls.get(balls.size() - 1));
  }
}

// test
void keyReleased() {  
  int inputKey = keyCode - 48;
  if (!occupied && (inputKey == p1.pin_b2 || inputKey == p2.pin_b2)) {
    occupyingPlayer = (inputKey == p1.pin_b2) ? p1 : p2;
    occupied = true;
    occupyingPlayer.charger.charging = true;
    occupyingPlayer.charger.chargingTime = frameCount;
    socket.broadcast("start");
    recorder = minim.createRecorder(in, "audio/" + recordId + ".wav");
    recorder.beginRecord();
  } else if (occupied && (inputKey == occupyingPlayer.pin_b2)) {
    socket.broadcast("stop");
    occupied = false;
    occupyingPlayer.charger.charging = false;
    occupyingPlayer.charger.chargingTime = 0;
    recorder.endRecord();
    ////
    //recorder.save();
    //recordId++;

    //balls.add(new Ball(ballId++, occupyingPlayer, "TEST"));
    //world.add(balls.get(balls.size() - 1));
    ////
  }
}

void manageComponents() {
  for (int i = 0; i < balls.size(); i++) {
    if (balls.get(i) == null) break;
    balls.get(i).display();
  }

  for (int i = 1; i < whiteObstacles.size(); i++) {
    if (whiteObstacles.get(i) == null) break;
    whiteObstacles.get(i).displaySquare();
  }

  for (int i = 1; i < blackObstacles.size(); i++) {
    if (blackObstacles.get(i) == null) break;
    blackObstacles.get(i).displaySquare();
  }
}

FWorld world;

void setWorld() {
  Fisica.init(this);
  RG.init(this);
  RG.setPolygonizer(RG.ADAPTATIVE);

  world = new FWorld();
  world.setGravity(0, 0);
  world.setEdges(color(0, 0, 0, 0));
  world.setEdgesFriction(0);
  world.setEdgesRestitution(1);

  renderBorders();
  renderGoalPosts();
  renderObstacles();
}

ArrayList<Border> borders = new ArrayList<Border>();

void renderBorders() {
  borders.add(new Border(72, 132, 201, 3, -45, true));
  borders.add(new Border(452, 63, 614, 3));
  borders.add(new Border(258, 128, 144, 13));
  borders.add(new Border(159, 156, 85, 13, -45, true));
  borders.add(new Border(1023, 128, 144, 13));
  borders.add(new Border(1122, 156, 85, 13, 45, true));
  borders.add(new Border(687, 120, 142, 3));
  borders.add(new Border(1180, 108, 300, 3, 45, true));
  borders.add(new Border(width-72, height-132, 201, 3, -45, true));
  borders.add(new Border(width-452, height-63, 614, 3));
  borders.add(new Border(width-258, height-125, 144, 13));
  borders.add(new Border(width-159, height-152, 85, 13, -45, true));
  borders.add(new Border(width-1023, height-125, 144, 13));
  borders.add(new Border(width-1122, height-152, 85, 13, 45, true));
  borders.add(new Border(width-687, height-120, 142, 3));
  borders.add(new Border(width-1180, height-108, 300, 3, 45, true));

  for (int i = 0; i < borders.size(); i++) {
    world.add(borders.get(i));
  }

  FCircle c1 = new FCircle(90);
  c1.setStatic(true);
  c1.setPosition(800, 110);
  c1.setNoFill();
  c1.setNoStroke();
  world.add(c1);

  FCircle c2 = new FCircle(90);
  c2.setStatic(true);
  c2.setPosition(width-800, height-110);
  c2.setNoFill();
  c2.setNoStroke();
  world.add(c2);
}

ArrayList<Border> goalPosts = new ArrayList<Border>();

void renderGoalPosts() {
  float w = 245;
  float h = 20; 

  goalPosts.add(new Border(-1001, 0, height/2, h, w));
  goalPosts.add(new Border(-1002, width, height/2, h, w));

  for (int i = 0; i < goalPosts.size(); i++) {
    world.add(goalPosts.get(i));
  }
}

ArrayList<WhiteObstacle> whiteObstacles = new ArrayList<WhiteObstacle>();
ArrayList<BlackObstacle> blackObstacles = new ArrayList<BlackObstacle>();

void renderObstacles() {
  whiteObstacles.add(new WhiteObstacle()); 
  whiteObstacles.add(new WhiteObstacle(1, 480, 168));

  for (int i = 1; i < whiteObstacles.size(); i++) {
    world.add(whiteObstacles.get(i));
  }

  blackObstacles.add(new BlackObstacle());
  blackObstacles.add(new BlackObstacle(1, 722, 341));

  for (int i = 1; i < blackObstacles.size(); i++) {
    world.add(blackObstacles.get(i));
  }
}

String[] presetWords = {"", "SHIT", "HELL"}; 

void contactEnded(FContact c) {
  int objectId = c.getBody1().getGroupIndex();
  int ballId = c.getBody2().getGroupIndex();

  // goalPost
  if ((objectId == -1001) || (objectId == -1002)) { 
    playAudioWithSound(goal, balls.get(ballId).audio);

    Player player = (objectId == -1001) ? p1 : p2 ;    
    player.insult = sumString(balls.get(ballId).words);

    for (int i = 0; i < balls.get(ballId).words.size(); i++) {
      if (i == 0) player.insults.add(new Insult(ballId, balls.get(ballId).words.get(i), minim.loadFile("audio/" + ballId + ".wav")));    
      else player.insults.add(new Insult(-101, "SHIT", tts));
    }

    //String insult = sumString(balls.get(ballId).words);
    //Player player = (objectId == -1001) ? p1 : p2 ;    
    //player.insult = insult;
    //player.insults.add(new Insult(ballId, insult, minim.loadFile("audio/" + ballId + ".wav")));

    player.displayingInsultCount = frameCount;
    player.score--;

    balls.get(ballId).removed = true;
    world.remove(balls.get(ballId));
  }

  // obastacles
  if ((objectId < 0) && objectId > -1000) {
    playAudioWithSound(bleep, balls.get(ballId).audio);

    int wordsSize = balls.get(ballId).words.size();

    if (objectId > -100) {  // white obstacle
      whiteObstacles.get(-objectId).squareDisplayed = true;
      whiteObstacles.get(-objectId).displayingSquareTime = frameCount;  

      if (wordsSize < 4) {
        balls.get(ballId).words.add(presetWords[-objectId]);
      }
    } else {                // black obstacle
      blackObstacles.get(-objectId/100).squareDisplayed = true;
      blackObstacles.get(-objectId/100).displayingSquareTime = frameCount;  

      if (wordsSize > 1) {
        balls.get(ballId).words.remove(balls.get(ballId).words.size() - 1);
      } else {     
        balls.get(ballId).removed = true;
        world.remove(balls.get(ballId));
      }
    }
  }

  // flippers
  if (objectId == 10000) {
    //playAudioWithSound(giggle, balls.get(ballId).audio);
  }
}

void playAudioWithSound(AudioPlayer sound, AudioPlayer audio) {
  sound.setGain(2);
  audio.setGain(10);

  if (finished) {
    sound.pause();
    audio.pause();
  } else {
    sound.play();
    sound.rewind();
    audio.play();
    audio.rewind();
  }
}

String[] swearWords = {"arse", "ass", "asshole", "bastard", "bitch", "bloody", "bollocks", "crap", "cunt", "damn", "fuck", "hell", "Judas Priest", "nigga", "nigger", "shit", "whore"};

boolean filterWords(String words) {
  for (int i = 0; i < swearWords.length; i++) {
    if (words.indexOf(swearWords[i]) > -1) return true;
  }  
  return true;
}

String sumString(ArrayList<String> arrListString) {
  String sum = "";
  for (int i = 0; i < arrListString.size(); i++) {
    sum += arrListString.get(i) + " ";
  }
  return sum;
}

void mouseClicked() {
  println(mouseX, mouseY);
}