public class swing extends bullet{
  
  PVector start;         //start position
  PVector end;           //end position
  PVector direction;     //direction(unit vector)
  PVector position;       //positon of the attack
  int default_size = 35; //default size of blast
  int max_size;          //max size of a blast
  int current_size;      //current size of a blast
  int range;             //the distance of blast position to player position
  
  swing(PVector start, PVector end, int range) {
    this.start = start;
    this.end = end;
    this.range = range;
    max_size = default_size;
    position = new PVector();
    current_size = 5;
  }
  //calculate a postion of the blast
  //direction here is actually facing
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
    position = start.add(direction.mult(range)) ;
  }
  //enlarge blast
  void move() {
    current_size++;
  }
    //hit counted by ball touch object
  public boolean hitObject(interActable inter) {
    Circle_Rect_Collision_Checker CR = new Circle_Rect_Collision_Checker();
    return CR.Check(position.x, position.y, current_size / 2, inter.inRoom_x, inter.inRoom_y, inter.X_size, inter.Y_size);
  }
  //circle-circle collision
  public boolean hitMoveObject(movingObject mo) {
    Circle_Circle_Collision_Checker CC = new Circle_Circle_Collision_Checker();
    return CC.Check(position.x, position.y, mo.position.x, mo.position.x, current_size / 2, mo.size / 2);
  }
  //display
  void display(color c) {
    stroke(c);
    strokeWeight(1);
    fill(c);
    ellipseMode(CENTER);
    ellipse(position.x, position.y, current_size, current_size);
  }
}
