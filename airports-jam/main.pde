import processing.sound.*;

// VARIABLES //
int stage = -1; // -2 = Settings, -1 = Loading, 0 = Menu, 1 = Game
FadeManager fadeManager = new FadeManager(2000);
UIManager menuUI = new UIManager();
PImage loading;

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

  // Load screen while loading assets
  loading = loadImage(dataPath("loading.png"));
  thread("loadAssets");
}

void draw(){
  background(0);
  if (stage == -2) drawSettings(); // Settings
  else if (stage == -1) image(loading, 0, 0, width, height); // Loading screen
  else if (stage == 0) drawMenu(); // Main menu

  fadeManager.update(); // Update fade
}

// DRAW FUNCTIONS //
void drawSettings(){
  // TODO
}

void drawMenu(){
  menuUI.render();
  // TODO
}

// LOAD ASSETS //
void loadAssets(){
  // Utilities.loadImagePng();
  // new SoundFile(this, "sound.wav");
  fadeManager.fade(changeStage, 0);
}

// CHANGE STAGE //
Consumer<Integer> changeStage = i -> stage = i;

// INPUT //
void mouseClicked() {
  if (stage == 0) menuUI.mouseClicked();
}
