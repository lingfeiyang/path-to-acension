class map{
  
  ArrayList<room> r;
    int Map_X;
  int Map_Y;
  map(ArrayList<room> r) {
    this.r = r;
    for (int i = 0; i < r.size(); i++) {
        r.get(i).Map_X = randomNum(0, width);
        r.get(i).Map_Y = randomNum(0, height);
    }
  }
  
  void display(room current) {
    for (int i = 0; i < r.size(); i++) {
      if (r.get(i) == current) {
        stroke(200,0,0);
      } else {
        stroke(0);
      }
      strokeWeight(1);
      fill(255);
      ellipseMode(CENTER);
      ellipse(r.get(i).Map_X, r.get(i).Map_Y, 30, 30);
      textSize(15);
      fill(0);
      text(r.get(i).room_id, r.get(i).Map_X, r.get(i).Map_Y);
      for (int j = 0; j < r.get(i).Portals.size(); j++) {
        line(r.get(i).Map_X, r.get(i).Map_Y, r.get(i).Portals.get(j).target.Map_X, r.get(i).Portals.get(j).target.Map_Y);
      }
    }
  }
  
  void setXY() {
    Point_Circle_Collision_Checker PC = new Point_Circle_Collision_Checker();
    for (int i = 0; i < r.size(); i++) {
      if (PC.Check(mouseX, mouseY, r.get(i).Map_X, r.get(i).Map_Y, 15)) {
        r.get(i).Map_X = mouseX;
        r.get(i).Map_Y = mouseY;
      }
    }
  }
  
  //random number
  int randomNum(float min, float max) {
    return (int)((Math.random() * ((max - min) + 1)) + min);
  }
}
