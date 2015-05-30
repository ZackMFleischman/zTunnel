public class AnimationResources
{
	TunnelDisplay mDisplay;
	TunnelSense mSense;
	XML mXml;
	XML[] mAnimationElements;
	ArrayList<Animation> mAnimations;

	//constructor
	AnimationResources(TunnelDisplay display, TunnelSense sense, Minim minim)
	{
		mDisplay = display;
		mSense = sense;

		String[] filesToTry = {
			"TunnelCfg.local.xml",
			"TunnelCfg.xml"
		};
		
		String fileName = null;
		for (int i = 0; i<filesToTry.length; i++) {
			File file = new File(sketchPath(filesToTry[i]));
			if (file.exists()) {
				fileName = file.toString();
				break;
			}
		}
		
		if (fileName == null) {
			println("Missing XML File! - ERROR");
			exit();
		} else {
			println("Reading config from " + fileName);
		}
  		
		mXml = loadXML(fileName);

		mAnimationElements = mXml.getChildren("animation");

		mAnimations = new ArrayList<Animation>();

		if(mAnimationElements.length == 0)
		{
			println("No animations! - ERROR");
			exit();
		}

                println("Loading " + mAnimationElements.length + " Animations from TunnelConfig.xml");
                
		for(int i = 0; i < mAnimationElements.length; i++)
		{
			String aniName = mAnimationElements[i].getString("id");
			String aniType = mAnimationElements[i].getString("type");
			Animation newAnimation = null;
			println("DEBUG: Animation " + i + ": " + aniName);
			if(aniType.equals("ParticleLettersAni"))
			{
				newAnimation = new ParticleLettersAni(aniName, this, mDisplay, mSense);
			}
			else if(aniType.equals("OrbitAni"))
			{
				newAnimation = new OrbitAni(aniName, this, mDisplay, mSense);
			}
			else if(aniType.equals("FlockingParticlesAni"))
			{
				newAnimation = new FlockingParticlesAni(aniName, this, mDisplay, mSense);
			}
			else if(aniType.equals("MovieAni"))
			{
				newAnimation = new MovieAni(aniName, this, mDisplay, mSense);
			}
                        else if(aniType.equals("Pong"))
                        {
                                newAnimation = new Pong(aniName, this, mDisplay, mSense);
                        }
                        else if(aniType.equals("TunnelParty"))
                        {
                                newAnimation = new TunnelParty(aniName, this, mDisplay, mSense);
                        }
                        else if(aniType.equals("TestAnim"))
                        {
                                newAnimation = new TestAnim(aniName, this, mDisplay, mSense);
                        }
                        else if(aniType.equals("SimpleImage"))
                        {
                                newAnimation = new SimpleImage(aniName, this, mDisplay, mSense);
                        }
                        else if(aniType.equals("FarmvilleAnimationTest"))
                        {
                                newAnimation = new FarmvilleAnimationTest (aniName, this, mDisplay, mSense);
                        }
                        else if(aniType.equals("AccessGranted"))
                        {
                                newAnimation = new AccessGranted(aniName, this, mDisplay, mSense, minim);
                        }
                        else if(aniType.equals("Ripples"))
                        {
                                newAnimation = new Ripples(aniName, this, mDisplay, mSense);
                        }
                        else if(aniType.equals("Whisps"))
                        {
                                newAnimation = new Whisps(aniName, this, mDisplay, mSense);
                        }
                        else if(aniType.equals("LudicrousSpeed"))
                        {
                                newAnimation = new LudicrousSpeed(aniName, this, mDisplay, mSense);
                        }
                        else if(aniType.equals("TunnelFireworks"))
                        {
                                newAnimation = new TunnelFireworks(aniName, this, mDisplay, mSense);
                        }
                        else if(aniType.equals("ScottStarTunnel"))
                        {
                                newAnimation = new ScottStarTunnel(aniName, this, mDisplay, mSense);
                        }
                        else if(aniType.equals("IPTunnelParty"))
                        {
                                newAnimation = new IPTunnelParty(aniName, this, mDisplay, mSense, minim);
                        }
                        else
			{
				println("AnimationResources::ctor Do not recognize animation " + aniName
					       + " ERROR...");
				exit();
			}
			if(newAnimation != null)
			{
				mAnimations.add(newAnimation);
			}
		}

                println("All Animations loaded");
	}

	public ArrayList getAnimations()
	{
		return mAnimations;
	}

	public String[] getFiles(String animationName)
	{
		String[] fileNames = {};

		for(int i = 0; i < mAnimationElements.length; i++)
		{
			println("DEBUG: Animation " + i + ": " + mAnimationElements[i].getString("id") +
				     " class : " + mAnimationElements[i].getString("type"));
			if(mAnimationElements[i].getString("id").equals(animationName))
			{
				XML[] files = mAnimationElements[i].getChildren("imageFile");
				println("   #files = " + files.length);
				for(int j = 0; j < files.length; j++)
				{
					String fileName = files[j].getString("name");
					if(fileName != null)
					{
						fileNames = append(fileNames, fileName);
					}
					else
					{
						println("null filename in AnimationResources.getFiles()");
					}
				}
			}
		}
		return fileNames;
	}

	public int getAnimationDuration(String animationName)
	{
		for(int i = 0; i < mAnimationElements.length; i++)
		{
			if(mAnimationElements[i].getString("id").equals(animationName))
			{
				int duration = mAnimationElements[i].getInt("duration", -1);
				println("Animation " + animationName + " duration = " + duration);
				return duration;
			}
		}
		println("getAnimationDuration() can't find Animation " + animationName);
		return -1;
	}

	public int[] getFileDurations(String animationName)
	{
		int[] durations = {};

		for(int i = 0; i < mAnimationElements.length; i++)
		{
			println("DEBUG: Animation " + i + ": " + mAnimationElements[i].getString("id"));
			if(mAnimationElements[i].getString("id").equals(animationName))
			{
				XML[] files = mAnimationElements[i].getChildren("imageFile");
				println("   #files = " + files.length);
				for(int j = 0; j < files.length; j++)
				{
					int duration = files[j].getInt("duration", -1);
					durations = append(durations, duration);
					if(duration == -1)
					{
						println("null duration in AnimationResources.getFileDurations()");
					}
				}
			}
		}
		return durations;
	}

}
