public class Point_Rect_Collision_Checker{
  //see http://jeffreythompson.org/collision-detection/circle-rect.php for detailled explaination of collision detection
  //point-rect collision ddetection, rect mode center
  public boolean Check(float px, float py, float rx, float ry, float rw, float rh) {
    if (px >= rx - rw &&   //point right of left edge
        px <= rx + rw &&   //point left of right edge
        py >= ry - rh &&   //point below of top edge
        py <= ry + rh) {   //point above of bottom edge
      return true;     
    }
    return false;
    
  }
}
