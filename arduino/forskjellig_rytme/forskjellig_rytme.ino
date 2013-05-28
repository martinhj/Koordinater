#include <Servo.h>

// Utfra hvilken verdi mellom 0 og 4 som leses på serialporten blir motoren
// satt igang og satt i nullstilling igjen.

Servo servo1;
Servo servo2;
Servo servo3;
Servo servo4;

int val;

const int servoPin1 = 7; //dypbass = 0
const int servoPin2 = 8; //litentromme = 1
const int servoPin3 = 9; //ritsjratsj = 2
const int servoPin4 = 10; //shaker = 3
const int NUMBER_OF_SERVOS = 4;
//const int TIME_TO_RESET_SERVO = 100;
//const int DELAY_BETWEEN_HITS = 400;


int ledPin = 13;
int drumPins [] = {0,1};
unsigned long drumLastHit [] = {0, 0, 0, 0};

//standard slag
int delayBetweenHits [] = {400, 600, 800, 200};
int timeToResetServo [] = {150, 150, 300, 100};
int servoEngagePosition [] = {145, 115, 50, 130};
int servoDisengagePosition [] = {115, 95, 0, 100};

//alternativt slag 2
int delayBetweenHits2 [] = {200, 200, 800, 200};
int timeToResetServo2 [] = {150, 150, 300, 100};
int servoEngagePosition2 [] = {145, 115, 50, 130};
int servoDisengagePosition2 [] = {115, 95, 0, 100};

//alternativt slag 3
int delayBetweenHits3 [] = {600, 400, 800, 200};
int timeToResetServo3 [] = {150, 150, 300, 100};
int servoEngagePosition3 [] = {145, 115, 50, 130};
int servoDisengagePosition3 [] = {115, 95, 0, 100};

//alternativt slag 4
int delayBetweenHits4 [] = {400, 400, 800, 200};
int timeToResetServo4 [] = {150, 150, 300, 100};
int servoEngagePosition4 [] = {145, 115, 50, 130};
int servoDisengagePosition4 [] = {115, 95, 0, 100};

boolean drumBusy [] = {false, false, false, false};
boolean drumAlternateHit1 [] = {false, false, false, false};
boolean drumAlternateHit2 [] = {false, false, false, false};
boolean drumAlternateHit3 [] = {false, false, false, false};

long time = 0;

void setup() {
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);
  pinMode(servoPin1, OUTPUT);
  pinMode(servoPin2, OUTPUT);
  servo1.attach(servoPin1);
  servo2.attach(servoPin2);
  servo3.attach(servoPin3);
  servo4.attach(servoPin4);
  // 9600 bps må korespondere med hva som brukes i processing.
  Serial.begin(9600);
  disengageAll();
}
void loop() {
  // leser bare hvis det er data på serial-linja.
  if (Serial.available()) {
    val = Serial.read();
  }
  hitDrum(val);
  hitDrum(2);
  hitDrum(3);
  disengageAll();
  //delay(500);
  // reset read value.
  val = ' ';
}
void hitDrum(int value) {
  if (value == 0) hitRightDrum(0);
  if (value == 1) hitRightDrum(1);
  // i og med at det kun er to tilkoblede motorer blir kun motor 0 og 1 satt
  // igang.
  if (value == 2) hitRightDrum(2);
  if (value == 3) hitRightDrum(3);
}

void hitRightDrum(int i) {
  if (drumBusy[i] == false) {
    engage(i);
    Serial.println("engage1 kjores");
  } else if (drumAlternateHit1[i] == false) {
    engage2(i);
    Serial.println("engage2 kjores");
  } else if (drumAlternateHit2[i] == false) {
    engage3(i);
    Serial.println("engage3 kjores");
  } else if (drumAlternateHit3[i] == false) {
    engage4(i); 
    Serial.println("engage4 kjores");
  }
}

void engage(int i) {
  digitalWrite(ledPin, HIGH); 
  if (drumBusy[i] == false && millis() - drumLastHit[i] > delayBetweenHits[i]) {
      drumBusy[i] = true;
      drumLastHit[i] = millis();
      servoWrite(i, servoEngagePosition[i]);
  }
}

void engage2(int i) {
  digitalWrite(ledPin, HIGH);
  if (drumAlternateHit1[i] == false && millis() - drumLastHit[i] > delayBetweenHits2[i]) {
      drumAlternateHit1[i] = true;
      drumLastHit[i] = millis();
      servoWrite(i, servoEngagePosition2[i]); 
  }
}

void engage3(int i) {
  digitalWrite(ledPin, HIGH);
  if (drumAlternateHit2[i] == false && millis() - drumLastHit[i] > delayBetweenHits3[i]) {
      drumAlternateHit2[i] = true;
      drumLastHit[i] = millis();
      servoWrite(i, servoEngagePosition3[i]);
  }
}

void engage4(int i) {
  digitalWrite(ledPin, HIGH);
  if (drumAlternateHit3[i] == false && millis() - drumLastHit[i] > delayBetweenHits4[i]) {
      drumAlternateHit3[i] = true;
      drumLastHit[i] = millis();
      servoWrite(i, servoEngagePosition4[i]);
  }
}

void disengage(int i) {
  servoWrite(i, servoDisengagePosition[i]);
}

void disengage2(int i) {
  servoWrite(i, servoDisengagePosition2[i]);
}

void disengage3(int i) {
  servoWrite(i, servoDisengagePosition3[i]);
}

void disengage4(int i) {
  servoWrite(i, servoDisengagePosition4[i]);
}

void servoWrite(int servo, int position) {
  if (servo == 0) servo1.write(position);
  if (servo == 1) servo2.write(position);
  if (servo == 2) servo3.write(position);
  if (servo == 3) servo4.write(position);
}
void disengageAll() {
  for (int i = 0; i < NUMBER_OF_SERVOS; i++) {
    if (drumAlternateHit3[i] == true) {
        if (millis() - drumLastHit[i] > timeToResetServo4[i]) {
          //setter hovedslag til false.
          drumBusy[i] = false;
          //setter begge alternative slag til false.
          drumAlternateHit1[i] = false;
          drumAlternateHit2[i] = false;
          drumAlternateHit3[i] = false;
          disengage4(i);
          digitalWrite(ledPin, LOW);
        }
    } else if (drumAlternateHit2[i] == true) {
        if (millis() - drumLastHit[i] > timeToResetServo3[i]) {
          disengage3(i);
          digitalWrite(ledPin, LOW);   
        }   
    } else if (drumAlternateHit1[i] == true) {
        if (millis() - drumLastHit[i] > timeToResetServo2[i]) {
           disengage2(i);
           digitalWrite(ledPin, LOW);
        }
    } else if (drumBusy[i] == true) {
        if (millis() - drumLastHit[i] > timeToResetServo[i]) {
          disengage(i);
          digitalWrite(ledPin, LOW);
        }
    }
  } 
}
