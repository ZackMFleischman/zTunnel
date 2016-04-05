The LED Light Tunnel Project
========

Re-engineer and refresh the zTunnel!

This is the software to drive the animations in the Zynga Light Tunnel in the atrium.

![alt tag](https://github.com/zFleischman/zTunnel/blob/master/light_tunnel.png)

##Installation

-Download and install processing 2
-Run processing once so it can create the folders it needs
-Go to your documents directory and find the Processing directory. Open it to find the libraries folder. Copy the contents of `Reloaded/libraries` to `<your documents directory>/Processing/libraries`

Start or Restart Processing and you should now be able to open our Reloaded sketch by opening the Reloaded.pde file in the Reloaded directory. If you did everything correctly you should be able to hit Play in the upper-left and see the animations running.

##How to make your own simple Animation
-Create a new pde file or make a copy of the BasicAnimation.pde and rename it.
-Create a new class in your pde file that extends Animation. If you didn't copy BasicAnimation.pde be sure to define all the functions needed by the Animation interface.

If you created your own Animation, you need to make sure you call sendImage on the Display object passed in through the constructor. You can see this call in the update function for BasicAnimation.pde. This is the line of code that sends the current backbuffer to the zTunnel display.

-Find TunnelCfg.xml and create a new animation block for your animation, with an ID that is unique to your Animation Type.

-Open the AnimationResources.pde file and add an allocator for your new Animation. Look for the ExampleAnimation in AnimationResources if you are confused.

You should now be able to hit play and test your animation!


