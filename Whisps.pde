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

  public static final int     N_PARTICLES          = 20;
  public static final float   Y_RATIO              = 0.6216216216f;
  public static final color   BG_COLOR             = #000000;       // Background color
  public static final int     BG_RED               = (BG_COLOR>>16)&0xff;
  public static final int     BG_GREEN             = (BG_COLOR>>8)&0xff;
  public static final int     BG_BLUE              = BG_COLOR&0xff;
  public static final int     BG_CLAMP_DISTANCE    = 10;
  public static final int     BG_CLAMP_DISTANCE_SQ = BG_CLAMP_DISTANCE * BG_CLAMP_DISTANCE;
  public static final int     BG_FADE_ALPHA        = 20;            // Larger number makes tails shorter
  public static final int     MIN_RADIUS           = 3;
  public static final int     MAX_RADIUS           = 10;
  public static final float   MIN_PROGRESS_SPEED   = 1f/150;
  public static final float   MAX_PROGRESS_SPEED   = 1f/50;
  public static final float   MIN_WAVE_MAGNITUDE   = 4;
  public static final float   MAX_WAVE_MAGNITUDE   = 20;
  public static final float   MIN_WAVE_FREQUENCY   = 20;
  public static final float   MAX_WAVE_FREQUENCY   = 40;
  public static final float   MIN_WAVE_OFFSET      = 0;
  public static final float   MAX_WAVE_OFFSET      = (float)(2 * Math.PI);

  Whisps(String name, AnimationResources resources, TunnelDisplay display, TunnelSense sense) {
    mName = name;
    mResources = resources;
    mDisplay = display;
    mSense = sense;
  }

  public void start() {
    background(BG_COLOR);
    particles = new ArrayList<WhispParticle>();
    for (int i = 0; i < N_PARTICLES; i++) {
      WhispParticle p = new WhispParticle();
      particles.add(p);
    }
  }

  public void update() {
    fill(BG_COLOR, BG_FADE_ALPHA);
    noStroke();
    rect(0, 0, width, height);
    for (WhispParticle p : particles) {
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
 
class WhispParticle {

  PVector location = new PVector();
  float radius;
  color whispColor;
  float progress;
  float progressSpeed;
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
    progressSpeed = random(Whisps.MIN_PROGRESS_SPEED, Whisps.MAX_PROGRESS_SPEED);
    whispColor = color(127+random(128), 127+random(128), 127+random(128));
    location.y = random(height);
    radius = random(Whisps.MIN_RADIUS, Whisps.MAX_RADIUS);
    waveMagnitude = random(Whisps.MIN_WAVE_MAGNITUDE, Whisps.MAX_WAVE_MAGNITUDE);
    waveFrequency = random(Whisps.MIN_WAVE_FREQUENCY, Whisps.MAX_WAVE_FREQUENCY);
    waveOffset = random(Whisps.MIN_WAVE_OFFSET, Whisps.MAX_WAVE_OFFSET);
  }

  public void update() {
    progress += progressSpeed;
    if (progress >= 1) {
      rebirth();
    }
  }

  void display() {
    noStroke();
    fill(whispColor);
    if (direction == 1) {
      location.x = width * progress;
    } else {
      location.x = width * (1 - progress);
    }    
    ellipse(location.x, location.y + sin(waveOffset + location.x/waveFrequency) * waveMagnitude, radius, Whisps.Y_RATIO * radius);
  }


}
