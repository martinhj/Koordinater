#include <Servo.h>

// Utfra hvilken verdi mellom 0 og 4 som leses på serialporten blir motoren
// satt igang og satt i nullstilling igjen.

Servo servo1;
Servo servo2;
 
int val;

const int servoPin1 = 3;
const int servoPin2 = 5;
const int NUMBER_OF_SERVOS = 2;
const int TIME_TO_RESET_SERVO = 100;
const int DELAY_BETWEEN_HITS = 400;


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
	// 9600 bps må korespondere med hva som brukes i processing.
	Serial.begin(9600);
}
void loop() {
	// leser bare hvis det er data på serial-linja.
 	if (Serial.available()) { 
		val = Serial.read();
 	}
    hitDrum(val);
    disengageAll();
    // reset read value.
    val = ' ';
 }
void hitDrum(int value) {
	if (value == 0) engage(0);
	if (value == 1) engage(1);
	if (value == 2) engage(0);
	if (value == 3) engage(1);
}
void engage(int i) {
	digitalWrite(ledPin, HIGH);
	if (drumBusy[i] == false && millis() - drumLastHit[i] > DELAY_BETWEEN_HITS) {
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
		if (drumBusy[i] == true && millis() - drumLastHit[i] > TIME_TO_RESET_SERVO) {
			drumBusy[i] = false;
			disengage(i);
			digitalWrite(ledPin, LOW);
		}
	}
}
