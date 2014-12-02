import processing.video.*;
import jp.nyatla.nyar4psg.*;

Capture cam;
MultiMarker nya1;
MultiMarker nya2;
MultiMarker nya3;
MultiMarker nya4;
MultiMarker nya5;
PFont font=createFont("FFScala", 32);
int DISPLAY_W = 1280; 
int DISPLAY_H = 720;

int NUM_PARTICLES = 3000;
particleBall ParticleBall;
float startingRadius = 80, radius = 80;
int centerX, centerY;
boolean mouseDown = false;
float time;
color BALL_COLOR;

void setup()
{
  size(DISPLAY_W, DISPLAY_H, P3D);
  frameRate(60);
  smooth();
  println(MultiMarker.VERSION);
  cam = new Capture(this, DISPLAY_W, DISPLAY_H);
  nya1 = new MultiMarker(this, width, height, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  nya1.addARMarker(loadImage("mark1.png"),16,25,80);  
  nya2 = new MultiMarker(this, width, height, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  nya2.addARMarker(loadImage("mark2.png"),16,25,80);  
  nya3 = new MultiMarker(this, width, height, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  nya3.addARMarker(loadImage("mark3.png"),16,25,80);  
  nya4 = new MultiMarker(this, width, height, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  nya4.addARMarker(loadImage("mark4.png"),16,25,80);
  nya5 = new MultiMarker(this, width, height, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  nya5.addARMarker(loadImage("mark5.png"),16,25,80);  
  cam.start();
  
  ParticleBall  = new particleBall();
  noStroke();
  sphereDetail(8);
}

void draw()
{
  if (cam.available() !=true) {
      return;
  }
  cam.read();
  nya1.detect(cam);
  nya2.detect(cam);
  nya3.detect(cam);
  nya4.detect(cam);
  nya5.detect(cam);
  background(0);
  nya1.drawBackground(cam);
  nya2.drawBackground(cam);
  nya3.drawBackground(cam);
  nya4.drawBackground(cam);  
  nya5.drawBackground(cam);
  
  
  if(nya1.isExistMarker(0)){
    nya1.beginTransform(0);

    BALL_COLOR = color(255,127,127);
    float angle = radians(time += .5);
    if(angle >= TWO_PI) angle = time = 0;
    rotateZ(2 * angle);
    rotateZ(4 * angle);

    if(mouseDown)
    {
      radius = startingRadius + centerX-mouseX;
    }
    pushMatrix();
      rotateY(map(mouseX,0,width,0,TWO_PI));
      rotateX(map(mouseY,0,height,0,TWO_PI));
      ParticleBall.update();
      ParticleBall.render();
    popMatrix();
  
  nya1.endTransform();
  }
  
  if(nya2.isExistMarker(0)){
    nya2.beginTransform(0);

    BALL_COLOR = color(255,127,255);
    float angle = radians(time += .5);
    if(angle >= TWO_PI) angle = time = 0;
    rotateZ(4 * angle);
    rotateZ(2 * angle);
    if(mouseDown)
    {
      radius = startingRadius + centerX-mouseX;
    }
    pushMatrix();
      rotateY(map(mouseX,0,width,0,TWO_PI));
      rotateX(map(mouseY,0,height,0,TWO_PI));
      ParticleBall.update();
      ParticleBall.render();
    popMatrix();
  
  nya2.endTransform();
  }
  
  if(nya3.isExistMarker(0)){
    nya3.beginTransform(0);

    BALL_COLOR = color(127,255,255);
    float angle = radians(time += .5);
    if(angle >= TWO_PI) angle = time = 0;
    rotateZ(4 * angle);
    rotateZ(2 * angle);
    if(mouseDown)
    {
      radius = startingRadius + centerX-mouseX;
    }
    pushMatrix();
      rotateY(map(mouseX,0,width,0,TWO_PI));
      rotateX(map(mouseY,0,height,0,TWO_PI));
      ParticleBall.update();
      ParticleBall.render();
    popMatrix();
  
  nya3.endTransform();
  }
  
  if(nya4.isExistMarker(0)){
    nya4.beginTransform(0);

    BALL_COLOR = color(127,255,127);
    float angle = radians(time += .5);
    if(angle >= TWO_PI) angle = time = 0;
    rotateZ(4 * angle);
    rotateZ(2 * angle);
    if(mouseDown)
    {
      radius = startingRadius + centerX-mouseX;
    }
    pushMatrix();
      rotateY(map(mouseX,0,width,0,TWO_PI));
      rotateX(map(mouseY,0,height,0,TWO_PI));
      ParticleBall.update();
      ParticleBall.render();
    popMatrix();
  
  nya4.endTransform();
  }
  
  if(nya5.isExistMarker(0)){
    nya5.beginTransform(0);

    BALL_COLOR = color(255,255,127);
    float angle = radians(time += .5);
    if(angle >= TWO_PI) angle = time = 0;
    rotateZ(4 * angle);
    rotateZ(2 * angle);
    if(mouseDown)
    {
      radius = startingRadius + centerX-mouseX;
    }
    pushMatrix();
      rotateY(map(mouseX,0,width,0,TWO_PI));
      rotateX(map(mouseY,0,height,0,TWO_PI));
      ParticleBall.update();
      ParticleBall.render();
    popMatrix();
  
  nya5.endTransform();
  }
}

void mousePressed()
{
  mouseDown = true;
  centerX = mouseX;
  centerY = mouseY;
}

void mouseReleased()
{
  mouseDown = false;
}
