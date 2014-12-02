class Particle {
  PVector lastPosition;
  PVector position;

  PVector acceleration; 

  float mass = 1;
  float damping = 20;

  ArrayList links = new ArrayList();

  boolean pinned = false;
  PVector pinLocation = new PVector(0, 0);

  Particle (PVector pos) {
    position = pos.get();
    lastPosition = pos.get();
    acceleration = new PVector(0, 0);
  }

  void updatePhysics (float timeStep) { // timeStep should be in elapsed seconds (deltaTime)
    // gravity:
    // f(gravity) = m * g
    PVector fg = new PVector(0, mass * gravity);
    this.applyForce(fg);

    PVector velocity = PVector.sub(position, lastPosition);
    // apply damping: acceleration -= velocity * (damping/mass)
    acceleration.sub(PVector.mult(velocity, damping/mass)); 
    // newPosition = position + velocity + 0.5 * acceleration * deltaTime * deltaTime
    PVector nextPos = PVector.add(PVector.add(position, velocity), PVector.mult(PVector.mult(acceleration, 0.5), timeStep * timeStep));

    lastPosition.set(position);
    position.set(nextPos);
    acceleration.set(0, 0, 0);
  } 
  void updateInteractions () {
    
    if (mousePressed) {
      float distanceSquared = distPointToSegmentSquared(pmouseX, pmouseY, mouseX, mouseY, position.x, position.y);
      if (mouseButton == LEFT) {
        if (distanceSquared < mouseInfluenceSize) {
          lastPosition = PVector.sub(position, new PVector((mouseX-pmouseX)*mouseInfluenceScalar, (mouseY-pmouseY)*mouseInfluenceScalar));
        }
      } else { 
        if (distanceSquared < mouseTearSize) 
          links.clear();
      }
    }
  }

  void draw () {
    stroke(0);
    if (links.size() > 0) {
      for (int i = 0; i < links.size (); i++) {
        Link currentLink = (Link) links.get(i);
        currentLink.draw();
      }
    } else
      point(position.x, position.y);
  }
  void solveConstraints () {
    for (int i = 0; i < links.size (); i++) {
      Link currentLink = (Link) links.get(i);
      currentLink.constraintSolve();
    }

    if (position.y < 1)
      position.y = 2 * (1) - position.y;
    if (position.y > height-1)
      position.y = 2 * (height - 1) - position.y;
    if (position.x > width-1)
      position.x = 2 * (width - 1) - position.x;
    if (position.x < 1)
      position.x = 2 * (1) - position.x;

    if (pinned)
      position.set(pinLocation);
  }

  void attachTo (Particle P, float restingDist, float stiff) {
    Link lnk = new Link(this, P, restingDist, stiff);
    links.add(lnk);
  }
  void removeLink (Link lnk) {
    links.remove(lnk);
  }  

  void applyForce (PVector f) {
    acceleration.add(PVector.div(f, mass));
  }

  void pinTo (PVector location) {
    pinned = true;
    pinLocation.set(location);
  }
} 

