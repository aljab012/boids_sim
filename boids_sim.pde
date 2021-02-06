// CSCI 5611 Project 1: Procedural Animation – Particles & Flocking

static int numBoids = 100;

Boid arr[] ;

float maxSpeed = 30;
float targetSpeed = 20;
float maxForce = 6;
float radius = 10;
int size = 100;
Vec2 obsPos;
float obsRadius = 50; 
boolean up=false,down=false,left=false,right=false;

PImage staticImg;
PImage shark;

void setup(){
  size(900,800);
  surface.setTitle("CSCI 5611 Project 1");
   staticImg = loadImage("fish.png");
   shark = loadImage("shark-icon.png");
  frameRate(30);
  arr= new Boid[numBoids];
  for (int i = 0; i < numBoids; i++){
    arr[i] = new Boid();
    arr[i].pos = new Vec2(200+random(300),200+random(200));
    arr[i].vel = new Vec2(-1+random(2),-1+random(2));
    arr[i].vel.normalize();
    arr[i].vel.mul(maxSpeed);
  }
  obsPos = new Vec2(width/2,height/2);
  
  strokeWeight(2);
}

Vec2 obstacleVel = new Vec2(0,0);


void draw(){
  if (up) {
     obsPos.y-= 3;
  }
  if (down) {
    obsPos.y+= 3;
  }
  if (left) {
    obsPos.x-= 3;
  }
  if (right) {
    obsPos.x+= 3;
  }
  
  background(0,191,255);
  fill(255,0,0);
  image(shark,obsPos.x-obsRadius,obsPos.y-obsRadius, obsRadius*2, obsRadius*2);
  stroke(255);
  strokeWeight(1);
  for (int i = 0; i < numBoids; i++){
    arr[i].draw();
  }
  float dt = .1;
  
  for (int i = 0; i < numBoids; i++){
    arr[i].acc = new Vec2(0,0);
      
    //Seperation force
    for  (int j = 0; j < numBoids; j++){ //Go through neighbors
      float dist = arr[i].pos.minus(arr[j].pos).length();
      if (dist < .01 || dist > 50) continue;
      Vec2 seperationForce =  arr[i].pos.minus(arr[j].pos).normalized();
      seperationForce.setToLength(200.0/pow(dist,2));
      arr[i].acc = arr[i].acc.plus(seperationForce);
    }
            
    //Atttraction force (move towards the average position of our neighbors)
    Vec2 avgPos = new Vec2(0,0);
    int count = 0;
    for  (int j = 0; j <  numBoids; j++){ //Go through neighbors
      float dist = arr[i].pos.minus(arr[j].pos).length();
      if (dist < 60 && dist > 0){
        avgPos.add(arr[j].pos);
        count += 1;
      }
    }
    avgPos.mul(1.0/count);
    if (count >= 1){
      Vec2 attractionForce = avgPos.minus(arr[i].pos);
      attractionForce.normalize();
      attractionForce.times(4);
      attractionForce.clampToLength(maxForce);
      arr[i].acc = arr[i].acc.plus(attractionForce);
    }
      
    //Alignment force
    Vec2 avgVel = new Vec2(0,0);
    count = 0;
    for  (int j = 0; j <  numBoids; j++){ //Go through neighbors
      float dist = arr[i].pos.minus(arr[j].pos).length();
      if (dist < 40 && dist > 0){
        avgVel.add(arr[j].vel);
        count += 1;
      }
    }
    avgVel.mul(1.0/count);
    if (count >= 1){
      Vec2 towards = avgVel.minus(arr[i].vel);
      towards.normalize();
      arr[i].acc = arr[i].acc.plus(towards.times(2));
    }
    
    //Goal Speed
    Vec2 targetVel = arr[i].vel;
    targetVel.setToLength(targetSpeed);
    Vec2 goalSpeedForce = targetVel.minus(arr[i].vel);
    goalSpeedForce.times(1);
    goalSpeedForce.clampToLength(maxForce);
    arr[i].acc = arr[i].acc.plus(goalSpeedForce);    
    
    //Wander force
    Vec2 randVec = new Vec2(1-random(2),1-random(2));
    arr[i].acc = arr[i].acc.plus(randVec.times(10.0)); 
  }
  
  for (int i = 0; i < numBoids; i++){
      
    //Update Position & Velocity
    arr[i].pos = arr[i].pos.plus(arr[i].vel.times(dt));
    arr[i].vel = arr[i].vel.plus(arr[i].acc.times(dt));

    //Max speed
    if (arr[i].vel.length() > maxSpeed){
      arr[i].vel = arr[i].vel.normalized().times(maxSpeed);
    }
    
    // Loop the world if agents fall off the edge.
    if (arr[i].pos.x < 0) arr[i].pos.x += width;
    if (arr[i].pos.x > width) arr[i].pos.x -= width;
    if (arr[i].pos.y < 0) arr[i].pos.y += height;
    if (arr[i].pos.y > height) arr[i].pos.y -= height;
  }
    for (int i = 0; i < numBoids; i++){
      if (arr[i].pos.distanceTo(obsPos) < (obsRadius+radius)){
        Vec2 normal = (arr[i].pos.minus(obsPos)).normalized();
        arr[i].pos = obsPos.plus(normal.times(obsRadius+radius).times(1.01));
        Vec2 velNormal = normal.times(arr[i].vel.x*normal.x+arr[i].vel.y*normal.y);
        arr[i].vel.subtract(velNormal.times(1 ));
      }
    }
}

void mousePressed(){
  if(numBoids == size){
    size = numBoids*2;
    Boid newArray[] = new Boid[size];
    System.arraycopy(arr, 0, newArray, 0, numBoids);
    arr = newArray;
  }
  arr[numBoids] = new Boid();
  arr[numBoids].pos = new Vec2(mouseX,mouseY);
  arr[numBoids].vel = new Vec2(-1+random(2),-1+random(2));
  arr[numBoids].vel.normalize();
  arr[numBoids].vel.mul(targetSpeed);
  numBoids++;
}
void keyPressed() {
  if (keyCode == UP) {
    up = true;
  }
  else if (keyCode == DOWN) {
    down=true;
  }
  else if (keyCode == LEFT) {
    left=true;
  }
  else if (keyCode == RIGHT) {
    right=true;
  }
}
 void keyReleased(){
  if (keyCode == UP) {
    up =false;
  }
  else if (keyCode == DOWN) {
    down =false;
  }
  else if (keyCode == LEFT) {
    left = false;
  }
  else if (keyCode == RIGHT) {
    right =false;
  }
 }

public class Boid{
    Vec2 pos;
    Vec2 vel;
    Vec2 acc;
    Boid(Vec2 pos, Vec2 vel, Vec2 acc){
        this.pos = pos;
        this.vel = vel;
        this.acc = acc;
    }
    Boid(){
    this.pos = new Vec2(0.0,0.0);
    this.vel = new Vec2(0.0,0.0);
    this.acc = new Vec2(0.0,0.0);
    }
    void setPos(float x, float y){
      pos.x = x;
      pos.y = y;
    }
    void setVel(float x, float y){
      vel.x = x;
      vel.y =y;
    }
     void setAcc(float x, float y){
      acc.x = x;
      acc.y =y;
    }
    void draw(){
      pushMatrix();
      translate(pos.x, pos.y);
      rotate(vel.heading());
      image(staticImg,0,0,10,10);
      popMatrix();
      stroke(255,255,255);

    }
}
