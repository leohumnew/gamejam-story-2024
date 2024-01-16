class Interactable {
  private int callbackValue = -1;
  private Consumer<Integer> callback;
  private Consumer<PImage[]> callbackImages;
  public boolean isAnimating = false;
  private PImage[] images;

  Interactable(Consumer<Integer> callback, int callbackValue) {
    this.callbackValue = callbackValue;
    this.callback = callback;
  }
  Interactable(Consumer<Integer> callback, int callbackValue, PImage[] images) {
    this(callback, 0);
    this.images = images;
  }
  Interactable(Consumer<PImage[]> callback, PImage[] images) {
    this.callbackImages = callback;
    this.images = images;
  }

  void interact() {
    isAnimating = true;
    if(callback != null) {
      callback.accept(callbackValue);
    } else if(callbackImages != null && callbackValue == -1) {
      callbackImages.accept(images);
    }
  }

  int getPriority() {
    return callbackImages != null ? 1 : 0;
  }
}