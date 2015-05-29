/* Jason Bucher
 * Tunnel Party!
 * 2015
 *
 * As you get people into the tunnel you increase the tension until max capacity is hit and there's a party!
 */

public class IPTunnelParty implements Animation {
  String             mName;
  AnimationResources mResources;      // AnimationResources object
  TunnelDisplay      mDisplay;        // The display bject on which to paint
  TunnelSense        mSense;          // Sensors in the tunnel

  int mPartyTarget;
  Boolean mTunnelPartyHappening;
  
  String[] mFilenames;        // Array of Filenames for images to display
  int[]    mDurations;        // Array of durations for images to display
  PImage[] mImages;           // image containing the words
  
  AudioSample mIntro;
  AudioSample mLoop;
  AudioSample mOutro;
  Minim mMinim;
  Boolean mThemeSongOn;
  
  //constructor
  IPTunnelParty(String name, 
              AnimationResources resources,
              TunnelDisplay display,
              TunnelSense sense,
              Minim minim) {
    mName = name;
    mResources = resources;
    mDisplay = display;
    mSense = sense;
    mMinim = minim;
    
    mFilenames = mResources.getFiles(mName);
    
    mPartyTarget = 5;
    mTunnelPartyHappening = false;
    mThemeSongOn = false;
            
    mIntro = minim.loadSample("intro.mp3");
    mLoop = minim.loadSample("loop.mp3");
    mOutro = minim.loadSample("out.mp3"); 
  }

  public void start() {
    // load all of our images into our image array
    mImages = new PImage[mFilenames.length];
    for(int i = 0; i < mFilenames.length; i++)
    {
      print("loading image " + mFilenames[i]);
      mImages[i] = loadImage(mFilenames[i]);
    }
    
    background(0);
  }
  
  public void update() {    
    if(mThemeSongOn) {
      if(getNumUsersInTunnel() <= 0) {
        // No one is around, stop playing the audio
        //outro.trigger();
        mThemeSongOn = false;
      }
    } else {
      if(getNumUsersInTunnel() > 0) {
        mLoop.trigger();
        mThemeSongOn = true;
      }
    }
        
    // Go ahead and push the image to the tunnel here so the other updates don't have to
    if(mImages[0] != null)
      image(mImages[0], 0, 0);
    mDisplay.sendImage();
  }
  
  public int getNumUsersInTunnel() {
    return mSense.getNumUsers();
  }
  
  public void stop() {
    // do nothing
    mImages = null;
  }

  public String getName() {
    return mName;
  }
}
