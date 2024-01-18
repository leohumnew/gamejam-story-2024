class Animation {
    private PImage[] images;
    private int x, y, startTime;
    private byte currentImage = 0;
    private boolean flip;

    Animation(PImage[] images, int x, int y, boolean flip) {
        this.images = images;
        this.x = x*S;
        this.y = y*S;
        this.startTime = millis();
        this.flip = flip;
    }

    void render(int playerX) {
        if(!flip) image(images[currentImage], x - playerX, height - y - images[0].height*S, images[0].width*S, images[0].height*S);
        else {
            pushMatrix();
            translate(x - playerX + images[0].width*S, height - y - images[0].height*S);
            scale(-1, 1);
            image(images[currentImage], 0, 0, images[0].width*S, images[0].height*S);
            popMatrix();
        }
        if (millis() - startTime > 200) {
            startTime = millis();
            currentImage = (byte)((currentImage + 1) % images.length);
        }
    }
}