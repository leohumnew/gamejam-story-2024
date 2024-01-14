class Interactable {
  private int value;
  private Consumer<Integer> callback;

  Interactable(Consumer<Integer> callback, int value) {
    this.value = value;
    this.callback = callback;
  }

  void interact() {
    callback.accept(value);
  }
}