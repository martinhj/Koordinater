import SimpleOpenNI.*;
import processing.serial.*;

// refakturere til å sjekke for hver rute. Hvis man sjekker x og y på hver sin
// side av null børe det være mulig å sjekke om en av disse har noen z-verdi 
// som ligger over gulvet, istedenfor å kalle metoden for hver gang det er noe
// over gulvet. Altså: Gå gjennom arrayet og sjekk om z har noe over gulvet, 
// avbryt etter første funn.

SimpleOpenNI context;

Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port


PFont fontA;
long time = 0;
long [] squareTime = {0,0,0,0};
boolean [] squareOnOff = {false,false,false,false};
float wx, wy, wz;
final int WHEIGHT = 480;
final int WLENGTH = 640;

void setup()
{
  println(Serial.list());
  // Relatert serialporten:
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);

  size(WLENGTH, WHEIGHT);
  frameRate(30);

  fill(255,255,100);
  fontA = loadFont("hn.vlw");
  //smooth();
  textFont(fontA, 32); 
  
  //context = new SimpleOpenNI(this,SimpleOpenNI.RUN_MODE_SINGLE_THREADED);
  context = new SimpleOpenNI(this);
  context.mirror();
  if(context.enableRGB() == false)
  {
    println("Can't open the RGB-stream, maybe the camera is not connectd!");
    exit();
    return;
  }
  // enable depthMap generation 
  if(context.enableDepth() == false)
  {
     println("Can't open the depthMap, maybe the camera is not connected!"); 
     exit();
     return;
  }
  context.setMirror(false);
  stroke(255,255,255);
 }

void draw()
{
  context.update();

  background(0,0,0);
  image(context.rgbImage(),0,0);
  drawGrid();
  //ellipse(WLENGTH/2, WHEIGHT/2, 50,50);

  int[]   depthMap = context.depthMap();
  int     steps   = 3;  // to speed up the drawing, draw every third point
  int     index;
  PVector realWorldPoint;

  stroke(255);

  PVector[] realWorldMap = context.depthMapRealWorld();
  // lengden på realWorldMap er 640x480 (307200)
  for(int y=0;y < context.depthHeight();y+=steps)
  {
    for(int x=0;x < context.depthWidth();x+=steps)
    {
      index = x + y * context.depthWidth();
      //if(depthMap[index] > 0)
      //{ 
//      realWorldPoint = context.depthMapRealWorld()[index];
        realWorldPoint = realWorldMap[index];
        if (realWorldPoint.z < 2600) {
          //wx = r.x; wy = r.y; wz = r.z;
          // Kan denne kanskje flyttes ned til drawText.
          // Hva slags endringer blir det av det?
          setSquare(realWorldPoint.x, realWorldPoint.y);         
          //drawSquare(r.x, r.y, r.z);
          //println(depthMap[index]);
         //wx = wy = wz = 0;
        }
      //}
    }

  }
  //drawText(wx, wy, wz);  
  frame.setTitle((int)frameRate + " fps");
  println("0: " + squareOnOff[0]);
  println("1: " + squareOnOff[1]);
  println("2: " + squareOnOff[2]);
  println("3: " + squareOnOff[3]);
  drawSquares();
}
void stop() {
  println("Hadet bra.");
}

void setSquare(float x, float y) {
  if (x < 0 && y > 0) {
    squareOnOff[0] = true;
  }
  if (x > 0 && y > 0) {
    squareOnOff[1] = true;
  }
  if (x > 0 && y < 0) {
    squareOnOff[2] = true;
  }
  if (x < 0 && y < 0) {
    squareOnOff[3] = true;
  }
}
/*void drawSquare(float x, float y, float z) {
  if ( r.x < 0 && r.y > 0) {
    drawSquare(0);
    myPort.write(1);
  }
  if (r.x > 0 && r.y > 0) {
    drawSquare(1);
    //myPort.write(1);
  }
  if (r.x > 0 && r.y < 0) {
    drawSquare(2);
    //myPort.write(2);
  }
  if (r.x < 0 && r.y < 0) {
    drawSquare(3);
    myPort.write(2);
  }
}*/

void drawSquares() {
  if (squareOnOff[1]) {drawSquare(1);squareOnOff[1] = false;}
  if (squareOnOff[2]) {drawSquare(2);squareOnOff[2] = false;}
  if (squareOnOff[0]) {drawSquare(0);squareOnOff[0] = false;}
  if (squareOnOff[3]) {drawSquare(3);squareOnOff[3] = false;}
}

void drawSquare(int square) {
  int x = 0, y = 0;
  if (square == 0 || square == 3) {
    x = 0;
  }
  if (square == 1 || square == 2) {
    x = WLENGTH / 2;
  }
  if (square == 0 || square == 1) {
    y = 0;
  }
  if (square == 2 || square == 3) {
    y = WHEIGHT / 2;
  }
  fill(0,204,255, 120);
  rect(x, y, WLENGTH / 2, WHEIGHT / 2);
  fill(255,155,100);
}

void drawText(float x, float y, float z) {
  text("X-akse: " + x, 25, 410);
  text("Y-akse: " + y, 25, 440);
  text("Z-akse: " + z, 25, 470); 
}

void drawGrid() {
  for(int i = 0; i <= WHEIGHT; i++) {
    if (i % (WHEIGHT / 10) == 0) {
      line(0, i, WLENGTH, i);
    }
    if ( i == WHEIGHT / 10 ) {
      stroke(255,0,0);
      line(0, i, WLENGTH, i);
      stroke(255,255,255);
    }
    if ( i == WHEIGHT / 10 * 5 ) {
      stroke(255,0,0);
      line(0, i, WLENGTH, i);
      stroke(255,255,255);
    }
    if ( i == WHEIGHT / 10 * 9 ) {
      stroke(255,0,0);
      line(0, i, WLENGTH, i);
      stroke(255,255,255);
    }
  }
  for (int i = 0; i <= WLENGTH; i++) {
    if (i % (WLENGTH / 10) == 0) {
      line(i, 0, i, WHEIGHT);
    }
    if ( i == WLENGTH / 10 * 5 ) {
      stroke(255,0,0);
      line(i, 0, i, WHEIGHT);
      stroke(255,255,255);
    }
    if ( i == WLENGTH / 10 ) {
      stroke(255,0,0);
      line(i, 0, i, WHEIGHT);
      stroke(255,255,255);
    }
    if ( i == WLENGTH / 10 * 9 ) {
      stroke(255,0,0);
      line(i, 0, i, WHEIGHT);
      stroke(255,255,255);
    }
  }
}
