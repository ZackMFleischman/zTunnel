public class ZTunnel
{
	public static final int sFps = 30;  // 30 fps for this tunnel

	public static final int sLedsPerStrip = 157;
	public static final int sNumStripsPerSystem = 128;

	AnimationResources 	mAnimationResources;
	AnimationScheduler 	mScheduler;
	TunnelDisplay 	 	mTunnelDisplay;
	TunnelSense             mTunnelSense;
        Minim                   minim;

	//ctor
	ZTunnel(PApplet context)
	{
		frameRate(sFps);
		size(sLedsPerStrip, sNumStripsPerSystem, OPENGL);
  		noCursor();

	  	mTunnelDisplay = new TunnelDisplay();
	  	mTunnelSense = new TunnelSense(context, this);
                minim = new Minim(context);
	  	mAnimationResources = new AnimationResources(mTunnelDisplay, mTunnelSense, minim);
	  	mScheduler = new AnimationScheduler(mAnimationResources);

		mScheduler.start();
	}

	public void update()
	{
		mTunnelSense.update();
		mScheduler.update();
	}
}
