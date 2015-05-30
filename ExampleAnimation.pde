/* ExampleAnimation
 * Author: Jason Bucher
 * ExampleAnimation is a simple script you can copy to get started making your own animations. All it does is clear the background and send the backbuffer off to the tunnel
 */

public class ExampleAnimation implements Animation
{
  String        _name;
  TunnelDisplay _display;

  ExampleAnimation(String name, AnimationResources resources, TunnelDisplay display, TunnelSense sense) {
    _name     = name;
    _display  = display;
  }

  public void start() {
    background(0);
  }
  
  public void update() {
    background(0);

    _display.sendImage();
  }


  public void stop() {
  }

  public String getName() { return _name; }
}

