class Player {
  private float posX = 0;
  private int speedX = 0;
  private PImage[] images;
  private int lastTime = 0, activeImg = 0, activeBubble = -1;
  private boolean facingRight = true;

  Player(PImage[] images) {
    this.images = images;
  }

  // Inputs
  void keyPress() {
    if (key == 'a' || keyCode == LEFT) speedX = 20;
    else if (key == 'd' || keyCode == RIGHT) speedX = -20;
  }

  void keyRelease() {
    if (key == 'a' || keyCode == LEFT) speedX = 0;
    else if (key == 'd' || keyCode == RIGHT) speedX = 0;
  }

  // Interactions
  void setActiveBubble(int activeBubble) {
    this.activeBubble = activeBubble;
  }

  // Position update
  int update() {
    posX += speedX / frameRate * 10;
    return (int)posX;
  }
  // Rendering, depending on speed, direction, and animation step
  void render() {
    if(speedX == 0) {
      if(effects[0].isPlaying()) effects[0].stop();
      if(facingRight) image(images[4], width / 2 - 80, height - 350, 160, 240);
      else {
        pushMatrix();
        scale(-1, 1);
        image(images[4], -(width / 2 + 70), height - 350, 160, 240);
        popMatrix();
      }
    }
    else {
      if(!effects[0].isPlaying()) effects[0].loop();
      if(millis() > lastTime + 250) {
        activeImg = (activeImg + 1) % 4;
        lastTime = millis();
      }
      if(speedX > 0) {
        pushMatrix();
        scale(-1, 1);
        image(images[activeImg], -(width / 2 + 70), height - 350, 160, 240);
        popMatrix();
        facingRight = false;
      }
      else {
        image(images[activeImg], width / 2 - 80, height - 350, 160, 240);
        facingRight = true;
      }
    }

    if(activeBubble != -1) image(interactionBubbles[activeBubble], width / 2 - 30, height - 400, width / 24, width / 24);
  }
}