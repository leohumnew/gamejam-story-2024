class LevelManager {
  private int level;
  PImage[] mainLayers;
  PImage[] staticItems;
  PImage[] trees;
  int[] itemPositions;

  LevelManager(int level, PImage mainLayers[], PImage staticItems[], int[] itemPositions, PImage[] trees) {
    this.level = level;
    this.mainLayers = mainLayers;
    this.staticItems = staticItems;
    this.itemPositions = itemPositions;
    this.trees = trees;
  }

  public void render(int posX) {
    background(#73CEF7);
    image(mainLayers[2], 0, 0);
    image(mainLayers[1], Math.floorMod(posX/2, mainLayers[1].width), height - mainLayers[0].height - mainLayers[1].height + 10);
    image(mainLayers[1], Math.floorMod(posX/2 + mainLayers[1].width, mainLayers[1].width) - mainLayers[1].width, height - mainLayers[0].height - mainLayers[1].height + 10);
    image(mainLayers[0], Math.floorMod(posX, (2*mainLayers[0].width)) - mainLayers[0].width, height - mainLayers[0].height);
    image(mainLayers[0], Math.floorMod(posX+mainLayers[0].width, 2*mainLayers[0].width) - mainLayers[0].width, height - mainLayers[0].height);
    
    for (int i = 0; i < staticItems.length; i++) {
      image(staticItems[i], posX - itemPositions[i], height - mainLayers[0].height - 20);
    }
  }
}
