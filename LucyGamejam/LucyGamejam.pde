import processing.sound.*;
final int S = 8, FS = 10;

// GENERAL / MENU VARIABLES //
int stage = -1; // -2 = Settings, -1 = Loading, 0 = Menu, 1 = Game
FadeManager fadeManager = new FadeManager(1500);
UIManager menuUI = new UIManager();
UIManager debugUI = new UIManager();
PImage loading;
PImage ui[], interactionBubbles[], bird[];
PImage[][] mainLevelLayers = new PImage[1][3];
PImage[][] levelItems = new PImage[1][];
PImage[][] levelForegroundItems = new PImage[1][];
int[][][] itemPositions = {{{1450, -900, -1900, -3900},{0},{-1},{2800},{1500},{-1},{-2000},{-1},{-4000},{-5500},{-8000},{-1},{-10000}}};
int[][][] foregroundItemPositions = {{{800, -3200}}};
SoundFile effects[];

// GAME VARIABLES //
LevelManager activeLevel;
Player player;

// MAIN FUNCTIONS //
void settings() {
  SaveManager.loadSave(this);
  if(SaveManager.getSetting("FULLSCREEN") == 1) fullScreen(P2D);
  else size(1920, 1080, P2D);
}

void setup(){
  surface.setTitle("Lucy");
  ((PGraphicsOpenGL)g).textureSampling(2);
  frameRate(75);
  background(0);

  // Load screen while loading assets
  loading = loadImage(dataPath("loading.png"));
  thread("loadAssets");
}

void draw(){
  if (stage == -2) drawSettings(); // Settings
  else if (stage == -1) image(loading, 0, 0, width, height); // Loading screen
  else if (stage == 0) drawMenu(); // Main menu
  else if (stage == 1) drawGame(1); // Game

  fadeManager.update(); // Update fade
  debugUI.render();
}

// DRAW FUNCTIONS //
void drawSettings(){
  // TODO
}

void drawMenu(){
  background(0);
  menuUI.render();
}

void drawGame(int level){
  activeLevel.render(player.update());
  player.render();
  activeLevel.renderForeground();
}

// CHANGE STAGE //
Consumer<Integer> changeStage = i -> {
  if(i > 0) {
    NPC[] npcs = {new NPC(bird, -width - 100, 100, true, -15)};
    activeLevel = new LevelManager(i, mainLevelLayers[i-1], levelItems[i-1], itemPositions[i-1], levelForegroundItems[i-1], foregroundItemPositions[i-1], npcs);
  }
  stage = i;
};
Consumer<Integer> fadeStage = i -> {
  fadeManager.fade(changeStage, i);
};

// INPUT //
void mouseClicked() {
  if (stage == 0) menuUI.mouseClicked();
}

void keyPressed() {
  if (stage >= 0) player.keyPress();
}

void keyReleased() {
  if (stage >= 0) player.keyRelease();
}

// LOAD ASSETS //
void loadAssets(){
  //ui = new PImage[8];
  interactionBubbles = Utilities.loadImagePng(this, "SpeechBubblesSpriteSheet.png", 256, 32, 8, 1);
  mainLevelLayers[0][0] = Utilities.loadImagePng(this, "Ground.png", 240, 29);
  mainLevelLayers[0][1] = Utilities.loadImagePng(this, "Mountains.png", 2880, 502);
  mainLevelLayers[0][2] = Utilities.loadImagePng(this, "Clouds.png", 2880, 804);
  levelItems[0] = new PImage[13];
  levelItems[0][0] = Utilities.loadImagePng(this, "tree.png", 59, 84);
  arrayCopy(Utilities.loadImagePng(this, "HousesSpriteSheet.png", 480, 327, 4, 3), 0, levelItems[0], 1, 12);

  levelForegroundItems[0] = new PImage[1];
  levelForegroundItems[0][0] = levelItems[0][0];

  bird = Utilities.loadImagePng(this, "bird.png", 72, 21, 4, 1);

  // Prepare sound effects
  effects = new SoundFile[1];
  effects[0] = new SoundFile(this, "OutdoorSteps.wav");
  effects[0].rate(2);

  // Prepare player
  player = new Player(Utilities.loadImagePng(this, "PlayerSpriteSheet.png", 256, 48, 8, 1));

  // Make menu UI
  menuUI.add(new ImgButton(width/2, height/2, 300, 100, Utilities.loadImagePng(this, "PlayButton.png", 300, 100), Utilities.loadImagePng(this, "PlayButtonHover.png", 300, 100), Utilities.loadImagePng(this, "PlayButtonPush.png", 300, 100), fadeStage, 1));
  debugUI.add(new FPSCounter(100,100));

  fadeStage.accept(0);
}
