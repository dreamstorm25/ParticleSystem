PImage texture;

class Waterfall {
  ArrayList<WaterParticle> particles;
  Ray origin;
  float life = 200.0;
  color splColor = color(12,160,240);
  float river_r = 100.0;
  float river_w = 200.0;
  int maxParticles = 10000;
  collisionSphere cs ;
  
  Waterfall(Ray position) {
    origin = position.copy();
    particles = new ArrayList<WaterParticle>();
    texture = loadImage("textures/smoke.png");
    cs = new collisionSphere(100,100,40,20) ;
  }

  void addParticle() {
    if(particles.size() < maxParticles){
      for(int i=0; i<30; i++){
        particles.add(new WaterParticle(new Ray(origin.x,origin.y,origin.z+random(-5,5))));
      }
    }
  }

  void update(){
    checkCollision() ;
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
    cs.drawSelf() ;
    println(str(cs.x) + " " + str(cs.y) + " " + str(cs.z)) ;
    pushMatrix();
    translate(0,99,0);
    rotateX(PI/2);
    fill(splColor);
    stroke(splColor,100);
    // Grow the mouth of river (ellipse part)
    if(life < 200.0){
      float temp_r = 0;//(life<100.0)? river_r : river_r * (1 - (life-100.0)/100.0);
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
  
  void moveSphereForward(){
    //cs.x = mouseX - gx ;
    //cs.z = mouseY - gy ;
    ////cs.z = gz ;
    //println("globe" + str(gx) + " " + str(gy) + " " + str(gz)) ;
    //cs.z = screenZ(mouseX, mouseY) ;
    cs.z += 5 ;
    cs.location = new Ray(cs.x, cs.y, cs.z) ;
  }
  
  void moveSphereBackward(){
    //cs.x = mouseX - gx ;
    //cs.z = mouseY - gy ;
    ////cs.z = gz ;
    //println("globe" + str(gx) + " " + str(gy) + " " + str(gz)) ;
    //cs.z = screenZ(mouseX, mouseY) ;
    cs.z -= 5 ;
    cs.location = new Ray(cs.x, cs.y, cs.z) ;
  }
  
  void checkCollision(){
    for ( WaterParticle p : particles){
      float d = Ray.dist(p.position, cs.location) ;
      if (cs.size > d){
        Ray norm = Ray.sub(p.position, cs.location) ;
        norm = norm.normalize() ;
        Ray bounce = norm.mult(p.velocity.dot(norm));
        p.velocity = p.velocity.sub(bounce.mult(1.1)) ;
      } 
    }
    
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
  float rotation;

  WaterParticle(Ray l) {
    this.respawn(l);
  }
  
  void respawn(Ray l){
    acceleration = new Ray(0, random(0.03,0.05), 0);
    velocity = new Ray(random(0.5,0.7), 0.0, random(-0.2, 0.2));
    position = l.copy();
    origin = l.copy();
    life = 200.0;
    alpha = 255.0;
    river = false;
    rotation = random(0,PI);
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
      position.y = 98.0;
      velocity.y *= -0.35;
    }
    if(river ==false && abs(velocity.y) < 0.1 && position.y > 95.0){
      river = true;
    }
  }
  
  void drawQuad(float x, float y, float z, float size, color color_){
    float theta = atan(velocity.y/velocity.x);
    float x_opp = x + size*cos(theta);//random(0, size);
    float y_opp = y + size*sin(theta); //random(0, size);
    float z_opp = z + size; //random(0, size);
    int imgHeight = texture.height;
    int imgWidth = texture.width;
    //hint(DISABLE_DEPTH_MASK);
    noStroke();
    tint(color_);
    fill(color_);
    beginShape(QUAD_STRIP);
    texture(texture);
    vertex(x,y,z,0,0);
    vertex(x_opp,y_opp,z,0,imgHeight);
    vertex(x,y,z_opp,imgWidth,0);
    vertex(x_opp,y_opp,z_opp,imgWidth,imgHeight);
    endShape();
    //hint(ENABLE_DEPTH_MASK);
  }
  
  // Method to display
  void display() {
    color tempColor;
    if(river){
      tempColor = color(red(splColor), green(splColor), blue(splColor));
    }else{
      tempColor = color(255.0);
    }
    float s = 5.0;
    //line(position.x, position.y, position.z, position.x+random(-s,s),position.y+random(-s,s), position.z+random(-s,s));
    noStroke();
    drawQuad(position.x, position.y, position.z, s, tempColor);
  }
  
}
