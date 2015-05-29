/* Jason Bucher
 * Tunnel Party!
 * 2015
 *
 * As you get people into the tunnel you increase the tension until max capacity is hit and there's a party!

 */

public class TunnelParty implements Animation {
  public class hypePoint {
    // 0.0 to 1.0, where 1.0 is halfway up the tunnel
    float targetPosition;
    // Where it is now as it moves to target
    float currentPosition;
    
    // How quickly it should get to the targetPosition
    float velocity;
    
    hypePoint() {
      targetPosition = 0.0;
      currentPosition = 0.0;
      velocity = 0.07;
    }
  }

  String             mName;
  AnimationResources mResources;      // AnimationResources object
  TunnelDisplay      mDisplay;        // The display bject on which to paint
  TunnelSense        mSense;          // Sensors in the tunnel

  int mPartyTarget;
  Boolean mTunnelPartyHappening;
  
  int mPartyStartTime;
  int mMaxPartyTime = 5000;
  hypePoint[] mHypePoints;        // Array of durations for images to display
  
  Boolean mLocalTunnelTest;
  int mLocalUserTest;
  
  //constructor
  TunnelParty(String name, 
              AnimationResources resources,
              TunnelDisplay display,
              TunnelSense sense) {
    mName = name;
    mResources = resources;
    mDisplay = display;
    mSense = sense;
    
    mPartyTarget = 7;
    mTunnelPartyHappening = false;
    
    mLocalTunnelTest = false;
    mLocalUserTest = 0;
    
    // slice up our width for hype bars
    int numHypePoints = width/4;
    mHypePoints = new hypePoint[numHypePoints];
    
    // create a fixed number of hype points along the tunnel. Do in multiples of 4.
    for(int i = 0; i < mHypePoints.length; i++) {
      mHypePoints[i] = new hypePoint();
    }
  }

  public void start() {
    background(0);
  }

  public void partyUpdate() {
    background(random(0, 200), random(0, 200), random(0, 200));
  }
  
  public void getHypedUpdate() {
    background(0);
    setHypePointTargets((float)getNumUsersInTunnel() / mPartyTarget);
    //setHypePointTargets(getNumUsersInTunnel() / mPartyTarget);
    drawBars();
    animateBars();
  }
  
  public void lonelyUpdate() {
    background(0);
  }
  
  public void setHypePointTargets(float newTarget) {
    // create a fixed number of hype points along the tunnel. Do in multiples of 4.
    for(int i = 0; i < mHypePoints.length; i++) {
      mHypePoints[i].targetPosition = newTarget;
    }
  }
  
  public void drawBars() {
    int currX = 0;
    int currY = 0;
    int barHeight = 0;
    int barWidth = 0;
    for(int i = 0; i < mHypePoints.length; i++) {
      barHeight = (int)((height/2) * mHypePoints[i].currentPosition);
      barWidth = 4;

      currX = i * 4;
      currY = 0;     
      rect(currX, currY, barWidth, barHeight);
     
      currY = height - barHeight;
      rect(currX, currY, barWidth, barHeight);
      //println(i + ": " + currX + ", " + currY + ", " + barWidth + ", " + barHeight + " - " + mHypePoints[i].currentPosition + ", " + mHypePoints[i].targetPosition);
    }
  }
  
  public void animateBars() {
    hypePoint currPoint;
    float currVelocity = 0.0;
    int maxHeight = height/2;
    for(int i = 0; i < mHypePoints.length; i++) {
      currPoint = mHypePoints[i];
      if(currPoint.currentPosition < currPoint.targetPosition) {
        currPoint.currentPosition += currPoint.velocity;
      }
      else {
        currPoint.currentPosition -= random(0.0, 0.1);
      } 
    }
  }
  
  public void update()
  {
    if (mousePressed && (mouseButton == LEFT)) {
      mLocalUserTest += 1;
      println(mLocalUserTest);
    } else if (mousePressed && (mouseButton == RIGHT)) {
      mLocalUserTest -= 1;
    }
    
    // If it's party time, let's show the party animation
    if(mTunnelPartyHappening) {
      partyUpdate();
      
      int timePartying = millis() - mPartyStartTime;
      if(timePartying >= mMaxPartyTime) {
        mTunnelPartyHappening = false;
      }
    }
    else {
      
      // See if next frame we should have a party!
      mTunnelPartyHappening = getNumUsersInTunnel() >= mPartyTarget;
      if(mTunnelPartyHappening) {
        mPartyStartTime = millis();
      }
      
      if(getNumUsersInTunnel() > 0) {
        // If we have people looking to party, let's get them hyped!
        getHypedUpdate();
      }
      else {
        // No one partying. We are lonely.
        lonelyUpdate();
      }
    }

    // Go ahead and push the image to the tunnel here so the other updates don't have to
    mDisplay.sendImage();
  }
  
  public int getNumUsersInTunnel() {
    if(mLocalTunnelTest) {
      return mLocalUserTest;
    } else {
      return mSense.getNumUsers();
    }
  }
  
  public void stop() {
    // do nothing
  }

  public String getName() {
    return mName;
  }
}
