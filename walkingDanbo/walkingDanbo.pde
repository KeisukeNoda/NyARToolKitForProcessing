import processing.video.*;
import jp.nyatla.nyar4psg.*;

Capture cam;
MultiMarker nya;
PFont font = createFont("FFScala", 32);

int DISPLAY_W = 1280; 
int DISPLAY_H = 720;

final int BACKGROUND_COLOR = 0xFFFFEEBB;
Danbo danbo;                             
float time;                              

void setup() {
  size(DISPLAY_W, DISPLAY_H, P3D);
  frameRate(60);
  smooth();
  
  println(MultiMarker.VERSION);
  cam = new Capture(this, DISPLAY_W, DISPLAY_H);
  nya = new MultiMarker(this, width, height, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  nya.addARMarker(loadImage("markDanbo.png"),16,25,80);  

  cam.start();
  
  noStroke();  
  danbo = new Danbo(); 
}


void draw() {

  if (cam.available() !=true) {
      return;
  }
  cam.read();
  nya.detect(cam);
  background(0);
  nya.drawBackground(cam);

  if(nya.isExistMarker(0)){
    nya.beginTransform(0); 
    
    lights();

    float angle = radians(time += 1.5);
    if(angle >= TWO_PI) angle = time = 0;

    translate(100 * sin(angle + PI), -100 * cos(angle + PI), 0);
    rotateZ(angle - PI/2);
    rotateX(-PI/2);
    scale(0.3); 
    
    danbo.update();
    
    fill(0xFFFFFFFF);
    danbo.render();
    
    nya.endTransform();
  }  
}
