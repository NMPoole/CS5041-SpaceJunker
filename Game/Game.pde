// ########################################################################
// CS5041 - Interactive Hardware And Software:
// Practical 1 - Micro:Bit And Processing:
//
// Game Name: 'Space Junker'
//
// Game Desc:
//   The player(s) are 'space junkers' - low-earth orbit garbage-men
//   whose job is to recover valuable rare-earth metal resources from Earth's
//   orbit. Set in the future, such resources are scarce and must be recovered
//   from the debris of the millions of satellites collecting as cosmic junk
//   around the planet. However, such a job is perillous. Due to a series of
//   gravitational events (between the Earth, satellites, and moon), there are
//   now plenty of mini- and macro- ateroids collected in orbit around the
//   planet. Space Junkers are, therefore, skilled pilots, having to dodge the
//   asteroid field around the planet to recover rare reseources.
//
//   1+ player(s) compete to earn score by collecting space junk on the screen
//   whilst avoiding hitting asteroids that will depleat their health,
//   eventually leading to elimination (i.e., game over).
//
// Author: Nathan Poole (170004680)
// ########################################################################

// Imports:
import processing.serial.*;
import ddf.minim.*;


// ########################################################################
// Game Attributes:
// ########################################################################

public GameConfig gameConfig; // Game configuration/settings.
public GameState gameState; // State of the game.
public String gameStage; // Stage of the game: "title", "game", "game_over".

public Minim minim; // Minim required for sound.
public IOSound gameSound; // Sounds for the game.

public boolean paused; // Indicates whether the game has been paused or not.

private Serial serialPort; // Port for interfacing with the Micro:Bit(s).


// ########################################################################
// Setup:
// ########################################################################

void setup() {
  
  // Load Game Management Objects:
  gameConfig = new GameConfig();
  gameState = new GameState();
  
  // Initialise Canvas:
  size(displayWidth, displayHeight); // Fullscreen.
  frameRate(gameConfig.FPS); // Ideal frames-per-second.
  noCursor(); // Disable cursor to enable game immersion.
  
  // Set-Up Serial Connection To Micro:Bit(s):
  try {
    serialPort = new Serial(this, Serial.list()[gameConfig.MB_SERIAL_INDEX], gameConfig.MB_BAUD_RATE);
    serialPort.bufferUntil(32);
  } catch (Exception e) {
    println("SERIAL USB UNAVAILABLE. PLEASE TRY AGAIN!");
    System.exit(-1);
  }
  
  // Begin With Title Screen:
  gameStage = "title";
  
  // Game is unpaused at start by default.
  paused = false;
  
  // Get sound object for the game sounds to be played.
  minim = new Minim(this);
  gameSound = new IOSound();
  
} // setup().


// ########################################################################
// Draw:
// ########################################################################

void draw() {
  
  if (!paused) { // Update game and screen only when unpaused.
    
    background(gameConfig.CANVAS_COLOR); // Paint background.
  
    switch(gameStage) { // Handle game according to stage of game.
      
      case "title":
        titleScreen(); // Handle title screen.
        break;
      
      case "game":
        gameScreen(); // Handle wave screen.
        break;
      
      case "game_over":
        gameOverScreen(); // Handle game over screen.
        break;
     
    }
    
  } else { // When paused, indicate as such to the player.
    
    displayPaused();
    
  }
  
} // draw().

void displayPaused() {
  
  // Add text (top left) to indicate that the game is paused to the player(s):
  
  stroke(gameConfig.TITLE_TEXT_COL_STROKE); // Letters black outline.
  fill(gameConfig.TITLE_TEXT_COL_FILL); // Letters white fill.
  textSize(gameConfig.TITLE_TEXT_SIZE); // Letters size.
  textAlign(CENTER); // Center aligning text in relative area.
  
  // Display 'PAUSED' in top-right of the screen (allows screenshots).
  text("PAUSED", gameConfig.CANVAS_WIDTH / 10, gameConfig.CANVAS_HEIGHT / 10);
  
} // displayPaused().


// ########################################################################
// Title Screen Methods:
// ########################################################################

private void titleScreen() {
  
  gameSound.toggleSndGameMusic(true); // Start game music at title screen.
  
  titleScreenDisplay(); // Display the title screen; start instructions.
  
} // titleScreen().

private void titleScreenDisplay() {
  
  // Set title screen text formatting.
  fill(gameConfig.TITLE_TEXT_COL_FILL);
  stroke(gameConfig.TITLE_TEXT_COL_STROKE);
  textAlign(CENTER);
  
  // Position text down the center of the screen.
  int canvasCenterX = gameConfig.CANVAS_WIDTH / 2;
  int canvasPosY = gameConfig.CANVAS_HEIGHT / 6;
  
  // Game Title:
  textSize(gameConfig.TITLE_TEXT_SIZE * 2);
  text("SPACE JUNKER", canvasCenterX, canvasPosY);
  
  // Player Connection Instructions:
  textSize(gameConfig.TITLE_TEXT_SIZE);
  text("SETUP INSTRUCTIONS:\n" + 
       "Press 'A' To Connect A Player (1+ Players)\n" +
       "Press 'LOGO' To Start The Game Once Player(s) Connected\n", 
       canvasCenterX, canvasPosY += 100);
       
  // Displaying Connected Players:
  text("CONNECTED PLAYERS:\n",
       canvasCenterX, canvasPosY += 175);
     
  String connPlayersStr = "";
  if (gameState.getNumPlayers() == 0) {
    connPlayersStr = "<NO PLAYERS CONNECTED>";
    fill(gameConfig.MB_DISCONNECTED_COL);
  } else {
    for (String playerID : gameState.getPlayerIDs()) connPlayersStr += "<" + playerID + "> ";
    fill(gameConfig.MB_CONNECTED_COL);
  }
  text(connPlayersStr, canvasCenterX, canvasPosY += 25);
  
  // Game Controls:
  fill(gameConfig.TITLE_TEXT_COL_FILL);
  stroke(gameConfig.TITLE_TEXT_COL_STROKE);
  text("CONTROLS:\n" +
       "Tilt Device - Adjust Movement\n" +
       "A (Left) Button - Activate Shield\n" +
       "B (Right) Button - Activate Disruptor\n" +
       "LOGO Press - Toggles Pausing\n", 
       canvasCenterX, canvasPosY += 100);
          
} // titleScreenDisplay().


// ########################################################################
// Game Screen Methods:
// ########################################################################

private void gameScreen() {
  
  gameSound.toggleSndGameMusic(true); // Keep game music playing during game.
  
  gameState.update(); // Update the game screen: update all game objects.
  gameState.display(); // Show the game screen: display all game objects.
  
  // Check game over condition:
  if (gameState.gameEndCondition()) {
    gameStage = "game_over";
    gameSound.toggleSndGameMusic(false); // End game music at game over.
  }
  
} // gameScreen().


// ########################################################################
// Game Over Screen Methods:
// ########################################################################

private void gameOverScreen() {
  
  gameOverScreenDisplay(); // Show the game over screen.
  
} // gameOverScreen().

private void gameOverScreenDisplay() {
  
  // Play game over sound.
  gameSound.toggleSndGameOver(true);
  
  // Set game_over screen text fomratting.
  fill(gameConfig.TITLE_TEXT_COL_FILL);
  stroke(gameConfig.TITLE_TEXT_COL_STROKE);
  textAlign(CENTER);
  
  // Position text down the center of the screen.
  int canvasCenterX = gameConfig.CANVAS_WIDTH / 2;
  int canvasPosY = gameConfig.CANVAS_HEIGHT / 6;
  
  // Game Over Title(s):
  textSize(gameConfig.TITLE_TEXT_SIZE * 2);
  text("GAME OVER", canvasCenterX, canvasPosY);
  
  textSize(gameConfig.TITLE_TEXT_SIZE);
  text("Better Luck Next Time Space Junkers!", 
       canvasCenterX, canvasPosY += 50);
       
  // Displaying Connected Player Scores:
  text("PLAYER SCORES:\n",
       canvasCenterX, canvasPosY += 100);
  
  String connPlayersStr = "";
  
  // Getting string of all player scores, and calculating the winner:
  ArrayList<String> winners = new ArrayList<String>();
  int topScore = 0;
  
  for (String playerID : gameState.getPlayerIDs()) {
    
    // Add current player scoring to string.
    ObjPlayer currPlayer = gameState.getPlayer(playerID);
    int currPlayerScore = currPlayer.getScore();
    connPlayersStr += "Player " + playerID + " Score: " + currPlayerScore + "\n";
    
    // Update winning player(s) if need be.
    if (currPlayerScore > topScore) {
      topScore = currPlayerScore;
      winners = new ArrayList<>();
      winners.add(playerID);
    } else if (currPlayerScore == topScore) {
      winners.add(playerID);
    }
    
  }
  
  // Display winner if multiple players, otherwise, just show scores.
  if (gameState.getNumPlayers() > 1) connPlayersStr += "\nWINNER: Player " + winners.toString();
  fill(gameConfig.MB_CONNECTED_COL);
  text(connPlayersStr, canvasCenterX, canvasPosY += 25);
  
  // Game Over Controls:
  fill(gameConfig.TITLE_TEXT_COL_FILL);
  stroke(gameConfig.TITLE_TEXT_COL_STROKE);
  text("PRESS ANY BUTTON TO RETURN TO THE TITLE SCREEN\n", 
       canvasCenterX, canvasPosY += 200);
  
} // gameOverScreenDisplay().
