import processing.sound.*;
SoundManager soundManager;
final int S = 8, FS = 10, LVL_NUM = 4;
final byte NEUTRAL = 0, FEAR = 1, ANGER = 2, SADNESS = 3, BRAVERY = 4, LOVE = 5, PEACE = 6, HEALING = 7, LOCKED = 8;

// GENERAL / MENU VARIABLES //
int stage = -1; // -2 = Settings, -1 = Loading, 0 = Menu, 1 = Game
FadeManager fadeManager = new FadeManager(1000);
UIManager menuUI = new UIManager();
UIManager debugUI = new UIManager();
PImage loading;
PImage ui[], interactionBubbles[], bird[], extraImages[];
PImage[][] mainLevelLayers = new PImage[LVL_NUM][5];
PImage[][] levelItems = new PImage[LVL_NUM][];
PImage[][] levelForegroundItems = new PImage[LVL_NUM][];
// 0 = Village, 1 = School, 2 = Home, 3 = Forest
float[][][] itemPositions = {
  { // 0 = Highschool, 1-3 = MC Houses, 4-12 = Houses, 13-24 = Bushes, 25-27 = Big trees, 28-33 = Trees, 34-35 = Doors, 36 = Bike
    {1375},
    {45},{-1},{-1},
    {400},{-1},{200},{1100},{-275},{1225},{800, 1600},{-150},{925},
    {175},{1050},{600},{-200},{1750},{},{-100},{},{-500},{},{-700},{},
    {300},{1700},{-400},
    {0},{},{750},{550},{},{},
    {1449},{113},
    {150}
  },{ // 0 = School, 1 = Bench, 2 = Tree, 3 = Class door, 4 = Exit door
    {-200.001},{253.4},{315.4},{113.42},{-194.001}
  },{
    {-10.001},{60.39},{385.3},{444.3},{489.36},{367.3},{236.39},{175.39},{-160, 580},{-70,575}
  },{ // 0-11 = Bushes, 12-14 = Big trees, 15-20 = Trees
    {-350},{300},{-100},{200},{400},{50},{-200},{740},{700},{100},{500},{-630},
    {-300, 600},{-20, 130},{-500, 250},
    {100},{-580},{350},{-400},{50},{-690}
  }
}; 
// 0 = Trees, 1 = Bushes
int[][][] foregroundItemPositions = {{{800},{-110, 1380}},{},{{470},{-110, 645}},{{100},{-200},{-320},{250},{-400},{350},{450},{-300}}};
HashMap<Integer, Interactable>[] interactables = new HashMap[LVL_NUM];
SoundFile effects[];

// GAME VARIABLES //
LevelManager activeLevel;
Player player;
int[][] worldLimits = {{-230, 1750}, {-176, 560}, {15, 532}, {-800, 800}};

// MAIN FUNCTIONS //
void settings() {
  SaveManager.loadSave(this);
  if(SaveManager.getSetting("FULLSCREEN") == 1) fullScreen(P2D);
  else size(1920, 1080, P2D);
}

void setup(){
  surface.setTitle("Lucy");
  ((PGraphicsOpenGL)g).textureSampling(2);
  frameRate(60);
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
  if(soundManager != null) soundManager.update(); // Update sound manager
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
    activeLevel = new LevelManager(i, mainLevelLayers[i-1], levelItems[i-1], itemPositions[i-1], levelForegroundItems[i-1], foregroundItemPositions[i-1], interactables[i-1]);
    // Level extras
    if(i == 1) {
      NPC[] npcs = { new NPC(bird, -width - 100, 100, true, -25) };
      activeLevel.addNPCs(npcs);
    } else if(i == 2) {
      PImage[] argumentImages = new PImage[1];
      arrayCopy(extraImages, 2, argumentImages, 0, 1);
      activeLevel.addExtraLayers(argumentImages, new float[][]{{-20, 44, 1.13}});
    } else if(i == 3) {
      PImage[] argumentImages = new PImage[2];
      arrayCopy(extraImages, 0, argumentImages, 0, 2);
      activeLevel.addExtraLayers(argumentImages, new float[][]{{205, 37, 1.13}, {150, 37, 1.13}});
    }
  }
  stage = i;
};
Consumer<Integer> fadeStage = i -> {
  fadeManager.fade(changeStage, i);
  soundManager.fadeTo(byte(i), 1000);
};

// INPUT //
void mouseClicked() {
  if (stage == 0) menuUI.mouseClicked();
}

void keyPressed() {
  if (stage > 0) {
    if(!player.keyPress()) activeLevel.keyPress();
  }
}

void keyReleased() {
  if (stage > 0) player.keyRelease();
}

Consumer<Integer> playerEmotion = i -> {
  player.setActiveBubble(byte(i));
};
Consumer<Integer> dropItem = i -> {
  itemPositions[0][36][0] = i;
};
Consumer<PImage[]> rideBike = img -> {
  itemPositions[0][36][0] = -1;
  player.setActiveAction(0, img, dropItem);
};

// LOAD ASSETS //
void loadAssets(){
  ui = new PImage[1];
  ui[0] = Utilities.loadImagePng(this, "Enter.png", 32, 32);
  interactionBubbles = Utilities.loadImagePng(this, "SpeechBubblesSpriteSheet.png", 1056, 32, 33, 1);
  // Level 0: Village
  mainLevelLayers[0][0] = Utilities.loadImagePng(this, "GroundPath.png", 240, 41);
  mainLevelLayers[0][1] = Utilities.loadImagePng(this, "Mountains.png", 360, 62);
  mainLevelLayers[0][2] = Utilities.loadImagePng(this, "Clouds.png", 358, 100);
  mainLevelLayers[0][3] = Utilities.loadImagePng(this, "Sunset.png", 240, 135);
  mainLevelLayers[0][4] = Utilities.loadImagePng(this, "NightSky.png", 240, 135);
  levelItems[0] = new PImage[37];
  levelItems[0][0] = Utilities.loadImagePng(this, "School.png", 216, 188);
  arrayCopy(Utilities.loadImagePng(this, "HousesSpriteSheet.png", 480, 327, 4, 3), 0, levelItems[0], 1, 12);
  arrayCopy(Utilities.loadImagePng(this, "BushesSpriteSheet.png", 192, 102, 4, 3), 0, levelItems[0], 13, 12);
  arrayCopy(Utilities.loadImagePng(this, "treeBig.png", 378, 172, 3, 1), 0, levelItems[0], 25, 3);
  arrayCopy(Utilities.loadImagePng(this, "tree.png", 189, 172, 3, 2), 0, levelItems[0], 28, 6);
  levelItems[0][34] = Utilities.loadImagePng(this, "SchoolDoor.png", 68, 69);
  levelItems[0][35] = Utilities.loadImagePng(this, "HouseDoor.png", 34, 46);
  levelItems[0][36] = Utilities.loadImagePng(this, "Bike.png", 40, 27);
  levelForegroundItems[0] = new PImage[2];
  levelForegroundItems[0][0] = levelItems[0][19];
  levelForegroundItems[0][1] = levelItems[0][13];
  // Level 1: School
  mainLevelLayers[1] = mainLevelLayers[0];
  levelItems[1] = new PImage[5];
  levelItems[1][0] = Utilities.loadImagePng(this, "SchoolInside.png", 924, 135);
  levelItems[1][1] = Utilities.loadImagePng(this, "Bench.png", 51, 27);
  levelItems[1][2] = Utilities.loadImagePng(this, "treeBigTrunk.png", 69, 72);
  levelItems[1][4] = Utilities.loadImagePng(this, "ExitSchoolDoor.png", 40, 124);
  levelForegroundItems[1] = new PImage[0];
  // Level 2: Home
  mainLevelLayers[2][0] = Utilities.loadImagePng(this, "Ground.png", 240, 41);
  mainLevelLayers[2][1] = mainLevelLayers[0][1];
  mainLevelLayers[2][2] = mainLevelLayers[0][2];
  mainLevelLayers[2][3] = Utilities.loadImagePng(this, "SunsetNoSun.png", 240, 135);
  mainLevelLayers[2][4] = mainLevelLayers[0][4];
  levelItems[2] = new PImage[10];
  levelItems[2][0] = Utilities.loadImagePng(this, "HouseInside.png", 570, 135);
  levelItems[2][1] = Utilities.loadImagePng(this, "ExitHouseDoor.png", 32, 46);
  levelItems[2][2] = Utilities.loadImagePng(this, "Bed.png", 57, 34);
  levelItems[2][3] = Utilities.loadImagePng(this, "Desk.png", 39, 32);
  levelItems[2][4] = Utilities.loadImagePng(this, "HomeWindow.png", 56, 43);
  levelItems[2][5] = Utilities.loadImagePng(this, "Cage.png", 16, 45);
  levelItems[2][6] = Utilities.loadImagePng(this, "KitchenDoor.png", 32, 46);
  levelItems[2][7] = Utilities.loadImagePng(this, "LivingDoor.png", 32, 46);
  levelItems[2][8] = levelItems[0][15];
  levelItems[2][9] = levelItems[0][13];
  levelForegroundItems[2] = new PImage[2];
  levelForegroundItems[2][0] = Utilities.loadImagePng(this, "Piano.png", 67, 29);
  levelForegroundItems[2][1] = levelItems[0][13];
  // Level 3: Forest
  mainLevelLayers[3][0] = mainLevelLayers[2][0];
  mainLevelLayers[3][1] = mainLevelLayers[0][1];
  mainLevelLayers[3][2] = mainLevelLayers[0][2];
  mainLevelLayers[3][3] = mainLevelLayers[0][3];
  mainLevelLayers[3][4] = mainLevelLayers[0][4];
  levelItems[3] = new PImage[21];
  arrayCopy(levelItems[0], 13, levelItems[3], 0, 21);
  levelForegroundItems[3] = new PImage[7];
  arrayCopy(levelItems[0], 13, levelForegroundItems[3], 0, 6);
  levelForegroundItems[3][6] = levelItems[0][28];

  // Load extra images
  extraImages = new PImage[3];
  extraImages[0] = Utilities.loadImagePng(this, "KitchenBG.png", 114, 46);
  extraImages[1] = Utilities.loadImagePng(this, "LivingBG.png", 61, 46);
  extraImages[2] = Utilities.loadImagePng(this, "WindowBG.png", 255, 57);

  bird = Utilities.loadImagePng(this, "bird.png", 72, 21, 4, 1);

  // Prepare sound effects
  effects = new SoundFile[1];
  effects[0] = new SoundFile(this, "OutdoorSteps.wav");
  effects[0].rate(2);

  // Prepare sound manager
  SoundFile[] music = new SoundFile[5];
  music[0] = new SoundFile(this, "SchoolMusic.wav");
  music[1] = new SoundFile(this, "VillageMusic.wav");
  music[2] = new SoundFile(this, "SchoolMusic.wav");
  music[3] = new SoundFile(this, "SchoolMusic.wav");
  music[4] = new SoundFile(this, "VillageMusic.wav");
  soundManager = new SoundManager(music, this);

  // Prepare player
  player = new Player(Utilities.loadImagePng(this, "PlayerSpriteSheet.png", 384, 49, 12, 1));
  loadInteractables();

  // Make menu UI
  menuUI.add(new ImgButton(width/2, height/2, 300, 100, Utilities.loadImagePng(this, "PlayButton.png", 300, 100), Utilities.loadImagePng(this, "PlayButtonHover.png", 300, 100), Utilities.loadImagePng(this, "PlayButtonPush.png", 300, 100), fadeStage, 3));
  debugUI.add(new FPSCounter(100,100));

  fadeStage.accept(0);
}

void loadInteractables() {
  // Emotions: NO ACTION = 0, FEAR = 1, ANGER = 2, SADNESS = 3, BRAVERY = 4, LOVE = 5, PEACE = 6, HEALING = 7, LOCKED = 8;
  PImage[] animImages;
  // Level 0: Village
  interactables[0] = new HashMap<Integer, Interactable>();
  interactables[0].put(34, new Interactable(fadeStage, 2, null));
  interactables[0].put(35, new Interactable(fadeStage, 3, null));
  animImages = Utilities.loadImagePng(this, "BikeSpriteSheet.png", 120, 48, 3, 1);
  interactables[0].put(36, new Interactable(rideBike, animImages, null));
  // Level 1: School
  interactables[1] = new HashMap<Integer, Interactable>();
  interactables[1].put(1, new Interactable(playerEmotion, 1, null));
  interactables[1].put(2, new Interactable(playerEmotion, 2, null));
  animImages = Utilities.loadImagePng(this, "SchoolInsideDoorSpriteSheet.png", 324, 48, 6, 1);
  interactables[1].put(3, new Interactable(playerEmotion, 2, animImages, null));
  levelItems[1][3] = animImages[5];
  interactables[1].put(4, new Interactable(fadeStage, 1, null));
  // Level 2: Home
  interactables[2] = new HashMap<Integer, Interactable>();
  interactables[2].put(1, new Interactable(fadeStage, 1, new byte[][][]{ // House door
    {{},{LOCKED,0},{}} // Evening 1
  }));
  interactables[2].put(2, new Interactable(playerEmotion, 0, new byte[][][]{ // Bed
    {{},{FEAR,0},{}}, {{},{SADNESS,1},{}}, {null} // Evening 1
  }));
  interactables[2].put(3, new Interactable(playerEmotion, 4, new byte[][][]{{null}}));
  interactables[2].put(4, new Interactable(fadeStage, 4, new byte[][][]{ // Window
    {{LOVE},{BRAVERY,1},{}}, {null} // Evening 1
  }));
  interactables[2].put(5, new Interactable(playerEmotion, 5, new byte[][][]{ // Cage
    {{},{LOVE,1},{2}}, {null} // Evening 1
  }));
  interactables[2].put(6, new Interactable(playerEmotion, 6, new byte[][][]{ // Kitchen door
    {null}
  }));
  interactables[2].put(7, new Interactable(playerEmotion, 7, new byte[][][]{ // Living room door
    {{},{FEAR,0},{}} // Evening 1
  }));
  // Level 3: Forest
  interactables[3] = new HashMap<Integer, Interactable>();
}
