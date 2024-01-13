import java.awt.Image;
import java.awt.Toolkit;
import java.awt.image.PixelGrabber;

static class Utilities {
  // IMAGE LOADING //
  // Image loading with PixelGrabber
  private static PImage[] loadImagePngCpyPx(PApplet sketch, String inFile, int w, int h, int xNum, int yNum) {
    Image image = Toolkit.getDefaultToolkit().createImage(sketch.dataPath(inFile)).getScaledInstance(w, h, Image.SCALE_DEFAULT);
    PImage[] retval = new PImage[xNum*yNum];
    try {
      for (int i = 0; i < yNum; i++) {
        for (int j = 0; j < xNum; j++) {
          retval[i*xNum+j] = sketch.createImage(w/xNum, h/yNum, ARGB);
          new PixelGrabber(image, w/xNum*j, h/yNum*i, w/xNum, h/yNum, retval[i*xNum+j].pixels, 0, w/xNum).grabPixels();
        }
      }
    } catch (InterruptedException e1) {
      println("Problem loading image: " + e1);
      retval[0] = sketch.loadImage(inFile);
      return retval;
    }

    return retval;
  }
  // Different overloads for loadImagePng
  static PImage[] loadImagePng(PApplet sketch, String inFile, int size, int xNum, int yNum) { return loadImagePngCpyPx(sketch, inFile, size, size, xNum, yNum); }
  static PImage loadImagePng(PApplet sketch, String inFile, int w, int h) { return loadImagePngCpyPx(sketch, inFile, w, h, 1, 1)[0]; }
  static PImage loadImagePng(PApplet sketch, String inFile, int size) { return loadImagePngCpyPx(sketch, inFile, size, size, 1, 1)[0]; }

  // ARRAY UTILITIES //
  static boolean contains(int[] arr, int val) {
    for (int i = 0; i < arr.length; i++) {
      if (arr[i] == val) return true;
    }
    return false;
  }
  static boolean contains(String[] arr, String val) {
    for (int i = 0; i < arr.length; i++) {
      if (arr[i].equals(val)) return true;
    }
    return false;
  }
}
