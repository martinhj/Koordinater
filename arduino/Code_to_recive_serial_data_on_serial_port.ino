// Wiring/Arduino code:
// Read data from the serial and turn ON or OFF a light depending on the value
 
char val; // Data received from the serial port
int ledPin = 13; // Set the pin to digital I/O 13
int ledPins []  = {4, 5, 6, 7};
unsigned long lastOn [] = {0, 0, 0, 0};
boolean ledOn [] = {false, false, false, false};

long time = 0;
 
void setup() {
for (int i = 0; i < sizeof(ledPins); i++) {
	pinMode(ledPins[i], OUTPUT);
	digitalWrite(ledPins[i], LOW);
}
pinMode(ledPin, OUTPUT); // Set pin as OUTPUT
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
    lightOrNot();
    disengageAll();
    val = ' ';
 }

/*void blinkLed(int i) {
	if (millis() - time > 100) {
		time = millis();	
		digitalWrite(ledPins[i], HIGH);
	}
}*/


void lightOrNot(){
	if (val == 'H')engage(0);
}

void engage(int i) {
	if (ledOn[i] == false && millis() - lastOn[i] > 200) {
		ledOn[i] = true;
		lastOn[i] = millis();
		digitalWrite(ledPins[i], HIGH);
	}
}
void disengage(int i) {
	digitalWrite(ledPins[i], LOW);
}

void disengageAll() {
	for (int i = 0; i < sizeof(ledPins); i++) {
		if (ledOn[i] == true && millis() - lastOn[i] > 100) {
			ledOn[i] = false;
			disengage(i);
		}
	}
}
