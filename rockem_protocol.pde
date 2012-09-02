class RockemProtocol {  
  int punchLeft, punchRight, moveForwardBack, moveLeftRight;

  RockemProtocol() {
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

  public String to_s() {
    return "" + moveLeftRight + "," + moveForwardBack + "," + punchLeft + "," + punchRight;    
  }
}
