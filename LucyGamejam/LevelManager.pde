class LevelManager {
  private int level, bgCharPos = width + 50;
  PImage[] mainLayers;
  PImage[] staticItems;
  PImage[] foregroundItems;
  int[][] itemPositions;
  int[][] foregroundItemPositions;
  int posX = 0;
  NPC[] npcs;
  HashMap<Integer, Interactable> interactables;

  LevelManager(int level, PImage mainLayers[], PImage staticItems[], int[][] itemPositions, PImage foregroundItems[], int[][] foregroundItemPositions, NPC[] npcs, HashMap<Integer, Interactable> interactables) {
    this.level = level;
    this.mainLayers = mainLayers;
    this.staticItems = staticItems;
    this.itemPositions = itemPositions;
    this.foregroundItems = foregroundItems;
    this.foregroundItemPositions = foregroundItemPositions;
    this.npcs = npcs;
    this.interactables = interactables;
  }

  // Rendering the level
  public void render(int posX) {
    this.posX = posX;
    background(#73CEF7);
    image(mainLayers[2], 0, 0);

    // Background characters
    if(npcs != null){
      for(NPC npc : npcs) {
        npc.render(posX);
      }
    }

    // Draw the background parallax layers
    image(mainLayers[1], Math.floorMod(-posX/2, mainLayers[1].width), height - mainLayers[0].height*S - mainLayers[1].height + 10);
    image(mainLayers[1], Math.floorMod(-posX/2 + mainLayers[1].width, mainLayers[1].width) - mainLayers[1].width, height - mainLayers[0].height*S - mainLayers[1].height + 10);
    image(mainLayers[0], Math.floorMod(-posX, (2*mainLayers[0].width*S)) - mainLayers[0].width*S, height - mainLayers[0].height*S, mainLayers[0].width*S, mainLayers[0].height*S);
    image(mainLayers[0], Math.floorMod(-posX + mainLayers[0].width*S, 2*mainLayers[0].width*S) - mainLayers[0].width*S, height - mainLayers[0].height*S, mainLayers[0].width*S, mainLayers[0].height*S);
    
    // Draw the static items
    for (int i = 0; i < staticItems.length; i++) {
      for(int pos : itemPositions[i]) {
        if(interactables.containsKey(i) && (posX + width/2)/S > pos && (posX + width/2)/S < pos + staticItems[i].width) {
          tint(175);
          image(ui[0], pos*S - posX + staticItems[i].width*S/2 - ui[0].width*S/2, height - staticItems[i].height*S - mainLayers[0].height*S * 0.85 - ui[0].height*S, ui[0].width*S, ui[0].height*S);
        }
        if(pos != -1) image(staticItems[i], pos*S - posX, height - staticItems[i].height*S - mainLayers[0].height*S * 0.8, staticItems[i].width*S, staticItems[i].height*S);
        noTint();
      }
    }
  }

  public void renderForeground() {
    for (int i = 0; i < foregroundItems.length; i++) {
      for(int pos : foregroundItemPositions[i]) {
        if(pos != -1) image(foregroundItems[i], pos*S - posX*1.2, height - foregroundItems[i].height*FS + 40, foregroundItems[i].width * FS, foregroundItems[i].height * FS);
      }
    }
  }

  // INPUT //
  public void keyPress() {
    if(key == 'e' || key == 'E' || keyCode == ENTER) {
      for(int i = 0; i < staticItems.length; i++) {
        for(int pos : itemPositions[i]) {
          if(interactables.containsKey(i) && (posX + width/2)/S > pos && (posX + width/2)/S < pos + staticItems[i].width) {
            interactables.get(i).interact();
          }
        }
      }
    }
  }
}