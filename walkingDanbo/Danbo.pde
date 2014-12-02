HashMap<String, PImage> imgMap;  
PMatrix3D           iViewMat; 

class Danbo {
  private HashMap<String, Node> bodyMap;  
  private Node              bodyTree; 
  private int               time;
  public Danbo() {
    createBody();
    time = 0;
  }
  

  public void update() {
    float angle = radians(++time * 4);
    if(angle >= TWO_PI) angle = time = 0;
    
    float sinAngle = sin(angle);
    float cosAngle = cos(angle);

    final float BODY_AMPLITUDE = radians(1); 

    Node body = bodyMap.get("BODY");
    body.rot.set(0, 0, BODY_AMPLITUDE * cosAngle);

    final float HEAD_AMPLITUDE_X = radians(5); 
    final float HEAD_AMPLITUDE_Y = radians(2);  

    Node head = bodyMap.get("HEAD");
    head.rot.set(HEAD_AMPLITUDE_X * abs(sinAngle), HEAD_AMPLITUDE_Y * sinAngle, 0);

    final float ARM_AMPLITUDE = radians(40);  
    
    Node leftArm = bodyMap.get("LEFTARM");
    leftArm.rot.set(ARM_AMPLITUDE * sinAngle, 0, 0);
    
    Node rightArm = bodyMap.get("RIGHTARM");
    rightArm.rot.set(-ARM_AMPLITUDE * sinAngle, 0, 0);  
    final float LEG_AMPLITUDE = radians(30);
    
    Node leftLeg = bodyMap.get("LEFTLEG");
    leftLeg.rot.set(-LEG_AMPLITUDE * sinAngle, 0, 0);
    
    Node rightLeg = bodyMap.get("RIGHTLEG");
    rightLeg.rot.set(LEG_AMPLITUDE * sinAngle, 0, 0);
  }
  
  public void render() {
    iViewMat = (PMatrix3D)getMatrix();
    iViewMat.invert();
    
    float shiftY = bodyTree.getGlobalMaxYCoord();
    
    pushMatrix();
    translate(0, -shiftY, 0);
    
    bodyTree.render();
    
    popMatrix();
  }
  
  private void createImageMap() {
    if(imgMap == null) imgMap = new HashMap<String, PImage>();
    
    if(!imgMap.containsKey("NORMAL")) imgMap.put("NORMAL",loadImage("d_normal.jpg"));
    if(!imgMap.containsKey("COIN"))   imgMap.put("COIN",  loadImage("d_coin.jpg"));
    if(!imgMap.containsKey("TAB"))    imgMap.put("TAB",   loadImage("d_tab.jpg"));
    if(!imgMap.containsKey("FACE"))   imgMap.put("FACE",  loadImage("d_face2.jpg"));
  }
  
  private void createBody() {
    if(bodyMap == null) bodyMap = new HashMap<String, Node>();
    else bodyMap.clear();
    
    createImageMap();
  
    final float MARGIN = 20;
  
    final float BODY_WIDTH  = 130;
    final float BODY_HEIGHT = 155;
    final float BODY_DEPTH  = 130;
    
    // 幾何情報の設定
    Node body = new Node();
    body.size.set(BODY_WIDTH, BODY_HEIGHT, BODY_DEPTH);
    
    // テクスチャの設定
    body.applyTexture("DEFAULT", imgMap.get("NORMAL"));
    body.applyTexture("FRONT",   imgMap.get("COIN"));
    
    final float HEAD_WIDTH  = 275;
    final float HEAD_HEIGHT = 180;
    final float HEAD_DEPTH  = 180;
    
    Node head = new Node();
    head.pos.set (0,          -.5 * (BODY_HEIGHT + HEAD_HEIGHT), 0         );
    head.org.set (0,           .5 * HEAD_HEIGHT,                 0         );
    head.size.set(HEAD_WIDTH,  HEAD_HEIGHT,                      HEAD_DEPTH);
    
    head.applyTexture("TOP",     imgMap.get("TAB"));
    head.applyTexture("FRONT",   imgMap.get("FACE"));
    head.applyTexture("DEFAULT", imgMap.get("NORMAL"));
    
    final float ARM_WIDTH  =  45;
    final float ARM_HEIGHT = 180;
    final float ARM_DEPTH  =  50;
    
    Node leftArm = new Node();
    leftArm.pos.set(-.5 * (BODY_WIDTH + ARM_WIDTH + MARGIN),    // x
                    -.5 * (BODY_HEIGHT - ARM_HEIGHT) + MARGIN,  // y
                      0);                                       // z

    leftArm.org.set (0,         -.5 * ARM_HEIGHT, 0        );
    leftArm.size.set(ARM_WIDTH,   ARM_HEIGHT,     ARM_DEPTH);

    leftArm.applyTexture("DEFAULT", imgMap.get("NORMAL"));


    Node rightArm = new Node();
    rightArm.pos.set( .5 * (BODY_WIDTH + ARM_WIDTH + MARGIN),    // x
                     -.5 * (BODY_HEIGHT - ARM_HEIGHT) + MARGIN,  // y
                       0);                                       // z

    rightArm.org.set (0,         -.5 * ARM_HEIGHT, 0        );
    rightArm.size.set(ARM_WIDTH,  ARM_HEIGHT,      ARM_DEPTH);

    rightArm.applyTexture("DEFAULT", imgMap.get("NORMAL"));
    
    final float LEG_HEIGHT = 130;
    final float LEG_WIDTH  =  50;
    final float LEG_DEPTH  = 100;
    
    Node leftLeg = new Node();
    leftLeg.pos.set(-.5 * (LEG_WIDTH + MARGIN),        // x
                     .5 * (BODY_HEIGHT + LEG_HEIGHT),  // y
                     0);                               // z
                     
    leftLeg.org.set (0,         -.5 * LEG_HEIGHT, 0        );
    leftLeg.size.set(LEG_WIDTH,   LEG_HEIGHT,     LEG_DEPTH);
    
    leftLeg.applyTexture("DEFAULT", imgMap.get("NORMAL"));
  
  
    Node rightLeg = new Node();
    rightLeg.pos.set(.5 * (LEG_WIDTH + MARGIN),        // x
                     .5 * (BODY_HEIGHT + LEG_HEIGHT),  // y
                      0);                              // z
                     
    rightLeg.org.set (0,         -.5 * LEG_HEIGHT, 0        );
    rightLeg.size.set(LEG_WIDTH,   LEG_HEIGHT,     LEG_DEPTH);
    
    rightLeg.applyTexture("DEFAULT", imgMap.get("NORMAL"));

    final float SKIRT_HEIGHT = .4 * BODY_DEPTH;
    final float SKIRT_ANGLE1 =  radians(30);
    final float SKIRT_ANGLE2 =  radians(20);
    
    Node backSkirt = new Node();
    
    backSkirt.pos.set( 0,                                 // x
                      .5 * (BODY_HEIGHT + SKIRT_HEIGHT),  // y
                      .5 * BODY_DEPTH);                   // z
                      
    backSkirt.org.set (0,            -.5 * SKIRT_HEIGHT, 0);
    backSkirt.rot.set (SKIRT_ANGLE1,  0,                 0);
    backSkirt.size.set(BODY_WIDTH,    SKIRT_HEIGHT,      1);
    
    backSkirt.applyTexture("DEFAULT", imgMap.get("NORMAL"));
    
    
    Node frontSkirt = new Node();

    frontSkirt.pos.set(  0,                                 // x
                        .5 * (BODY_HEIGHT + SKIRT_HEIGHT),  // y
                       -.5 * BODY_DEPTH);                   // z
                       
    frontSkirt.org.set ( 0,            -.5 * SKIRT_HEIGHT, 0);
    frontSkirt.rot.set (-SKIRT_ANGLE1,  0,                 0);
    frontSkirt.size.set( BODY_WIDTH,    SKIRT_HEIGHT,      1);
    
    frontSkirt.applyTexture("DEFAULT", imgMap.get("NORMAL"));
  
  
    Node leftSkirt = new Node();
    
    leftSkirt.pos.set(-.5 * BODY_WIDTH,                    // x
                       .5 * (BODY_HEIGHT + SKIRT_HEIGHT),  // y
                        0);                                // z
    
    leftSkirt.org.set (0, -.5 * SKIRT_HEIGHT, 0           );
    leftSkirt.rot.set (0,   0,                SKIRT_ANGLE2);
    leftSkirt.size.set(1,   SKIRT_HEIGHT,     BODY_DEPTH  );
    
    leftSkirt.applyTexture("DEFAULT", imgMap.get("NORMAL"));
  
  
    Node rightSkirt = new Node();
    
    rightSkirt.pos.set(.5 * BODY_WIDTH,                    // x
                       .5 * (BODY_HEIGHT + SKIRT_HEIGHT),  // y
                        0);                                // z
                       
    rightSkirt.org.set (0, -.5 * SKIRT_HEIGHT,  0           );
    rightSkirt.rot.set (0,   0,                -SKIRT_ANGLE2);
    rightSkirt.size.set(1,   SKIRT_HEIGHT,      BODY_DEPTH  );
    
    rightSkirt.applyTexture("DEFAULT", imgMap.get("NORMAL"));
    
    bodyMap.put("HEAD",     head);
    bodyMap.put("BODY",     body);
    bodyMap.put("LEFTARM",  leftArm);
    bodyMap.put("RIGHTARM", rightArm);
    bodyMap.put("LEFTLEG",  leftLeg);
    bodyMap.put("RIGHTLEG", rightLeg);
    
    body.addChild(leftLeg);
    body.addChild(rightLeg);
    body.addChild(head);
    body.addChild(leftArm);
    body.addChild(rightArm);
    bodyTree = body;
  
    body.addChild(backSkirt);
    body.addChild(frontSkirt);
    body.addChild(leftSkirt);
    body.addChild(rightSkirt);
  }
}

