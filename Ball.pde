class Ball extends FBox {

  String msg;
  int id;

  Ball(String msg, float w, float h, float x, float y, PVector velocity) {
    super(w, h);

    this.msg = msg;

    this.setPosition(x, y);
    this.setRestitution(2);  
    this.setVelocity(velocity.x, velocity.y);
    this.setFriction(0);
    this.addTorque(50);
    this.setDamping(0);

    this.setNoFill();
    //this.setNoStroke();
    this.setGroupIndex(0);
  }

  float size;
  void move() {
    pushMatrix();
    translate(this.getX(), this.getY());
    rotate(this.getRotation());

    while (sqrt(msg.length()) != (int)sqrt(msg.length())) {
      msg += 'ㅗ';
    }

    size = sqrt(msg.length());
    noFill();
    rect(0, 0, size*20, size*20);

    int i = 0;
    int j = 0;

    for (int id = 0; id < msg.length(); id++) {
      pushMatrix();
      translate(i * 20, j * 20);
      //rotate(PI/4);
      fill(0);
      textAlign(LEFT, TOP);
      text(msg.charAt(id), 0, 0);
      popMatrix();

      i++;

      if (i == size) {
        i = 0; 
        j++;
      }
    }

    popMatrix();
  }
}