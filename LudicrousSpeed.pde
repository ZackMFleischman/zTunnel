/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/34101*@* */
/* Joshua Adam Hart
 * LudicrousSpeed
 * 2015
 */


/**************************************************************************
 *
 *************************************************************************/ 
public class LudicrousSpeed implements Animation {
  String             mName;           // Animation Name
  AnimationResources mResources;      // AnimationResources object
  TunnelDisplay      mDisplay;        // The display bject on which to paint
  TunnelSense        mSense;          // Sensors in the tunnel
  
  ArrayList<LudicrousSpeedParticle> stars;
  int nStars = 25;

  LudicrousSpeed(String name, AnimationResources resources, TunnelDisplay display, TunnelSense sense) {
    mName = name;
    mResources = resources;
    mDisplay = display;
    mSense = sense;
  }

  public void start() {
    background(0);
    stars = new ArrayList<LudicrousSpeedParticle>();
    for (int i = 0; i < nStars; i++) {
      LudicrousSpeedParticle p = new LudicrousSpeedParticle();
      stars.add(p);
    }
  }

  public void update() {
    fill(0, 0, 0, 10);
    rect(0, 0, width, height);
    // filter(BLUR, 1);
    for (LudicrousSpeedParticle p : stars) {
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
 
class LudicrousSpeedParticle {

  PVector location = new PVector(100,100);
  float targetRadius;
  color c;
  float progress;
  float progressSpeed;
  float minRadius = 1;
  float maxRadius = 2;
  float minProgressSpeed = 1.0/50;
  float maxProgressSpeed = 1.0/25;

  LudicrousSpeedParticle() {
    rebirth();
    progress = random(1);
    location.x = width * progress;

  }

  void rebirth() {
    progress = 0;
    progressSpeed = random(minProgressSpeed, maxProgressSpeed);
    c = color(200+random(56), 200+random(56), 200+random(56));
    location.y = random(height);
    location.x = 0;
    targetRadius = random(minRadius, maxRadius);
  }

  public void update() {
    progress += progressSpeed;
    if (progress >= 1) {
      rebirth();
    }
  }

  void display() {
    stroke(c);
    strokeCap(PROJECT);
    strokeWeight(targetRadius);
    float previousX = location.x-3;
    location.x = width * progress;
    line(location.x, location.y, previousX, location.y);
  }
}
