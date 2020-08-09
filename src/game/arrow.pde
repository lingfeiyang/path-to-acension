public class arrow extends bullet{
  
  PVector start;      //start position
  PVector end;        //end position
  PVector direction;  //direction(unit vector), an arrow has 5 unit vector
  PVector tail;       //tail of the arrow
  PVector head;       //head of the arrow
  
  arrow(PVector start, PVector end) {
    this.start = start;
    this.end = end;
    //tail at start at beginning
    tail = new PVector(start.x, start.y);
    head = new PVector();
  }
  
  void calDirection() {
    //calculate a ratio of moving vertically and horizontally using linear formula y = ax + b
    //using y direction as unit, so y of velocity 1
    if (start.y > end.y) {//firing downwards
      direction = new PVector((end.x - start.x) / (start.y - end.y), -1);
    } else if (start.y < end.y) {//fire up wards, here switch start.x and end.x because left and right are switched when firing up
      direction = new PVector((start.x - end.x) / (start.y - end.y), 1);
    } else {//firing horizontally
      direction = new PVector(end.x - start.x, 0);
    }
    //get unit vector of direction
    direction.normalize();
    //set up start and end
    head.x = tail.x + 15 * direction.x;
    head.y = tail.y + 15 * direction.y;
  }
  //move arrow forward
  void move() {
    tail.x = head.x; 
    tail.y = head.y;
    head.x = head.x + 15 * direction.x;
    head.y = head.y + 15 * direction.y;
  }
  //hit counted by arrow head in object
  public boolean hitObject(interActable inter) {
    Point_Rect_Collision_Checker PR = new Point_Rect_Collision_Checker();
    return PR.Check(head.x, head.y, inter.inRoom_x, inter.inRoom_y, inter.X_size, inter.Y_size);
  }

  public boolean hitMoveObject(movingObject mo) {
    Point_Circle_Collision_Checker PC = new Point_Circle_Collision_Checker();
    return PC.Check(head.x, head.y, mo.position.x, mo.position.y, mo.size);
  }
  void display(color c) {
    stroke(c);
    line(tail.x, tail.y, head.x, head.y);
  }
  
}
