class Player {
  private float[] posX = {-1, 140, -170, 70, 0};
  private float tempPosX = 0;
  private int level = 0, speedX = 0, speedMultiplier = 1;
  private PImage[] images, backupImages;
  private int imgTime = 0, activeImg = 0, activeBubble = -2, bubbleTime = 0, bubbleAnimTime = 0, bubbleDuration = 2500, activeAction = -1, animFrames = 4;
  private boolean facingRight = true;
  private int playerWidth, playerHeight;
  private byte bubbleAnimStep = 0, lastChoice = -2;
  private Consumer<Integer> actionEndCallback = null;

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
  boolean keyPress() {
    if (key == 'a' || keyCode == LEFT) speedX = -40 * speedMultiplier;
    else if (key == 'd' || keyCode == RIGHT) speedX = 40 * speedMultiplier;
    else if ((keyCode == ENTER || key == 'e') && backupImages != null) resetPlayerAction();
    else return false;

    return true;
  }

  void keyRelease() {
    if (key == 'a' || keyCode == LEFT) speedX = 0;
    else if (key == 'd' || keyCode == RIGHT) speedX = 0;
  }

  // Interactions
  void setActiveBubble(byte activeBubble) {
    // 0: no action, 1: bravery, 2: sadness, 3: fear, 4: anger, 5: love, 6: peace, 7: healing, 8: locked
    lastChoice = activeBubble;
    this.activeBubble = activeBubble - 1; // Subtract one so as to start animation ones from 0
    bubbleTime = millis();
    bubbleDuration = this.activeBubble == -1 ? 700 : 2500;
    bubbleAnimTime = millis();
  }

  void setActiveAction(int action, PImage[] actionImg) {
    animFrames = 2;
    backupImages = images;
    images = actionImg;
    playerWidth = images[0].width*S;
    playerHeight = images[0].height*S;
    activeImg = 0;
    if(action == 0) {
      speedMultiplier = 5;
      speedX *= speedMultiplier;
    }
  }
  void setActiveAction(int action, PImage[] actionImg, Consumer<Integer> actionCallback) {
    setActiveAction(action, actionImg);
    actionEndCallback = actionCallback;
  }
  void resetPlayerAction() {
    animFrames = 4;
    images = backupImages;
    backupImages = null;
    playerWidth = images[0].width*S;
    playerHeight = images[0].height*S;
    if(actionEndCallback != null) actionEndCallback.accept((int)((posX[level] + width/2)/S));
    speedMultiplier = 1;
    if(keyPressed) { // TODO: Fix resetting speedX on dismount
      if (key == 'a' || keyCode == LEFT) speedX = -40 * speedMultiplier;
      else if (key == 'd' || keyCode == RIGHT) speedX = 40 * speedMultiplier;
    }
  }

  // Position update
  int update(int[] worldLimits) {
    if(activeBubble != -2 && millis() > bubbleTime + bubbleDuration) activeBubble = -2;

    tempPosX = posX[level] + speedX / frameRate * 10;
    if(tempPosX + width/2 > worldLimits[0]*S && tempPosX + width/2 < worldLimits[1]*S) posX[level] = tempPosX;
    return (int)posX[level];
  }

  // Rendering, depending on speed, direction, and animation step
  void render() {
    imageMode(CENTER);
    if(speedX == 0) {
      if(effects[0].isPlaying()) effects[0].stop();

      if(facingRight) image(images[0], width / 2, height - playerHeight*0.8, playerWidth, playerHeight);
      else {
        pushMatrix();
        scale(-1, 1);
        image(images[0], -width / 2, height - playerHeight*0.8, playerWidth, playerHeight);
        popMatrix();
      }
    } else {
      if(!effects[0].isPlaying()) effects[0].loop();
      if(millis() > imgTime + 300) {
        activeImg = (activeImg + 1) % animFrames;
        imgTime = millis();
      }
      if(speedX > 0) {
        image(images[activeImg+1], width / 2, height - playerHeight*0.8, playerWidth, playerHeight);
        facingRight = true;
      } else {
        pushMatrix();
        scale(-1, 1);
        image(images[activeImg+1], -width / 2, height - playerHeight*0.8, playerWidth, playerHeight);
        popMatrix();
        facingRight = false;
      }
    }

    pushStyle();
    noTint();
    if(activeBubble == -1) image(interactionBubbles[0], width / 2 + 60, height - 600, interactionBubbles[0].width*S, interactionBubbles[0].width*S);
    else if(activeBubble >= 0) {
      image(interactionBubbles[(activeBubble*4) + bubbleAnimStep + 1], width / 2 + 60, height - 600, interactionBubbles[0].width*S, interactionBubbles[0].width*S);
      if(millis() > bubbleAnimTime + 200) {
        bubbleAnimStep = (byte)((bubbleAnimStep + 1) % 4);
        bubbleAnimTime = millis();
      }
    }
    popStyle();
    imageMode(CORNER);
  }
}
