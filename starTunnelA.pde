public class ScottStarTunnel implements Animation {
  ParticleSystem ps;
  
  TunnelDisplay mDisplay;
  float startXMin = -10;
  float startXMax = 10;
  PVector starsPos;
  float starsXRot;
  int lastMillis;
  String mName;
  
  //constructor
  ScottStarTunnel(String name, 
              AnimationResources resources,
              TunnelDisplay display,
              TunnelSense sense) {
    ps = new ParticleSystem();
    ps.fillVolume(startXMin, startXMax, 0);
    
    // camera
    starsPos = new PVector();
    starsXRot = 0;
    lastMillis = millis();
    mDisplay = display;
    mName = name;
  }
  
  public String getName() {
    return mName;
  }
  
  public void start() {
    background(0);
    //ortho(0, width, 0, height);
  }
  
  public void stop() {
    // do nothing
  }
  
  void update() 
  {
    int currentMillis = millis();
    float deltaTime = float(currentMillis - lastMillis) / 1000.0;
    float currentTime = float(currentMillis) / 1000.0;
    lastMillis = currentMillis;
    
    background(0);
    float speed = 10 * pow(.6 + .4 * sin(currentTime/10.0 * (2*PI)), 2);
    float camOffset = speed * deltaTime;
    ps.fillVolume(startXMin - (starsPos.x + camOffset), startXMin - starsPos.x, currentTime);
    ps.cullVolume(startXMax - starsPos.x, 10000);
    starsPos.add(camOffset, 0, 0);
    PVector target = new PVector(-starsPos.x, -starsPos.y, -starsPos.z);
    
    float rotSpeed = .4 * (2 * PI) * cos(currentTime/13.0 * (2*PI));
    starsXRot += rotSpeed * deltaTime;
    // print ("starsXRot: " + starsXRot + "\n");
    
    PMatrix3D mx = new PMatrix3D();
    mx.rotateX(starsXRot);
    mx.translate(starsPos.x, starsPos.y, starsPos.z); //order?
    // mx.print();
   
    
    ps.update(deltaTime, mx, target);
    // testLine();
    mDisplay.sendImage();
  }
  
  void testMatrix()
  {
      // PMatrix3D mx = new PMatrix3D();
    // pushMatrix();
    // translate (1,2,3);
    // popMatrix();
    // g.getMatrix(mx);
  
    PMatrix3D mx = new PMatrix3D();
    mx.rotateX(PI/2);
    PVector p = new PVector(0,1,0);
    PVector pW = new PVector();
    mx.mult(p, pW);
    // print("Vector " + pW + "\n");
  }
  
  void testLine()
  {
      // stroke(255.0, 255.0, 255.0, 255.0);
      noFill();
      beginShape(LINES);
      // fill(1.0, 1.0, 1.0);
      stroke(255,0,0,255);
      vertex(0,0,-.5);
      stroke(0,0,0,255);
      vertex(width,height,-.5);
      
      stroke(0,255,0,255);
      vertex(0,height,-.5);
      stroke(0,0,0,255);
      vertex(width,0,-.5);
  
  //    stroke(255,255,255,255);
  //    vertex(0,55,-.5);
  //    //stroke(1,1,1,0);
  //    stroke(0,0,0,0);
  //    vertex(100,55,-.5);
  
      endShape();
  
  }
  
  // A simple Particle class
  
  class Particle {
    // PVector lastPosition;
    PVector position;
    PVector cavePos;
    PVector [] lastCavePos;
    PVector velocity;
    PVector acceleration;
    PVector rgbBase;
    int lastCount;
    // float hue;
    // PVector rgb;
    float lifespan;
  
    Particle(PVector l) 
    {
      // acceleration = new PVector(0,0.05);
      // velocity = new PVector(0, 0, 0);
      // acceleration = new PVector();
      velocity = PVector.random3D();
      velocity.mult(1.5 * pow(random(0, 1.0), 1));
      position = l.get();
      cavePos = new PVector();
  
      lastCount = int(2.0 + 10.0 * pow(random(1.0), 8));
      lastCavePos = new PVector[lastCount];
      for (int i = lastCount - 1; i >= 0; i--) {
        lastCavePos[i] = cavePos;
      }
      rgbBase = new PVector(.6, 1.0, .4);
      // rgb = new PVector();
      lifespan = 255.0;
    }
    
    void setHue(float hue)
    {
      rgbBase.set(HSVtoRGB(hue, .7, 1.0));
    }
    
    PVector HSVtoRGB(float h, float s, float v)
    {
      int i;
      float f, p, q, t;
      PVector rgb = new PVector();
      if( s == 0 ) {
        // achromatic (grey)
        rgb.set(v, v, v);
        return rgb;
      }
      h = h - floor(h);
      h *= 5.0;      // sector 0 to 5
      i = floor( h );
      f = h - i;      // factorial part of h
      p = v * ( 1.0 - s );
      q = v * ( 1.0 - s * f );
      t = v * ( 1.0 - s * ( 1.0 - f ) );
      switch( i ) {
        case 0:
          rgb.x = v;
          rgb.y = t;
          rgb.z = p;
          break;
        case 1:
          rgb.x = q;
          rgb.y = v;
          rgb.z = p;
          break;
        case 2:
          rgb.x = p;
          rgb.y = v;
          rgb.z = t;
          break;
        case 3:
          rgb.x = p;
          rgb.y = q;
          rgb.z = v;
          break;
        case 4:
          rgb.x = t;
          rgb.y = p;
          rgb.z = v;
          break;
        default:    // case 5:
          rgb.x = v;
          rgb.y = p;
          rgb.z = q;
          break;
      }
      return rgb;
    }
  
  //  void run(float deltaTime) {
  //    update(deltaTime);
  //    display();
  //  }
  
    // Method to update location
    void update(float deltaTime, PVector target) 
    {
      // velocity.add(acceleration);
      // PVector vAdd = new PVector();
      float speed = velocity.mag();
      
      // add a random directional push
      PVector push = PVector.random3D();
      push.mult(10.0 * speed * deltaTime);
      velocity.add(push);
  
  //    acceleration.add(push);
  //    float accelMag = acceleration.mag();
  //    float maxAccel = 100000.0;
  //    if (accelMag > maxAccel) {
  //      acceleration.normalize();
  //      acceleration.mult(maxAccel);
  //    }
  //    velocity.add(acceleration);
      
      // push towards the target
      PVector targetPush = target.get();
      targetPush.sub(position);
      targetPush.normalize();
      targetPush.mult(3 * speed * deltaTime);
      velocity.add(targetPush);
      
      // preserve the speed
      velocity.normalize();
      velocity.mult(speed);
      
      position.add(PVector.mult(velocity, deltaTime));
      lifespan -= deltaTime;
    }
  
  //  // Method to display
  //  void display() {
  //    stroke(255, lifespan);
  //    fill(255, lifespan);
  //    
  //    // float v1[] = new float(VERTEX_FIELD_COUNT);
  //    // float v2[] = new float(VERTEX_FIELD_COUNT);
  //    beginShape(LINES);
  //    fill(255);
  //    vertex(0,0,0);
  //    fill(0);
  //    vertex(1,0,0);
  //    endShape();
  //    // ellipse(location.x,location.y,8,8);
  //  }
    
    void display()
    {
      // color c = getColor();
      // stroke(c);
      // stroke(0,0,0,0);
      color lastRgb = color(0,0,0,0);
      for (int i = lastCount - 1; i > 0; i--) {
        stroke(lastRgb);
        vertex(width * lastCavePos[i-1].x, height * lastCavePos[i-1].y, lastCavePos[i-1].z);
        lastRgb = getColor(1.0 - float(i) / float(lastCount));
        stroke(lastRgb);
        vertex(width * lastCavePos[i].x, height * lastCavePos[i].y, lastCavePos[i].z);
      }
      stroke(lastRgb);
      vertex(width * lastCavePos[0].x, height * lastCavePos[0].y, lastCavePos[0].z);
      stroke(getColor(1.0));
      vertex(width * cavePos.x, height * cavePos.y, cavePos.z);
      
      lastCavePos[0] = cavePos.get();
      for (int i = lastCount - 1; i > 0; i--) lastCavePos[i] = lastCavePos[i-1];
    }
  
    void caveTransform(PMatrix3D mx) 
    {
      PVector pWorld = new PVector();
      mx.mult(position, pWorld);
      // print ("pWorld: " + pWorld.x + ", " + pWorld.y + ", " + pWorld.z + "\n");
      
      // do a perspective transform on the x coord based on it's distance from the cam
      // float dist = pWorld.mag();
      float dist = sqrt(pWorld.y * pWorld.y + pWorld.z * pWorld.z);
      float fov = 1;
      cavePos.x = 0.5 + 0.5 * (pWorld.x / dist);
      // atan2(y,x)
      float angleNorm = .5 + .5 * (atan2(pWorld.z, -pWorld.y) / PI);
      cavePos.y = norm(angleNorm, 0, 1);
      cavePos.z = dist;
      
      if (abs(cavePos.y - lastCavePos[0].y) > .5) {
        for (int i = lastCount - 1; i > 0; i--) {
          lastCavePos[i].y = cavePos.y;
        }
      }
    }
    
  //  color getColor()
  //  {
  //    PVector white = new PVector(1,1,1);
  //    PVector black = new PVector(0,0,0);
  //    PVector c = new PVector(0,1,0);
  //  
  //    float t = cavePos.z / 10.0;
  //    PVector rgb = (t < .4) ? PVector.lerp(white, c, t / .4) : 
  //      PVector.lerp(c, black, (t-.4)/.6);
  //    return color(int(255.0 * rgb.x), int(255.0 * rgb.y), int(255.0 * rgb.z), 255);
  //  }
    
    color getColor(float lengthIntensity)
    {
      float distIntensity = 4.0 * lengthIntensity * pow(1.0 - (cavePos.z / 10), 3);
      // PVector col = new PVector(1.0, .6, .5);
      // PVector col = new PVector(.6, 1.0, .4);
      // float exp = 1.0;
      // float mul = distIntensity;
      PVector rgb = new PVector(distIntensity * rgbBase.x, distIntensity * rgbBase.y, distIntensity * rgbBase.z);
      // rgb.mult(4.0);
      return color(int(255.0 * rgb.x), int(255.0 * rgb.y), int(255.0 * rgb.z), int(255.0 * lengthIntensity));
    }
    
    // Is the particle still useful?
    boolean isDead() {
      if (lifespan < 0.0) {
        return true;
      } else {
        return false;
      }
    }
  }
  
  // A class to describe a group of Particles
  // An ArrayList is used to manage the list of Particles 
  
  class ParticleSystem {
    ArrayList<Particle> particles;
    PVector origin;
    float density = .5;
    float fillRadius = 10;
  
    ParticleSystem() {
      // origin = location.get();
      particles = new ArrayList<Particle>();
    }
    
    void fillVolume(float xMin, float xMax, float time) 
    {
        float vol = (xMax - xMin) * fillRadius * fillRadius;
        int pCount = int(density * vol);
        for (int pi = 0; pi < pCount; pi++) {
          PVector pos = new PVector(random(xMin, xMax), 
            random(-fillRadius, fillRadius), random(-fillRadius, fillRadius));
          Particle p = new Particle(pos);
          p.setHue(time / 8.0);
          particles.add(p);
        }
    }
    
    void cullVolume(float xMin, float xMax)
    {
      for (int i = particles.size()-1; i >= 0; i--) {
        Particle p = particles.get(i);
        if (p.position.x > xMin && p.position.x < xMax) {
          particles.remove(i);
        }
      }
    }
  
    void addParticle() {
      particles.add(new Particle(origin));
    }
  
    void update(float deltaTime, PMatrix3D mx, PVector target) 
    {
      for (int i = particles.size()-1; i >= 0; i--) {
        Particle p = particles.get(i);
        p.update(deltaTime, target);
        p.caveTransform(mx);
        if (p.isDead()) {
          particles.remove(i);
        }
      }
      
      beginShape(LINES);
      // stroke(255,255,255,255);
      for (int i = particles.size()-1; i >= 0; i--) {
        Particle p = particles.get(i);
        p.display();
        // stroke(p.getColor());
        // vertex(width * p.cavePos.x, height * p.cavePos.y, p.cavePos.z);
        // vertex(width * p.cavePos.x + 10, height * p.cavePos.y, p.cavePos.z);
      }
      endShape();
    }
  
  }
}
