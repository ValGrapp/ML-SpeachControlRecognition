import mqtt.*;
import oscP5.*;  
import netP5.*;

MQTTClient client;

// Creating the instances to connect and send, receive OSC messages
OscP5 oscP5;
NetAddress dest;
OscP5 oscP5_wekinator;
NetAddress dest_wekinator;

public int output_browser;
public int output_wekinator;

void setup() {
  // Starting the OSC Communication. listen on port 9000, return messages on port 8000
  oscP5 = new OscP5(this, 9000); 
  dest = new NetAddress("127.0.0.1", 8000);
  oscP5_wekinator = new OscP5(this, 12000);
  dest_wekinator = new NetAddress("127.0.0.1", 6448);
  
  client = new MQTTClient(this);
  client.connect("mqtt://127.0.0.1:1883");
}

void draw() {}
// Recieve OSC messages from browser
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/word") == true) {
    // Receiving the output from browser
    output_browser = theOscMessage.get(0).intValue();  
  }
    // Voice Ethan
    else if (theOscMessage.checkAddrPattern("/output_1") == true) {
    output_wekinator = 1;
  }
  // Voice Valerie
  else if (theOscMessage.checkAddrPattern("/output_2") == true) {
    output_wekinator = 2;
  }
  
  // Ethan morning mode
  if (output_browser == 3 && output_wekinator == 1) {
    client.publish("/light", "1");
  }
  // Ethan work mode
  else if (output_browser == 4 && output_wekinator == 1) {
    client.publish("/light", "2");
  }
  // Ethan relax mode
  else if (output_browser == 5 && output_wekinator == 1) {
    client.publish("/light", "3");
  }
    // Valerie morning mode
  else if (output_browser == 3 && output_wekinator == 2) {
    client.publish("/light", "4");
  }
  // Valerie work mode
  else if (output_browser == 4 && output_wekinator == 2) {
    client.publish("/light", "5");
  }
  // Valerie relax mode
  else if (output_browser == 5 && output_wekinator == 2) {
    client.publish("/light", "6");
  }
}

// These functions are necessary to run mqtt 
void clientConnected() {
  println("client connected");
}

void messageReceived(String topic, byte[] payload) {
  println("new message: " + topic + " - " + new String(payload));
}

void connectionLost() {
  println("connection lost");
}
