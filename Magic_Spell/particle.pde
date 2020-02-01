class Particle{
  PVector location;
  PVector velocity;
  PVector acceleration;
  color splColor; 
  float lifespan;
  float death;
  float alpha;
  float size = random(1,4);
  
  Particle(PVector l, color splColor){
    restart(l);
    this.splColor = splColor;
  }
  void run(){
    update();
    display();
  }
  void update(){
    velocity.add(acceleration);
    location.add(velocity);
    lifespan-=1.0;
    //if(lifespan % 32 == 0.0)
    //{
    //  acceleration.y = -1 * acceleration.y;
    //  velocity.x = velocity.x + random(-0.5,0.5);
    //  velocity.y = random(0,0);
    //  alpha = random(30,50);
    //}
  }
  void display(){
    stroke(splColor);
    fill(splColor);
    ellipse(location.x,location.y,size,4);
  }
  void restart(PVector l){
    acceleration = new PVector(random(-0.05,0.01),random(-0.05,0.05));
    velocity = new PVector(random(-1.5,-0.5),random(0,0));
    location = l.copy();
    lifespan = 20.0;
    alpha = random(100,150);
    splColor = color(red(splColor),green(splColor),blue(splColor),alpha);
    death = random(-10,10);
  }
  boolean isDead(){
    if(lifespan<death){
      return true;
    }else{
      return false;
    }
  }
}
