public class Circle_Rect_Collision_Checker{
  //see http://jeffreythompson.org/collision-detection/circle-rect.php for detailled explaination of collision detection
  //circle-rectangle collision, rect mode center, circle mode center
  public boolean Check(float cx, float cy, float r, float rx, float ry, float rw, float rh) {
    // temporary variables to set edges for testing
    float testX = cx;
    float testY = cy;
    // which edge is closest?
    if (cx < rx - rw / 2) {//test left edge
      testX = rx - rw / 2;     
    } else if (cx > rx + rw / 2) {//right edge
      testX = rx + rw / 2;
    }
    if (cy < ry - rh / 2) {// top edge
      testY = ry - rh / 2;
    } else if (cy > ry + rh / 2) {// bottom edge
      testY = ry + rh / 2;
    }
    // get distance from closest edges
    float distX = cx-testX;
    float distY = cy-testY;
    float distance = sqrt( (distX*distX) + (distY*distY) );
    // if the distance is less than the radius, collision!
    if (distance <= r) {
      return true;      
    }
    return false;
  }
}
