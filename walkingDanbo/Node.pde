class Node {
  public PVector pos;  
  public PVector org;  
  public PVector size; 
  public PVector rot; 
  
  private ArrayList<Node>          child;   
  private HashMap<String, PImage> texMap;    
  private PVector[]           localCoords; 
  private PVector[]           globalCoords;
  private final int NUM_VERTICES   = 8;
  private final int NUM_PARTITIONS = 5; 
  
  public Node() {
    pos          = new PVector(0, 0, 0);
    org          = new PVector(0, 0, 0);
    size         = new PVector(1, 1, 1);
    rot          = new PVector(0, 0, 0);
    
    child        = new ArrayList<Node>();
    texMap       = new HashMap<String, PImage>();
    
    localCoords  = new PVector[NUM_VERTICES];
    globalCoords = new PVector[NUM_VERTICES];
    
    for(int i = 0; i < NUM_VERTICES; ++i) {
      localCoords [i] = new PVector();
      globalCoords[i] = new PVector();
    }
  }
  
  public void addChild(Node child) {
    this.child.add(child);
  }
  
  public void applyTexture(String name, PImage tex) {
    this.texMap.put(name, tex);
  }

  public float getGlobalMaxYCoord() {
    return getGlobalMaxYCoord(Float.MIN_VALUE);
  }
  private float getGlobalMaxYCoord(float maxY) {
    float ret = maxY;
    
    localCoords[0].set(-.5*size.x, -.5*size.y, -.5*size.z);
    localCoords[1].set(-.5*size.x, -.5*size.y,  .5*size.z);
    localCoords[2].set( .5*size.x, -.5*size.y,  .5*size.z);
    localCoords[3].set( .5*size.x, -.5*size.y, -.5*size.z);
    localCoords[4].set(-.5*size.x,  .5*size.y, -.5*size.z);
    localCoords[5].set(-.5*size.x,  .5*size.y,  .5*size.z);
    localCoords[6].set( .5*size.x,  .5*size.y,  .5*size.z);
    localCoords[7].set( .5*size.x,  .5*size.y, -.5*size.z);    

    pushMatrix();
    
    translate(pos.x, pos.y, pos.z);
    
    translate(org.x, org.y, org.z);
    rotateY(rot.y); rotateX(rot.x); rotateZ(rot.z);
    translate(-org.x, -org.y, -org.z);
    
    PMatrix3D worldMat = (PMatrix3D)getMatrix();
    worldMat.preApply(iViewMat);
    
    for(int i = 0; i < NUM_VERTICES; i++)
      worldMat.mult(localCoords[i], globalCoords[i]);

    float tmp = globalCoords[0].y;
    if(ret < tmp) ret = tmp;     
    for(Node n : child) {
      tmp = n.getGlobalMaxYCoord(ret);
      if (ret < tmp) ret = tmp;
    }

    popMatrix();
    return ret;
  }

  void render() {
    pushMatrix();

    translate(pos.x, pos.y, pos.z);

    translate(org.x, org.y, org.z);
    rotateY(rot.y); rotateX(rot.x); rotateZ(rot.z);
    translate(-org.x, -org.y, -org.z);
    
    float dx = size.x / NUM_PARTITIONS;
    float dz = size.z / NUM_PARTITIONS;
    
    PImage tex = texMap.get("FRONT");
    if(tex == null) tex = texMap.get("DEFAULT");
    
    beginShape(QUAD_STRIP);
    if(tex != null) {
      float texdx = (float)(tex.width-1) / NUM_PARTITIONS;
      texture(tex);
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(.5 * size.x - i * dx, -.5 * size.y, -.5 * size.z, texdx * i, 0);
        vertex(.5 * size.x - i * dx,  .5 * size.y, -.5 * size.z, texdx * i, tex.height-1);
      }
    } else {
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(.5 * size.x - i * dx, -.5 * size.y, -.5 * size.z);
        vertex(.5 * size.x - i * dx,  .5 * size.y, -.5 * size.z);
      }
    }
    endShape();
    
    tex= texMap.get("BACK");
    if(tex == null) tex = texMap.get("DEFAULT");
    
    beginShape(QUAD_STRIP);
    if(tex != null) {
      float texdx = (float)(tex.width-1) / NUM_PARTITIONS;
      texture(tex);
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(-.5 * size.x + i * dx, -.5 * size.y, .5 * size.z, texdx * i, 0);
        vertex(-.5 * size.x + i * dx,  .5 * size.y, .5 * size.z, texdx * i, tex.height-1);
      }
    } else {
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(-.5 * size.x + i * dx, -.5 * size.y, .5 * size.z);
        vertex(-.5 * size.x + i * dx,  .5 * size.y, .5 * size.z);
      }
    }
    endShape();

    tex= texMap.get("TOP");
    if(tex == null) tex = texMap.get("DEFAULT");
    
    beginShape(QUAD_STRIP);
    if(tex != null) {
      float texdx = (float)(tex.width-1) / NUM_PARTITIONS;
      texture(tex);
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(.5 * size.x - i * dx, -.5 * size.y,  .5 * size.z, texdx * i, 0);
        vertex(.5 * size.x - i * dx, -.5 * size.y, -.5 * size.z, texdx * i, tex.height-1);
      }
    } else {
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(.5 * size.x - i * dx, -.5 * size.y,  .5 * size.z);
        vertex(.5 * size.x - i * dx,  .5 * size.y, -.5 * size.z);
      }
    }
    endShape();

    tex= texMap.get("BOTTOM");
    if(tex == null) tex = texMap.get("DEFAULT");
    
    beginShape(QUAD_STRIP);
    if(tex != null) {
      float texdx = (float)(tex.width-1) / NUM_PARTITIONS;
      texture(tex);
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(.5 * size.x - i * dx, .5 * size.y,  .5 * size.z, texdx * i, 0);
        vertex(.5 * size.x - i * dx, .5 * size.y, -.5 * size.z, texdx * i, tex.height-1);
      }
    } else {
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(.5 * size.x - i * dx, .5 * size.y,  .5 * size.z);
        vertex(.5 * size.x - i * dx, .5 * size.y, -.5 * size.z);
      }
    }
    endShape();
    
    tex= texMap.get("LEFT");
    if(tex == null) tex = texMap.get("DEFAULT");
    
    beginShape(QUAD_STRIP);
    if(tex != null) {
      float texdx = (float)(tex.width-1) / NUM_PARTITIONS;
      texture(tex);
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(-.5 * size.x, -.5 * size.y, -.5 * size.z + i * dz, texdx * i, 0);
        vertex(-.5 * size.x,  .5 * size.y, -.5 * size.z + i * dz, texdx * i, tex.height-1);
      }
    } else {
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(-.5 * size.x, -.5 * size.y, -.5 * size.z + i * dz);
        vertex(-.5 * size.x,  .5 * size.y, -.5 * size.z + i * dz);
      }
    }
    endShape();

    tex= texMap.get("RIGHT");
    if(tex == null) tex = texMap.get("DEFAULT");
    
    beginShape(QUAD_STRIP);
    if(tex != null) {
      float texdx = (float)(tex.width-1) / NUM_PARTITIONS;
      texture(tex);
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(.5 * size.x, -.5 * size.y, .5 * size.z - i * dz, texdx * i, 0);
        vertex(.5 * size.x,  .5 * size.y, .5 * size.z - i * dz, texdx * i, tex.height-1);
      }
    } else {
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(.5 * size.x, -.5 * size.y, .5 * size.z - i * dz);
        vertex(.5 * size.x,  .5 * size.y, .5 * size.z - i * dz);
      }
    }
    endShape();
    
    for(Node n : child) {
      n.render();
    }
    popMatrix();
  }
}

