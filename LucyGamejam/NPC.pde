class NPC {
  private PImage[] images;
  private int x, y, currentImage, lastTime, speedX;
  private boolean isMoving;

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
      if(x < posX - 200 || x > posX + width + 200) {
        if(random(0,1) > 0.98) {
          speedX *= (random(0,1) > 0.5 ? 1 : -1);
          x = (speedX > 0 ? posX - 180 : posX + width + 180);
        }
        return;
      }
    }

    tint(#dff3ff); // #dff3ff or #fbf236 when #ff7c2e
    if(speedX > 0) {
      pushMatrix();
      image(images[currentImage], x - posX, y, images[currentImage].width*S, images[currentImage].height*S);
      translate(speedX > 0 ? posX-(width-2*x) : 0, 0);
      scale(speedX > 0 ? -1 : 1, 1);
      popMatrix();
    } else image(images[currentImage], x - posX, y, images[currentImage].width*S, images[currentImage].height*S);
    noTint();
  }
}
