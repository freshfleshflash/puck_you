// pins {mic, button1, button2, left, right}

int[] pins1 = {1, 2, 3, 5, 6};
int[] pins2 = {0, 8, 9, 10, 11};

import cc.arduino.*;
import processing.serial.*;
import muthesius.net.*;
import org.webbitserver.*;
import fisica.*;
import geomerative.*;

Arduino arduino;

WebSocketP5 socket1, socket2;

int prePressed1 = 0;
int prePressed2 = 0;

FWorld world;

ArrayList<Border> scoreBorders = new ArrayList<Border>();
ArrayList<Border> borders = new ArrayList<Border>();
ArrayList<WhiteObstacle> whiteObstacles = new ArrayList<WhiteObstacle>();
ArrayList<BlackObstacle> blackObstacles = new ArrayList<BlackObstacle>();
String[] oWordsStorage = {"", "정말로", "이런", "아오"}; 
ArrayList<Ball> balls = new ArrayList<Ball>();

Player p1, p2;
PFont font;
PImage bg;

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
  //renderObstacles();

  // player
  p1 = new Player(pins1, -1);
  p2 = new Player(pins2, 1);

  // etc.
  font = createFont("Arial-Black-24.vlw", 24);
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
  controlBallCreationWithKey();
}

int hmm = 0;

void setArduino() {
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[2], 57600);

  //  for (int i = 0; i < 3; i++) {
  //    arduino.pinMode(pins1[i], Arduino.INPUT); // player 1
  //    arduino.pinMode(pins2[i], Arduino.INPUT); // player 2
  //  }

  for (int i = 3; i < 5; i++) {
    arduino.pinMode(pins1[i], Arduino.SERVO); // player 1
    println(pins1[i]);
    arduino.pinMode(pins2[i], Arduino.SERVO); // player 2
    println(pins2[i]);
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
  } else if ((arduino.digitalRead(p1.pin_b1) - prePressed1 == -1)) { 
    p1.portal = false;
    socket1.broadcast("stop1");    
    prePressed1 = 0;
  }

  if (((arduino.digitalRead(p2.pin_b1) - prePressed2) == 1)) {
    p2.portal = true;
    socket2.broadcast("start2");
    prePressed2 = 1;
  } else if ((arduino.digitalRead(p2.pin_b1) - prePressed2 == -1)) { 
    p2.portal = false;
    socket2.broadcast("stop2");
    prePressed2 = 0;
  }
}

// player별로 따로 관리하고 싶으나 socket 연동하려니까 이거 어째..
void controlBallCreationWithKey() {
  if (keyPressed && keyCode == LEFT) {
    p1.portal = true;
    socket1.broadcast("start1");
    prePressed1 = 1;
  } else { 
    p1.portal = false;
    socket1.broadcast("stop1");    
    prePressed1 = 0;
  }

  if (keyPressed && keyCode == RIGHT) {
    p2.portal = true;
    socket2.broadcast("start2");
    prePressed2 = 1;
  } else { 
    p2.portal = false;
    socket2.broadcast("stop2");
    prePressed2 = 0;
  }
}

int bId = 0;
void websocketOnMessage(WebSocketConnection con, String msg) {
  Player p = (msg.substring(0, 3).equals("[a]")) ? p1 : p2;

  balls.add(new Ball(bId++, p.x, p.ballSlot, new PVector(p.player * -500, 0), split(msg, ']')[1]));
  world.add((balls.get(balls.size() - 1)));
}

void websocketOnOpen(WebSocketConnection con) {
  println("A client joined ");
}

void websocketOnClosed(WebSocketConnection con) {
  println("A client left ");
}

void renderBorders() {

  //world.add(new FSVGB("b1.svg", 0, 0, 500, 400));

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

  float borderW = 600;
  for (int i = 1; i <= 1; i++) {
    whiteObstacles.add(new WhiteObstacle(i, random((width-borderW)/4, width - (width-borderW)/4), random((height-borderW)/4, height - (height-borderW)/4)));
    world.add(whiteObstacles.get(i));
  }

  for (int i = 1; i <= 3; i++) {
    blackObstacles.add(new BlackObstacle(i, random((width-borderW)/4, width - (width-borderW)/4), random((height-borderW)/4, height - (height-borderW)/4)));
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
    //println(occupied);

    if (cId > -100) {  // white obstacle
      if (occupied < 4) balls.get(bId).msgStorage.add(oWordsStorage[-cId]);
    } else { // black obstacle
      if (occupied != 0) {
        balls.get(bId).msgStorage.remove(balls.get(bId).msgStorage.size() - 1);
      } else {     
        balls.get(bId).disappeared = true;
        world.remove(balls.get(bId));
      }
    }
  }

  if ((cId == -1001) || (cId == -1002)) {  
    balls.get(bId).disappeared = true;

    String loserWords = "";
    for (int i = 0; i < balls.get(bId).msgStorage.size(); i++) {
      loserWords += balls.get(bId).msgStorage.get(i);
    }

    if (cId == -1001) {
      p1.score--;
      p1.loserStorage.add(loserWords);
    } else if (cId == -1002) {
      p2.score--;
      p1.loserStorage.add(loserWords);
    }

    world.remove(balls.get(bId));
  }
}

String sumString(ArrayList<String> arrListString) {
  String sum = "";

  for (int i = 0; i < arrListString.size(); i++) {
    sum += arrListString.get(i);
  }

  return sum;
}

void mouseClicked() {
  println(mouseX, mouseY);
}