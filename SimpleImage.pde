public class SimpleImage implements Animation
{
  static final int   sDefaultImageTime = 60;  // load new image interval in seconds

  String               mName;
  AnimationResources  mResources;    // AnimationResources object
  TunnelDisplay    mDisplay;    // The display bject on which to paint
  TunnelSense      mSense;         // Sensors in the tunnel

  String[] mFilenames;        // Array of Filenames for images to display
  int[]    mDurations;        // Array of durations for images to display
  PImage   mImage;            // image containing the words
  int      mCurFileIndex = 0;      // index into mFileNames for the current image

  int mNumUsers = 0;     // Assume 0 peeps in tunnel to start

  //constructor
  SimpleImage(String             name,
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

    mCurFileIndex = 0;
    mImage = loadImage(mFilenames[mCurFileIndex]);
    stroke(255);

    //go through the image, find all black pixel and create a particle for them
    //start by drawing the background and the image to the screen
    background(0);

    // Determine our starting state free or not and whether we can use TunnelSense
  }

  public void update()
  {
    // Send the screen image to the Tunnel for display
    image(mImage, 0, 0);
    mDisplay.sendImage();
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
