Rockem
======

Installation instructions:

1. Download and install [Processing](http://processing.org/).
2. Follow [Simple OpenNI's installation](http://code.google.com/p/simple-openni/wiki/Installation) which includes installing OpenNI, NITE, and usually some Sensor drivers. Then putting the SimpleOpenNI libraries in the appropriate Processing dir. 
3. Open rockem.pde in Processing and run! (with Kinect plugged in)

Some notes: It takes a little while to start up the OpenGL display and Kinect drivers. Once up you'll need to do the calibration dance (no really, it's a [pose](http://www.greenfoot.org/images/calibration-pose.png))

There are some .wav's in the data dir. You can use ddf.Minim to trigger those sounds for debug. 