import java.util.function.Consumer;

// Class for managing UI elements
class UIManager {
  private ArrayList<UIElement> UIElements = new ArrayList<UIElement>();

  public void add(UIElement element) {
    UIElements.add(element);
  }

  public void clearUIElements() {
    UIElements.clear();
  }

  public void render() {
    textAlign(CENTER, CENTER);
    textSize(18);

    for (UIElement element : UIElements) {
      element.render();
    }
  }

  public void mouseClicked() {
    for (UIElement element : UIElements) {
      if (element instanceof Button) {
        Button button = (Button) element;
        if (button.isHovered()) {
          button.callback.accept(button.callbackValue);
          return;
        }
      }
    }
  }
}

// Interface for UI elements
interface UIElement {
  public void render();
}

// UI ELEMENT IMPLEMENTATIONS //
class Button implements UIElement {
  protected int x, y, width, height;
  protected Consumer<Integer> callback;
  protected int callbackValue;

  Button(int x, int y, int width, int height, Consumer<Integer> callback, int callbackValue) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.callback = callback;
    this.callbackValue = callbackValue;
  }

  public void render() {
    return;
  }

  public boolean isHovered() {
    return mouseX > x && mouseX < x + width && mouseY > y && mouseY < y + height;
  }
}

class TextButton extends Button {
  private String text;
  private color buttonColor;

  TextButton(int x, int y, int width, int height, color buttonColor, String text, Consumer<Integer> callback, int callbackValue) {
    super(x, y, width, height, callback, callbackValue);
    this.buttonColor = buttonColor;
    this.text = text;
  }

  public void render() {
    if(mouseX > x && mouseX < x + width && mouseY > y && mouseY < y + height) {
      if(mousePressed) {
        fill(buttonColor, 150);
      } else {
        fill(buttonColor, 200);
      }
    } else {
      fill(buttonColor);
    }
    rect(x, y, width, height, 5);
    fill(0);
    text(text, x + width / 2, y + height / 2);
  }
}

class ImgButton extends Button {
  private PImage image, imageHover, imagePressed;

  ImgButton(int x, int y, int width, int height, PImage image, PImage imageHover, PImage imagePressed, Consumer<Integer> callback, int callbackValue) {
    super(x, y, width, height, callback, callbackValue);
    this.image = image;
    this.imageHover = imageHover;
    this.imagePressed = imagePressed;
  }

  public void render() {
    if(isHovered()) {
      if(mousePressed) {
        image(imagePressed, x, y, width, height);
      } else {
        image(imageHover, x, y, width, height);
      }
    } else {
      image(image, x, y, width, height);
    }
  }
}

class Text implements UIElement {
  private String text;
  private int x, y;

  Text(int x, int y, String text) {
    this.x = x;
    this.y = y;
    this.text = text;
  }

  public void render() {
    fill(0);
    text(text, x, y);
  }
}

class FPSCounter implements UIElement {
  private int x, y;

  FPSCounter(int x, int y) {
    this.x = x;
    this.y = y;
  }

  public void render() {
    //fill(0);
    //rect(x-40, y-15, 80, 30);
    fill(255);
    // FPS, rounded to 0 decimal places
    text("FPS: " + Math.round(frameRate), x, y);
  }
}

// FADE MANAGER //
class FadeManager {
  private int duration, oldDuration;
  private int initTime;
  private int fadeState = -1; // -1: Inactive, 0: Fading in, 1: Fading out
  private int newValue;
  private Consumer<Integer> callback;

  FadeManager(int duration) {
    this.duration = duration / 2;
  }

  public void fade(Consumer<Integer> callback, int newValue) {
    this.callback = callback;
    this.newValue = newValue;
    fadeState = 0;
    initTime = millis();
    inputEnabled = false;
  }
  public void fade(Consumer<Integer> callback, int newValue, int duration) {
    oldDuration = this.duration;
    this.duration = duration / 2;
    fade(callback, newValue);
  }

  public void update() {
    if (fadeState == -1) return;
    else if (fadeState == 0) {
      fill(0, constrain(map(millis(), initTime, initTime + duration, 0, 255), 0, 255));
      if (millis() >= initTime + duration) {
        if(callback != null) callback.accept(newValue);
        fadeState = 1;
        initTime = millis();
      }
    } else if (fadeState == 1) {
      fill(0, constrain(map(millis(), initTime, initTime + duration, 255, 0), 0, 255));
      if (millis() >= initTime + duration) {
        fadeState = -1;
        duration = oldDuration;
        inputEnabled = true;
      }
    }

    rect(0, 0, width, height);
  }
}

class SlideManager {
  private PImage[] activeSlides;
  private int slideIndex = 0, slideDuration, lastSlideTime, endStage;
  private boolean finished = false;

  void setSlides(PImage[] slides) {
    activeSlides = slides;
  }

  void startSlides(int slideDuration, int endStage) {
    slideIndex = 0;
    this.slideDuration = slideDuration;
    this.endStage = endStage;
    lastSlideTime = millis();
    finished = false;
  }

  void render() {
    if(activeSlides != null) {
      image(activeSlides[slideIndex], 0, 0, width, height);
    }

    if(millis() >= lastSlideTime + slideDuration && !finished) {
      slideIndex++;
      if(slideIndex >= activeSlides.length) {
        slideIndex = activeSlides.length - 1;
        fadeStage.accept(endStage);
        finished = true;
      }
      lastSlideTime = millis();
    }
  }
}