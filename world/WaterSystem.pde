class Waterfall {
  ArrayList<WaterParticle> particles;
  Ray origin;
  float life = 200.0;
  color splColor = color(12,160,240);
  float river_r = 100.0;
  float river_w = 200.0;
  int maxParticles = 10000;
  
  Waterfall(Ray position) {
    origin = position.copy();
    particles = new ArrayList<WaterParticle>();
  }

  void addParticle() {
    if(particles.size() < maxParticles){
      for(int i=0; i<50; i++){
        particles.add(new WaterParticle(new Ray(origin.x,origin.y,origin.z+random(-5,5))));
      }
    }
  }

  void update(){
    print("water particles:"+str(particles.size())+"\n");
    addParticle();
    for(WaterParticle p : particles){
      p.run();
      if (p.life < 0.0) {
        p.respawn(p.origin);
      }
    }
  }
  
  void display(){
    // Draw River.
    pushMatrix();
    translate(0,99,0);
    rotateX(PI/2);
    fill(splColor);
    stroke(splColor,100);
    // Grow the mouth of river (ellipse part)
    if(life < 200.0){
      float temp_r = (life<100.0)? river_r : river_r * (1 - (life-100.0)/100.0);
      ellipse(40, 0, temp_r, 0.7*temp_r);
    }
    // Grow length of the river
    if(life < 100){
      rectMode(CENTER);
      float temp_w = (life<0.0)? river_w : river_w * (1 - (life-0.0)/100.0);
      rect(70+(temp_w * 0.5), 0, temp_w, 30);
    }
    popMatrix();
  }
  
  void run() {
    update();
    display();
    life -= 1.0;
  }
}


// WaterParticle class
class WaterParticle {
  Ray position;
  Ray velocity;
  Ray acceleration;
  Ray origin;
  color splColor = color(12,160,240,100);
  boolean river;
  float life;
  float alpha;

  WaterParticle(Ray l) {
    this.respawn(l);
  }
  
  void respawn(Ray l){
    acceleration = new Ray(0, random(0.25,0.35), 0);
    velocity = new Ray(random(1.5,2), 0.0, random(-0.5, 0.5));
    position = l.copy();
    origin = l.copy();
    life = 100.0;
    alpha = 255.0;
    river = false;
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    life -= 1.0;
    alpha -= 5.0;
    if(position.y > 100.0){
      //print("position x:"+str((int)position.x)+" velocity.y:"+str((int)velocity.y)+"\n");
      position.x = random(35.0,45.0);
      position.y = random(90.0, 100.0);
      velocity.y = -0.35 * velocity.y;
      //print("position x:"+str((int)position.x)+" velocity.y:"+str((int)velocity.y)+"\n");
    }
    if(river ==false && abs(velocity.y) < 0.01){
      river = true;
      position = new Ray(random(40.0,60.0), random(98.0,100.0), random(-15,15));
      acceleration = new Ray(0, 0, 0);
      velocity = new Ray(random(0.25,0.5), 0, random(-0.05, 0.05));
    }
  }

  // Method to display
  void display() {
    if(river){
      color tempColor = color(red(splColor), green(splColor), blue(splColor));
      stroke(tempColor);
      fill(tempColor);
    }else{
      stroke(255.0, alpha);
      fill(255.0, alpha);
    }
    //point(position.x, position.y, position.z);
    float s = 2.0;
    line(position.x, position.y, position.z, position.x+random(-s,s),position.y+random(-s,s), position.z+random(-s,s));
    //pushMatrix();
    //translate(position.x, position.y, position.z);
    //box(0.5 );
    //popMatrix();
  }
}