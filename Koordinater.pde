import SimpleOpenNI.*;
import processing.serial.*;

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
  PVector r = new PVector(0,0,0);

void setup()
{
  // Relatert serialporten:
  String portName = Serial.list()[6];
  myPort = new Serial(this, portName, 9600);

  size(WLENGTH, WHEIGHT);
  frameRate(30);

  fill(255,255,100);
  fontA = loadFont("hn.vlw");
  //smooth();
  textFont(fontA, 32); 
  
  //context = new SimpleOpenNI(this,SimpleOpenNI.RUN_MODE_SINGLE_THREADED);
  context = new SimpleOpenNI(this);
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
  ellipse(WLENGTH/2, WHEIGHT/2, 50,50);

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
      if(depthMap[index] > 0)
      { 
//      realWorldPoint = context.depthMapRealWorld()[index];
        realWorldPoint = realWorldMap[index];
        r = realWorldPoint;
      }
      /*if (r.z > 1700 && r.z < 1800 && millis() - time > 10) {*/
      // millis() - time > 10 with the time = millis() inside the if statement 
      // makes it update only each hundered millisecond.
      // The r.z < 2000 makes sure to ignore the floor and all things near the floor.
      
        
      if (millis() - time > 5  ) {
        if (r.z < 2600) {
          wx = r.x; wy = r.y; wz = r.z;
          // Kan denne kanskje flyttes ned til drawText.
          // Hva slags endringer blir det av det?
          drawSquare(r.x, r.y, r.z);
          println(depthMap[index]);
        
         time = millis();
         
         wx = wy = wz = 0;
        }
      }
       // println("x:  " + r.x + " y: " + r.y + " z:  " + r.z);
      //}
      //if (r.z > 2000 && r.z < 2600 && r.z != 0.0) {
      //  println("x:  " + r.x + " y: " + r.y + " z:  " + r.z);
      //}
      
    }

  }
  //drawText(wx, wy, wz);  
  frame.setTitle((int)frameRate + " fps");

}
void stop() {
  println("Hadet bra.");
}

void drawSquare(float x, float y, float z) {
  if ( r.x < 0 && r.y > 0) {
    drawSquare(0);
    myPort.write(0);
  }
  if (r.x > 0 && r.y > 0) {
    drawSquare(1);
    myPort.write(0);
  }
  if (r.x > 0 && r.y < 0) {
    drawSquare(2);
    myPort.write(0);
  }
  if (r.x < 0 && r.y < 0) {
    drawSquare(3);
    myPort.write(0);
  }
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
