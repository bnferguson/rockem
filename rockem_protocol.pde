class RockemProtocol {  
  int punchLeft, punchRight, moveForwardBack, moveLeftRight, userId;

  RockemProtocol(int _userId) {
    userId = _userId;
    reset();
  }

  public void reset() {
    punchRight = 0;
    punchLeft = 0;
    moveForwardBack = 0;
    moveLeftRight = 0;
  }

  public void punchLeft() {
    punchLeft = 1;
  }

  public void punchRight() {
    punchRight = 1;
  }

  public void moveForward() {
    moveForwardBack = 1;
  }

  public void moveBackward() {
    moveForwardBack = -1;
  }

  public void moveLeft() {
    moveLeftRight = 1;
  }

  public void moveRight() {
    moveLeftRight = -1;
  }

  public String toString() {
    String output = userId + "," + moveLeftRight + "," + moveForwardBack + "," + punchLeft + "," + punchRight;
    return output;
  }
}
