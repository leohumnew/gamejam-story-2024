class LevelManager {
  private int level;

  LevelManager(int level) {
    this.level = level;
  }

  public void render() {
    System.out.println("Level: " + level);
  }
}