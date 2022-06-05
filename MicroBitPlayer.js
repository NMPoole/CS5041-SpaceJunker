// ################################################################
// CS5041 Interactive Software And Hardware - Practical 1:
// BBC Micro:Bit And Processing
//
// Author: 170004680
//
// Description:
// JavaScript code encompassing the logic perfomed by the Micro:Bit
// (MB) as a player of the game in Processing. The MBs are coded
// with the ability to operate both as a relay for another player 
// and as a player itself.
//
// Set-Up:
// MB Player 1 --radio--> MB Player/Relay 2 --serial--> Processing.
//
// ################################################################


// ################################################################
// ATTRIBUTES:
// ################################################################

let playerID = "1" // ID is UNIQUE to MB, although code is identical.

let isRelay = (playerID == "1") // Whether this MB is the relay.
let isPlayer = false // Whether this MB is a player.

let MSG_DELIM = ":" // Message delimiter over radio/serial.

radio.setGroup(10) // Setup radio for comms with other MB.

// ################################################################
// SENDING MESSAGES: Not including forwarding...
// ################################################################

// SENDING SENSOR DATA:

basic.forever(function () {

    // Periodically send sensor updates.

    let msgFreqMillis = 100 // Freq of updates.
    basic.pause(msgFreqMillis) // Pause as to not overrun comms.

    if (isPlayer) sendUpdates() // Periodic sending of messages.

})

function sendUpdates() {

    // NOTE: Only called when this MB is a player.

    // Create and send TILT (i.e, accelerometer) message:
    let tiltMsg = createTiltMsg()
    sendMsg(tiltMsg)

}

function createTiltMsg() {

    // Get pitch and roll to send in message.
    let roll = input.rotation(Rotation.Roll)
    let pitch = input.rotation(Rotation.Pitch)

    // Data for accelerometer message type is simply:
    // ROLL:PITCH
    //, where roll and pitch are between [-180, 180] each.
    let tiltData = (roll.toString() + MSG_DELIM + pitch.toString())

    // Create and return formatted TILT message.
    let msg = createMsg("TILT", tiltData)
    return msg

}

// SENDING BUTTON A:

input.onButtonPressed(Button.A, function() {
    
    // A Button event sent even when not a player.
    // ...it is used to connect as a player to the game.

    // Create and send formatted BUTTON message.
    let buttonMsg = createMsg("BUTTON", "A")
    sendMsg(buttonMsg)

})

// SENDING BUTTON B:

input.onButtonPressed(Button.B, function () {

    if (isPlayer) { // Send messages from this MB only if player.

        // Create and send formatted BUTTON message.
        let buttonMsg = createMsg("BUTTON", "B")
        sendMsg(buttonMsg)

    }

})

// SENDING 'BUTTON' LOGO:

input.onLogoEvent(TouchButtonEvent.Released, function() {
    
    if (isPlayer) { // Send messages from this MB only if player.

        // Create and send formatted BUTTON message.
        let buttonMsg = createMsg("BUTTON", "LOGO")
        sendMsg(buttonMsg)

    }

})

// GENERAL SENDING MESSAGES:

function createMsg(msgType: string, msgData: string) {

    // Message Format = ID:TYPE:DATA
    // , where ID is playerID, type is "BUTTON", "LOGO", etc.
    // , and DATA is a string formatted acording to data sent.
    // e.g., "0:TILT:-180:-180\n"
    return (playerID + MSG_DELIM +
            msgType + MSG_DELIM +
            msgData + "\n")

}

function sendMsg(msg: string) {

    if (isRelay) { // If this MB is the relay, send msg via serial.

        serial.writeLine(msg)

    } else { // If this MB is not the relay, send msg via radio.
        
        radio.sendString(msg)
    }

}


// ################################################################
// INCOMING MESSAGES:
// ################################################################

// INCOMING RADIO MESSAGES:

radio.onReceivedString(function(receivedMsg: string) {

    // Check if this MB is the recipient.
    // Necessarily checks that there is a msg w/ an ID.
    let isRecipient = checkRecipient(receivedMsg)

    // If so, process the message.
    if (isRecipient == 1) processMsg(receivedMsg)

    // If not, forward the message to serial if this is the relay.
    if (isRecipient == -1 && isRelay) serial.writeLine(receivedMsg)

})

// INCOMING SERIAL MESSAGES:

serial.onDataReceived(serial.delimiters(Delimiters.NewLine), function() {
    
    // Get message from serial.
    let receivedMsg = serial.readLine()

    // Check if this MB is the recipient.
    // Necessarily checks that there is a msg w/ an ID.
    let isRecipient = checkRecipient(receivedMsg)

    // If so, process the message.
    if (isRecipient == 1) processMsg(receivedMsg)

    // If not, forward the message to radio if this is the relay.
    if (isRecipient == -1 && isRelay) radio.sendString(receivedMsg)

})

// GENERAL RECEIVING METHODS:

function checkRecipient(receivedMsg: string) {

    if (!receivedMsg.isEmpty()) { // If there is a message.

        // Get player ID associated with the message.
        let msgParts = receivedMsg.split(MSG_DELIM)
        let msgID = msgParts[0]

        if (!msgID.isEmpty()) { // If message has valid format.

            if (msgID == playerID) { // This MB is recipient?
                return 1 // Is recipient.
            } else {
                return -1 // Not the recipient.
            }

        }
    }

    return 0 // No message or bad format, then ignore.

}

function processMsg(msg: string) {

    // Remove unwanted characters.
    msg = msg.trim()

    // Get the message payload.
    let msgParts = msg.split(MSG_DELIM);

    // Get the msg type and msg data from the message.
    let msgType = msgParts[1] // First item is type.
    let msgData = msgParts.slice(2) // The rest is data.

    // Process the message according to message type.
    switch (msgType) {

        case "PLAYER":
            processPlayerMsg(msgData);
            break;

        case "RUMBLE":
            processRumbleMsg(msgData);
            break;

        default:
            break; // Ignore all unrecognised message types.
    }

}

function processPlayerMsg(data: string[]) {

    // This MB is accepted as player.
    if (data[0] == "ACC") {

        isPlayer = true;

        // Show player number to indicate connected.
        basic.showIcon(IconNames.Yes, 1000)
        basic.showString(playerID)

    }

    // This MB is declined as player.
    else if (data[0] == "DEC") {

        isPlayer = false;

        // Show disconnected.
        basic.showIcon(IconNames.No, 1000)
        basic.clearScreen()

    }

    // This MB has died in the game.
    else if (data[0] == "DEATH") {

        // Show player death.
        basic.showIcon(IconNames.Skull)

    }

    // Ignore "PLAYER" messages with other data values; invalid.

}

function processRumbleMsg(data: String[]) {

    // This MB player was hit by an asteroid/disruption.
    if (data[0] == "AST" || data[0] == "DISR") {

        // Activate rumble motor pattern.
        // OMITTED: Need external battery packs to power servos!
        //pins.servoWritePin(AnalogPin.P0, 180)

    }

}