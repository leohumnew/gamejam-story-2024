static class SaveManager {
  private static final String SAVE_FILE = "save.dat";
  private static byte[] save;

  private static byte[] createSave() {
    return new byte[] {
      0x00, // Fullscreen: 0 = false, 1 = true
    };
  }

  public static void loadSave(PApplet sketch) {
    if (sketch.dataFile(SAVE_FILE).isFile()) save = sketch.loadBytes(SAVE_FILE);
    else save = createSave();
  }

  public static void saveSave(PApplet sketch, byte[] save) {
    sketch.saveBytes(SAVE_FILE, save);
  }

  public static int getSetting(String string) {
    String[] settings = {"FULLSCREEN", "LANGUAGE"};
    for(int i = 0; i < settings.length; i++) {
      if(string.equals(settings[i])) return save[i];
    }
    return -1;
  }
}
