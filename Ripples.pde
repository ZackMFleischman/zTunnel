/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/34101*@* */
/* Joshua Adam Hart
 * Ripples - Simple animation of expanding circles.
 * 2015
 */


/**************************************************************************
 *
 *************************************************************************/ 
public class Ripples implements Animation {
  String             mName;           // Animation Name
  AnimationResources mResources;      // AnimationResources object
  TunnelDisplay      mDisplay;        // The display bject on which to paint
  TunnelSense        mSense;          // Sensors in the tunnel
  
  ArrayList<RippleParticle> particles;
  int nRipples = 500;

  Ripples(String name, AnimationResources resources, TunnelDisplay display, TunnelSense sense) {
    mName = name;
    mResources = resources;
    mDisplay = display;
    mSense = sense;
  }

  public void start() {
    particles = new ArrayList<RippleParticle>();
    for (int i = 0; i < nRipples; i++) {
      RippleParticle p = new RippleParticle();
      particles.add(p);
    }    
  }

  public void update() {
    background(0);
    for (RippleParticle p : particles) {
      p.update();
      p.display();
    }
    mDisplay.sendImage();
  }

  public void stop() {
  }

  public String getName() {
    return mName;
  }

}

/**************************************************************************
 *
 *************************************************************************/
 
class RippleParticle {

  PVector location = new PVector(100,100);
  float targetRadius;
  color c;
  float progress;
  float progressSpeed;
  float minRadius = 10;
  float maxRadius = 30;

  RippleParticle() {
    rebirth();
    progress = random(1);
  }

  boolean isDead() {
    return false;
  }
  
  void display() {
    stroke(c);
    strokeWeight(5 - 5 * progress);
    fill(0);
    float radius = progress * targetRadius;
    ellipse(location.x, location.y, radius, radius);
  }

  void rebirth() {
    progress = 0;
    progressSpeed = 1.0/30 + random(1.0/30);
    c = color(127+random(128), 127+random(128), 127+random(128));
    location.x = random(width);
    location.y = random(height);
    targetRadius = random(minRadius, maxRadius);
  }

  public void update() {
    progress += progressSpeed;
    if (progress >= 1) {
      rebirth();
    }
  }

}
