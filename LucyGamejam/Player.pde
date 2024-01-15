class Player {
  private float posX = 0, tempPosX = 0;
  private int speedX = 0;
  private PImage[] images;
  private int lastTime = 0, activeImg = 0, activeBubble = -1, bubbleTime = 0;
  private boolean facingRight = true;
  private int playerWidth, playerHeight;

  Player(PImage[] images) {
    this.images = images;
    playerWidth = images[0].width*S;
    playerHeight = images[0].height*S;
  }

  void resetPos(int newLevel) {
    posX = 0;
  }

  // Inputs
  void keyPress() {
    if (key == 'a' || keyCode == LEFT) speedX = -400;
    else if (key == 'd' || keyCode == RIGHT) speedX = 400;
  }

  void keyRelease() {
    if (key == 'a' || keyCode == LEFT) speedX = 0;
    else if (key == 'd' || keyCode == RIGHT) speedX = 0;
  }

  // Interactions
  void setActiveBubble(int activeBubble) {
    this.activeBubble = activeBubble;
    bubbleTime = millis();
  }

  // Position update
  int update(int[] worldLimits) {
    if(activeBubble != -1 && millis() > bubbleTime + 2000) activeBubble = -1;

    tempPosX = posX + speedX / frameRate * 10;
    if(tempPosX > worldLimits[0]*S && tempPosX + width < worldLimits[1]*S) posX = tempPosX;
    return (int)posX;
  }
  // Rendering, depending on speed, direction, and animation step
  void render() {
    imageMode(CENTER);
    if(speedX == 0) {
      if(effects[0].isPlaying()) effects[0].stop();

      if(facingRight) image(images[4], width / 2, height - playerHeight*0.8, playerWidth, playerHeight);
      else {
        pushMatrix();
        scale(-1, 1);
        image(images[4], -width / 2, height - playerHeight*0.8, playerWidth, playerHeight);
        popMatrix();
      }
    } else {
      if(!effects[0].isPlaying()) effects[0].loop();
      if(millis() > lastTime + 300) {
        activeImg = (activeImg + 1) % 4;
        lastTime = millis();
      }
      if(speedX > 0) {
        image(images[activeImg], width / 2, height - playerHeight*0.8, playerWidth, playerHeight);
        facingRight = true;
      } else {
        pushMatrix();
        scale(-1, 1);
        image(images[activeImg], -width / 2, height - playerHeight*0.8, playerWidth, playerHeight);
        popMatrix();
        facingRight = false;
      }
    }

    if(activeBubble != -1) image(interactionBubbles[activeBubble], width / 2 + 40, height - 600, interactionBubbles[0].width*S, interactionBubbles[0].width*S);
    imageMode(CORNER);
  }
}
