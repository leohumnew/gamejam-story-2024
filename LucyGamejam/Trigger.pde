class Trigger {
  private Consumer<Integer> consumer;
  private int x, consumerArg, selfIndex;
  private HashMap<Integer, Trigger> parent;

  Trigger(Consumer<Integer> consumer, int consumerArg, int x, HashMap<Integer, Trigger> parent, int selfIndex) {
    this.consumer = consumer;
    this.consumerArg = consumerArg;
    this.x = x;
    this.parent = parent;
    this.selfIndex = selfIndex;
  }

  void update(int playerX) {
    if (playerX > x) {
      consumer.accept(consumerArg);
      parent.remove(selfIndex);
    }
  }
}