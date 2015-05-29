/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/34101*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/* Andy Wallace
 * Particle Letters
 * 2010
 *
 * Click to have the particles form the word

 */


public class Pong implements Animation
{
  static final float sAccel = .25;      //acceleration rate of the particles
  static final float sMaxSpeed = 2;     //max speed the particles can move at
  static final int   sNearBoundry = 25;   // # pixels to goal that defines "near"
  static final int   sDefaultImageTime = 60;  // load new image interval in seconds

  PVector location = new PVector(100,100);
  PVector velocity = new PVector(1,1);
  
  String             mName;
  AnimationResources mResources;      // AnimationResources object
  TunnelDisplay      mDisplay;        // The display bject on which to paint
  TunnelSense        mSense;          // Sensors in the tunnel

  String[] mFilenames;        // Array of Filenames for images to display
  int[]    mDurations;        // Array of durations for images to display
  PImage   mWords;            // image containing the words
  int      mCurFileIndex = 0;     // index into mFileNames for the current image
  int      mImageExpirationFrame;
  int      mStateChangeExpirationFrame = 0;

  color mBgColor = color(0);
  color mTestColor = color(255);    //the color we will check for in the image. Currently black
  color mNearColor = color(255,0,0);
  color mFarColor = color(255,255,255);

  Particlevector[] mParticles = new Particlevector[0];
  boolean mFree = true;  //when this becomes false, the particles move toward their goals
  int mFreePeriod = 13;  // 13 sec. preriod for free/not free states
  int mNumUsers = 0;     // Assume 0 peeps in tunnel to start

  static final int sFreePeriod = 13;  // 13 sec. preriod for free/not free states


  //constructor
  Pong(String             name,
           AnimationResources resources,
           TunnelDisplay      display,
           TunnelSense        sense)
  {
    mName = name;
    mResources = resources;
    mDisplay = display;
    mSense = sense;

    mFilenames = mResources.getFiles(mName);
    mDurations = mResources.getFileDurations(mName);
    if(mFilenames.length == 0)
    {
      println("No Resources for " + mName + " - FAIL");
      exit();
    }
    else
    {
      println("Resource files for " + mName + " :");
      for(int i = 0; i < mFilenames.length; i++)
      {
        println("    " + mFilenames[i] + " : " + mDurations[i] + " sec.");
      }
    }
  }

  public void start()
  {
  
    //go through the image, find all black pixel and create a particle for them
    //start by drawing the background and the image to the screen
    background(0);
  }

  int colorShift = 0;
  int frameCounter = 0;
  int r = 0;
  int g = 0;
  int b = 0;
  public void update()
  {  
    frameCounter++;
    background(0);
    fill(10,255);
    location.add(velocity);
    
    if(location.x > width || location.x < 0){
      velocity.x = velocity.x * -1;
    }
    if(location.y > height - 7 || (location.y < 7))
    {
       velocity.y = velocity.y * -1; 
    }
    
    stroke(255);
    fill(255);
    ellipse(location.x, location.y, 2, 2);
    line(location.x - 10, 5, location.x + 10, 5);
    line(location.x - 10, height - 5, location.x + 10, height - 5);
    /*
    for(int i = 0; i < 128; i++)
    {
      if(frameCounter % 5 == 0)
      {
        colorShift++;
        r++;
        if(r > 255)
        {
          g++;
        }
        if(g > 255)
        {
           b++; 
        }
        if(b > 255)
        {
          r = 0;
          b = 0;
          g = 0; 
        }
      }
      
      
      if(colorShift > 255) 
      {
        colorShift = 0;
      }
      //stroke(r,g,b);
     //line(0,i,width,i); //-- experimental color tunnel code :)
    }*/
    mDisplay.sendImage();
  }


   private void ghost()
   {
   // fill(0, 2);
    //rect(0, 0, width, height);
    pct += step;
    if (pct < 1.0)
    {
      freshx = beginX + (pct * distX);
      freshy = beginY + (pow(pct, exponent) * distY);
    }
    //fill(255);
    //ellipse(x, y, 20, 20);
    
    if(frameCount % (3 * fps) == 0)
    {
      pct = 0.0;
      beginX = freshx;
      beginY = freshy;
      endX = random(0, width);
      endY = random(0, height);
      distX = endX - beginX;
      distY = endY - beginY;
    }
    //println("locationx : " + freshx);
    //println("locationy : " + freshy);
  }
      

  public void stop()
  {
    // do nothing
  }


  public String getName()
  {
    return mName;
  }


  //returns the locaiton in pixels[] of the point (x,y)
  int GetPixel(int x, int y)
  {
      return(x + y * width);
  }



}
