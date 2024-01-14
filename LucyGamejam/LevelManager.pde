class LevelManager {
  private int level, bgCharPos = width + 50;
  PImage[] mainLayers;
  PImage[] staticItems;
  PImage[] foregroundItems;
  int[][] itemPositions;
  int[][] foregroundItemPositions;
  int posX = 0;
  NPC[] npcs;

  LevelManager(int level, PImage mainLayers[], PImage staticItems[], int[][] itemPositions, PImage foregroundItems[], int[][] foregroundItemPositions, NPC[] npcs) {
    this.level = level;
    this.mainLayers = mainLayers;
    this.staticItems = staticItems;
    this.itemPositions = itemPositions;
    this.foregroundItems = foregroundItems;
    this.foregroundItemPositions = foregroundItemPositions;
    this.npcs = npcs;
  }

  // Rendering the level
  public void render(int posX) {
    this.posX = posX;
    background(#73CEF7);
    image(mainLayers[2], 0, 0);

    // Background characters
    for(NPC npc : npcs) {
      npc.render(posX);
    }

    // Draw the background parallax layers
    image(mainLayers[1], Math.floorMod(posX/2, mainLayers[1].width), height - mainLayers[0].height - mainLayers[1].height + 10);
    image(mainLayers[1], Math.floorMod(posX/2 + mainLayers[1].width, mainLayers[1].width) - mainLayers[1].width, height - mainLayers[0].height - mainLayers[1].height + 10);
    image(mainLayers[0], Math.floorMod(posX, (2*mainLayers[0].width)) - mainLayers[0].width, height - mainLayers[0].height, mainLayers[0].width*S, mainLayers[0].height*S);
    image(mainLayers[0], Math.floorMod(posX + mainLayers[0].width, 2*mainLayers[0].width) - mainLayers[0].width, height - mainLayers[0].height, mainLayers[0].width*S, mainLayers[0].height*S);
    
    // Draw the static items
    for (int i = 0; i < staticItems.length; i++) {
      for(int pos : itemPositions[i]) {
        if(pos != -1) image(staticItems[i], posX - pos, height - staticItems[i].height*S - mainLayers[0].height * 0.75, staticItems[i].width*S, staticItems[i].height*S);
      }
    }
  }

  public void renderForeground() {
    for (int i = 0; i < foregroundItems.length; i++) {
      for(int pos : foregroundItemPositions[i]) {
        image(foregroundItems[i], posX*1.2 - pos, height - foregroundItems[i].height*FS + 40, foregroundItems[i].width * FS, foregroundItems[i].height * FS);
      }
    }
  }
}
