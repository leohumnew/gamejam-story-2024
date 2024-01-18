class LevelManager {
  private int level, bgCharPos = width + 50, animationFrame = 0;
  private PImage[] mainLayers, staticItems, foregroundItems, extraLayers;
  private float[][] itemPositions;
  private int[][] foregroundItemPositions;
  int playerX = 0;
  private int[] bgYPos = new int[2];
  private float[][] extraPositions;
  private NPC[] npcs = new NPC[0];
  private HashMap<Integer, Interactable> interactables;
  private ArrayList<Interactable> pendingInteractions = new ArrayList<Interactable>();

  LevelManager(int level, PImage mainLayers[], PImage staticItems[], float[][] itemPositions, PImage foregroundItems[], int[][] foregroundItemPositions, HashMap<Integer, Interactable> interactables) {
    this.level = level;
    this.mainLayers = mainLayers;
    this.staticItems = staticItems;
    this.itemPositions = itemPositions;
    this.foregroundItems = foregroundItems;
    this.foregroundItemPositions = foregroundItemPositions;
    this.interactables = interactables;
    for(Interactable interactable : interactables.values()) {
      interactable.parentInteractablesArray = this.interactables;
    }
    bgYPos[0] = height - (mainLayers[0] == null ? 0 : mainLayers[0].height*S);
    bgYPos[1] = bgYPos[0] - (mainLayers[1] == null ? 0 : mainLayers[1].height - 3)*S;
  }
  public void addExtraLayers(PImage[] extraLayers, float[][] extraPositions) {
    this.extraLayers = extraLayers;
    this.extraPositions = extraPositions;
  }
  public void addNPCs(NPC[] npcs) {
    this.npcs = npcs;
  }

  public void advanceTime() {
    for(Interactable interactable : interactables.values()) {
      interactable.advanceTime();
    }
  }

  // Rendering the level
  public void render(int playerX) {
    this.playerX = playerX;
    // Set sky colour and tint based on time
    noTint();
    if(timeOfDay > 6 && timeOfDay < 16) {
      background(#73CEF7);
      image(mainLayers[2], 0, 0, mainLayers[2].width*S, mainLayers[2].height*S);
    }
    else if(timeOfDay >= 16 && timeOfDay < 24) {
      image(mainLayers[3], 0, 0, mainLayers[3].width*S, mainLayers[3].height*S);
      tint(#240303);
    }
    else if(timeOfDay >= 0 || timeOfDay < 6) {
      image(mainLayers[4], 0, 0, mainLayers[4].width*S, mainLayers[4].height*S);
      tint(#373d6d);
    }

    // Draw the background parallax layers
    if(mainLayers[1] != null) {
      image(mainLayers[1], Math.floorMod(-playerX/3, mainLayers[1].width*S), bgYPos[1], mainLayers[1].width*S, mainLayers[1].height*S);
      image(mainLayers[1], Math.floorMod(-playerX/3 + mainLayers[1].width*S, mainLayers[1].width*S) - mainLayers[1].width*S, bgYPos[1], mainLayers[1].width*S, mainLayers[1].height*S);
    }

    // Change tints for closer foreground
    if(timeOfDay >= 18 && timeOfDay < 20) tint(#715A51);
    else if(timeOfDay >= 20 || timeOfDay < 6) tint(#5E67A0);

    if(mainLayers[0] != null) { // Main layer
      image(mainLayers[0], Math.floorMod(-playerX, (2*mainLayers[0].width*S)) - mainLayers[0].width*S, bgYPos[0], mainLayers[0].width*S, mainLayers[0].height*S);
      image(mainLayers[0], Math.floorMod(-playerX + mainLayers[0].width*S, 2*mainLayers[0].width*S) - mainLayers[0].width*S, bgYPos[0], mainLayers[0].width*S, mainLayers[0].height*S);
    }
    if(extraLayers != null) {
      for(int i = 0; i < extraLayers.length; i++) {
        image(extraLayers[i], extraPositions[i][0]*S - (playerX/extraPositions[i][2]), height - (extraLayers[i].height + extraPositions[i][1])*S, extraLayers[i].width*S, extraLayers[i].height*S);
      }
    }

    // Background characters
    if(npcs != null){
      for(NPC npc : npcs) {
        npc.render(playerX);
      }
    }

    // Draw the static items
    for (int i = 0; i < staticItems.length; i++) {
      for(int j = 0; j < itemPositions[i].length; j++) {
        int pos = (int)itemPositions[i][j];
        if(pos != -1 && pos > playerX/S - staticItems[i].width && pos < playerX/S + width/S) { // Cull offscreen and hidden items
          int yOffset = (pos == itemPositions[i][j]) ? (int)(mainLayers[0].height*0.78) : round((abs(itemPositions[i][j]) % pos) * 100); // Get y position from the decimal part of the position, offset to allow for negatives
          if(interactables.containsKey(i)) {
            if((playerX + width/2)/S > pos && (playerX + width/2)/S < pos + staticItems[i].width) { // If close enough to interact
              pushStyle();
              tint(170);
              image(staticItems[i], pos*S - playerX, height - (staticItems[i].height + yOffset)*S, staticItems[i].width*S, staticItems[i].height*S);
              tint(200, 150);
              image(ui[0], pos*S - playerX + (staticItems[i].width - ui[0].width)*S/2, max(height - (staticItems[i].height + ui[0].height + yOffset)*S, 12*S), ui[0].width*S, ui[0].height*S);
              popStyle();
            } else image(staticItems[i], pos*S - playerX, height - (staticItems[i].height + yOffset)*S, staticItems[i].width*S, staticItems[i].height*S);
            interactables.get(i).render(playerX);
          } else image(staticItems[i], pos*S - playerX, height - (staticItems[i].height + yOffset)*S, staticItems[i].width*S, staticItems[i].height*S);
        }
      }
    }
  }

  public void renderForeground() {
    for (int i = 0; i < foregroundItems.length; i++) {
      for(int pos : foregroundItemPositions[i]) {
        if(pos != -1) image(foregroundItems[i], pos*S - playerX*1.2, height - foregroundItems[i].height*FS + 40, foregroundItems[i].width * FS, foregroundItems[i].height * FS);
      }
    }
  }

  // INPUT //
  public void keyPress() {
    if(key == 'e' || key == 'E' || keyCode == ENTER) {
      for(int i = 0; i < staticItems.length; i++) {
        for(float pos : itemPositions[i]) {
          if(interactables.containsKey(i) && (playerX + width/2)/S > floor(pos) && (playerX + width/2)/S < floor(pos) + staticItems[i].width) {
            pendingInteractions.add(interactables.get(i));
          }
        }
      }
      // Check if any pending interactions are high priority
      for(Interactable interactable : pendingInteractions) {
        if(interactable.getPriority() == 1) {
          interactable.interact();
          pendingInteractions.clear();
          return;
        }
      }
      // If not, interact with the first one
      if(pendingInteractions.size() > 0) {
        pendingInteractions.get(0).interact();
        pendingInteractions.clear();
      }
    }
  }
}
