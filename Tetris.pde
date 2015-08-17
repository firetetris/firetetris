/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/34481*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/*
  Tetris
  Author: Karl Hiner
  Controls:
  LEFT/RIGHT/DOWN to move
  UP - flip
  SPACE - hard drop (drop immediately)
 */
 
import ddf.minim.*;

final static int TETRIS_WIDTH = 10;
final static int TETRIS_HEIGHT = 20;

Config config;
AppletRenderer renderer;
UDPRenderer udpRenderer;
TetrisGame currentGame;
TetrisMenu menu;
GameInputController inputController;
ControlP5 controlP5;
Minim minim;
Audio audio;

public void setup() {
  size(562, 666, PApplet.P2D); // Must be the first call in setup()

  controlP5 = new ControlP5(this);
  inputController = new GameInputController(this, config);
  renderer = new AppletRenderer();
  udpRenderer = new UDPRenderer(config);
  menu = new TetrisMenu();
  
  minim = new Minim(this);
  audio = new Audio(minim);
}

public void draw() {
  boolean menuShown = currentGame == null || currentGame.isGameOver() || currentGame.isPaused();
  // Get the current input, direct it to the current active component
  inputController.update(menuShown ? menu : currentGame);

  // Recalculate which is the active component as it may have changed
  menuShown = currentGame == null || currentGame.isGameOver() || currentGame.isPaused();

  // Clear everything from previous frame
  background(0);

  // Update the audio
  if (audio != null)
    audio.update();

  // Update and render the current game
  if (currentGame != null && !currentGame.isPaused()) 
    currentGame.update();

  renderer.renderGameState(currentGame);
  udpRenderer.renderGameState(currentGame);
  
  if (currentGame != null)
    currentGame.cleanup();

  // Update and render the menu
  if (menuShown) {
    pushStyle();
    fill(0, 0, 0, 230);
    rect(0, 0, width, height);
    popStyle();
    renderer.renderMenu(currentGame, menu);
  }
}

boolean ctrlPressed = false;

public void keyPressed() {
  if (key == ESC) {
    // Ignore escape being pressed. This prevents the default quit behavior.
    key = 0;
  } else if (char(keyCode) == 'Q' && ctrlPressed) {
    // Flush displays and exit
    renderer.renderGameState(null);
    udpRenderer.renderGameState(null);
    exit();
  } else if (keyCode == CONTROL) {
    ctrlPressed = true;
  } else if (char(keyCode) == 'S') {
    audio.toggleShuffleMode();
  } else if (char(keyCode) == 'L') {
    audio.toggleLoopSingleTrackMode();
  } else if (char(keyCode) == 'N') {
    audio.playNextMusic();
  }


  inputController.keyPressed();
}

public void keyReleased() {
  if (keyCode == CONTROL) {
    ctrlPressed = false;
  }

  inputController.keyReleased();
}
