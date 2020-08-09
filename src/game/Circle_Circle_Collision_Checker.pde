public class Circle_Circle_Collision_Checker{
  //see http://jeffreythompson.org/collision-detection/circle-rect.php for detailled explaination of collision detection
  //cirle-circle collision ddetection, circle mode center
  public boolean Check(float x1, float y1, float x2, float y2, float r1, float r2) {
    //calculate distance of two circle center
    float distX = x1 - x2;
    float distY = y1 - y2;
    //distance must greater than sum of two radius
    float distance = sqrt((distX*distX) + (distY*distY));
    if (distance <= r1 + r2) {
      return true;
    }
    return false;
  }
}
