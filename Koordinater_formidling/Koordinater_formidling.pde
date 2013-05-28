import SimpleOpenNI.*;
import processing.serial.*;


SimpleOpenNI context;


Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port

Firkant en;
Firkant to;
Firkant tre;
Firkant fire;
Firkant [] firkantArray = {en,to,tre,fire};
PFont fontA;
long time = 0;
long [] squareTime = {0,0,0,0};
boolean [] squareOnOff = {false,false,false,false};
int barrier;
final int WHEIGHT = 480;
final int WLENGTH = 640;

void setup(){
  println(Serial.list());
  // Relatert serialporten:
  String portName = Serial.list()[6];
  myPort = new Serial(this, portName, 9600);
  // oppe til venster
  en = new Firkant (0, 25, 130, 50);
  // oppe til høyre
  to = new Firkant (320, 25,130, 50);
  // nede til høyre
  tre = new Firkant (320, 25, 330, 50);
  // nede til venster
  fire = new Firkant (0, 25,330, 50);
  
  firkantArray [0] = en;
  firkantArray [1] = to;
  firkantArray [2] = tre;
  firkantArray [3] = fire;  

  //spacing between zones
  barrier = 0;


  size(WLENGTH, WHEIGHT);
  frameRate(60);


  fill(255,255,100);
  //fontA = loadFont("hn.vlw");
  //smooth();
  //textFont(fontA, 32);
  
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
  context.setMirror(true);
  stroke(255,255,255);
 }


void draw()
{
  context.update();


  background(0,0,0);
  image(context.rgbImage(),0,0);
  drawGrid();
  // flytte deklareringen av disse til setup?
  int[]   depthMap = context.depthMap();
  int     steps   = 3;  // to speed up the drawing, draw every third point
  int     index;
  int realWorldPoint;
  //flytte disse til setup hvis alt er greit.
  int height = context.depthHeight();
  int width = context.depthWidth();
  stroke(255);

  // PVector[] realWorldMap = context.depthMapRealWorld();
  // lengden på realWorldMap er 640x480 (307200)
  for(int y=0;y < height;y+=steps)
  {
    for(int x=0;x < width;x+=steps)
    {
      index = x + y * width;
      if(depthMap[index] > 0)
      { 
//      realWorldPoint = context.depthMapRealWorld()[index];
        realWorldPoint = depthMap[index];
        if (realWorldPoint < 2700 && realWorldPoint > 1300) {
          setSquare(x, y);
        }
      }
    }


  }
  //drawText(wx, wy, wz);  
  frame.setTitle((int)frameRate + " fps");
  drawSquares();
}
// slette serial-lock-fila her?
void exit() {
  println("Hadet bra.");
  super.exit();
}


void setSquare(float x, float y) {
  if (x < width  / 2 - barrier && y < height / 2 - barrier) {
    squareOnOff[0] = true;
  }
  if (x >= width / 2 + barrier && y < height / 2 - barrier) {
    squareOnOff[1] = true;
  }
  if (x >= width / 2 + barrier && y >= height / 2 + barrier) {
    squareOnOff[2] = true;
  }
  if (x < width / 2 - barrier && y >= height / 2 + barrier) {
    squareOnOff[3] = true;
  }
}


void drawSquares() {
  // en funker
  if (squareOnOff[0]) firkantArray[0].opp();
  if (!squareOnOff[0]) firkantArray[0].ned();
  // to funker
  if (squareOnOff[1]) firkantArray[1].opp();
  if (!squareOnOff[1]) firkantArray[1].ned();
  // tre funker
  if (squareOnOff[2]) firkantArray[2].opp();
  if (!squareOnOff[2])firkantArray[2].ned();
  //fire funker
  if (squareOnOff[3]) firkantArray[3].opp();
  if (!squareOnOff[3]) firkantArray[3].ned();
  
  for (int i = 0; i < 4; i++) {
   if (firkantArray[i].oppe) {myPort.write(i);} 
  }
  
  if (squareOnOff[0]) {
    drawSquare(0);
  }
  if (squareOnOff[1]) {
    drawSquare(1);
  }
  if (squareOnOff[2]) {
    drawSquare(2);
  }
  if (squareOnOff[3]) {
    drawSquare(3);
  }
}


void drawSquare(int square) {
  //if (firkantArray[square].oppe) {myPort.write(square);}
  //myPort.write(square);
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
  //rect(x, y, WLENGTH / 2, WHEIGHT / 2);
  fill(255,155,100);
  
  // reset square
  squareOnOff[square] = false;
}


void drawText(float x, float y, float z) {
  text("X-akse: " + x, 25, 410);
  text("Y-akse: " + y, 25, 440);
  text("Z-akse: " + z, 25, 470); 
}


void drawGrid() {
  for(int i = 0; i <= WHEIGHT; i++) {
    if (i % (WHEIGHT / 10) == 0) {
      //line(0, i, WLENGTH, i);
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
      //line(i, 0, i, WHEIGHT);
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

class Firkant {
float a;
int b;
int c;
int d;
int e;
boolean oppe;
boolean nede;
int kurve;
int storrelse;
int x;
int y;
int mellomrom;

Firkant (int posX, int mellom, int posY, int stor) {
  a = 0;
  b = -100;
  c = -100;
  d = -100;
  e = -100;
  oppe = false; 
  kurve = 7;
  storrelse = stor;
  x = posX;
  y = posY;
  mellomrom = mellom;
}

void tegnFirkant() {
  fill(255);
  rect(mellomrom + x, y, storrelse, storrelse,kurve);
  rect(storrelse + x + (mellomrom * 2), y, storrelse, storrelse,kurve);  
  rect((storrelse * 2) + x + (mellomrom * 3), y, storrelse, storrelse,kurve);
  rect((storrelse * 3) + x +(mellomrom * 4), y, storrelse, storrelse,kurve);
  fill(0,255,0);
}

void opp() {
  //background(51);
  tegnFirkant();
  if (a > 50) b = mellomrom + x;
  rect(b, y, storrelse, storrelse,kurve);
  if (a > 100) c = storrelse + x + (mellomrom * 2);
  rect(c, y, storrelse, storrelse,kurve);  
  if (a > 150) d = (storrelse * 2) + x + (mellomrom * 3);
  rect(d, y, storrelse, storrelse,kurve);
  if (a > 200) e = (storrelse * 3) + x + (mellomrom * 4);
  rect(e, y, storrelse, storrelse,kurve);
  fill (255);
  a = a + 1.0; //regulerer hvor fort baren beveger seg, og i hvilken retning
  if (a > 210) a = 215;
  if (oppe == false) oppe = a > 210; //for at baren skal gÃ¥ nedover nÃ¥r den er pÃ¥ toppen
}

void ned() {
  //background(51);
  tegnFirkant();
  if (a < 50) b = -100;
  rect(b,y, storrelse, storrelse,kurve);
  if (a < 100) c = -100;
  rect(c,y, storrelse, storrelse,kurve);  
  if (a < 150) d = -100;
  rect(d,y, storrelse, storrelse,kurve);
  if (a < 200) e = -100;
  rect(e, y, storrelse, storrelse,kurve);
  fill(255);
  a = a - 1.0; //regulerer hvor fort baren beveger seg, og i hvilken retning
  if (a < 0) a = -0.01;
  if (oppe == true) oppe = !(a < 0); //for at baren skal gÃ¥ nedover nÃ¥r den er pÃ¥ toppen
}
}
