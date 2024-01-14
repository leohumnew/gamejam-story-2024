class Interactable {
  private int posX, area;
  private Consumer<Integer> callback;

  Interactable(int posX, int area, Consumer<Integer> callback) {
    this.posX = posX;
    this.area = area;
    this.callback = callback;
  }
}