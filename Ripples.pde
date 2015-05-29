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

  public static final int     N_PARTICLES        = 500;  
  public static final float   Y_RATIO            = 0.6216216216f;
  public static final int     MIN_RADIUS         = 10;
  public static final int     MAX_RADIUS         = 50;
  public static final float   MIN_PROGRESS_SPEED = 1f/50;
  public static final float   MAX_PROGRESS_SPEED = 1f/25;
  public static final color   BG_COLOR           = #000000;
  public static final int     MIN_HSB_SATURATION = 40; 
  public static final int     MAX_HSB_SATURATION = 60; 
  public static final int     MIN_HSB_BRIGHTNESS = 50; 
  public static final int     MAX_HSB_BRIGHTNESS = 75; 

  Ripples(String name, AnimationResources resources, TunnelDisplay display, TunnelSense sense) {
    mName = name;
    mResources = resources;
    mDisplay = display;
    mSense = sense;
  }

  public void start() {
    // Set color mode to HSB
    colorMode(HSB, 100);
    
    particles = new ArrayList<RippleParticle>();
    for (int i = 0; i < N_PARTICLES; i++) {
      RippleParticle p = new RippleParticle();
      particles.add(p);
    }    
  }

  public void update() {
    background(BG_COLOR);
    for (RippleParticle p : particles) {
      p.update();
      p.display();
    }

    // Update Tunnel LEDs
    mDisplay.sendImage();
  }

  public void stop() {
    // Return color mode to RGB
    colorMode(RGB, 255);
  }

  public String getName() {
    return mName;
  }

}

/**************************************************************************
 *
 *************************************************************************/
 
class RippleParticle {

  PVector location = new PVector();
  float targetRadius;
  color outerColor;
  float progress;
  float progressSpeed;
  
  RippleParticle() {
    rebirth();
    progress = random(1);
  }

  void rebirth() {
    progress = 0;
    location.x = random(width);
    location.y = random(height);
    progressSpeed = random(Ripples.MIN_PROGRESS_SPEED, Ripples.MAX_PROGRESS_SPEED);
    outerColor = color(random(100), random(Ripples.MIN_HSB_SATURATION, Ripples.MAX_HSB_SATURATION), random(Ripples.MIN_HSB_BRIGHTNESS, Ripples.MAX_HSB_BRIGHTNESS));
    targetRadius = random(Ripples.MIN_RADIUS, Ripples.MAX_RADIUS);
  }

  public void update() {
    progress += progressSpeed;
    if (progress >= 1) {
      rebirth();
    }
  }

  void display() {
    
    float outerRadius = progress * targetRadius;
    float stroke = (1 - progress) * outerRadius;
    float innerRadius = Math.max(0, outerRadius-stroke);

    noStroke();

    // Draw outer circle
    fill(outerColor);
    ellipse(location.x, location.y, outerRadius, Ripples.Y_RATIO * outerRadius);
    
    // Draw inner circle
    fill(Ripples.BG_COLOR);
    ellipse(location.x, location.y, innerRadius, Ripples.Y_RATIO * innerRadius);
  }

}
