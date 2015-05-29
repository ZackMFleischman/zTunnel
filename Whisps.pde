/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/34101*@* */
/* Joshua Adam Hart
 * Whisps
 * 2015
 */


/**************************************************************************
 *
 *************************************************************************/ 
public class Whisps implements Animation {
  String             mName;           // Animation Name
  AnimationResources mResources;      // AnimationResources object
  TunnelDisplay      mDisplay;        // The display bject on which to paint
  TunnelSense        mSense;          // Sensors in the tunnel
  
  ArrayList<WhispParticle> particles;
  int nWhisps = 20;

  Whisps(String name, AnimationResources resources, TunnelDisplay display, TunnelSense sense) {
    mName = name;
    mResources = resources;
    mDisplay = display;
    mSense = sense;
  }

  public void start() {
    background(0);
    particles = new ArrayList<WhispParticle>();
    for (int i = 0; i < nWhisps; i++) {
      WhispParticle p = new WhispParticle();
      particles.add(p);
    }
  }

  public void update() {
    fill(0, 0, 0, 20);
    rect(0, 0, width, height);
    for (WhispParticle p : particles) {
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
 
class WhispParticle {

  PVector location = new PVector(100,100);
  float targetRadius;
  color c;
  float progress;
  float progressSpeed;
  float minRadius = 3;
  float maxRadius = 10;
  float minProgressSpeed = 1.0/150;
  float maxProgressSpeed = 1.0/50;
  float waveMagnitude;
  float waveFrequency;
  float waveOffset;
  int direction;

  WhispParticle() {
    rebirth();
  }

  void rebirth() {
    direction = random(1) > 1-0.125 ? 1 : -1;
    progress = 0;
    progressSpeed = random(minProgressSpeed, maxProgressSpeed);
    c = color(127+random(128), 127+random(128), 127+random(128));
    location.y = random(height);
    targetRadius = random(minRadius, maxRadius);
    waveMagnitude = random(4, 20);
    waveFrequency = random(20, 40);
    waveOffset = random(3.14*2.0);
  }

  public void update() {
    progress += progressSpeed;
    if (progress >= 1) {
      rebirth();
    }
  }

  void display() {
    fill(c);
    noStroke();
    if (direction == 1) {
      location.x = width * progress;
    } else {
      location.x = width * (1 - progress);
    }
    
    float radius = targetRadius;
    ellipse(location.x, location.y + sin(waveOffset + location.x/waveFrequency) * waveMagnitude, radius, radius);
  }


}
