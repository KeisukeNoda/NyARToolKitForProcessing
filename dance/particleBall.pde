class particleBall
{
  particle[] Particles = new particle[NUM_PARTICLES];
  
  particleBall()
  {
    for(int i = 0; i < NUM_PARTICLES; i++)
    {
      float theta = random(0,TWO_PI);
      float u = random(-1,1);
      Particles[i] = new particle(theta,u); 
    }
  }
  
  void update()
  {
    for(int i = 0; i < NUM_PARTICLES; i++)
    {
      Particles[i].update(); 
    }
  }
  
  void render()
  {
    fill(0,0,0,220);
    translate(0,0,100);
    sphereDetail(40);
    sphere(radius - 20);
    sphereDetail(5);
    fill(BALL_COLOR,100);
    for(int i = 0; i < NUM_PARTICLES; i++)
    {
      Particles[i].render(); 
    }
  }
}
