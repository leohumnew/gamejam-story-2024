class Player {
  private float[] posX = {-1, 65, -170, 70};
  private float tempPosX = 0;
  private int level = 0, speedX = 0;
  private PImage[] images;
  private int imgTime = 0, activeImg = 0, activeBubble = -1, bubbleTime = 0;
  private boolean facingRight = true;
  private int playerWidth, playerHeight;
  private int lastChoice = -1;

  Player(PImage[] images) {
    this.images = images;
    playerWidth = images[0].width*S;
    playerHeight = images[0].height*S;
    for(int i = 0; i < posX.length; i++) posX[i] = posX[i]*S - width/2;
  }

  void changeLevel(int newLevel) {
    level = newLevel;
  }

  // Inputs
  void keyPress() {
    if (key == 'a' || keyCode == LEFT) speedX = -30;
    else if (key == 'd' || keyCode == RIGHT) speedX = 30;
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

    tempPosX = posX[level] + speedX / frameRate * 10;
    if(tempPosX + width/2 > worldLimits[0]*S && tempPosX + width/2 < worldLimits[1]*S) posX[level] = tempPosX;
    return (int)posX[level];
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
      if(millis() > imgTime + 300) {
        activeImg = (activeImg + 1) % 4;
        imgTime = millis();
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
