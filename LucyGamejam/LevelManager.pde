class LevelManager {
  private int level;
  PImage[] mainLayers;
  PImage[] staticItems;
  PImage[] foregroundItems;
  int[][] itemPositions;
  int[][] foregroundItemPositions;
  int posX = 0;

  LevelManager(int level, PImage mainLayers[], PImage staticItems[], int[][] itemPositions, PImage foregroundItems[], int[][] foregroundItemPositions) {
    this.level = level;
    this.mainLayers = mainLayers;
    this.staticItems = staticItems;
    this.itemPositions = itemPositions;
    this.foregroundItems = foregroundItems;
    this.foregroundItemPositions = foregroundItemPositions;
  }

  // Rendering the level
  public void render(int posX) {
    this.posX = posX;
    background(#73CEF7);

    // Draw the background parallax layers
    image(mainLayers[2], 0, 0);
    image(mainLayers[1], Math.floorMod(posX/2, mainLayers[1].width), height - mainLayers[0].height - mainLayers[1].height + 10);
    image(mainLayers[1], Math.floorMod(posX/2 + mainLayers[1].width, mainLayers[1].width) - mainLayers[1].width, height - mainLayers[0].height - mainLayers[1].height + 10);
    image(mainLayers[0], Math.floorMod(posX, (2*mainLayers[0].width)) - mainLayers[0].width, height - mainLayers[0].height);
    image(mainLayers[0], Math.floorMod(posX + mainLayers[0].width, 2*mainLayers[0].width) - mainLayers[0].width, height - mainLayers[0].height);
    
    // Draw the static items
    for (int i = 0; i < staticItems.length; i++) {
      for(int pos : itemPositions[i]) {
        image(staticItems[i], posX - pos, height - staticItems[i].height - mainLayers[0].height * 0.75);
      }
    }
  }

  public void renderForeground() {
    for (int i = 0; i < foregroundItems.length; i++) {
      for(int pos : foregroundItemPositions[i]) {
        image(foregroundItems[i], posX*1.2 - pos, height - foregroundItems[i].height + 40);
      }
    }
  }
}
