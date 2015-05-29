

public class TestAnim implements Animation
  {
  String        _name;
  TunnelDisplay _display;

  TestAnim
    ( String              name
    , AnimationResources  resources
    , TunnelDisplay       display
    , TunnelSense         sense
    )
    {

    _name     = name;
    _display  = display;

    }


  public void start()
    {

    background(0);

    }


  private int bitrev(int n)
    {
    int c = 0;

    for (int i = 32; i-- > 0;)
      {
      n <<= 1;
      c |= n & 1;
      n >>= 1;
      }

    return c;
    }


  int _gxt = 0;
  int _rxt = 0;
  int _bxt = 0;
  int _gyt = 0;
  int _ryt = 0;
  int _byt = 0;

  public void update()
    {

    _gxt += 1;
    _gyt += -2;
    _rxt += -3;
    _ryt += 4;
    _bxt += 5;
    _byt += -6;

    background(0);

    for (int y = height; y-- > 0;)
      {
      for (int x = width; x-- > 0;)
        {
        int g = ((x + _gxt) ^ (y + _gyt));
        int r = ((x + _rxt) ^ (y + _ryt));
        int b = ((x + _bxt) ^ (y + _byt));
        color c = color(r & 0xFF, g & 0xFF, b & 0xFF);
        set(x, y, c);
        }
      }

    _display.sendImage();

    }


  public void stop()
    {
    }


  public String getName()
    {return _name;}


  }


// end of file ------------------------------------------------------------------------------------

