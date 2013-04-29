#include <NewPing.h>
#include <Servo.h>

#define TRIGGER_PIN  12  // Arduino pin tied to trigger pin on the ultrasonic sensor.
#define ECHO_PIN     11  // Arduino pin tied to echo pin on the ultrasonic sensor.
#define MAX_DISTANCE 400 // Maximum distance we want to ping for (in centimeters). Maximum sensor distance is rated at 400-500cm.

//NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE); // NewPing setup of pins and maximum distance.

Servo servo1;
Servo servo2;
const int buttonPin = 2;
const int servoPin1 = 3;
const int servoPin2 = 5;
int buttonState = 0;

unsigned long prevTime;

boolean array[10]; 

void setup() {

  Serial.begin(115200); // Open serial monitor at 115200 baud to see ping results.

  pinMode(buttonPin, INPUT);
  pinMode(servoPin1, OUTPUT);
  servo1.attach(servoPin1);
  servo2.attach(servoPin2);

  prevTime = millis();

}

void loop() {

  //unsigned int uS = sonar.ping();
  //int cm = (uS / US_ROUNDTRIP_CM);

  if (prevTime + 50 < millis() && array[10] == false) {
    drum1opp();//opp1
    array[10] = true;
    array[0] = true;
  }
    
  if (prevTime + 200 < millis() && array[0] == true) {
    drum2ned(); //dunk2
    array[0] = false; //avslutter denne.
    array[1] = true; //starter neste.
  }
    
  if (prevTime + 100 < millis() && array[1] == true) {
    drum2opp(10);//opp2
    array[1] = false;
    array[2] = true;
  }
  
  if (prevTime + 300 < millis() && array[2] == true) {
    drum1ned();//dunk1
    array[2] = false;
    array[3] = true;
  }
    
  if (prevTime + 100 < millis() && array[3] == true) {
    drum1opp();//opp1
    array[3] = false;
    array[4] = true;
  }
  
  if (prevTime + 100 < millis() && array[4] == true) {
    drum1ned();//dunk1
    array[4] = false;
    array[5] = true;
  }
   
  if (prevTime + 100 < millis() && array[5] == true) { 
    drum1opp();//opp1
    array[5] = false;
    array[6] = true;
  }
    
  if (prevTime + 100 < millis() && array[6] == true) {
    drum2ned();//dunk2
    array[6] = false;
    array[7] = true;
  }
  
  if (prevTime + 100 < millis() && array[7] == true) {
    drum2opp(10);//opp2
    array[7] = false;
    array[8] = true;
  }
    
  if (prevTime + 200 < millis() && array[8] == true) {
    drum1ned();//dunk1
    array[8] = false;
    array[9] = true;
  }
    
  if (prevTime + 100 < millis() && array[9] == true) {
    array[9] = false;
    array[10] = false;
  }
    



  // Wait 50ms between pings (about 20 pings/sec). 29ms should be the shortest delay between pings.
  //unsigned int uS = sonar.ping(); // Send ping, get ping time in microseconds (uS).
 // Serial.print("Ping: ");
 // Serial.print(cm); // Convert ping time to distance in cm and print result (0 = outside set distance range)
 // Serial.println("cm");

}

void drum1ned() {
  servo1.write(30);
  prevTime = millis();
}

void drum1opp() {
  servo1.write(0);
  prevTime = millis();
}

void drum2ned() {
  servo2.write(-30);
  prevTime = millis();
}

void drum2opp(int i) {
  servo2.write(i);
  prevTime = millis();
}


