// ########################################################################
// GAME CONTROL EVENTS:
//
// Interaction in the game is controlled with the Micro:Bit(s) via serial.
// ########################################################################

// Imports:
import processing.serial.*;
import java.util.Arrays;
import java.util.Set;


// ########################################################################
// INPUT: Entirely Micro:Bit(s) Based.
// ########################################################################

void serialEvent(Serial serialPort) {
  
  // Process all incoming messages from serial (USB).
  while (serialPort.available() > 0) {
    
    // Read message.
    String inMsg = serialPort.readString();
    inMsg = trim(inMsg);
    
    // Process message if there is one.
    if (inMsg != null && !inMsg.isEmpty()) {
      println("RECEIVED MSG: '" + inMsg + "'"); // Record in console for debugging.
      processMsg(inMsg);
    }
    
  }
  
} // serialEvent().


// ########################################################################
// INPUT - Processing Received Messages:
// ########################################################################

private void processMsg(String msg) {
  
  // Split message into message attributes:
  String[] msgParts = msg.split(gameConfig.MB_MSG_DELIM);
  
  // Get Message Attributes:
  String msgID = msgParts[0];
  String msgType = msgParts[1];
  String[] msgData = Arrays.copyOfRange(msgParts, 2, msgParts.length);
  
  // Messages processed differently depending on game stage:
  switch (gameStage) {
    
    case "title":
      processInputTitle(msgID, msgType, msgData);
      break;
      
    case "game":
      processInputGame(msgID, msgType, msgData);
      break;

    case "game_over":
      processInputGameOver(msgID, msgType, msgData);
      break;
    
  }
  
} //processMsg().


// ########################################################################
// INPUT - Processing Received Messages: TITLE
// ########################################################################

private void processInputTitle(String msgID, String msgType, String[] msgData) {
  
  // At title screen, only messages accepted are 'A' and 'LOGO' button presses.
  if (msgType.equals("BUTTON")) {
    
    switch (msgData[0]) {
      
      case "A":
        // Attempt to add the player to the game.
        boolean added = gameState.addPlayer(msgID);
        // If player was added (may have already been connected), acknowledge it.
        if (added) {
          sendMsgPlayerConn(msgID, true);
          gameSound.toggleSndPlayerConn(true); // Play sound to indicate player connected.
        }
        break;
        
      case "LOGO":
        // If player(s) have connected, then can start the game.
        if (gameState.getNumPlayers() > 0) gameStage = "game";
        break;
      
    }
    
  }
  
} // processInputTitle().


// ########################################################################
// INPUT - Processing Received Messages: GAME
// ########################################################################

private void processInputGame(String msgID, String msgType, String[] msgData) {
  
  // During the game, process 'A', 'B', 'LOGO', and 'TILT' input messages.
  switch(msgType) {
    
    case "BUTTON":
      // Process button presses during the game.
      processInputGameButton(msgID, msgData);
      break;
      
    case "TILT":
      // Process incoming accelerometer messages.
      processInputGameTilt(msgID, msgData);
      break;
    
  }
  
} // processInputGame().

private void processInputGameButton(String msgID, String[] msgData) {
  
  // Player object associated with the message.
  ObjPlayer currPlayer = gameState.getPlayer(msgID);
  
  // Accepted button presses during the game are 'A', 'B', and 'LOGO'.
  switch (msgData[0]) {
    
    case "A":
      // 'A' button: If there are shields, activate them.
      if (currPlayer.hasShields()) {
        currPlayer.activateShield();
        gameSound.toggleSndActiveShield(true);
      }
      break;
      
    case "B":
      // 'B' button: If there are disruptors, activate them.
      if (currPlayer.hasDisrupts()) {
        currPlayer.activateDisrupt();
        gameSound.toggleSndActiveDisrupt(true);
      }
      break;
      
    case "LOGO":
      // 'LOGO' button is simply used to toggle game pausing.
      paused = !paused;
      break;
    
  }
  
} // processInputGameButton().

private void processInputGameTilt(String msgID, String[] msgData) {
  
  // Handle TILT messages.
  
  // Get roll (x-dir) and pitch (y-dir) from the message.
  int roll = parseInt(msgData[0]);
  int pitch = parseInt(msgData[1]);
  
  // Get x- and y- velocity factors by mapping pitch and roll between -1 and 1.
  float velXFact = map(roll, -180, 180, -1, 1);
  float velYFact = map(pitch, -180, 180, -1, 1);
  
  // Applying scaling to the velocity components.
  float velX = velXFact * gameConfig.PLAYER_VEL_MULT;
  float velY = velYFact * gameConfig.PLAYER_VEL_MULT;
  PVector velocity = new PVector(velX, velY);
  
  // Apply velocity to the player identified from the message.
  ObjPlayer currPlayer = gameState.getPlayer(msgID);
  currPlayer.setVelocity(velocity);

} // processInputGameTilt().


// ########################################################################
// INPUT - Processing Received Messages: GAME OVER
// ########################################################################

private void processInputGameOver(String msgID, String msgType, String[] msgData) {
  
  // During the game over screen, any button will cause a return to the title screen.
  switch(msgType) { //<>// //<>// //<>// //<>//
    
    case "BUTTON":
      // Process button presses during the game.
      disconnectPlayers(); // Disconnect players.
      gameSound.toggleSndGameOver(false); // Stop game over sound.
      gameStage = "title"; // Return to title screen.
      gameState.init(); // Reset game state.
      break;
    
  }
  
} // processInputGameOver().

private void disconnectPlayers() {
  
  // Send a disconnection message to all connected players.
  for (String currPlayerID : gameState.getPlayerIDs()) sendMsgPlayerConn(currPlayerID, false);
  
} // disconnectPlayers().


// ########################################################################
// OUTPUT - SENDING MESSAGES:
// ########################################################################

private void sendMsgRumble(String msgID, String msgData) {
  
  // When a player gets hit, aim to have the MBs vibrate via a servomotor.
  String msgType = "RUMBLE";
  
  // msgData is the type of object the MB is hitting causing the rumble.
  // Can have different haptic patterns based on the game status of the player.
  
  // Send message:
  sendMsg(msgID, msgType, msgData);
  
} // sendMsgRumble().

private void sendMsgPlayerDeath(String msgID) {
  
  // Form message type and message data: player status message - death.
  String msgType = "PLAYER";
  String msgData = "DEATH";
  
  // Send message:
  sendMsg(msgID, msgType, msgData);
  
} // sendMsgPlayerDeath().

private void sendMsgPlayerConn(String msgID, boolean connected) {
  
  // Form message type and message data: player status message - (dis)connected.
  String msgType = "PLAYER";
  String msgData = (connected) ? "ACC" : "DEC";
  
  // Send message:
  sendMsg(msgID, msgType, msgData);
  
} // sendMsgPlayerConn().

private void sendMsg(String msgID, String msgType, String msgData) {
  
  // Format message to send.
  String msg = msgID + gameConfig.MB_MSG_DELIM + msgType + gameConfig.MB_MSG_DELIM + msgData + "\n";
  
  // Send message to relay via serial.
  serialPort.write(msg);
  
  println("SENT MSG: '" + msg.trim() + "'"); // SHow in console for ease.
  
} // sendMsg().
