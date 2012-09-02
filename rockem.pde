import processing.opengl.*;
import SimpleOpenNI.*;

SimpleOpenNI  kinect;
PVector centerPoint;
RockemProtocol rockem;


void setup() {
  size(1028, 768, OPENGL);

  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  kinect.setMirror(true);

  fill(255, 0, 0);
}

void draw() {
  kinect.update();
  background(255);

  translate(width/2, height/2, 0);
  rotateX(radians(180));
  
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  for (int i=0; i < userList.size(); i++) { 
    int userId = userList.get(i);
    if ( kinect.isTrackingSkeleton(userId)) {
      processUserAndSendToArduino(userId);
      drawUser(userId);
    } 
  }
}

void processUserAndSendToArduino(int userId) {
  rockem = new RockemProtocol();
  handleBodyPosition(userId);
  handlePunches(userId);

  println(rockem.to_s());
}

void drawUser(int userId) {
  PVector position = new PVector();
  PMatrix3D orientation = new PMatrix3D();

  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_TORSO, position);
  kinect.getJointOrientationSkeleton(userId, SimpleOpenNI.SKEL_TORSO, orientation);
  drawSkeleton(userId);
  drawAxis(position, orientation);
}

void handleBodyPosition(int userId) {
  PVector position = new PVector();
  int deadzone = 200;

  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, position);
  
  if (centerPoint == null) {
    centerPoint = position;
  }

  if (position.x < centerPoint.x - deadzone){
    rockem.moveLeft();
  }

  if (position.x > centerPoint.x + deadzone){
    rockem.moveRight();
  }

  if (position.z < centerPoint.z - deadzone){
    rockem.moveForward();
  }

  if (position.z > centerPoint.z + deadzone){
    rockem.moveBackward();
  }
}

void handlePunches(int userId) {
  float leftArmLength = calculateArmLength(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  float rightArmLength = calculateArmLength(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  PVector leftShoulder = new PVector();
  PVector rightShoulder = new PVector();

  PVector leftHand = new PVector();
  PVector rightHand = new PVector();


  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, leftShoulder);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, rightShoulder);

  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);

  PVector leftPunchPoint = new PVector(leftShoulder.x, leftShoulder.y, leftShoulder.z - (leftArmLength - leftArmLength/4));
  PVector rightPunchPoint = new PVector(rightShoulder.x, rightShoulder.y, rightShoulder.z - (rightArmLength - rightArmLength/4));

  if (rightHand.z < rightPunchPoint.z) {
    rockem.punchRight();
  }

  if (leftHand.z < leftPunchPoint.z) {
    rockem.punchLeft();
  }
}


float calculateArmLength(int userId, int shoulder, int elbow, int hand) {
  float length = 0.0;

  length += calculateLimbLength(userId, shoulder, elbow);
  length += calculateLimbLength(userId, elbow, hand);

  return length;
}

float calculateLimbLength(int userId, int jointId1, int jointId2) {
  PVector jointPos1 = new PVector();
  PVector jointPos2 = new PVector();

  kinect.getJointPositionSkeleton(userId, jointId1, jointPos1);
  kinect.getJointPositionSkeleton(userId, jointId2, jointPos2);

  return jointPos1.dist(jointPos2);
}

void drawSkeleton(int userId) {
  drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
  drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);
}

void drawLimb(int userId,int jointType1,int jointType2)
{
  PVector jointPos1 = new PVector();
  PVector jointPos2 = new PVector();
  float  confidence;

  confidence = kinect.getJointPositionSkeleton(userId,jointType1,jointPos1);
  confidence +=  kinect.getJointPositionSkeleton(userId,jointType2,jointPos2);
  stroke(100);
  strokeWeight(5);
  if(confidence > 1){
    line(jointPos1.x,jointPos1.y,jointPos1.z, jointPos2.x,jointPos2.y,jointPos2.z);
  }
}

void drawAxis(PVector position, PMatrix3D orientation) {
  pushMatrix();
  // move to the position of the TORSO
  translate(position.x, position.y, position.z);
  // adopt the TORSO's orientation
  // to be our coordinate system

  applyMatrix(orientation);

  // draw x-axis in red
  stroke(255, 0, 0);
  strokeWeight(3);
  line(0, 0, 0, 150, 0, 0);
  // draw y-axis in blue
  stroke(0, 255, 0);
  line(0, 0, 0, 0, 150, 0);
  // draw z-axis in green
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, 150);

  popMatrix();
}

// user-tracking callbacks!
void onNewUser(int userId) {
  println("start pose detection");
  kinect.startPoseDetection("Psi", userId);
}

void onEndCalibration(int userId, boolean successful) {
  if (successful) {
    println("  User calibrated !!!");
    kinect.startTrackingSkeleton(userId);
  }
  else {
    println("  Failed to calibrate user !!!");
    kinect.startPoseDetection("Psi", userId);
  }
}

void onStartPose(String pose, int userId) {
  println("Started pose for user");
  kinect.stopPoseDetection(userId);
  kinect.requestCalibrationSkeleton(userId, true);
}