// pins {mic, button1, button2, left, right}

int[] pins1 = {5, 2, 3, 4, 5};
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

ArrayList<Border> borders = new ArrayList<Border>();
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
ArrayList<BlackObstacle> blackObstacles = new ArrayList<BlackObstacle>();
String[] oWordsStorage = {"", "정말로", "이런", "아오"}; 
ArrayList<Ball> balls = new ArrayList<Ball>();

Player p1, p2;
PFont font;

void setup() {
  size(displayWidth, displayHeight);
  smooth();

  println(width, height);

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
  renderObstacles();

  // player
  p1 = new Player(pins1, -1);
  p2 = new Player(pins2, 1);

  // etc.
  font = createFont("Arial-Black-24.vlw", 24);
  textFont(font);
}

void draw() {
  background(255);

  p1.method();
  p2.method();

  world.draw();
  world.step();

  manageBalls();
  //controlBallCreation();
  controlBallCreationWithKey();

  //drawCenterLine();
  //convertBooleanToInt();
}

void setArduino() {
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[2], 57600);

  for (int i = 0; i < 3; i++) {
    arduino.pinMode(pins1[i], Arduino.INPUT); // player 1
    arduino.pinMode(pins2[i], Arduino.INPUT); // player 2
  }

  arduino.pinMode(0, Arduino.INPUT);

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
  float borderW = 600;
  float borderH = 20; 

  borders.add(new Border(0, height/2, borderH, borderW, -1001));
  borders.add(new Border(width, height/2, borderH, borderW, -1002));

  for (int i = 0; i < borders.size(); i++) {
    world.add(borders.get(i));
  }
}

void renderObstacles() {
  obstacles.add(new Obstacle());
  blackObstacles.add(new BlackObstacle());

  float borderW = 600;
  for (int i = 1; i <= 1; i++) {
    obstacles.add(new Obstacle(i, random((width-borderW)/4, width - (width-borderW)/4), random((height-borderW)/4, height - (height-borderW)/4)));
    world.add(obstacles.get(i));
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
    println(occupied);

    if (cId > -100) {
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

void drawCenterLine() {
  stroke(100);
  line(0, height/2, 1280, height/2);
  line(width/2, 0, width/2, 800);
}

int pressed = 0;
void convertBooleanToInt() {
  if (keyPressed) pressed = 1;
  else pressed = 0;
}

String sumString(ArrayList<String> arrListString) {
  String sum = "";
  
  for(int i = 0; i < arrListString.size(); i++) {
    sum += arrListString.get(i);
  }
  
  return sum;
}