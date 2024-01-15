class LevelManager {
  private int level, bgCharPos = width + 50, animationFrame = 0;
  private PImage[] mainLayers, staticItems, foregroundItems, extraLayers;
  private float[][] itemPositions;
  private int[][] foregroundItemPositions;
  int posX = 0, timeOfDay = 12;
  private int[] bgYPos = new int[2], extraPositions;
  private NPC[] npcs;
  private HashMap<Integer, Interactable> interactables;

  LevelManager(int level, PImage mainLayers[], PImage staticItems[], float[][] itemPositions, PImage foregroundItems[], int[][] foregroundItemPositions, NPC[] npcs, HashMap<Integer, Interactable> interactables) {
    this.level = level;
    this.mainLayers = mainLayers;
    this.staticItems = staticItems;
    this.itemPositions = itemPositions;
    this.foregroundItems = foregroundItems;
    this.foregroundItemPositions = foregroundItemPositions;
    this.npcs = npcs;
    this.interactables = interactables;
    bgYPos[0] = height - (mainLayers[0] == null ? 0 : mainLayers[0].height*S);
    bgYPos[1] = bgYPos[0] - (mainLayers[1] == null ? 0 : mainLayers[1].height - 1)*S;
  }

  public void addExtraLayers(PImage[] extraLayers, int[] extraPositions) {
    this.extraLayers = extraLayers;
    this.extraPositions = extraPositions;
  }

  public void setTimeOfDay(int timeOfDay) {
    this.timeOfDay = timeOfDay;
  }

  // Rendering the level
  public void render(int posX) {
    this.posX = posX;
    // Set sky colour and tint based on time
    if(timeOfDay > 6 && timeOfDay < 18) {
      background(#73CEF7);
      noTint();
    }
    else if(timeOfDay >= 18 && timeOfDay < 20) {
      background(#ff7c2e);
      tint(#fbf236);
    }
    else if(timeOfDay >= 20 || timeOfDay < 6) {
      background(#000000);
      tint(#898FFF);
    }
    image(mainLayers[2], 0, 0, mainLayers[2].width*S, mainLayers[2].height*S);

    // Background characters
    if(npcs != null){
      for(NPC npc : npcs) {
        npc.render(posX);
      }
    }

    // Draw the background parallax layers
    if(mainLayers[1] != null) {
      image(mainLayers[1], Math.floorMod(-posX/2, mainLayers[1].width*S), bgYPos[1], mainLayers[1].width*S, mainLayers[1].height*S);
      image(mainLayers[1], Math.floorMod(-posX/2 + mainLayers[1].width*S, mainLayers[1].width*S) - mainLayers[1].width*S, bgYPos[1], mainLayers[1].width*S, mainLayers[1].height*S);
    }
    if(mainLayers[0] != null) {
      image(mainLayers[0], Math.floorMod(-posX, (2*mainLayers[0].width*S)) - mainLayers[0].width*S, bgYPos[0], mainLayers[0].width*S, mainLayers[0].height*S);
      image(mainLayers[0], Math.floorMod(-posX + mainLayers[0].width*S, 2*mainLayers[0].width*S) - mainLayers[0].width*S, bgYPos[0], mainLayers[0].width*S, mainLayers[0].height*S);
    }

    // Draw the static items
    for (int i = 0; i < staticItems.length; i++) {
      for(int j = 0; j < itemPositions[i].length; j++) {
        int pos = (int)itemPositions[i][j];
        if(pos != -1) {
          int yOffset = (pos == itemPositions[i][j]) ? (int)(mainLayers[0].height*0.8) : (int)((abs(itemPositions[i][j]) % pos) * 100); // Get y position from the decimal part of the position, offset to allow for negatives
          if(interactables.containsKey(i) && (posX + width/2)/S > pos && (posX + width/2)/S < pos + staticItems[i].width) {
            tint(170);
            image(staticItems[i], pos*S - posX, height - (staticItems[i].height + yOffset)*S, staticItems[i].width*S, staticItems[i].height*S);
            tint(200, 150);
            image(ui[0], pos*S - posX + (staticItems[i].width - ui[0].width)*S/2, max(height - (staticItems[i].height + ui[0].height + yOffset)*S, 12*S), ui[0].width*S, ui[0].height*S);
            noTint();
          } else image(staticItems[i], pos*S - posX, height - (staticItems[i].height + yOffset)*S, staticItems[i].width*S, staticItems[i].height*S);
        }
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
        for(float pos : itemPositions[i]) {
          if(interactables.containsKey(i) && (posX + width/2)/S > floor(pos) && (posX + width/2)/S < floor(pos) + staticItems[i].width) {
            interactables.get(i).interact();
          }
        }
      }
    }
  }
}