class Ball extends FCircle {

  int id;
  float size = 50;
  ArrayList<String> msgStorage = new ArrayList<String>();
  boolean disappeared = false;

  Ball(int id, float x, float y, PVector velocity, String msg) {
    super(50);

    this.id = id;
    this.msgStorage.add(msg);

    this.setGroupIndex(id);
    this.setPosition(x, y);
    this.setRestitution(1);  
    this.setVelocity(velocity.x, velocity.y);
    this.setFriction(0);
    //this.addTorque(10);
    this.setDamping(0);
    this.setNoStroke();
    this.setNoFill();
    this.setAllowSleeping(false);
  }

  void moveText() {   
    if (!disappeared) {
      textAlign(CENTER, TOP);

      String msgSum = sumString(msgStorage);
      while (msgSum.length() < 7) {
        msgSum += 'ㅗ';
      }

      pushMatrix();
      translate(this.getX(), this.getY());

      float r;
      float ts;
      float arclength = 0;

      for (int i = 0; i < msgSum.length(); i++) {   
        r = size / pow(2, ((int)i/7) + 1);
        ts = r / 2;

        textSize(ts);
        char currentChar = msgSum.charAt(i);

        float w = textWidth(currentChar);
        arclength += w;

        float theta = PI + arclength / r;    

        pushMatrix();  
        translate(r*cos(theta), r*sin(theta));
        rotate(theta+PI/2); 
        fill(0);
        if (!finished) text(currentChar, 0, 0);
        popMatrix();

        arclength += w;
      }

      popMatrix();
    }
  }
}