public class Point_Circle_Collision_Checker{
  //see http://jeffreythompson.org/collision-detection/circle-rect.php for detailled explaination of collision detection
  //point-circle collision ddetection, circle mode center
  public boolean Check(float px, float py, float cx, float cy, float r) {
    //get distance between the point and circle's center
    //using the Pythagorean Theorem
    float distX = px - cx;
    float distY = py - cy;
    float distance = sqrt((distX*distX) + (distY*distY));   
    // if the distance is less than the circle's
    // radius the point is inside!
    if (distance <= r) {
      return true;
    }
    return false;
    }
}
