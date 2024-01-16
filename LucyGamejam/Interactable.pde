class Interactable {
  private int callbackValue = -1;
  private Consumer<Integer> callback;
  private Consumer<PImage[]> callbackImages;
  public boolean isAnimating = false;
  private PImage[] images;
  public short storyStage = 0;
  private byte[][][] emotionProperties; // Each one contains [requirements, causedEmotion + story steps to advance, advancedInteractables]
  public HashMap<Integer, Interactable> parentInteractablesArray;

  Interactable(Consumer<Integer> callback, int callbackValue, byte[][][] emotionProperties) {
    this.callbackValue = callbackValue;
    this.callback = callback;
    this.emotionProperties = emotionProperties;
  }
  Interactable(Consumer<Integer> callback, int callbackValue, PImage[] images, byte[][][] emotionProperties) {
    this(callback, 0, emotionProperties);
    this.images = images;
  }
  Interactable(Consumer<PImage[]> callback, PImage[] images, byte[][][] emotionProperties) {
    this.callbackImages = callback;
    this.images = images;
    this.emotionProperties = emotionProperties;
  }

  void interact() {
    if(emotionProperties == null || emotionProperties[storyStage][0] != null && (emotionProperties[storyStage][0].length == 0 || Utilities.contains(emotionProperties[storyStage][0], player.lastChoice))) {
      isAnimating = true;
      if(callback != null) { // Callback passing value out
        callback.accept(callbackValue);
      } else if(callbackImages != null && callbackValue == -1) { // Callback passing images out
        callbackImages.accept(images);
      }
      if(emotionProperties != null) storyStage += emotionProperties[storyStage][1][1];
    }
    if(emotionProperties != null) {
      if(emotionProperties[storyStage][0] != null) {
        player.setActiveBubble(emotionProperties[storyStage][1][0]);
        for(int i = 0; i < emotionProperties[storyStage][2].length; i++) {
          parentInteractablesArray.get(emotionProperties[storyStage][2][i]).storyStage++;
        }
      }
      else player.setActiveBubble(NEUTRAL);
    }
  }

  int getPriority() {
    return callbackImages != null ? 1 : 0;
  }
}