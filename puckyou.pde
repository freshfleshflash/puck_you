// pins {mic, button1, button2, left, right}
// player class에서 레벨 빼자!!!
// 사운드 인풋 관련 다 빼자!!!!

int[] pins2 = {1, 2, 3, 5, 6};
int[] pins1 = {0, 9, 8, 11, 10};
String p1_name = "Thomas";
String p2_name = "John";

import cc.arduino.*;
import processing.serial.*;
import muthesius.net.*;
import org.webbitserver.*;
import fisica.*;
import geomerative.*;

Arduino arduino;
WebSocketP5 socket1, socket2;
FWorld world;

int prePressed1 = 0;
int prePressed2 = 0;

ArrayList<Border> scoreBorders = new ArrayList<Border>();
ArrayList<Border> borders = new ArrayList<Border>();
ArrayList<WhiteObstacle> whiteObstacles = new ArrayList<WhiteObstacle>();
ArrayList<BlackObstacle> blackObstacles = new ArrayList<BlackObstacle>();
String[] oWordsStorage = {"", "Shit", "Crap"}; 
ArrayList<Ball> balls = new ArrayList<Ball>();

Player p1, p2;
PFont font;
PImage bg;

boolean finished = false;

color normalColor = color(0, 120, 129);
color chargingColor = color(129, 0, 120);

int wNum = 1;
int bNum = 1;

void setup() {
  size(1280, 640);
  smooth();

  bg = loadImage("totalbg.jpg");

  // arduino
  setArduino();

  // socket
  socket1 = new WebSocketP5(this, 8080, "socket1");
  socket2 = new WebSocketP5(this, 9090, "socket2");

  // fisica
  Fisica.init(this);
  RG.init(this);
  RG.setPolygonizer(RG.ADAPTATIVE);

  world = new FWorld();
  world.setGravity(0, 0);
  world.setEdges(color(0, 0, 0, 0));
  world.setEdgesFriction(0);
  world.setEdgesRestitution(1);

  renderBorders();
  renderScorescoreBorders();
  renderObstacles();

  // player
  p1 = new Player(pins1, -1, p1_name);
  p2 = new Player(pins2, 1, p2_name);

  // etc.
  font = createFont("ArialRoundedMTBold-48.vlw", 24);
  textFont(font);
}

void draw() { 
  image(bg, 0, 0);

  p1.method();
  p2.method();

  world.draw();
  world.step();

  manageBalls();
  controlBallCreation();
  //controlBallCreationWithKey();
}

void setArduino() {
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[2], 57600);

  for (int i = 1; i < 3; i++) {
    arduino.pinMode(pins1[i], Arduino.INPUT); // player 1
    arduino.pinMode(pins2[i], Arduino.INPUT); // player 2
  }

  for (int i = 3; i < 5; i++) {
    arduino.pinMode(pins1[i], Arduino.SERVO); // player 1
    arduino.pinMode(pins2[i], Arduino.SERVO); // player 2
  }
}

void stop() {
  socket1.stop();
  socket2.stop();
}

// player별로 따로 관리하고 싶으나 socket 연동하려니까 이거 어째..
void controlBallCreation() {
  if (((arduino.digitalRead(p1.pin_b1) - prePressed1) == 1)) {
    p1.portal = true;
    socket1.broadcast("start1");
    prePressed1 = 1;
    p1.chargers[0].c = chargingColor;
    p1.charging = true;
  } else if ((arduino.digitalRead(p1.pin_b1) - prePressed1 == -1)) { 
    p1.portal = false;
    socket1.broadcast("stop1");    
    prePressed1 = 0;
    p1.charged = 0;
    p1.charging = false;
  }

  if (((arduino.digitalRead(p2.pin_b1) - prePressed2) == 1)) {
    p2.portal = true;
    socket2.broadcast("start2");
    prePressed2 = 1;
    p2.chargers[0].c = chargingColor;
    p2.charging = true;
  } else if ((arduino.digitalRead(p2.pin_b1) - prePressed2 == -1)) { 
    p2.portal = false;
    socket2.broadcast("stop2");
    prePressed2 = 0;
    p2.charged = 0;
    p2.charging = false;
  }
}

// player별로 따로 관리하고 싶으나 socket 연동하려니까 이거 어째..
void controlBallCreationWithKey() {
  if (keyPressed && keyCode == LEFT) {
    p1.portal = true;
    socket1.broadcast("start1");
    prePressed1 = 1;
    p1.chargers[0].c = chargingColor;
    p1.charging = true;
    p1.charged++;
    if (p1.charged > 6*50) p1.charged = 0;
  } else { 
    p1.portal = false;
    socket1.broadcast("stop1");    
    prePressed1 = 0;
    p1.charged = 0;
    p1.charging = false;
  }

  if (keyPressed && keyCode == RIGHT) {
    p2.portal = true;
    socket2.broadcast("start2");
    prePressed2 = 1;
    p2.chargers[0].c = chargingColor;
    p2.charging = true;
    p2.charged++;
    if (p2.charged > 6*50) p2.charged = 0;
  } else { 
    p2.portal = false;
    socket2.broadcast("stop2");
    prePressed2 = 0;
    p2.charged = 0;
    p2.charging = false;
  }
}

int bId = 0;
void websocketOnMessage(WebSocketConnection con, String msg) {
  Player p = (msg.substring(0, 3).equals("[a]")) ? p1 : p2;

  println(msg);

  msg = split(msg, ']')[1];

  int sob = msg.indexOf("개**");
  if (sob != -1) {
    msg = msg.substring(0, sob) + "개새끼" + msg.substring(sob+3, msg.length());
  }

  int fuck = msg.indexOf("f***");
  if (fuck != -1) {
    msg = msg.substring(0, fuck) + "fuck" + msg.substring(fuck+4, msg.length());
  }

  balls.add(new Ball(bId++, p.x, p.ballSlot, new PVector(p.player * -400, 0), msg));

  world.add((balls.get(balls.size() - 1)));
}

void websocketOnOpen(WebSocketConnection con) {
  println("A client joined ");
}

void websocketOnClosed(WebSocketConnection con) {
  println("A client left ");
}

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

void renderScorescoreBorders() {
  float borderW = 260;
  float borderH = 20; 

  scoreBorders.add(new Border(0, height/2, borderH, borderW, -1001));
  scoreBorders.add(new Border(width, height/2, borderH, borderW, -1002));

  for (int i = 0; i < scoreBorders.size(); i++) {
    world.add(scoreBorders.get(i));
  }
}

void renderObstacles() {
  whiteObstacles.add(new WhiteObstacle());
  blackObstacles.add(new BlackObstacle());
  whiteObstacles.add(new WhiteObstacle(1, 480, 168));

  for (int i = 1; i <= wNum; i++) {
    world.add(whiteObstacles.get(i));
  }

  blackObstacles.add(new BlackObstacle(1, 722, 341));

  for (int i = 1; i <= bNum; i++) {
    world.add(blackObstacles.get(i));
  }
}

void manageBalls() {
  for (int i = 0; i < balls.size(); i++) {
    if (balls.get(i) != null) {
      balls.get(i).moveText();
    }
  }
}

// 가서 부딪치는 애(공)가 getBody2() 임 
void contactEnded(FContact c) {
  int cId = c.getBody1().getGroupIndex();
  int bId = c.getBody2().getGroupIndex();

  if ((cId < 0) && cId > -1000) {
    int occupied = balls.get(bId).msgStorage.size();

    if (cId > -100) {  // white obstacle
      if (occupied < 4) balls.get(bId).msgStorage.add(oWordsStorage[-cId]);
    } else { // black obstacle
      if (occupied > 1) {
        balls.get(bId).msgStorage.remove(balls.get(bId).msgStorage.size() - 1);
      } else {     
        balls.get(bId).disappeared = true;
        world.remove(balls.get(bId));
      }
    }
  }

  if ((cId == -1001) || (cId == -1002)) {  
    balls.get(bId).disappeared = true;

    String loserWords = sumString(balls.get(bId).msgStorage);

    if (cId == -1001 && !p1.lost) {
      p1.score--;
      p1.loserStorage.add(loserWords);
      p1.insult = loserWords;
      p1.preFrameCount = frameCount;
      println("p1 ", loserWords);
    } else if (cId == -1002 && !p2.lost) {
      p2.score--;
      p2.loserStorage.add(loserWords);
      p2.insult = loserWords;
      p2.preFrameCount = frameCount;
      println("p2 ", loserWords);
    }

    world.remove(balls.get(bId));
  }
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





boolean isSwearingContained() {

  return true;
}