/* David Daudelin
 * Access Granted (Security Scan)
 * 2015
 *
 * As someone enters the tunnel, a simulated security scan takes place with audio

 */
 

public class AccessGranted implements Animation {

  String             mName;
  AnimationResources mResources;      // AnimationResources object
  TunnelDisplay      mDisplay;        // The display bject on which to paint
  TunnelSense        mSense;          // Sensors in the tunnel
  int[]              curBrightness;   // Stores the current brightness of each column of lights
  int[]              minBrightness;   // Ensures that grid lines don't dissapear after a scan
  int                scanX;           // Current x position of scan laser
  int                scanWidth;       // Controls width of scan laser
  int                oldNumUsers;     // Remembers last number of users in the tunnel
  int                spacing;         // Determines the size of the grid squares
  AudioSample        accessGranted;
  AudioSample        securityScan;

  //constructor
  AccessGranted(String name, 
              AnimationResources resources,
              TunnelDisplay display,
              TunnelSense sense,
              Minim minim) {
    mName = name;
    mResources = resources;
    mDisplay = display;
    mSense = sense;
    scanWidth = 5;
    scanX = width+scanWidth;
    oldNumUsers = getNumUsersInTunnel();
    spacing = 10;
    curBrightness = new int[width+1];
    minBrightness = new int[width+1];
    accessGranted = minim.loadSample( "accessgranted.mp3", 512);
    securityScan = minim.loadSample( "securityscan.mp3", 512);
    securityScan.setGain(-2.0); 
  }

  public void start() {
    background(0);
    initGrid();
  }
  
  public void initGrid(){
    for(int x=0; x<width; x++){
        if(x%spacing==0){
           minBrightness[x] = 50;
           curBrightness[x] = 50; 
        }else{
           minBrightness[x] = 0;
           curBrightness[x] = 0; 
        }
    }
  }
  
  public void drawGrid() {
    background(0);

    for(int x = 0; x < width; x++) {
      int shimmer = 0;
      
      if(minBrightness[x]>0){
        shimmer = (int)random(0, 40);
      }
        
      stroke(0,curBrightness[x],shimmer);
      
      line(x, 0, x, height);
      
      if(curBrightness[x] > minBrightness[x]){
         curBrightness[x]-=10; 
      }
    }
    
    stroke(0,50,0);
    
    for(int y = 0; y < height; y+=spacing) {
      line(0, y, width, y);
    }
  }
  
  public void startScan(){
     scanX=0; 
     securityScan.trigger();
  }
  
  public void updateScan(){

     for(int i=0; i<scanWidth; i++){
       if(scanX+i<=width)
         curBrightness[scanX+i] += 200;
     }
     
     scanX = scanX+scanWidth; 
     
     if(scanX >= width){
       accessGranted.trigger();
     }
  }
  
  public void update()
  {
    drawGrid();
    
    if (getNumUsersInTunnel()>oldNumUsers || mousePressed) {
       startScan();
    }
    
    if(scanX<(width+scanWidth)){
       updateScan(); 
    }
    
    mDisplay.sendImage();
    oldNumUsers = getNumUsersInTunnel();
  }
  
  public int getNumUsersInTunnel() {
  //  if(mLocalTunnelTest) {
   //   return mLocalUserTest;
  //  } else {
      return mSense.getNumUsers();
   // }
  }
  
  public void stop() {
    // do nothing
  }

  public String getName() {
    return mName;
  }
}
