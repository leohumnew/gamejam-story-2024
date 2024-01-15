import processing.sound.*;
final int S = 8, FS = 10;

// GENERAL / MENU VARIABLES //
int stage = -1; // -2 = Settings, -1 = Loading, 0 = Menu, 1 = Game
FadeManager fadeManager = new FadeManager(1000);
UIManager menuUI = new UIManager();
UIManager debugUI = new UIManager();
PImage loading;
PImage ui[], interactionBubbles[], bird[];
PImage[][] mainLevelLayers = new PImage[3][3];
PImage[][] levelItems = new PImage[3][];
PImage[][] levelForegroundItems = new PImage[3][];
// 0 = Village, 1 = School, 2 = Home, 3 = Forest
float[][][] itemPositions = {
  { // 0 = Highschool, 1-3 = MC Houses, 4-12 = Houses, 13-14 = Bushes, 15-17 = Big trees, 18-20 = Trees, 20-21 = Doors
    {1375},
    {45},{-1},{-1},
    {400},{-1},{200},{1100},{-275},{1225},{800, 1600},{-150},{925},
    {175},{600, 1050},
    {300},{1700},{-400},
    {0},{550},{750},
    {1449},{113}
  },{ // 0 = School, 1 = Bench, 2 = Tree, 3 = Class door
    {-200.001},{219.4},{275.41},{89.43},{-194.001}
  },{
    {-10.001},{60.4},{385.3},{444.3},{494.3},{367.3},{236.4},{175.4}
  }
}; 
// 0 = Trees, 1 = Bushes
int[][][] foregroundItemPositions = {{{800},{-110, 1380}},{},{{470}}};
HashMap<Integer, Interactable>[] interactables = new HashMap[3];
SoundFile effects[];

// GAME VARIABLES //
LevelManager activeLevel;
Player player;
int[][] worldLimits = {{-230, 1750}, {-176, 550}, {15, 532}};

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
  else if (stage >= 1) drawGame(stage); // Game

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
  activeLevel.render(player.update(worldLimits[level-1]));
  player.render();
  activeLevel.renderForeground();
}

// CHANGE STAGE //
Consumer<Integer> changeStage = i -> {
  if(i > 0) {
    player.changeLevel(i);
    NPC[] npcs = null;
    if(i == 1) {
      NPC[] npcsTemp = { new NPC(bird, -width - 100, 100, true, -25) };
      npcs = npcsTemp;
    }
    activeLevel = new LevelManager(i, mainLevelLayers[i-1], levelItems[i-1], itemPositions[i-1], levelForegroundItems[i-1], foregroundItemPositions[i-1], npcs, interactables[i-1]);
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
  if (stage > 0) {
    activeLevel.keyPress();
    player.keyPress();
  }
}

void keyReleased() {
  if (stage > 0) player.keyRelease();
}

Consumer<Integer> playerEmotion = i -> {
  player.setActiveBubble(i);
};

// LOAD ASSETS //
void loadAssets(){
  ui = new PImage[1];
  ui[0] = Utilities.loadImagePng(this, "Enter.png", 32, 32);
  interactionBubbles = Utilities.loadImagePng(this, "SpeechBubblesSpriteSheet.png", 256, 32, 8, 1);
  // Level 0: Village
  mainLevelLayers[0][0] = Utilities.loadImagePng(this, "Ground.png", 240, 29);
  mainLevelLayers[0][1] = Utilities.loadImagePng(this, "Mountains.png", 360, 62);
  mainLevelLayers[0][2] = Utilities.loadImagePng(this, "Clouds.png", 360, 100);
  levelItems[0] = new PImage[23];
  levelItems[0][0] = Utilities.loadImagePng(this, "School.png", 216, 188);
  arrayCopy(Utilities.loadImagePng(this, "HousesSpriteSheet.png", 480, 327, 4, 3), 0, levelItems[0], 1, 12);
  arrayCopy(Utilities.loadImagePng(this, "BushesSpriteSheet.png", 96, 34, 2, 1), 0, levelItems[0], 13, 2);
  arrayCopy(Utilities.loadImagePng(this, "treeBig.png", 378, 172, 3, 1), 0, levelItems[0], 15, 3);
  arrayCopy(Utilities.loadImagePng(this, "tree.png", 189, 86, 3, 1), 0, levelItems[0], 18, 3);
  levelItems[0][21] = Utilities.loadImagePng(this, "SchoolDoor.png", 68, 69);
  levelItems[0][22] = Utilities.loadImagePng(this, "HouseDoor.png", 34, 46);
  levelForegroundItems[0] = new PImage[2];
  levelForegroundItems[0][0] = levelItems[0][19];
  levelForegroundItems[0][1] = levelItems[0][13];
  // Level 1: School
  mainLevelLayers[1][0] = mainLevelLayers[0][0];
  mainLevelLayers[1][1] = mainLevelLayers[0][1];
  mainLevelLayers[1][2] = mainLevelLayers[0][2];
  levelItems[1] = new PImage[5];
  levelItems[1][0] = Utilities.loadImagePng(this, "SchoolInside.png", 858, 135);
  levelItems[1][1] = Utilities.loadImagePng(this, "Bench.png", 51, 27);
  levelItems[1][2] = Utilities.loadImagePng(this, "treeBigTrunk.png", 69, 72);
  levelItems[1][4] = Utilities.loadImagePng(this, "ExitSchoolDoor.png", 40, 124);
  levelForegroundItems[1] = new PImage[0];
  // Level 2: Home
  mainLevelLayers[2][0] = mainLevelLayers[0][0];
  mainLevelLayers[2][1] = mainLevelLayers[0][1];
  mainLevelLayers[2][2] = mainLevelLayers[0][2];
  levelItems[2] = new PImage[8];
  levelItems[2][0] = Utilities.loadImagePng(this, "HouseInside.png", 570, 135);
  levelItems[2][1] = Utilities.loadImagePng(this, "ExitHouseDoor.png", 32, 46);
  levelItems[2][2] = Utilities.loadImagePng(this, "Bed.png", 57, 34);
  levelItems[2][3] = Utilities.loadImagePng(this, "Desk.png", 39, 32);
  levelItems[2][4] = Utilities.loadImagePng(this, "HomeWindow.png", 56, 43);
  levelItems[2][5] = Utilities.loadImagePng(this, "Cage.png", 16, 45);
  levelItems[2][6] = Utilities.loadImagePng(this, "KitchenDoor.png", 32, 46);
  levelItems[2][7] = Utilities.loadImagePng(this, "LivingDoor.png", 32, 46);
  levelForegroundItems[2] = new PImage[1];
  levelForegroundItems[2][0] = Utilities.loadImagePng(this, "Piano.png", 67, 29);

  bird = Utilities.loadImagePng(this, "bird.png", 72, 21, 4, 1);

  // Prepare sound effects
  effects = new SoundFile[1];
  effects[0] = new SoundFile(this, "OutdoorSteps.wav");
  effects[0].rate(2);

  // Prepare player
  player = new Player(Utilities.loadImagePng(this, "PlayerSpriteSheet.png", 256, 49, 8, 1));
  loadInteractables();

  // Make menu UI
  menuUI.add(new ImgButton(width/2, height/2, 300, 100, Utilities.loadImagePng(this, "PlayButton.png", 300, 100), Utilities.loadImagePng(this, "PlayButtonHover.png", 300, 100), Utilities.loadImagePng(this, "PlayButtonPush.png", 300, 100), fadeStage, 1));
  debugUI.add(new FPSCounter(100,100));

  fadeStage.accept(0);
}

void loadInteractables() {
  PImage[] doorAnim;
  // Level 0: Village
  interactables[0] = new HashMap<Integer, Interactable>();
  interactables[0].put(21, new Interactable(fadeStage, 2));
  interactables[0].put(22, new Interactable(fadeStage, 3));
  // Level 1: School
  interactables[1] = new HashMap<Integer, Interactable>();
  interactables[1].put(1, new Interactable(playerEmotion, 1));
  interactables[1].put(2, new Interactable(playerEmotion, 2));
  doorAnim = Utilities.loadImagePng(this, "SchoolInsideDoorSpriteSheet.png", 324, 48, 6, 1);
  interactables[1].put(3, new Interactable(playerEmotion, 3, doorAnim));
  levelItems[1][3] = doorAnim[0];
  interactables[1].put(4, new Interactable(fadeStage, 1));
  // Level 2: Home
  interactables[2] = new HashMap<Integer, Interactable>();
  interactables[2].put(1, new Interactable(fadeStage, 1));
  interactables[2].put(2, new Interactable(playerEmotion, 0));
  interactables[2].put(3, new Interactable(playerEmotion, 4));
  interactables[2].put(4, new Interactable(fadeStage, 3));
  interactables[2].put(5, new Interactable(playerEmotion, 5));
  interactables[2].put(6, new Interactable(playerEmotion, 6));
  interactables[2].put(7, new Interactable(playerEmotion, 7));
}
