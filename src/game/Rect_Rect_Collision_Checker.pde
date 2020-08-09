public class Rect_Rect_Collision_Checker{
  //see http://jeffreythompson.org/collision-detection/circle-rect.php for detailled explaination of collision detection
  //rectanlge rectangle collision, rect mode center
  public boolean Check(float r1x, float r1y, float r1w, float r1h, float r2x, float r2y, float r2w, float r2h) {
    if (r1x + r1w / 2 >= r2x - r2w / 2 &&    // r1 right edge past r2 left
        r1x - r1w / 2 <= r2x + r2w / 2 &&    // r1 left edge past r2 right
        r1y - r1h / 2 <= r2y + r2h / 2 &&    // r1 top edge past r2 bottom
        r1y + r1h / 2 >= r2y - r2h / 2) {    // r1 bottom edge past r2 top
      return true;
    }
    return false;
  }
}
