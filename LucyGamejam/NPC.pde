class NPC {
  private PImage[] images;
  private int x, y, currentImage, lastTime, speedX;
  private boolean isMoving, isFacingLeft = true;

  NPC(PImage[] images, int x, int y, boolean isMoving, int speedX) {
    this.images = images;
    this.x = x;
    this.y = y;
    this.isMoving = isMoving;
    this.speedX = speedX;
  }

  void render(int posX) {
    if (millis() - lastTime > 100) { // Change image through animation
      currentImage = (currentImage + 1) % images.length;
      lastTime = millis();
    }
    if(isMoving) { // Draw sprite and update position, depending on direction
      x += speedX / frameRate * 10;
      if(x < posX - 200) {
        if(random(0,1) > 0.99) {
          isFacingLeft = random(0,1) > 0.5;
          x = posX + width + 180;
        }
        return;
      }
    }

    if(!isFacingLeft) {
      pushMatrix();
      scale(-1, 1);
      translate(width, 0);
      image(images[currentImage], x - posX, y, images[currentImage].width*S, images[currentImage].height*S);
      popMatrix();
    } else image(images[currentImage], x - posX, y, images[currentImage].width*S, images[currentImage].height*S);
  }
}
