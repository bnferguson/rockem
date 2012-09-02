import java.util.BitSet;

class RockemProtocol {  

  public static final byte USER_ONE = (byte) 0x80;
  public static final byte USER_TWO = (byte) 0x40;
  public static final byte PUNCH_RIGHT = (byte) 0x20;
  public static final byte PUNCH_LEFT = (byte) 0x10;
  public static final byte MOVE_FORWARD = (byte) 0x08;
  public static final byte MOVE_BACKWARD = (byte) 0x04;
  public static final byte MOVE_LEFT = (byte) 0x02;
  public static final byte MOVE_RIGHT = (byte) 0x01;
    
  Byte rockemBits;

  RockemProtocol(int userId) {
    rockemBits = new Byte((byte) 0x00);
    if (userId == 1){
      rockemBits = (byte) (rockemBits | USER_ONE);
    } else {
      rockemBits = (byte) (rockemBits | USER_TWO);
    }
  }

  public void punchLeft() {
    rockemBits = (byte) (rockemBits | PUNCH_LEFT);
  }

  public void punchRight() {
    rockemBits = (byte) (rockemBits | PUNCH_RIGHT);
  }

  public void moveForward() {
    rockemBits = (byte) (rockemBits | MOVE_FORWARD);
  }

  public void moveBackward() {
    rockemBits = (byte) (rockemBits | MOVE_BACKWARD);
  }

  public void moveLeft() {
    rockemBits = (byte) (rockemBits | MOVE_LEFT);
  }

  public void moveRight() {
    rockemBits = (byte) (rockemBits | MOVE_RIGHT);
  }

  public String toString() {
    return Integer.toBinaryString(rockemBits.intValue());
  }
}
