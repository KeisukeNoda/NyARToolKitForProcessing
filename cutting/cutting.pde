import processing.video.*;
import jp.nyatla.nyar4psg.*;

Capture cam;
MultiMarker nya1, nya2;

ArrayList particles;

int DISPLAY_W = 1280; 
int DISPLAY_H = 720;

//  cut
float mouseInfluenceSize = 15; 
float mouseTearSize = 8;
float mouseInfluenceScalar = 1;
float gravity = 392; 

final int curtainHeight = 100;
final int curtainWidth = 180;
final int yStart = 25;
final float restingDistances = 5;
final float stiffnesses = 1;
final float curtainTearSensitivity = 50;

long previousTime;
long currentTime;

final int fixedDeltaTime = 15;
float fixedDeltaTimeSeconds = (float)fixedDeltaTime / 1000.0;
int leftOverDeltaTime = 0;
int constraintAccuracy = 3;

PFont font;
final int instructionLength = 3000;
final int instructionFade = 300;

void setup () {
  size(DISPLAY_W, DISPLAY_H, P3D);
  frameRate(60);
  smooth();
  
  println(MultiMarker.VERSION);
  cam = new Capture(this, DISPLAY_W, DISPLAY_H);
  nya1 = new MultiMarker(this, width, height, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  nya1.addARMarker(loadImage("markPUSH.png"),16,25,80);  

  nya2 = new MultiMarker(this, width, height, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  nya2.addARMarker(loadImage("markCUT.png"),16,25,80);  
  
  cam.start();
  
  mouseInfluenceSize *= mouseInfluenceSize; 
  mouseTearSize *= mouseTearSize;
  
  createCurtain();
  
  font = loadFont("LucidaBright-Demi-16.vlw");
  textFont(font);
}

void draw () {
  if (cam.available() !=true) {
      return;
  }
  cam.read();
  nya1.detect(cam);
  nya1.drawBackground(cam);
  nya2.detect(cam);
  nya2.drawBackground(cam);
  fill(255, 255, 255, 150);
  rect(0, 0, DISPLAY_W, DISPLAY_H);
  
  PVector[] pos2d_1 = nya1.getMarkerVertex2D(0);
  PVector[] pos2d_2 = nya2.getMarkerVertex2D(0);
  
  if(nya1.isExistMarker(0)){
     mousePressed = true;
     mouseButton = LEFT;
     pmouseX = (int)pos2d_1[2].x - 20;
     pmouseY = (int)pos2d_1[2].y - 20;
     mouseX  = (int)pos2d_1[0].x + 20;
     mouseY  = (int)pos2d_1[0].y + 20;
  }
  
  if(nya2.isExistMarker(0)){
     mousePressed = true;
     mouseButton = RIGHT;
     pmouseX = (int)pos2d_2[0].x + 20;
     pmouseY = (int)pos2d_2[0].y + 20;
     mouseX  = (int)pos2d_2[2].x - 20;
     mouseY  = (int)pos2d_2[2].y - 20;
  }
  
  currentTime = millis();

  long deltaTimeMS = currentTime - previousTime;
  previousTime = currentTime;
  
  int timeStepAmt = (int)((float)(deltaTimeMS + leftOverDeltaTime) / (float)fixedDeltaTime);

  timeStepAmt = min(timeStepAmt, 5);
  
  leftOverDeltaTime += (int)deltaTimeMS - (timeStepAmt * fixedDeltaTime); 
  mouseInfluenceScalar = 1.0 / timeStepAmt;
  
  for (int iteration = 1; iteration <= timeStepAmt; iteration++) {
    for (int x = 0; x < constraintAccuracy; x++) {
      for (int i = 0; i < particles.size(); i++) {
        Particle particle = (Particle) particles.get(i);
        particle.solveConstraints();
      }
    }
    
    for (int i = 0; i < particles.size(); i++) {
      Particle particle = (Particle) particles.get(i);
      particle.updateInteractions();
      particle.updatePhysics(fixedDeltaTimeSeconds);
    }
  }
  for (int i = 0; i < particles.size(); i++) {
    Particle particle = (Particle) particles.get(i);
    particle.draw();
  }
  
  if (millis() < instructionLength)
    drawInstructions();
 
  if (frameCount % 60 == 0)
    println("Frame rate is " + frameRate);
}
void createCurtain () {
  particles = new ArrayList();
  int midWidth = (int) (width/2 - (curtainWidth * restingDistances)/2);

  for (int y = 0; y <= curtainHeight; y++) {
    for (int x = 0; x <= curtainWidth; x++) { 
      Particle particle = new Particle(new PVector(midWidth + x * restingDistances, y * restingDistances + yStart));
      
      if (x != 0) 
        particle.attachTo((Particle)(particles.get(particles.size()-1)), restingDistances, stiffnesses);
      if (y != 0)
        particle.attachTo((Particle)(particles.get((y - 1) * (curtainWidth+1) + x)), restingDistances, stiffnesses);

      if (y == 0)
        particle.pinTo(particle.position);
        
      particles.add(particle);
    }
  }
}

void keyPressed() {
  if ((key == 'r') || (key == 'R'))
    createCurtain();
  if ((key == 'g') || (key == 'G'))
    toggleGravity();
}
void toggleGravity () {
  if (gravity != 0)
    gravity = 0;
  else
    gravity = 392;
}

void drawInstructions () {
  float fade = 255 - (((float)millis()-(instructionLength - instructionFade)) / instructionFade) * 255;
  stroke(0, fade);
  fill(255, fade);
  rect(0,0, 200,45);
  fill(0, fade);
  text("'r' : reset", 10, 20);
  text("'g' : toggle gravity", 10, 35);
}

float distPointToSegmentSquared (float lineX1, float lineY1, float lineX2, float lineY2, float pointX, float pointY) {
  float vx = lineX1 - pointX;
  float vy = lineY1 - pointY;
  float ux = lineX2 - lineX1;
  float uy = lineY2 - lineY1;
  
  float len = ux*ux + uy*uy;
  float det = (-vx * ux) + (-vy * uy);
  if ((det < 0) || (det > len)) {
    ux = lineX2 - pointX;
    uy = lineY2 - pointY;
    return min(vx*vx+vy*vy, ux*ux+uy*uy);
  }
  
  det = ux*vy - uy*vx;
  return (det*det) / len;
}
