/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/34101*@* */
/* Joshua Adam Hart
 * LudicrousSpeed
 * 2015
 */


/**************************************************************************
 *
 *************************************************************************/ 
public class LudicrousSpeed implements Animation {

  public static final int     N_PARTICLES          = 25;
  public static final float   Y_RATIO              = 0.6216216216f;
  public static final color   BG_COLOR             = #000000;       // Background color
  public static final int     BG_RED               = (BG_COLOR>>16)&0xff;
  public static final int     BG_GREEN             = (BG_COLOR>>8)&0xff;
  public static final int     BG_BLUE              = BG_COLOR&0xff;
  public static final int     BG_CLAMP_DISTANCE    = 100;
  public static final int     BG_CLAMP_DISTANCE_SQ = BG_CLAMP_DISTANCE * BG_CLAMP_DISTANCE;
  public static final int     BG_FADE_ALPHA        = 20;            // Larger number makes tails shorter
  public static final int     MIN_RADIUS           = 3;
  public static final int     MAX_RADIUS           = 10;
  public static final float   MIN_PROGRESS_SPEED   = 1f/150;
  public static final float   MAX_PROGRESS_SPEED   = 1f/50;

  String             mName;           // Animation Name
  AnimationResources mResources;      // AnimationResources object
  TunnelDisplay      mDisplay;        // The display bject on which to paint
  TunnelSense        mSense;          // Sensors in the tunnel
  
  ArrayList<LudicrousSpeedParticle> particles;

  LudicrousSpeed(String name, AnimationResources resources, TunnelDisplay display, TunnelSense sense) {
    mName = name;
    mResources = resources;
    mDisplay = display;
    mSense = sense;
  }

  public void start() {
    background(BG_COLOR);
    particles = new ArrayList<LudicrousSpeedParticle>();
    for (int i = 0; i < N_PARTICLES; i++) {
      LudicrousSpeedParticle p = new LudicrousSpeedParticle();
      particles.add(p);
    }
  }

  public void update() {
    fill(BG_COLOR, BG_FADE_ALPHA);
    rect(0, 0, width, height);
    // filter(BLUR, 1);
    for (LudicrousSpeedParticle p : particles) {
      p.update();
      p.display();
    }
 
    // Clamp pixels to BG COLOR
    loadPixels();
    for (int i = (width*height)-1; i>=0; i--) {
      color c = pixels[i];
      int dr = (c>>16)&0xff - BG_RED;
      int dg = (c>>8)&0xff - BG_GREEN;
      int db = c&0xff - BG_BLUE;
      if (dr*dr + dg*dg + db*db < BG_CLAMP_DISTANCE_SQ) {
        pixels[i] = BG_COLOR;
      }
    }
    updatePixels();
    
    // Update Tunnel LEDs
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
