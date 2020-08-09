public class magicBall extends bullet{
  
  PVector start;      //start position
  PVector end;        //end position
  PVector direction;  //direction(unit vector)
  PVector current;    //current positon
  int size;           //size of ball
  float TargetedDistance; //target distance, magic ball gone after reaching it
  
  magicBall(PVector start, PVector end) {
    this.start = start;
    this.end = end;
    current = new PVector(start.x, start.y);
    size = 10;
    //calculate distance
    float distX = start.x - end.x;
    float distY = start.y - end.y;
    TargetedDistance = sqrt((distX*distX) + (distY*distY));
  }
  
  void calDirection() {
    //calculate a ratio of moving vertically and horizontally using linear formula y = ax + b
    //using y direction as unit, so y of velocity 1
    if (start.y > end.y) {
      direction = new PVector((end.x - start.x) / (start.y - end.y), -1);
    } else if (start.y < end.y) {
      direction = new PVector((start.x - end.x) / (start.y - end.y), 1);
    } else {
      direction = new PVector(end.x - start.x, 0);
    }
    //get unit vector of direction
    direction.normalize();
  }
  //move ball forward
  void move() {
    current.add(direction);
  }
  //hit counted by ball touch object
  public boolean hitObject(interActable inter) {
    Circle_Rect_Collision_Checker CR = new Circle_Rect_Collision_Checker();
    return CR.Check(current.x, current.y, size / 2, inter.inRoom_x, inter.inRoom_y, inter.X_size, inter.Y_size);
  }
  //circle-circle collision
  public boolean hitMoveObject(movingObject mo) {
    Circle_Circle_Collision_Checker CC = new Circle_Circle_Collision_Checker();
    return CC.Check(current.x, current.y, mo.position.x, mo.position.x, size / 2, mo.size / 2);
  }
  //display
  void display(color c) {
    stroke(c);
    strokeWeight(1);
    fill(c);
    ellipseMode(CENTER);
    ellipse(current.x, current.y, size, size);
  }
}
