class NPC {
  PImage[] images;
  int x, y, currentImage, lastTime, speedX;
  boolean isMoving;

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
        if(random(0,1) > 0.95) {
          speedX *= (random(0,1) > 0.5 ? 1 : -1);
          x = (speedX > 0 ? posX - 180 : posX + width + 180);
        }
        return;
      }
    }
    pushMatrix();
    scale(speedX > 0 ? -1 : 1, 1);
    tint(#dff3ff); // #dff3ff or #fbf236 when #ff7c2e
    image(images[currentImage], posX - x, y, images[currentImage].width*S, images[currentImage].height*S);
    noTint();
    popMatrix();
  }
}
