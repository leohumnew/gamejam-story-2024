import processing.sound.*;

// GENERAL / MENU VARIABLES //
int stage = -1; // -2 = Settings, -1 = Loading, 0 = Menu, 1 = Game
FadeManager fadeManager = new FadeManager(1500);
UIManager menuUI = new UIManager();
PImage loading;

// GAME VARIABLES //
LevelManager activeLevel;

// MAIN FUNCTIONS //
void settings() {
  SaveManager.loadSave(this);
  if(SaveManager.getSetting("FULLSCREEN") == 1) fullScreen(P2D);
  else size(1280, 720, P2D);
}

void setup(){
  surface.setTitle("Airports");
  // ((PGraphicsOpenGL)g).textureSampling(2);
  frameRate(60);
  background(0);

  // Load screen while loading assets
  loading = loadImage(dataPath("loading.png"));
  thread("loadAssets");
}

void draw(){
  background(0);
  if (stage == -2) drawSettings(); // Settings
  else if (stage == -1) image(loading, 0, 0, width, height); // Loading screen
  else if (stage == 0) drawMenu(); // Main menu
  else if (stage == 1) drawGame(1); // Game

  fadeManager.update(); // Update fade
}

// DRAW FUNCTIONS //
void drawSettings(){
  // TODO
}

void drawMenu(){
  menuUI.render();
}

void drawGame(int level){
  activeLevel.render();
}

// LOAD ASSETS //
void loadAssets(){
  // new SoundFile(this, "sound.wav");
  delay(1000);

  // Make menu UI
  menuUI.add(new ImgButton(width/2, height/2, 300, 100, Utilities.loadImagePng(this, "PlayButton.png", 300, 100), Utilities.loadImagePng(this, "PlayButtonHover.png", 300, 100), Utilities.loadImagePng(this, "PlayButtonPush.png", 300, 100), fadeStage, 1));

  fadeStage.accept(0);
}

// CHANGE STAGE //
Consumer<Integer> fadeStage = i -> fadeManager.fade(changeStage, i);
Consumer<Integer> changeStage = i -> {
  if(i > 0) {
    activeLevel = new LevelManager(stage);
  }
  stage = i;
};

// INPUT //
void mouseClicked() {
  if (stage == 0) menuUI.mouseClicked();
}
