class Map {
  private final byte[] NO_COLLISION = {}; // List of tiles with no collision
  private PShape TILE_CHUNK; // Base tile chunk shape
  private byte[][] map; // Map array, stores the type of each tile
  private PShape[][] chunks; // Array of tile chunk PShapes
  private PImage texture; // Tile texture map
  private byte chunkTilesAcross, chunksX, chunksY; // Chunk size and number of chunks
  private int tileSizePx, tileResolution; // Tile size in pixels and resolution of each tile in the texture map
  private byte texTilesX; // Number of tiles in the texture map in the x direction

  Map(int chunkTilesAcross, int chunksX, int chunksY, int tileSizePixels) {
    this.tileSizePx = tileSizePixels;
    // Creaty array of bytes to store tile info
    map = new byte[chunksX * chunkTilesAcross][chunksY * chunkTilesAcross];
    // Create the tile chunk PShapes
    TILE_CHUNK = createTileChunk(chunkTilesAcross, chunkTilesAcross, tileSizePx);
    chunks = new PShape[chunksX][chunksY];
    for (int i = 0; i < chunksX; i++) {
      for (int j = 0; j < chunksY; j++) {
        chunks[i][j] = TILE_CHUNK;
        chunks[i][j].setTexture(texture);
        updateChunk(i, j);
      }
    }
    // Set variables
    this.chunkTilesAcross = (byte) chunkTilesAcross;
    this.chunksX = (byte) chunksX;
    this.chunksY = (byte) chunksY;
  }

  public void setTexture(PImage texture, int tilesX, int tileResolution) {
    this.texture = texture;
    this.texTilesX = (byte) tilesX;
    this.tileResolution = tileResolution;
    for (int i = 0; i < chunksX; i++) {
      for (int j = 0; j < chunksY; j++) {
        chunks[i][j].setTexture(this.texture);
      }
    }
  }

  public void updateChunk(int chunkX, int chunkY) {
    for (int i = 0; i < chunkTilesAcross; i++) {
      for (int j = 0; j < chunkTilesAcross; j++) {
        // Set the UV coordinates of the tile depending on the type specified in the map by getting the vertices of each child
        byte type = map[chunkX * chunkTilesAcross + i][chunkY * chunkTilesAcross + j];
        PShape currentChunk = chunks[chunkX][chunkY].getChild(i * chunkTilesAcross + j);
        currentChunk.setTextureUV(0, (type % texTilesX) * tileResolution, (type / texTilesX) * tileResolution);
        currentChunk.setTextureUV(1, (type % texTilesX) * tileResolution + tileResolution, (type / texTilesX) * tileResolution);
        currentChunk.setTextureUV(2, (type % texTilesX) * tileResolution + tileResolution, (type / texTilesX) * tileResolution + tileResolution);
        currentChunk.setTextureUV(3, (type % texTilesX) * tileResolution, (type / texTilesX) * tileResolution + tileResolution);
      }
    }
  }

  public void render(int posX, int posY) {
    // Calculate the chunk coordinates of the player
    int chunkPxSize = chunkTilesAcross * tileSizePx;
    int chunkXPos = posX / chunkPxSize;
    int chunkYPos = posY / chunkPxSize;
    int chunkX = width / 2 / chunkPxSize;
    int chunkY = height / 2 / chunkPxSize;
    int xOffset = width / 2 - posX;
    int yOffset = height / 2 - posY;
    // Render the chunks around the player
    for (int i = chunkXPos - chunkX; i <= chunkXPos + chunkX; i++) {
      for (int j = chunkYPos - chunkY; j <= chunkYPos + chunkY; j++) {
        // Check if the chunk is valid
        if (i >= 0 && i < chunksX && j >= 0 && j < chunksY) {
          // Render the chunk
          shape(chunks[i][j], i * chunkPxSize + xOffset, j * chunkPxSize + yOffset);
        }
      }
    }
  }

  public byte getTile(int x, int y) {
    return map[x][y];
  }

  private PShape createTileChunk(int tilesX, int tilesY, int tileSize) {
    noStroke();
    PShape tileChunk = createShape(GROUP);
    for (int i = 0; i < tilesX; i++) {
      for (int j = 0; j < tilesY; j++) {
        tileChunk.addChild(createShape(RECT, i * tileSize, j * tileSize, tileSize, tileSize));
      }
    }
    return tileChunk;
  }
}
