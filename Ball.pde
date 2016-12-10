class Ball extends FCircle {
  
  int id;
  String msg;
  float size = 100;

  Ball(int id, float x, float y, PVector velocity) {
    super(100);

    this.id = id;

    this.setGroupIndex(id);
    this.setPosition(x, y);
    this.setRestitution(1);  
    this.setVelocity(velocity.x, velocity.y);
    this.setFriction(0);
    //this.addTorque(10);
    this.setDamping(0);
    this.setNoStroke();
  }

  void moveText() {   
    textAlign(CENTER, TOP);
    
    msg = wordsStorage.get(id);
    while (msg.length() < 7) {
      msg += 'ㅗ';
    }
  
    float r = size / 2;
    float ts = (int)r / 2;
    textSize(ts);

    pushMatrix();
    translate(this.getX(), this.getY());
    //noFill();
    //noStroke();
    //ellipse(0, 0, r*2, r*2);

    float arclength = 0;
    for (int i = 0; i < msg.length(); i++) {   
      char currentChar = msg.charAt(i);

      float w = textWidth(currentChar);
      arclength += w/1;

      float theta = PI + arclength / r;    

      pushMatrix();  
      translate(r*cos(theta), r*sin(theta));
      rotate(theta+PI/2); 
      fill(0);
      text(currentChar, 0, 0);
      popMatrix();

      arclength += w/1;
    }

    popMatrix();
  }
}