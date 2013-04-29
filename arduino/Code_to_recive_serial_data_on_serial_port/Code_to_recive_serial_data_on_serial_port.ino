#include <Servo.h>

// Wiring/Arduino code:
// Read data from the serial and turn ON or OFF a light depending on the value

Servo servo1;
Servo servo2;
 
int val; // Data received from the serial port

const int servoPin1 = 3;
const int servoPin2 = 5;
const int NUMBER_OF_SERVOS = 2;

//int ledPin = 13; // Set the pin to digital I/O 13
//int ledPins []  = {4, 5, 6, 7};
int ledPin = 13;
int drumPins [] = {0,1};
unsigned long drumLastHit [] = {0, 0, 0, 0};
boolean drumBusy [] = {false, false, false, false};

long time = 0;
 
void setup() {
	pinMode(ledPin, OUTPUT);
	digitalWrite(ledPin, LOW);
	pinMode(servoPin1, OUTPUT);
	pinMode(servoPin2, OUTPUT);
	servo1.attach(servoPin1);
	servo2.attach(servoPin2);
	//servos[0].write(-30);
	//for (int i = 0; i < sizeof(ledPins); i++) {
		//pinMode(ledPins[i], OUTPUT);
		//digitalWrite(ledPins[i], LOW);
	//}
	//pinMode(ledPin, OUTPUT); // Set pin as OUTPUT
	Serial.begin(9600); // Start serial communication at 9600 bps

}
 
void loop() {
	/*for (int i = 0; i < sizeof(ledPins); i++) {
		digitalWrite(ledPins[i], HIGH);
		delay(1000);
	}*/

 	if (Serial.available()) { // If data is available to read,
		val = Serial.read(); // read it and store it in val
 	}
	/*if (val == 'H') { // If H was received
   		digitalWrite(ledPin, HIGH); // turn the LED on
 	} else {
   		digitalWrite(ledPin, LOW); // Otherwise turn it OFF
 	}
    // Wait 100 milliseconds for next reading*/
    hitDrum(val);
    disengageAll();
    val = ' ';

 }

/*void blinkLed(int i) {
	if (millis() - time > 100) {
		time = millis();	
		digitalWrite(ledPins[i], HIGH);
	}
}*/


void hitDrum(int value) {
	//if (value == 0) engage(0);
	if (value == 1) engage(0);
	if (value == 2) engage(0);
	if (value == 3) engage(0);
}

void engage(int i) {
	digitalWrite(ledPin, HIGH);
	if (drumBusy[i] == false && millis() - drumLastHit[i] > 200) {
		drumBusy[i] = true;
		drumLastHit[i] = millis();
		servoWrite(i, 30);
	}
}
void disengage(int i) {
	servoWrite(i, 0);
}

void servoWrite(int servo, int position) {
	
	if (servo == 0) servo1.write(position);
	if (servo == 1) servo2.write(position);
}


void disengageAll() {
	for (int i = 0; i < NUMBER_OF_SERVOS; i++) {
		if (drumBusy[i] == true && millis() - drumLastHit[i] > 100) {
			drumBusy[i] = false;
			disengage(i);
			digitalWrite(ledPin, LOW);
		}
	}
}
