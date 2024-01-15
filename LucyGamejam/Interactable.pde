class Interactable {
  private int callbackValue;
  private Consumer<Integer> callback;
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

  void interact() {
    isAnimating = true;
    callback.accept(callbackValue);
  }
}