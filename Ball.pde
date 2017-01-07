class Ball extends FCircle {
  int id;

  ArrayList<String> words = new ArrayList<String>();

  float size = 100;
  boolean removed = false;
  //boolean soundPlayed = false;

  AudioPlayer audio;

  Ball(int id, Player player, String msg) {
    super(100);

    this.id = id;

    this.words.add(msg);
    audio = minim.loadFile(id + ".wav");

    this.setGroupIndex(id);
    this.setAllowSleeping(false);
    this.setRestitution(1);  
    this.setFriction(0);
    this.setDamping(0);

    this.setPosition(player.x, player.slot);
    this.setVelocity(-300 * player.player, 0);

    this.setNoStroke();
    this.setNoFill();
  }

  void display() {
    String wordsSum = sumString(words);
    while (wordsSum.length() < 10) {
      wordsSum += '-';
    }

    pushMatrix();
    translate(this.getX(), this.getY());

    float r;
    float ts;
    float arclength = 0;

    for (int i = 0; i < wordsSum.length(); i++) {   
      if (removed || finished) break;

      r = size / pow(2, ((int)i/10) + 1);
      ts = r / 2;
      textSize(ts);

      char currentChar = wordsSum.charAt(i);
      float w = textWidth(currentChar);
      arclength += w;
      float theta = PI + arclength / r;    

      pushMatrix();  
      translate(r*cos(theta), r*sin(theta));
      rotate(theta+PI/2); 
      pushStyle();
      textAlign(CENTER, TOP);
      fill(0);
      text(currentChar, 0, 0);
      popStyle();
      popMatrix();

      arclength += w;
    }

    popMatrix();
  }

  //void playSound() {
  //  if (soundPlayed) {
  //    if (!ding.isPlaying()) ding.play();
  //    if (ding.position() == ding.length()) {
  //      if (!audio.isPlaying()) {
  //        audio.play();      
  //        audio.rewind();
  //        ding.rewind();
  //        soundPlayed = false;
  //      }
  //    }
  //  }
  //}
}