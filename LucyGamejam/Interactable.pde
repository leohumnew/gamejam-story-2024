class Interactable {
  private int value;
  private Consumer<Integer> callback;
  public boolean isAnimating = false;
  private PImage[] images;

  Interactable(Consumer<Integer> callback, int value) {
    this.value = value;
    this.callback = callback;
  }
  Interactable(Consumer<Integer> callback, int value, PImage[] images) {
    this(callback, 0);
    this.images = images;
  }

  void interact() {
    isAnimating = true;
    callback.accept(value);
  }
}