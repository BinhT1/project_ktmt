#include <WiFi.h>
#include <PubSubClient.h>
#include <Wire.h>

const char* ssid = "Binh";
const char* password = "1234567888";
const char* mqtt_server = "broker.mqttdashboard.com";
const char* subscribeTopic = "BINH.NB194231_HOST";
const char* publishTopic = "BINH.NB194231_DEVICE";
const String macAddress = WiFi.macAddress();
WiFiClient espClient;
PubSubClient client(espClient);
void setup() {
  Serial.begin(115200);

  WiFi.disconnect(true);
  // We start by connecting to a WiFi network
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  //set up mqtt
  client.setServer(mqtt_server, 1883);
}

void loop() {

  long randNumber1 = random(10000001, 89999998);
  long randNumber2 = random(10000001, 89999998);

  String lat = "21.03" + String(randNumber1);

  String lng = "105.78" + String(randNumber2); 

  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  String msg = "{\"deviceId\":\"" + macAddress + "\",\"latitude\":\"" + String(lat) + "\",\"longitude\":\"" + String(lng) + "\"}";

  client.publish(publishTopic, msg.c_str());

  delay(2000);
}

void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Create a random client ID or can use mac address
    String client_id = "esp32-client-20194231";
    client_id += String(WiFi.macAddress());
    Serial.printf("The client %s is connecting to the public mqtt broker\n", client_id.c_str());
    if (client.connect(client_id.c_str())) {
      Serial.println("connected");
      // Once connected, publish an announcement...
      client.publish(publishTopic, "{\"test\":\"Bình test\"}");
      // ... and resubscribe
      client.subscribe(subscribeTopic);
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 1 seconds");
      delay(1000);
    }
  }
}
