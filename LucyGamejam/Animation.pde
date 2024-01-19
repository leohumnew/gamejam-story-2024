class Animation {
    private PImage[] images;
    private int x, y, startTime, currentImage = 0, duration = 1;
    private boolean flip;
    private int xOffsetEnd, xOffsetCurrent = 0, offsetStartTime;

    Animation(PImage[] images, int x, int y, boolean flip) {
        this.images = images;
        this.x = x*S;
        this.y = y*S;
        this.startTime = millis();
        this.flip = flip;
    }
    Animation(PImage[] images, int x, int y, boolean flip, int xOffsetEnd, int duration) {
        this(images, x, y, flip);
        this.xOffsetEnd = xOffsetEnd;
        this.duration = duration;
    }

    void render(int playerX) {
        if (xOffsetEnd != 0) {
            if(abs(xOffsetCurrent) > abs(xOffsetEnd)) return;
            if(offsetStartTime == 0) offsetStartTime = millis();
            xOffsetCurrent = (int) map(millis() - offsetStartTime, 0, duration, 0, xOffsetEnd);
        }
        if(!flip) image(images[currentImage], x - playerX + xOffsetCurrent, height - y - images[0].height*S, images[0].width*S, images[0].height*S);
        else {
            pushMatrix();
            translate(x - playerX + images[0].width*S, height - y - images[0].height*S);
            scale(-1, 1);
            image(images[currentImage], 0 + xOffsetCurrent, 0, images[0].width*S, images[0].height*S);
            popMatrix();
        }
        if (millis() - startTime > 200) {
            startTime = millis();
            currentImage = (currentImage + 1) % images.length;
        }
    }
}