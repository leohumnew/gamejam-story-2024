class Interactable {
  private int callbackValue = -1;
  private Consumer<Integer> callback;
  private Consumer<PImage[]> callbackImages;
  public boolean isAnimating = false;
  private PImage[] images;
  public short storyStage = 0;
  private byte[][][] emotionProperties; // Each one contains [requirements, causedEmotion + story steps to advance, advancedInteractables]
  public HashMap<Integer, Interactable> parentInteractablesArray;
  private Animation secondaryAnimations[];

  Interactable(byte[][][] emotionProperties) { // Emotion propeties: [requirements, causedEmotion + story steps to advance, Interactables to advance]
    this.emotionProperties = emotionProperties;
  }
  Interactable(Consumer<Integer> callback, int callbackValue, byte[][][] emotionProperties) {
    this(emotionProperties);
    this.callbackValue = callbackValue;
    this.callback = callback;
  }
  Interactable(Consumer<Integer> callback, int callbackValue, PImage[] images, byte[][][] emotionProperties) {
    this(callback, callbackValue, emotionProperties);
    this.images = images;
  }
  Interactable(Consumer<PImage[]> callback, PImage[] images, byte[][][] emotionProperties) {
    this.callbackImages = callback;
    this.images = images;
    this.emotionProperties = emotionProperties;
  }
  void setSecondaryAnimations(Animation[] secondaryAnimations) {
    this.secondaryAnimations = secondaryAnimations;
  }

  // Main interaction method
  void interact() {
    if(emotionProperties == null || emotionProperties[storyStage][0] != null && (emotionProperties[storyStage][0].length == 0 || Utilities.contains(emotionProperties[storyStage][0], player.lastChoice))) {
      if(emotionProperties != null && emotionProperties[storyStage][1] != null) { // If the interactable has a story stage to advance to
        // Show emotion if there is one to show
        if(emotionProperties[storyStage][1].length > 0) player.setActiveBubble(emotionProperties[storyStage][1][0]);
        // Advance other interactables if there are any to advance
        if(emotionProperties[storyStage][2].length > 0) {
          for(int i = 0; i < emotionProperties[storyStage][2].length; i++) {
            parentInteractablesArray.get(int(emotionProperties[storyStage][2][i])).storyStage++;
          }
        }
        // Run callback, advance story, and play animation if not locked or if no caused emotions/requirements
        if(emotionProperties[storyStage][1].length == 0 || (emotionProperties[storyStage][1].length > 0 && emotionProperties[storyStage][1][0] != LOCKED)) {
          isAnimating = true;
          
          if(emotionProperties[storyStage][1].length > 0) storyStage += emotionProperties[storyStage][1][1];

          if(callback != null) { // Callback passing value out
            callback.accept(callbackValue);
          } else if(callbackImages != null && callbackValue == -1) { // Callback passing images out
            callbackImages.accept(images);
          }
        }
      } else {
        if(callback != null) { // Callback passing value out
          callback.accept(callbackValue);
        } else if(callbackImages != null && callbackValue == -1) { // Callback passing images out
          callbackImages.accept(images);
        }
      }
    } else { // If the player doesn't meet the requirements or the interactable is disabled for this story stage
      player.setActiveBubble(NEUTRAL);
    }
  }

  // Render animations
  void render(int playerX) {
    if(secondaryAnimations != null) {
      for(Animation animation : secondaryAnimations) {
        animation.render(playerX);
      }
    }
  }

  int getPriority() { // Check if bike
    return callbackImages != null ? 1 : 0;
  }

  // Advance story stage due to time passing
  void advanceTime() {
    if(emotionProperties != null) {
      while(emotionProperties[storyStage] != null && emotionProperties[storyStage][0] != null) storyStage++;
      if(emotionProperties[storyStage] != null) storyStage++;
    }
  }
}