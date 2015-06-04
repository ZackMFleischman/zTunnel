public class FarmvilleAnimationTest implements Animation
{
  String             mName;
  AnimationResources mResources;    // AnimationResources object
  TunnelDisplay      mDisplay;    // The display bject on which to paint
  TunnelSense        mSense;         // Sensors in the tunnel

  String[] mFilenames;        // Array of Filenames for images to display
  int[]    mDurations;        // Array of durations for images to display
  PImage[] mImages;           // image containing the words
  
  int  mCurFileIndex = 0;   // index into mFileNames for the current image
  int  mCurImageIndex = 0;  // flipbook index  

  float animTimer = 0.0;
    
  //constructor
  FarmvilleAnimationTest(String             name,  
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
    println(mName + " starting up.");
    
    // load all of our images into our image array
    mImages = new PImage[mFilenames.length];
    for(int i = 0; i < mFilenames.length; i++)
    {
      mImages[i] = loadImage(mFilenames[i]);
    }
      
    mCurFileIndex = 0;
    mCurImageIndex = 0;

    animTimer = millis();
    background(0);
  }
  
  public void update()
  {
    background(0);
    if(animTimer + 1000 >= millis()) {
      mCurImageIndex = (mCurImageIndex + 1) % mImages.length;
      animTimer = millis();
    }

    // Send the screen image to the Tunnel for display
    //image(mImages[mCurImageIndex], 0, 0, width/4, height/4);
    float aspectRatio = 1280.0/720.0;
    //image(mImages[mCurImageIndex], 0, 0, width/2, height/2);
    int imgH = 64;
    int imgW = 128;
    image(mImages[mCurImageIndex], 0, 0, imgW, imgH);
    
    
    //image(mImages[mCurImageIndex], width/4, 0, width * 0.75, height/2);
    //image(mImages[mCurImageIndex], width/4, 0, width/4, height/4);
    //image(mImages[mCurImageIndex], width/4 * 2, 0, width/4, height/4);
    //image(mImages[mCurImageIndex], width/4 * 3, 0, width/4, height/4);
    mDisplay.sendImage();
  }

  public void stop()
  {
    mImages = null;
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
